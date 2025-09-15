#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/scripts_dados_cvm/DOC/find_meta_files.sh
# ---------------------------------------------------------------------------
# Objetivo:
#   Listar todos os arquivos .txt que estão dentro de subpastas chamadas META
#   na árvore de dados/DOC, imprimindo o caminho de cada arquivo seguido do
#   nome limpo (sem meta_ e .txt).
#
# Como funciona:
#   - Percorre recursivamente a pasta dados/DOC.
#   - Filtra apenas arquivos .txt em subpastas META.
#   - Para cada arquivo, imprime o caminho completo e o nome limpo.
#
# Uso:
#   bash find_meta_files.sh
# ---------------------------------------------------------------------------

find dados/DOC -type f -path "*/META/meta_*.txt" | while read -r f; do
  fname=$(basename "$f")
  clean_name="${fname#meta_}"
  clean_name="${clean_name%.txt}"
  echo "$f"
  echo "$clean_name"
done