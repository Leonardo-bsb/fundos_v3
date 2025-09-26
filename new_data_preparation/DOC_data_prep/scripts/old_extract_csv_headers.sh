#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/csv_doc_headers.sh
# ---------------------------------------------------------------------------
# Objetivo:
#   Para cada arquivo .txt em subpastas META, procura todos os arquivos .csv que comecem
#   com esse nome nas subpastas /DADOS/ do base_dir e gera um objeto JSON onde
#   as chaves são o clean_name e os valores são arrays com os nomes únicos das colunas
#   encontradas nos headers desses csvs.
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

  # Procura todos os CSVs que começam com o clean_name
  find "$base_dir" -type f -path "*/DADOS/${clean_name}*.csv" | while read -r csv_file; do
    head -n 1 "$csv_file"
  done | tr ';' '\n' | awk 'NF' | sort -u | awk '{printf "%s\"%s\"", (NR==1?"[":","), $0} END{if(NR>0)print "]"; else print "[]"}' | \
  awk -v name="$clean_name" 'BEGIN{ORS=""} {print name "|" $0 "\n"}'
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