import subprocess
import json
from collections import OrderedDict

# ---------------------------------------------------------------------------
# Objective:
#   Orchestrate the workflow to generate CREATE TABLE SQL using in-memory outputs.
#   Steps:
#     1. Extract headers from CSVs (json_cad_headers.sh)
#     2. Extract meta info from meta files (format_meta.sh)
#     3. Sort meta by headers (in memory)
#     4. Generate SQL (in memory, print to terminal)
# ---------------------------------------------------------------------------

def pg_type(typ, size):
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

# Step 1: Extract headers from CSVs
headers_json = subprocess.run(
    ["bash", "scripts_dados_cvm/CAD/json_cad_headers.sh", "dados/CAD/DADOS"],
    capture_output=True
).stdout.decode("latin1")
headers = json.loads(headers_json)

# Step 2: Extract meta info from meta files
meta_json = subprocess.run(
    ["bash", "scripts_dados_cvm/CAD/format_meta.sh", "dados/CAD/META"],
    capture_output=True
).stdout.decode("latin1")
meta = json.loads(meta_json)

# Step 3: Sort meta by headers (in memory)
sorted_meta = OrderedDict()
for table, meta_obj in meta.items():
    table_headers = headers.get(table, [])
    if not isinstance(meta_obj, dict):
        sorted_meta[table] = meta_obj
        continue
    ordered = OrderedDict()
    for col in table_headers:
        if col in meta_obj:
            ordered[col] = meta_obj[col]
    for k in meta_obj.keys():
        if k not in ordered:
            ordered[k] = meta_obj[k]
    sorted_meta[table] = ordered

# Step 4: Generate SQL (print to terminal)
table_names = [table for table in sorted_meta.keys()]
print("DROP TABLE IF EXISTS")
print(",\n    ".join(table_names), "CASCADE;\n")

for table, columns in sorted_meta.items():
    print(f"-- Table: {table}")
    print(f"CREATE TABLE {table} (")
    col_defs = []
    for col, val in columns.items():
        if isinstance(val, (list, tuple)) and len(val) == 2:
            typ, size = val
        else:
            typ, size = "text", ""
        coltype = pg_type(typ, size)
        col_defs.append(f'    "{col}" {coltype}')
    print(",\n".join(col_defs))
    print(");\n")