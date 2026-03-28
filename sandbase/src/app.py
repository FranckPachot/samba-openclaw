"""Flask web application for Sandbase.

Provides a minimal UI to define a *collection* (SQL table) and trigger
executions against configured databases. Results are shown on the same
page.
"""

from flask import Flask, request, render_template_string, jsonify
from db_worker import run_test_against_databases, get_default_db_configs

app = Flask(__name__)

HTML = """
<!doctype html>
<title>Sandbase – Create Collection</title>
<h1>Define a collection (SQL table)</h1>
<form method=post>
  <label>Name: <input name=table_name required></label><br>
  <label>Columns (comma‑separated, e.g. id INT, name TEXT):<br>
    <textarea name=columns rows=3 required></textarea>
  </label><br>
  <button type=submit>Run test</button>
</form>
{% if result %}
<h2>Result</h2>
<pre>{{ result }}</pre>
{% endif %}
"""

@app.route('/', methods=['GET', 'POST'])
def index():
    result = None
    if request.method == 'POST':
        table_name = request.form['table_name']
        columns = request.form['columns']
        # Build a simple CREATE TABLE statement
        ddl = f"CREATE TABLE {table_name} ({columns});"
        # Run the test across default DB configs
        result = run_test_against_databases(ddl, get_default_db_configs())
    return render_template_string(HTML, result=result)

# Simple JSON API (useful for Lambda)
@app.route('/api/run', methods=['POST'])
def api_run():
    payload = request.get_json(force=True)
    ddl = payload.get('ddl')
    db_configs = payload.get('db_configs', get_default_db_configs())
    if not ddl:
        return jsonify({'error': 'Missing DDL'}), 400
    result = run_test_against_databases(ddl, db_configs)
    return jsonify({'result': result})

if __name__ == '__main__':
    # Listen on port 80 as requested
    app.run(host='0.0.0.0', port=80)
"""