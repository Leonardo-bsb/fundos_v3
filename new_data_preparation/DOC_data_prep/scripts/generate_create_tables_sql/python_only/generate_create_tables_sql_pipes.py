import sys
import os
import glob
import json
import subprocess
from utils_pipes import (
    extract_csv_headers_json,
    generate_table_columns_json,
    generate_sql
)

UTILS_SH = "new_data_preparation/DOC_data_prep/scripts/generate_create_tables_sql/python_only/utils_pipes.sh"

def build_object_from_meta_file_bash(meta_file):
    """
    Calls the Bash function build_object_from_meta_file for a given META file.
    Returns a dict: {column: [type, size]}
    """
    bash_cmd = f"source '{UTILS_SH}'; build_object_from_meta_file < '{meta_file}'"
    result = subprocess.run(
        ["bash", "-c", bash_cmd],
        capture_output=True,
        text=True,
        encoding="latin_1"
    )
    if result.returncode != 0:
        raise RuntimeError(f"Error running build_object_from_meta_file: {result.stderr}")
    # Parse the output JSON
    try:
        return json.loads(result.stdout)
    except Exception as e:
        print(f"Error parsing JSON from {meta_file}: {e}")
        return {}

def find_meta_files_json_flat_bash(base_dir):
    """
    Uses the Bash build_object_from_meta_file for all META files in base_dir.
    Returns a dict where each key is a column name, and the value is the last [type, size] found.
    """
    meta_files = glob.glob(os.path.join(base_dir, "**/META/meta_*.txt"), recursive=True)
    data = {}
    for meta_file in meta_files:
        obj = build_object_from_meta_file_bash(meta_file)
        for k, v in obj.items():
            data[k] = v
    return {k: data[k] for k in sorted(data)}

def main(csv_folder, meta_folder):
    # Extract headers from CSVs
    headers_json = extract_csv_headers_json(csv_folder)
    # Use bash/awk/sed logic for META files
    meta_json = find_meta_files_json_flat_bash(meta_folder)
    # Cross headers and meta
    tabelas_json = generate_table_columns_json(headers_json, meta_json)
    # Generate SQL
    generate_sql(tabelas_json)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Uso: {sys.argv[0]} <csv_folder> <meta_folder>", file=sys.stderr)
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])