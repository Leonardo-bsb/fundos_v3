#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/scripts_dados_cvm/data_preparation/dos2unix-v1.sh

# Caminho relativo a partir do diretório raiz do projeto
DADOS_DIR="dados"
find "$DADOS_DIR" -type f -exec dos2unix {} \;
# Remove \r do final das linhas e todas as aspas simples e duplas de todos os arquivos na pasta dados/ recursivamente
find "$DADOS_DIR" -type f -exec sh -c '
  echo "Processando: $1"
  sed -i "s/\r\$//; s/[\"'\'']/ /g" "$1"
' _ {} \;

find "$DADOS_DIR" -type f -exec sed -i '/Warning: Null value is eliminated by an aggregate or other SET operation./d' {} \;

echo "Conversão concluída. Todos os arquivos em dados/ agora estão no formato Unix e sem aspas."