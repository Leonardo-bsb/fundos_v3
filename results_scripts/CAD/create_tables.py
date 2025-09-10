import json

# ---------------------------------------------------------------------------
# Objective:
#   Generate PostgreSQL CREATE TABLE statements from the meta_cad.sorted.json
#   file, which contains table and column metadata (type and size).
#
# Usage:
#   python3 create_tables.py > create_tables.sql
#   Then, in psql prompt: \i /home/leo/linguagens/fundos_v3/results_scripts/CAD/create_tables.sql
#
# Notes:
#   - Reads meta_cad.sorted.json using Latin-1 encoding.
#   - Maps types and sizes to PostgreSQL types.
#   - Output is ready to be pasted or executed in psql.
# ---------------------------------------------------------------------------

meta_path = "/home/leo/linguagens/fundos_v3/results_scripts/CAD/meta_cad.sorted.json"

# Load the sorted meta JSON
with open(meta_path, encoding="latin1") as f:
    meta = json.load(f)

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