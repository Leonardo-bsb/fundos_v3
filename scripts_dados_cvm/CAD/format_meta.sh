#!/bin/bash
set -euo pipefail

# Uso: ./format_meta.sh <arquivo_meta.txt | diretorio_com_txt>
# - Diretório: gera um único JSON com uma chave por arquivo (sem meta_ e .txt)
# - Arquivo: gera JSON com uma única chave
# Cada registro do META vira:  "CAMPO": ["TIPO","TAMANHO"]

build_object_from_meta() {
  local in="$1"
  sed -e 's/\r//g' "$in" \
    | sed '/^-/d' \
    | sed '/Descrição/d' \
    | sed '/Descricao/d' \
    | sed '/Domínio/d' \
    | sed '/Dominio/d' \
    | awk '
BEGIN {
  RS=""; FS="\n"; count=0;
}
{
  # Espera blocos com pelo menos 5 linhas (Nome, Descrição, Domínio, Tipo, Tamanho)
  # Extrai a parte após ":" em cada linha relevante
  name=$1; sub(/^[^:]*:\s*/, "", name)
  typ =$4; sub(/^[^:]*:\s*/, "", typ)
  size=$5; sub(/^[^:]*:\s*/, "", size)

  # Remove espaços internos, como no bash original (gsub(/ /,"", $0))
  gsub(/[[:space:]]+/, "", name)
  gsub(/[[:space:]]+/, "", typ)
  gsub(/[[:space:]]+/, "", size)

  # Escapa aspas
  gsub(/"/, "\\\"", name)
  gsub(/"/, "\\\"", typ)
  gsub(/"/, "\\\"", size)

  if (length(name)==0) next

  if (count++ > 0) printf ",\n"
  printf "    \"%s\": [\"%s\",\"%s\"]", name, typ, size
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
    obj="$(build_object_from_meta "$f")"
    [[ -z "$obj" ]] && continue
    if [[ $first -eq 0 ]]; then echo ","; fi
    echo "  \"$key\": {"
    echo "$obj"
    echo "  }"
    first=0
  done
  echo "}"
elif [[ -f "$in" ]]; then
  fname="$(basename "$in")"
  key="${fname%.txt}"
  key="${key#meta_}"
  obj="$(build_object_from_meta "$in")"
  echo "{"
  echo "  \"$key\": {"
  echo "$obj"
  echo "  }"
  echo "}"
else
  echo "Erro: caminho não encontrado: $in" >&2
  exit 1
fi