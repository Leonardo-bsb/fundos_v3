#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/generate_create_tables_sql_pipes.sh

set -euo pipefail

# Carrega funções utilitárias do projeto (deve conter todas as funções auxiliares usadas abaixo)
source /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/generate_create_tables_sql/utils_pipes.sh

# Função principal: Orquestra a geração do SQL de criação de tabelas DOC usando apenas pipes
main() {
  # Checa argumentos
  if [ $# -ne 2 ]; then
    echo "Uso: $0 <csv_folder> <meta_folder>" >&2
    exit 1
  fi

  local csv_folder="$1"
  local meta_folder="$2"

  # Extrai os headers dos CSVs (JSON) e os metadados dos arquivos META (JSON)
  headers_json=$(extract_csv_headers_json "$csv_folder")
  meta_json=$(find_meta_files_json_flat "$meta_folder")

  # Cria arquivo temporário para o JSON final
  tmp_tabelas=$(mktemp)

  # Passa os dois JSONs via pipe, separados por um delimitador, e salva no arquivo temporário
  (echo "$headers_json"; echo "___DELIM___"; echo "$meta_json") | generate_table_columns_json > "$tmp_tabelas"

  # Gera o SQL de criação das tabelas usando o JSON final
  generate_sql "$tmp_tabelas"

  # Remove o arquivo temporário
  rm "$tmp_tabelas"
}

main "$@"