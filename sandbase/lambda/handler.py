"""AWS Lambda entry point for Sandbase.

The expected event format (JSON) is:

```json
{
  "ddl": "CREATE TABLE demo (id INT, name TEXT);",
  "db_configs": [
    {"name": "Postgres", "url": "postgresql://..."},
    ...
  ]
}
```
If ``db_configs`` is omitted, the default list from ``src.db_worker`` is used.
"""

import json
import os
import sys

# Ensure the src directory is on the path
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(BASE_DIR)

from src.db_worker import run_test_against_databases, get_default_db_configs

def lambda_handler(event, context=None):
    # Lambda may pass the payload as a dict already
    if isinstance(event, str):
        try:
            event = json.loads(event)
        except json.JSONDecodeError:
            return {"statusCode": 400, "body": "Invalid JSON"}

    ddl = event.get('ddl')
    if not ddl:
        return {"statusCode": 400, "body": "Missing 'ddl' in request"}

    db_configs = event.get('db_configs') or get_default_db_configs()
    result = run_test_against_databases(ddl, db_configs)
    return {
        "statusCode": 200,
        "body": json.dumps({"result": result})
    }
"""