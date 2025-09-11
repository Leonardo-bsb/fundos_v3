#!/bin/bash
# ---------------------------------------------------------------------------
# Objetivo:
#   Gerar um arquivo JSON contendo os nomes das colunas de cada arquivo CSV
#   da pasta informada, para uso como headers.json.
#
# Uso:
#   ./json_cad_headers.sh /caminho/para/dados/CAD/DADOS > headers.json
# ---------------------------------------------------------------------------

csv_dir="${1:-dados/CAD/DADOS}"

echo "{"
first=1
for f in "$csv_dir"/*.csv; do
  fname=$(basename "$f" .csv)
  header=$(head -1 "$f")
  IFS=';' read -ra cols <<< "$header"
  if [ $first -eq 0 ]; then echo ","; fi
  echo -n "  \"$fname\": ["
  for i in "${!cols[@]}"; do
    if [ $i -ne 0 ]; then echo -n ", "; fi
    echo -n "\"${cols[$i]}\""
  done
  echo -n "]"
  first=0
done
echo
echo "}"