#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/generate_create_tables_sql.sh

# Uso: bash generate_create_tables_sql.sh <csv_folder> <meta_folder>
set -euo pipefail

# Carrega funções utilitárias do projeto
source /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/utils_pipes.sh

# Checa argumentos
if [ $# -ne 2 ]; then
  echo "Uso: $0 <csv_folder> <meta_folder>" >&2
  exit 1
fi

csv_folder="$1"
meta_folder="$2"

# Cria arquivos temporários para armazenar os JSONs intermediários
tmp_headers=$(mktemp)
tmp_meta=$(mktemp)
tmp_tabelas=$(mktemp)

# 1. Extrai os headers dos CSVs e salva em tmp_headers
extract_csv_headers_json "$csv_folder" > "$tmp_headers"

# 2. Extrai os metadados dos arquivos META e salva em tmp_meta
find_meta_files_json "$meta_folder" > "$tmp_meta"

# 3. Gera o JSON final de tabelas e colunas (chave: tabela, valor: colunas e tipos)
generate_table_columns_json "$tmp_headers" "$tmp_meta" > "$tmp_tabelas"

# 4. Gera o SQL de criação das tabelas

# Imprime o comando DROP TABLE para todas as tabelas encontradas
# Explicação do jq:
# - 'keys_unsorted' pega todas as chaves do JSON (nomes das tabelas)
# - 'join(",\n    ")' junta os nomes das tabelas separados por vírgula e quebra de linha
# - '+ " CASCADE;"' adiciona o sufixo CASCADE ao final
jq -r 'keys_unsorted | join(",\n    ") + " CASCADE;"' "$tmp_tabelas"
echo

# Para cada tabela, gera o comando CREATE TABLE
jq -c 'to_entries[]' "$tmp_tabelas" | while read -r entry; do
  table=$(echo "$entry" | jq -r '.key') # Pega o nome da tabela
  echo "-- Table: $table"
  echo "CREATE TABLE $table ("
  cols=$(echo "$entry" | jq -c '.value') # Pega o objeto de colunas da tabela

  # Prepara um array para armazenar as linhas de definição de colunas
  col_lines=()
  # mapfile lê todas as entradas de coluna para o array col_entries
  mapfile -t col_entries < <(echo "$cols" | jq -c 'to_entries[]')
  for col_entry in "${col_entries[@]}"; do
    col=$(echo "$col_entry" | jq -r '.key')
    val=$(echo "$col_entry" | jq -r '.value')
    typ=$(echo "$val" | jq -r '.[0]' | tr '[:upper:]' '[:lower:]')
    size=$(echo "$val" | jq -r '.[1]')
    case "$typ" in
      varchar|char)
        coltype="${typ}"; [[ -n "$size" && "$size" != "null" ]] && coltype="${typ}(${size//[^0-9]/})"
        ;;
      numeric|real|date|bigint)
        coltype="$typ"
        ;;
      *)
        coltype="text"
        ;;
    esac
    col_lines+=("    \"$col\" $coltype")
  done
  (IFS=$'\n'; echo "${col_lines[*]}" | sed '$!s/$/,/')
  echo ");"
  echo
done

echo '\echo Script finished successfully!'

rm "$tmp_headers" "$tmp_meta" "$tmp_tabelas"