import sys
import json
from collections import OrderedDict
from pathlib import Path
import subprocess

# ---------------------------------------------------------------------------
# Objective:
#   Orchestrate the workflow to generate CREATE TABLE SQL using utils.sh functions.
#   Steps:
#     1. Extract unique column names from all CSV headers that match each META file
#        (extract_csv_headers_json from utils.sh).
#     2. Extract meta info from meta files (find_meta_files_json from utils.sh)
#     3. Use generate_table_columns_json from utils.sh to generate a new JSON:
#        {"tabela1": {"col1": ["tipo", "tamanho"], "col2": ...}, ...}
#     4. Generate SQL (in memory, print to terminal)
#   Now receives CSV and META folder paths via command line arguments.
# ---------------------------------------------------------------------------

if len(sys.argv) != 3:
    print(f"Usage: {sys.argv[0]} <csv_folder> <meta_folder>", file=sys.stderr)
    sys.exit(1)

csv_folder = sys.argv[1]
meta_folder = sys.argv[2]

UTILS_PATH = "/home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/utils.sh"

def run_bash_func(func_name, *args):
    """Executa uma função bash do utils.sh e retorna a saída como string."""
    bash_command = [
        "bash", "-c",
        f"source {UTILS_PATH} && {func_name} \"$@\"",
        func_name, *args
    ]
    result = subprocess.run(
        bash_command,
        capture_output=True,
        text=True,
        encoding="latin1"
    )
    if result.returncode != 0:
        print(f"Error running {func_name}: {result.stderr}", file=sys.stderr)
        sys.exit(1)
    return result.stdout

# Step 1: Extract headers from CSVs (as JSON)
headers_json_str = run_bash_func("extract_csv_headers_json", csv_folder)

# Step 2: Extract meta info from meta files (as JSON)
meta_json_str = run_bash_func("find_meta_files_json", meta_folder)

# Step 3: Use generate_table_columns_json to generate the joined JSON
with open("tmp_headers.json", "w", encoding="latin1") as f:
    f.write(headers_json_str)
with open("tmp_meta.json", "w", encoding="latin1") as f:
    f.write(meta_json_str)

tabelas_json_str = run_bash_func(
    "generate_table_columns_json", "tmp_headers.json", "tmp_meta.json"
)

# Clean up temp files
Path("tmp_headers.json").unlink(missing_ok=True)
Path("tmp_meta.json").unlink(missing_ok=True)

# Step 4: Generate SQL (in memory, print to terminal)
tabelas = json.loads(tabelas_json_str, object_pairs_hook=OrderedDict)

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

# Print message at the end (as SQL for psql)
print(r"\echo Script finished successfully!")

