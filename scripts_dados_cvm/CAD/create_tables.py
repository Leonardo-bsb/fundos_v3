import json
import subprocess

# ---------------------------------------------------------------------------
# Objective:
#   Generate PostgreSQL DROP TABLE IF EXISTS statements (option 1) and
#   CREATE TABLE statements from the sorted meta produced by sort_meta_by_headers.py.
#
# Usage:
#   python3 create_tables.py > create_tables.sql
#   Then, in psql prompt: \i /home/leo/linguagens/fundos_v3/results_scripts/CAD/create_tables.sql
#
# Notes:
#   - Calls sort_meta_by_headers.py and reads its output (latin1 encoding).
#   - Maps types and sizes to PostgreSQL types.
#   - Output is ready to be pasted or executed in psql.
# ---------------------------------------------------------------------------

# Run sort_meta_by_headers.py and capture its output
result = subprocess.run(
    ["python3", "scripts_dados_cvm/CAD/sort_meta_by_headers.py"],
    capture_output=True
)
meta_json = result.stdout.decode("latin1")
meta = json.loads(meta_json)

def pg_type(typ, size):
    """
    Map type and size from meta to PostgreSQL type.
    """
    t = typ.lower()
    sz = "".join(filter(str.isdigit, size))
    if t in ("varchar", "char"):
        return f"{t}({sz})" if sz else t
    if t == "numeric":
        return "numeric"
    if t == "real":
        return "real"
    if t == "date":
        return "date"
    if t == "bigint":
        return "bigint"
    return "text"

# Generate DROP TABLE IF EXISTS statement for all tables
table_names = [table for table in meta.keys()]
print("DROP TABLE IF EXISTS")
print(",\n    ".join(table_names), "CASCADE;\n")

# Iterate over tables and columns, print CREATE TABLE statements
for table, columns in meta.items():
    print(f"-- Table: {table}")
    print(f"CREATE TABLE {table} (")
    col_defs = []
    for col, (typ, size) in columns.items():
        coltype = pg_type(typ, size)
        col_defs.append(f'    "{col}" {coltype}')
    print(",\n".join(col_defs))
    print(");\n")