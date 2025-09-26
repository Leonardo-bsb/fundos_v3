#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/format_meta.sh

set -euo pipefail  # Faz o script abortar em caso de erro, variável indefinida ou erro em pipes

# ---------------------------------------------------------------------------
# USO:
#   ./format_meta.sh <arquivo_meta.txt | diretorio_com_txt>
#   - Se receber um arquivo: gera um JSON apenas com as colunas desse arquivo (sem chave de arquivo)
#   - Se receber um diretório: gera um único JSON com todas as colunas de todos os arquivos (sem chave de arquivo)
#   Cada registro do META vira:  "CAMPO": ["TIPO","TAMANHO"]
#   A função abaixo processa um arquivo META e gera pares "campo": ["tipo","tamanho"]
#   Remove caracteres de fim de linha do Windows, linhas desnecessárias e monta o JSON.
# ---------------------------------------------------------------------------

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
  RS=""; FS="\n"; count=0;                # Usa bloco vazio como separador de registro (blocos separados por linha em branco)
}
{
  # Espera blocos com pelo menos 5 linhas (Nome, Descrição, Domínio, Tipo, Tamanho)
  # Extrai a parte após ":" em cada linha relevante
  name=$1; sub(/^[^:]*:\s*/, "", name)    # Extrai o nome do campo (linha 1)
  typ =$4; sub(/^[^:]*:\s*/, "", typ)     # Extrai o tipo (linha 4)
  size=$5; sub(/^[^:]*:\s*/, "", size)    # Extrai o tamanho (linha 5)

  # Remove todos os espaços internos
  gsub(/[[:space:]]+/, "", name)
  gsub(/[[:space:]]+/, "", typ)
  gsub(/[[:space:]]+/, "", size)

  # Escapa aspas duplas
  gsub(/"/, "\\\"", name)
  gsub(/"/, "\\\"", typ)
  gsub(/"/, "\\\"", size)

  if (length(name)==0) next               # Pula se o nome estiver vazio

  if (count++ > 0) printf ",\n"           # Adiciona vírgula entre pares, exceto no primeiro
  printf "  \"%s\": [\"%s\",\"%s\"]", name, typ, size  # Imprime o par JSON
}
END { print "" }'
}

# Checa se recebeu argumento
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <meta_file_or_directory>" >&2
  exit 1
fi

in="$1"

if [[ -d "$in" ]]; then
  # Se o argumento for um diretório, processa todos os arquivos .txt dentro dele
  echo "{"
  first=1
  shopt -s nullglob  # Garante que o for não falhe se não houver arquivos .txt
  for f in "$in"/*.txt; do
    [[ -f "$f" ]] || continue  # Pula se não for arquivo regular
    obj="$(build_object_from_meta "$f")"  # Processa o arquivo e gera o JSON dos campos
    [[ -z "$obj" ]] && continue           # Pula se o resultado estiver vazio
    if [[ $first -eq 0 ]]; then echo ","; fi  # Adiciona vírgula entre objetos, exceto antes do primeiro
    echo "$obj"                              # Imprime o JSON dos campos desse arquivo
    first=0
  done
  echo "}"
elif [[ -f "$in" ]]; then
  # Se o argumento for um arquivo, processa apenas esse arquivo
  obj="$(build_object_from_meta "$in")"   # Processa o arquivo e gera o JSON dos campos
  echo "{"
  echo "$obj"
  echo "}"
else
  # Se o argumento não for nem arquivo nem diretório, exibe erro e sai com código 1
  echo "Erro: caminho não encontrado: $in" >&2
  exit 1
fi