#!/bin/bash
set -euo pipefail

# Uso: ./format_meta.sh <arquivo_meta.txt | diretorio_com_txt>
# - Se for diretório: gera um único JSON com uma chave por arquivo (sem meta_ e .txt)
# - Se for arquivo: gera JSON com uma única chave

build_array_from_meta() {
  local in="$1"
  sed -e 's/\r//g' "$in" \
    | sed '/^-/d' \
    | sed '/Descrição/d' \
    | sed '/Descricao/d' \
    | sed '/Domínio/d' \
    | sed '/Dominio/d' \
    | awk -F: '{ print $2 }' \
    | awk '
BEGIN { FS=";"; RS=""; c=0 }
{
  gsub(/ /, "", $0);
  # campos: $1 = nome, $4 = tipo, $5 = tamanho
  name=$1; typ=$4; size=$5;
  # escapa aspas
  gsub(/"/, "\\\"", name);
  gsub(/"/, "\\\"", typ);
  gsub(/"/, "\\\"", size);
  printf "%s[\"%s\",\"%s\",\"%s\"]", (c++?",":""), name, typ, size
}
END { print "" }'
}

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <meta_file_or_directory>" >&2
  exit 1
fi

in="$1"

if [[ -d "$in" ]]; then
  echo "{"
  first=1
  shopt -s nullglob
  for f in "$in"/*.txt; do
    [[ -f "$f" ]] || continue
    fname="$(basename "$f")"
    key="${fname%.txt}"
    key="${key#meta_}"
    arr="$(build_array_from_meta "$f")"
    # pula vazios
    [[ -z "$arr" ]] && continue
    if [[ $first -eq 0 ]]; then echo ","; fi
    echo "  \"$key\": [$arr]"
    first=0
  done
  echo "}"
elif [[ -f "$in" ]]; then
  fname="$(basename "$in")"
  key="${fname%.txt}"
  key="${key#meta_}"
  arr="$(build_array_from_meta "$in")"
  echo "{"
  echo "  \"$key\": [$arr]"
  echo "}"
else
  echo "Erro: caminho não encontrado: $in" >&2
  exit 1
fi