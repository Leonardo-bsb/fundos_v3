#!/bin/bash

# Executa o comando 'file' em todos os arquivos da pasta dados/ recursivamente
# e salva o resultado em scripts_dados_cvm/files.txt

find "$(dirname "$0")/../dados" -type f -exec file {} \; > "$(dirname "$0")/files.txt"

echo "Resultado salvo em scripts_dados_cvm/files.txt"
