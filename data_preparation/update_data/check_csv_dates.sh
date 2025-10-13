#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/data_preparation/update_data/check_csv_dates.sh

# Script para verificar a data de última modificação de arquivos remotos da CVM
# e converter as datas para o formato yyyy-mm-dd

# URL base do site de dados da CVM
BASE_URL="https://dados.cvm.gov.br/dados/FI/"
# Arquivo contendo a lista de arquivos a serem verificados
RECENT_FILES="data_preparation/update_data/recent_files"
# Cria um arquivo temporário para armazenar as respostas HTTP
TMPFILE=$(mktemp)

# Para cada arquivo listado em recent_files, salva o nome e o cabeçalho HTTP no arquivo temporário
while read -r file; do
  # Monta a URL completa concatenando a URL base com o caminho do arquivo
  url="${BASE_URL}${file}"
  # Salva o nome do arquivo (com ':' no final) no arquivo temporário
  echo "$file:" >> "$TMPFILE"
  # Faz uma requisição HTTP HEAD (-I) silenciosa (-s) para obter apenas os cabeçalhos
  curl -sI "$url" >> "$TMPFILE"
  # Adiciona uma linha em branco para separar os arquivos
  echo >> "$TMPFILE"
done < "$RECENT_FILES"

# Processa o arquivo temporário para extrair apenas o nome do arquivo e a data de modificação
awk '/:$/ {fname=$0}  # Identifica linhas que terminam com ':' (nomes dos arquivos)
/^Last-Modified:/ {
  # Extrai a data do campo Last-Modified
  split($0, arr, " ")  # Divide a linha em palavras separadas por espaço
  # arr[3]=dia, arr[4]=mês abreviado, arr[5]=ano
  
  # Mapa de conversão de meses abreviados para números
  m["Jan"]="01"; m["Feb"]="02"; m["Mar"]="03"; m["Apr"]="04"; m["May"]="05"; m["Jun"]="06";
  m["Jul"]="07"; m["Aug"]="08"; m["Sep"]="09"; m["Oct"]="10"; m["Nov"]="11"; m["Dec"]="12";
  
  # Imprime o nome do arquivo seguido da data no formato yyyy-mm-dd
  printf "%s %s-%s-%s\n", fname, arr[5], m[arr[4]], arr[3]
}' "$TMPFILE"

# Remove o arquivo temporário
rm "$TMPFILE"