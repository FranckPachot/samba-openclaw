#!/usr/bin/env bash
set -euo pipefail

# Ensure Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "Docker does not seem to be running. Start Docker and retry."
  exit 1
fi

# Build and start containers in the background
cd "$(dirname "$0")/../docker"

echo "Building and starting Sandbase containers..."

docker compose up -d --build

# Wait for databases to become healthy (simple loop)
for svc in postgres mysql; do
  echo "Waiting for $svc to be healthy..."
  until [ "$(docker inspect -f '{{.State.Health.Status}}' sandbase_${svc})" = "healthy" ]; do
    sleep 2
  done
done

echo "All services are up. Access the web UI at http://localhost (port 80)."
