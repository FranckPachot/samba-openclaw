# Sandbase

**Sandbase** is a lightweight proof‑of‑concept platform that lets you define collections (SQL tables) through a simple web UI, run multi‑session tests against multiple databases and compare the normalized results.

## Features

- Web UI (Flask) served on port **80** to create collections and launch tests.
- Supports **PostgreSQL, MySQL and SQLite** out of the box (add more via adapters).
- Multi‑session execution – each test runs in its own container to avoid state leakage.
- Results are normalised and displayed side‑by‑side for easy comparison.
- Admin scripts to spin up Docker containers locally.
- **AWS Lambda** deployment scripts to run the same logic server‑less.

## Repository layout

```
 sandbase/
 ├─ README.md                # this file
 ├─ requirements.txt         # Python dependencies
 ├─ src/
 │   ├─ app.py               # Flask web application
 │   └─ db_worker.py         # Database abstraction & test runner
 ├─ docker/
 │   ├─ Dockerfile           # Build image for the web service
 │   └─ docker-compose.yml   # Spin up web + DB containers
 ├─ scripts/
 │   ├─ create_containers.sh # Helper to start local containers
 │   ├─ deploy_lambda.sh     # Deploy Lambda version to AWS
 │   └─ test.sh              # Run local test suite
 └─ lambda/
     └─ handler.py           # Lambda entry point (re‑uses db_worker)
```

## Quick start (local Docker)

```bash
# 1. Build and start containers
cd sandbase
./scripts/create_containers.sh

# 2. The web UI will be available at http://localhost (port 80)
```

## Deploy to AWS Lambda

```bash
# Prerequisites: AWS CLI configured with appropriate credentials
cd sandbase
./scripts/deploy_lambda.sh my-sandbase-function
```

The Lambda function expects a JSON payload describing the collection definition and the target databases. See **lambda/handler.py** for the exact schema.

## Running tests

```bash
cd sandbase
./scripts/test.sh
```

The script will:
1. Spin up temporary containers for each configured database.
2. Execute the collection creation and insertion steps.
3. Pull results, normalise them and print a diff.

## Extending the platform

- Add new database adapters in `src/db_worker.py`.
- Extend the UI in `src/app.py` to support more complex schema definitions.
- Update `docker-compose.yml` to include additional services.
- Modify `scripts/deploy_lambda.sh` for advanced IAM roles or layers.

---

Feel free to open issues, propose pull requests or ask me for help evolving the project!
