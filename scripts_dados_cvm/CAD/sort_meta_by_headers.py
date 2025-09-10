import json
from collections import OrderedDict
from pathlib import Path

# ---------------------------------------------------------------------------
# Purpose:
#   Reorder second-level keys (column names) in meta_cad.json to match the
#   order provided in headers.json, per table.
#
# Inputs (read using Latin-1 due to original data encoding):
#   - headers.json: { "<table>": ["COL1","COL2",...], ... }
#   - meta_cad.json: { "<table>": { "COL": ["TYPE","SIZE"], ... }, ... }
#
# Output:
#   - meta_cad.sorted.json with the same structure of meta_cad.json but with
#     columns ordered per headers.json order. Extra columns appear at the end.
#
# Notes:
#   - Uses OrderedDict to preserve the desired order in the output JSON.
#   - Emits warnings for columns present in headers but missing in meta and
#     for tables present in headers but not in meta.
#   - All files are opened with encoding="latin1".
# ---------------------------------------------------------------------------

headers_path = Path("/home/leo/linguagens/fundos_v3/results_scripts/CAD/headers.json")
meta_path = Path("/home/leo/linguagens/fundos_v3/results_scripts/CAD/meta_cad.json")
out_path = Path("/home/leo/linguagens/fundos_v3/results_scripts/CAD/meta_cad.sorted.json")

# Load headers and meta using Latin-1 encoding
with headers_path.open(encoding="latin1") as f:
    headers = json.load(f)
with meta_path.open(encoding="latin1") as f:
    meta = json.load(f)

sorted_meta = OrderedDict()

# Iterate each table present in meta
for table, meta_obj in meta.items():
    # Get the target order for this table from headers.json (may be empty)
    table_headers = headers.get(table, [])

    # Skip reordering if the meta entry is not an object/dict
    if not isinstance(meta_obj, dict):
        print(f"-- WARN: meta[{table}] is not an object, skipping re-order")
        sorted_meta[table] = meta_obj
        continue

    # First: place columns following headers.json order (only those that exist in meta)
    ordered = OrderedDict()
    missing_in_meta = []
    for col in table_headers:
        if col in meta_obj:
            ordered[col] = meta_obj[col]
        else:
            # Keep track of columns that appear in headers but not in meta
            missing_in_meta.append(col)

    # Then: append any extra columns that exist only in meta (preserving their original order)
    extras = [k for k in meta_obj.keys() if k not in ordered]
    for k in extras:
        ordered[k] = meta_obj[k]

    # Emit informational messages about mismatches
    if missing_in_meta:
        print(f"-- WARN: {table}: columns in headers but not in meta: {missing_in_meta}")
    if extras:
        extra_only = [k for k in extras if k not in table_headers]
        if extra_only:
            print(f"-- INFO: {table}: extra columns only in meta (appended at end): {extra_only}")

    # Save the ordered object for this table
    sorted_meta[table] = ordered

# Also warn for any tables present only in headers (not found in meta)
only_in_headers = [t for t in headers.keys() if t not in sorted_meta]
for t in only_in_headers:
    print(f"-- WARN: table in headers but not in meta: {t}")

# Write the sorted meta JSON using Latin-1 encoding
with out_path.open("w", encoding="latin1") as f:
    json.dump(sorted_meta, f, ensure_ascii=False, indent=2)

print(f"Written: {out_path}")