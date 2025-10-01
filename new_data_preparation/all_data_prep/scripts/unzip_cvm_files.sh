#!/bin/bash

# Define o diretório onde estão os arquivos zip
DATA_DIR="$(dirname "$0")/../dados"

# Procura todos os arquivos .zip recursivamente na pasta dados
# Para cada arquivo encontrado:
#   - Descompacta no mesmo diretório do arquivo
#   - Se a descompactação for bem-sucedida, apaga o .zip
#   - Caso contrário, exibe mensagem de erro
find "$DATA_DIR" -type f -name "*.zip" | while read -r zipfile; do
    echo "Unzipping $zipfile ..."
    unzip -o "$zipfile" -d "$(dirname "$zipfile")"
    if [ $? -eq 0 ]; then
        echo "Deleting $zipfile ..."
        rm -f "$zipfile"
    else
        echo "Failed to unzip $zipfile" >&2
    fi
done
