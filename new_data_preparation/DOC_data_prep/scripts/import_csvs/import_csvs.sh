#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/import_csvs_new.sh

# Itera sobre todos os arquivos CSV em todas as subpastas /DADOS de dados/DOC/
find dados/CAD/ -type f -path "*/DADOS/*.csv" | while read -r file; do
  [ -f "$file" ] || continue

  # Obtém o nome da tabela (basename sem sufixo _yyyy, _yyyymm ou _yyyymmdd)
  basename=$(basename "$file" .csv)
  table=$(echo "$basename" | sed -E 's/_[0-9]{4}$//; s/_[0-9]{6}$//; s/_[0-9]{8}$//')

  # Extrai o header do CSV e monta a lista de colunas, mantendo a capitalização e colocando aspas duplas
  header=$(head -n 1 "$file" | tr -d '\r')
  IFS=';' read -ra cols <<< "$header"
  for i in "${!cols[@]}"; do
    # Remove espaços extras e coloca aspas duplas
    col=$(echo "${cols[$i]}" | sed 's/^ *//;s/ *$//')
    cols[$i]="\"$col\""
  done
  header_clean=$(printf ",%s" "${cols[@]}")
  header_clean=${header_clean:1} # remove a vírgula inicial

  # Gera o comando SQL para importar o arquivo
  echo "\\copy $table($header_clean) FROM '$file' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');"
  echo "\\echo Imported into $table"
done