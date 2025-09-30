import subprocess

def test_sql_output_equals_expected(tmp_path):
    # Caminhos dos arquivos
    script = "new_data_preparation/DOC_data_prep/scripts/generate_create_tables_sql/generate_create_tables_sql_pipes.py"
    csv_folder = "dados/Doc"
    meta_folder = "dados/Doc"
    expected_file = "new_data_preparation/sql_scripts/create_doc_tables-teste.sql"
    output_file = tmp_path / "output.sql"

    # Executa o script e salva a saída
    result = subprocess.run(
        ["python3", script, csv_folder, meta_folder],
        stdout=open(output_file, "w", encoding="latin1"),
        stderr=subprocess.PIPE,
        text=True
    )
    assert result.returncode == 0, f"Script failed: {result.stderr}"

    # Usa o diff do sistema para comparar os arquivos
    diff_result = subprocess.run(
        ["diff", "-u", expected_file, str(output_file)],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )

    if diff_result.stdout:
        print(diff_result.stdout)
    assert diff_result.returncode == 0, "SQL output does not match expected file"