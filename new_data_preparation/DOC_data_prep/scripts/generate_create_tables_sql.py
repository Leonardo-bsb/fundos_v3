import subprocess
import json
import sys
from collections import OrderedDict
from pathlib import Path
import tempfile

# ---------------------------------------------------------------------------
# Objective:
#   Orchestrate the workflow to generate CREATE TABLE SQL using in-memory outputs.
#   Steps:
#     1. Extract unique column names from all CSV headers that match each META file
#        (csv_doc_headers.sh now collects all unique column names from all matching CSVs).
#     2. Extract meta info from meta files (format_meta.sh)
#     3. Use tabelas_colunas.sh to generate a new JSON:
#        {"tabela1": {"col1": ["tipo", "tamanho"], "col2": ...}, ...}
#     4. Generate SQL (in memory, print to terminal)
#   Now receives CSV and META folder paths via command line arguments.
# ---------------------------------------------------------------------------

if len(sys.argv) != 3:
    print(f"Usage: {sys.argv[0]} <csv_folder> <meta_folder>", file=sys.stderr)
    sys.exit(1)

csv_folder = sys.argv[1]
meta_folder = sys.argv[2]

# Step 1: Extract headers from CSVs (as JSON)
with tempfile.NamedTemporaryFile("w+", delete=False, encoding="latin1") as headers_file:
    subprocess.run(
        ["bash", "new_data_preparation/DOC_data_prep/scripts/extract_csv_headers.sh", csv_folder],
        stdout=headers_file
    )
    headers_file_path = headers_file.name

# Step 2: Extract meta info from meta files (as JSON)
with tempfile.NamedTemporaryFile("w+", delete=False, encoding="latin1") as meta_file:
    subprocess.run(
        ["bash", "new_data_preparation/DOC_data_prep/scripts/find_meta_files.sh", meta_folder],
        stdout=meta_file
    )
    meta_file_path = meta_file.name

# Step 3: Use tabelas_colunas.sh to generate the joined JSON
with tempfile.NamedTemporaryFile("w+", delete=False, encoding="latin1") as tabelas_file:
    subprocess.run(
        ["bash", "new_data_preparation/DOC_data_prep/scripts/tabelas_colunas.sh", headers_file_path, meta_file_path],
        stdout=tabelas_file
    )
    tabelas_file_path = tabelas_file.name

# Step 4: Generate SQL (in memory, print to terminal)
with open(tabelas_file_path, encoding="latin1") as f:
    tabelas = json.load(f, object_pairs_hook=OrderedDict)

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

table_names = [table for table in tabelas.keys()]
print("DROP TABLE IF EXISTS")
print(",\n    ".join(table_names), "CASCADE;\n")

for table, columns in tabelas.items():
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

# Clean up temporary files
Path(headers_file_path).unlink(missing_ok=True)
Path(meta_file_path).unlink(missing_ok=True)
Path(tabelas_file_path).unlink(missing_ok=True)

# Print message at the end (as SQL for psql)
print(r"\echo Script finished successfully!")

