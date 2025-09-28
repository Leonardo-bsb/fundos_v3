import os
import json
import glob

def extract_csv_headers_json(base_dir):
    """
    For each meta_*.txt in META subfolders, finds all CSVs starting with the table name in DADOS subfolders,
    and returns a dict where keys are table names and values are lists of unique column names from CSV headers.
    """
    result = {}
    meta_files = glob.glob(os.path.join(base_dir, "**/META/meta_*.txt"), recursive=True)
    for meta_file in meta_files:
        clean_name = os.path.basename(meta_file)[5:-4]  # Remove 'meta_' and '.txt'
        csv_files = glob.glob(os.path.join(base_dir, f"**/DADOS/{clean_name}*.csv"), recursive=True)
        headers = set()
        for csv_file in csv_files:
            with open(csv_file, encoding="latin_1") as f:
                first_line = f.readline().strip()
                headers.update(first_line.split(";"))
        result[clean_name] = sorted(h for h in headers if h)
    return result

def build_object_from_meta_file(meta_file):
    """
    Processes a META file and returns a dict: {column: [type, size]}
    """
    with open(meta_file, encoding="latin_1") as f:
        content = f.read().replace('\r', '')
    blocks = [b for b in content.split('\n\n') if b.strip()]
    result = {}
    for block in blocks:
        lines = block.split('\n')
        if len(lines) < 5:
            continue
        name = lines[0].split(':', 1)[-1].strip()
        typ = lines[3].split(':', 1)[-1].strip()
        size = lines[4].split(':', 1)[-1].strip()
        if name:
            result[name] = [typ, size]
    return result

def find_meta_files_json_flat(base_dir):
    """
    Processes all META files in a directory and returns a dict where each key is a column name,
    and the value is the last [type, size] found for that column (across all META files).
    """
    meta_files = glob.glob(os.path.join(base_dir, "**/META/meta_*.txt"), recursive=True)
    data = {}
    for meta_file in meta_files:
        obj = build_object_from_meta_file(meta_file)
        for k, v in obj.items():
            data[k] = v
    # Sort keys alphabetically
    return {k: data[k] for k in sorted(data)}

def generate_table_columns_json(headers_json, meta_json):
    """
    Receives two dicts: headers_json and meta_json.
    Returns a dict: {table: {col: [type, size], ...}, ...}
    Only includes columns that exist in meta_json.
    """
    result = {}
    for table, columns in headers_json.items():
        table_cols = {}
        for col in columns:
            if col in meta_json:
                table_cols[col] = meta_json[col]
        result[table] = table_cols
    return result

def generate_sql(tabelas_json):
    """
    Receives a dict of tables and columns, and prints SQL for DROP and CREATE TABLEs.
    """
    table_names = list(tabelas_json.keys())
    print("DROP TABLE IF EXISTS")
    print(",\n    ".join(table_names), "CASCADE;\n")

    for table, columns in tabelas_json.items():
        print(f"-- Table: {table}")
        print(f"CREATE TABLE {table} (")
        col_defs = []
        for col, val in columns.items():
            typ, size = val
            typ = typ.lower()
            if typ in ("varchar", "char"):
                coltype = f'{typ}({size})' if size.isdigit() else typ
            elif typ in ("numeric", "real", "date", "bigint"):
                coltype = typ
            else:
                coltype = "text"
            col_defs.append(f'    "{col}" {coltype}')
        print(",\n".join(col_defs))
        print(");\n")
    print(r"\echo Script finished successfully!")

# Example usage (replace with your actual workflow):
if __name__ == "__main__":
    csv_folder = "dados/DOC/"
    meta_folder = "dados/DOC/"
    headers_json = extract_csv_headers_json(csv_folder)
    meta_json = find_meta_files_json_flat(meta_folder)
    tabelas_json = generate_table_columns_json(headers_json, meta_json)
    generate_sql(tabelas_json)