#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/scripts_dados_cvm/DOC/find_meta_files.sh
# ---------------------------------------------------------------------------
# Objetivo:
#   Gerar um objeto JSON válido, onde cada chave é o nome limpo do arquivo
#   meta_*.txt (sem prefixo/sufixo) e o valor é o conteúdo do format_meta.sh,
#   sem duplicar a chave.
#
# Uso:
#   bash find_meta_files.sh > meta_files.json
# ---------------------------------------------------------------------------

base_dir="dados/DOC"

# Cria uma lista de todos os arquivos meta_*.txt nas subpastas META
mapfile -t meta_files < <(find "$base_dir" -type f -path "*/META/meta_*.txt")

echo "{"
for i in "${!meta_files[@]}"; do
  f="${meta_files[$i]}"
  fname=$(basename "$f")
  clean_name="${fname#meta_}"
  clean_name="${clean_name%.txt}"
  # Extrai só o valor do objeto usando jq
  meta_json=$(bash scripts_dados_cvm/DOC/format_meta.sh "$f" | jq ".[\"$clean_name\"]")
  # Adiciona vírgula exceto no primeiro elemento
  if [ "$i" -ne 0 ]; then
    echo ","
  fi
  echo -n "  \"${clean_name}\": $meta_json"
done
echo
echo "}"