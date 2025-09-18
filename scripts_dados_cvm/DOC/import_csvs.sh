#!/bin/bash

# Caminho base
BASE_DIR="dados/DOC"

# Caminho para o banco e usuário
PGUSER="leo"
PGDATABASE="fundos_8859"

TMP_SQL="/tmp/import_all_$$.sql"

find "$BASE_DIR" -type f \( -path "*/DADOS/*.csv" -o -path "*/DADOS/HIST/*.csv" \) | while read -r csv; do
  fname=$(basename "$csv")
  # Remove extensão
  base="${fname%.csv}"
  # Remove sufixo de data _yyyymm ou _yyyymmdd
  table=$(echo "$base" | sed -E 's/_[0-9]{6,8}$//')
  echo "\copy $table FROM '$csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');"
done > "$TMP_SQL"

psql -U "$PGUSER" -d "$PGDATABASE" -f "$TMP_SQL"
rm "$TMP_SQL"