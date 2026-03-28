#!/usr/bin/env bash
set -euo pipefail

# Ensure containers are running (starts them if needed)
if ! docker compose -f ../docker/docker-compose.yml ps | grep -q "web"; then
  echo "Starting containers..."
  ./create_containers.sh
fi

# Define a simple DDL for testing
DDL="CREATE TABLE demo (id INT PRIMARY KEY, name TEXT);"

# Run the test using the local Python environment
python3 - <<PY
import json, sys
sys.path.append('..')  # make src available
from src.db_worker import run_test_against_databases, get_default_db_configs
result = run_test_against_databases(DDL, get_default_db_configs())
print(result)
PY
