"""Database helper utilities for Sandbase.

The module defines a very small abstraction over SQLAlchemy to:
* connect to a list of database URIs,
* execute a DDL statement (e.g. CREATE TABLE),
* insert a tiny test row,
* fetch all rows and return them as a list of dictionaries.

The `run_test_against_databases` function runs the same DDL and test
logic against each configured database, normalises the results (by
ordering columns and rows) and returns a pretty‑printed diff.
"""

from typing import List, Dict, Any
from sqlalchemy import create_engine, text
import json

def get_default_db_configs() -> List[Dict[str, str]]:
    """Return a list of default database configurations.

    Each config is a dict with a human readable ``name`` and a SQLAlchemy
    ``url``.  Adjust the URLs to match your local Docker container names
    or remote instances.
    """
    return [
        {"name": "PostgreSQL", "url": "postgresql://postgres:postgres@postgres:5432/postgres"},
        {"name": "MySQL", "url": "mysql+pymysql://root:root@mysql:3306/mysql"},
        {"name": "SQLite", "url": "sqlite:///sandbox.db"},
    ]

def _run_once(ddl: str, db_url: str) -> List[Dict[str, Any]]:
    """Execute *ddl* on a single database and return fetched rows.

    Steps performed:
    1. Connect using ``create_engine``.
    2. Execute the DDL (CREATE TABLE).
    3. Insert a test row (``INSERT INTO ... VALUES (...)``) – the function
       parses the column definition to generate a minimal row.
    4. SELECT * FROM the newly created table.
    """
    engine = create_engine(db_url, echo=False, future=True)
    with engine.begin() as conn:
        # 1. Create table
        conn.execute(text(ddl))
        # 2. Build a simple INSERT based on DDL column list
        #    This is naive but sufficient for a demo.
        cols_part = ddl.split('(')[1].rsplit(')', 1)[0]
        col_names = [c.split()[0] for c in cols_part.split(',')]
        placeholders = ", ".join(["'test'" if 'CHAR' in c.upper() or 'TEXT' in c.upper() else "1" for c in cols_part.split(',')])
        table_name = ddl.split()[2]
        insert_sql = f"INSERT INTO {table_name} ({', '.join(col_names)}) VALUES ({placeholders});"
        conn.execute(text(insert_sql))
        # 3. Fetch rows
        result = conn.execute(text(f"SELECT * FROM {table_name};"))
        rows = [dict(row) for row in result]
    return rows

def _normalise(rows: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """Return rows sorted by keys and values for deterministic diffing."""
    # Sort rows by JSON representation to have a stable order
    return sorted([{k: row[k] for k in sorted(row)} for row in rows], key=lambda r: json.dumps(r, sort_keys=True))

def run_test_against_databases(ddl: str, db_configs: List[Dict[str, str]]) -> str:
    """Run *ddl* against each DB config and return a human readable diff.

    The function returns a multi‑line string where each block starts with the
    database name, followed by the normalised JSON representation of the rows.
    If any database raises an exception, the error is captured and shown.
    """
    output_blocks = []
    for cfg in db_configs:
        name = cfg.get('name', cfg.get('url'))
        try:
            rows = _run_once(ddl, cfg['url'])
            norm = _normalise(rows)
            block = f"--- {name} ---\n" + json.dumps(norm, indent=2, sort_keys=True)
        except Exception as e:
            block = f"--- {name} ---\nError: {e}"
        output_blocks.append(block)
    return "\n\n".join(output_blocks)
"""