#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/import_csvs.sh

# Uso: bash import_csvs.sh <destino_do_sql>
# Exemplo: bash import_csvs.sh /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/results

# Caminho base
BASE_DIR="dados/DOC"

# Verifica argumento de destino
if [ $# -ne 1 ]; then
  echo "Uso: $0 <pasta_de_destino_para_import_all.sql>"
  exit 1
fi

DEST_DIR="$1"
OUT_SQL="$DEST_DIR/import_all.sql"

find "$BASE_DIR" -type f \( -path "*/DADOS/*.csv" -o -path "*/DADOS/HIST/*.csv" \) | while read -r csv; do
  fname=$(basename "$csv")
  # Remove extensão
  base="${fname%.csv}"
  # Remove sufixo de data _yyyymm ou _yyyymmdd
  table=$(echo "$base" | sed -E 's/_[0-9]{6,8}$//')
  # Extrai o header do CSV e monta a lista de colunas
  header=$(head -n 1 "$csv" | tr -d '\r')
  # Remove espaços extras dos nomes das colunas e monta a lista separada por vírgula
  IFS=';' read -ra cols <<< "$header"
  header_clean=$(printf ",%s" "${cols[@]}")
  header_clean=${header_clean:1} # remove a vírgula inicial
  echo "\\copy $table($header_clean) FROM '$csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');"
done > "$OUT_SQL"

echo "Script SQL gerado em $OUT_SQL"