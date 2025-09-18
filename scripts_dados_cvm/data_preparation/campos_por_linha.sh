#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/scripts_dados_cvm/data_preparation/count_fields.sh
# Uso: bash count_fields.sh arquivo.csv

if [ $# -ne 1 ]; then
  echo "Uso: $0 arquivo.csv"
  exit 1
fi

awk -F';' '
  NF==9 {n9++}
  NF==18 {n18++}
  END {
    print "Linhas com 9 campos: " n9+0
    print "Linhas com 18 campos: " n18+0
  }
' "$1"