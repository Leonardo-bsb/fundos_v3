#!/bin/bash

# ---------------------------------------------------------------------------
# Função: json_cad_headers
# Objetivo:
#   Gerar um arquivo JSON contendo os nomes das colunas de cada arquivo CSV
#   da pasta informada, para uso como headers.json.
#
# Uso:
#   json_cad_headers /caminho/para/dados/CAD/DADOS > headers.json
# ---------------------------------------------------------------------------
json_cad_headers() {
  local csv_dir="$1"
  if [ -z "$csv_dir" ]; then
    echo "Uso: json_cad_headers /caminho/para/dados/CAD/DADOS" >&2
    return 1
  fi

  echo "{"
  local first=1
  for f in "$csv_dir"/*.csv; do
    local fname=$(basename "$f" .csv)
    local header=$(head -1 "$f")
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
}

# ---------------------------------------------------------------------------
# Função: format_meta
# Objetivo:
#   Gerar um arquivo JSON contendo os metadados dos arquivos META da pasta informada.
#
# Uso:
#   format_meta /caminho/para/dados/CAD/META > meta.json
# ---------------------------------------------------------------------------
format_meta() {
  local meta_dir="$1"
  if [ -z "$meta_dir" ]; then
    echo "Uso: format_meta /caminho/para/dados/CAD/META" >&2
    return 1
  fi

  echo "{"
  local first=1
  for f in "$meta_dir"/*.txt; do
    local fname=$(basename "$f" .txt)
    # Processa cada arquivo META para extrair campos, tipo e tamanho
    local obj=$(awk '
      BEGIN { print "{" }
      {
        if ($0 ~ /^Campo:/) {
          if (count++ > 0) print ",";
          gsub(/^Campo:[[:space:]]*/, "", $0);
          printf "  \"%s\": ", $0;
        }
        if ($0 ~ /^Tipo Dados:/) {
          gsub(/^Tipo Dados:[[:space:]]*/, "", $0);
          tipo = $0;
        }
        if ($0 ~ /^Tamanho:/) {
          gsub(/^Tamanho:[[:space:]]*/, "", $0);
          tamanho = $0;
          printf "[\"%s\", \"%s\"]", tipo, tamanho;
        }
      }
      END { print "" }
    ' "$f")
    if [ $first -eq 0 ]; then echo ","; fi
    echo -n "  \"$fname\": $obj"
    first=0
  done
  echo
  echo "}"
}