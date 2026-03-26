# DB Knowledge Skill

## Name

db-knowledge

## Description

A personal knowledge base for database performance analysis. Includes:
- Tips and best‑practice notes for interpreting execution plans from PostgreSQL, MySQL, MongoDB, etc.
- Frequently asked questions and quick reference tables.
- Links to reference books, articles, and documentation.

## Usage

You can ask the assistant to:
- Explain a given execution plan string.
- Summarize the key performance concerns.
- Retrieve a tip or best‑practice recommendation.
- Provide a citation to a stored document or book.

The skill stores its knowledge in plain‑text Markdown files under `knowledge/` and reference documents (PDFs, e‑books, etc.) under `docs/`.

### Adding Knowledge

Create a new Markdown file in `knowledge/` (e.g., `knowledge/postgres_plans.md`) with bullet points, examples, and explanations.

### Adding Documents

Place PDFs or other files in `docs/`. The assistant can search their titles and provide links.

---
*This skill is user‑maintained. Keep the files up‑to‑date for the best assistance.*
