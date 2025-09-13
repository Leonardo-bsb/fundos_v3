import json
import subprocess
from collections import OrderedDict

# ---------------------------------------------------------------------------
# Purpose:
#   Reorder second-level keys (column names) in meta_cad.json to match the
#   order provided in headers.json, per table.
#
# Inputs:
#   - headers: output of scripts_dados_cvm/CAD/json_cad_headers.sh
#   - meta: output of scripts_dados_cvm/CAD/format_meta.sh
#
# Output:
#   - Prints the sorted JSON to the terminal (stdout).
#
# Notes:
#   - Uses OrderedDict to preserve the desired order in the output JSON.
#   - Emits warnings for columns present in headers but missing in meta and
#     for tables present in headers but not in meta.
#   - All encoding is set to latin1 for compatibility with original data.
# ---------------------------------------------------------------------------

headers_script = ["bash", "scripts_dados_cvm/CAD/json_cad_headers.sh", "dados/CAD/DADOS"]
meta_script = ["bash", "scripts_dados_cvm/CAD/format_meta.sh", "dados/CAD/META"]

# Run scripts and load JSON outputs (decode as latin1)
headers_json = subprocess.run(headers_script, capture_output=True).stdout.decode("latin1")
meta_json = subprocess.run(meta_script, capture_output=True).stdout.decode("latin1")

headers = json.loads(headers_json)
meta = json.loads(meta_json)

sorted_meta = OrderedDict()

# Iterate each table present in meta
for table, meta_obj in meta.items():
    table_headers = headers.get(table, [])

    if not isinstance(meta_obj, dict):
        print(f"-- WARN: meta[{table}] is not an object, skipping re-order")
        sorted_meta[table] = meta_obj
        continue

    ordered = OrderedDict()
    missing_in_meta = []
    for col in table_headers:
        if col in meta_obj:
            ordered[col] = meta_obj[col]
        else:
            missing_in_meta.append(col)

    extras = [k for k in meta_obj.keys() if k not in ordered]
    for k in extras:
        ordered[k] = meta_obj[k]

    if missing_in_meta:
        print(f"-- WARN: {table}: columns in headers but not in meta: {missing_in_meta}")
    if extras:
        extra_only = [k for k in extras if k not in table_headers]
        if extra_only:
            print(f"-- INFO: {table}: extra columns only in meta (appended at end): {extra_only}")

    sorted_meta[table] = ordered

only_in_headers = [t for t in headers.keys() if t not in sorted_meta]
for t in only_in_headers:
    print(f"-- WARN: table in headers but not in meta: {t}")

# Print the sorted meta JSON to terminal (stdout)
print(json.dumps(sorted_meta, ensure_ascii=False, indent=2))