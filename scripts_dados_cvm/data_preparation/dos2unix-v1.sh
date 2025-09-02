#!/bin/bash

# Remove \r do final das linhas e todas as aspas simples e duplas de todos os arquivos na pasta dados/ recursivamente
find "$(dirname "$0")/../dados" -type f -exec sh -c '
  echo "Processando: $1"
  sed -i "s/\r\$//; s/[\"'\'']/ /g" "$1"
' _ {} \;

echo "Conversão concluída. Todos os arquivos em dados/ agora estão no formato Unix e sem aspas."

