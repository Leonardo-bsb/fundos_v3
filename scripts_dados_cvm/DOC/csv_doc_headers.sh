#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/scripts_dados_cvm/DOC/csv_doc_headers.sh
# ---------------------------------------------------------------------------
# Objetivo:
#   Para cada arquivo .txt em subpastas META, procura um arquivo .csv que comece
#   com esse nome nas subpastas /DADOS/ do base_dir e gera um objeto JSON onde
#   as chaves são o clean_name e os valores são arrays com os headers do CSV.
#
# Uso:
#   bash csv_doc_headers.sh /caminho/para/pasta
# ---------------------------------------------------------------------------

base_dir="$1"
if [ -z "$base_dir" ]; then
  echo "Uso: $0 /caminho/para/pasta" >&2
  exit 1
fi

find "$base_dir" -type f -path "*/META/meta_*.txt" | while read -r f; do
  fname=$(basename "$f")
  clean_name="${fname#meta_}"
  clean_name="${clean_name%.txt}"
  csv_file=$(find "$base_dir" -type f -path "*/DADOS/${clean_name}*.csv" | head -n 1)
  if [ -n "$csv_file" ]; then
    header=$(head -n 1 "$csv_file")
    # Transforma o header em array JSON
    header_json=$(echo "$header" | awk -F';' '{
      printf("[");
      for(i=1;i<=NF;i++){
        gsub(/"/, "\\\"", $i);
        printf("%s\"%s\"", (i>1?",":""), $i);
      }
      printf("]");
    }')
    echo "$clean_name|$header_json"
  fi
done | {
  echo "{"
  first=1
  while IFS='|' read -r name header_arr; do
    if [ $first -eq 0 ]; then
      echo ","
    fi
    echo -n "  \"${name}\": ${header_arr}"
    first=0
  done
  echo
  echo "}"
}