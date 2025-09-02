#!/bin/bash

# Para cada subpasta chamada DADOS dentro de dados/DOC/, pega o primeiro arquivo CSV e extrai o header
find dados/DOC/ -type d -name DADOS | while read -r dir; do
  f=$(find "$dir" -maxdepth 1 -type f -name '*.csv' | head -n 1)
  [ -z "$f" ] && continue
  fname=$(basename "$f" .csv)
  # Remove sufixo _yyyymm (ano e mês) ou _yyyy (apenas ano)
  fname=$(echo "$fname" | sed -E 's/_[0-9]{6}$//;s/_[0-9]{4}$//')
  header=$(head -1 "$f")
  # Converte o header em array separada por ponto e vírgula
  IFS=';' read -ra cols <<< "$header"
  # Monta array em formato bash
  echo -n "$fname: ["
  for i in "${!cols[@]}"; do
    if [ $i -ne 0 ]; then echo -n ", "; fi
    echo -n "\"${cols[$i]}\""
  done
  echo "]"
done