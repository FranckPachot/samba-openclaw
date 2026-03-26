#!/usr/bin/env bash
set -e

# Create a dedicated network for MongoDB replica set
NETWORK="mongo-repl-net"
if ! podman network ls --format "{{.Name}}" | grep -q "^${NETWORK}$"; then
  podman network create ${NETWORK}
fi

# MongoDB image version (you can change as needed)
IMG="docker.io/library/mongo:latest"
# Replica set name
RSNAME="rs0"
# Number of replicas
REPLICAS=5

# Function to start a container
start_container() {
  local idx=$1
  local name="mongodb${idx}"
  local port=$((27017 + idx - 1))
  # Create a persistent volume for data
  local vol="${name}-data"
  if ! podman volume ls --format "{{.Name}}" | grep -q "^${vol}$"; then
    podman volume create ${vol}
  fi
  # Run container
  podman run -d \
    --name ${name} \
    --network ${NETWORK} \
    -p ${port}:27017 \
    -v ${vol}:/data/db \
    -e "TZ=$(date +%Z)" \
    ${IMG} --replSet ${RSNAME}
}

# Start containers if not already running
for i in $(seq 1 $REPLICAS); do
  if ! podman ps --format "{{.Names}}" | grep -q "^mongodb${i}$"; then
    start_container $i
  else
    echo "Container mongodb${i} already running"
  fi
done

# Wait for MongoDB processes to be ready
echo "Waiting for MongoDB instances to be ready..."
for i in $(seq 1 $REPLICAS); do
  until podman exec mongodb${i} mongo --eval "db.adminCommand('ping')" >/dev/null 2>&1; do
    echo "mongodb${i} not ready yet, sleeping 2s..."
    sleep 2
  done
done

echo "All MongoDB instances are up. Initializing replica set..."
# Build the replica set configuration JSON
CONFIG="{ _id: \"${RSNAME}\", members: ["
for i in $(seq 1 $REPLICAS); do
  port=$((27017 + i - 1))
  member="{ _id: $((i-1)), host: \"localhost:${port}\" }"
  CONFIG+="$member"
  if [ $i -ne $REPLICAS ]; then
    CONFIG+=" , "
  fi
done
CONFIG+="] }"

# Initiate the replica set from the first container
podman exec mongodb1 mongo --eval "rs.initiate(${CONFIG})"

# Wait for the replica set to become healthy
echo "Waiting for replica set to reach PRIMARY state..."
while true; do
  STATE=$(podman exec mongodb1 mongo --quiet --eval "rs.status().myState")
  # 1 = PRIMARY, 2 = SECONDARY
  if [ "$STATE" == "1" ]; then
    echo "Replica set is PRIMARY."
    break
  else
    echo "Current state: $STATE. Waiting..."
    sleep 2
  fi
done

echo "MongoDB replica set with ${REPLICAS} members is ready."
