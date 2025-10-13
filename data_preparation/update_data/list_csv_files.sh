#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/data_preparation/update_data/list_csv_files.sh

# Lista todos os arquivos .zip e .csv em subpastas DADOS de dados1 (recursivamente), ordenados por nome descendente,
# e para cada basename (sem sufixo de data), imprime apenas o caminho do primeiro arquivo encontrado (sem o prefixo dados1/)

find dados1/ -type f -path "*/DADOS/*.csv" -o -type f -path "*/DADOS/*.zip" | sort -r | \
awk -F/ '
{
  # Remove caminho e extensão
  fname = $NF
  # Remove sufixos de data: _yyyymmdd, _yyyymm, _yyyy
  sub(/_[0-9]{8}\.(csv|zip)$/, "", fname)
  sub(/_[0-9]{6}\.(csv|zip)$/, "", fname)
  sub(/_[0-9]{4}\.(csv|zip)$/, "", fname)
  # Remove extensão .csv ou .zip se não tiver sufixo de data
  sub(/\.(csv|zip)$/, "", fname)
  # Imprime apenas o primeiro arquivo para cada basename
  if (!(fname in seen)) {
    # Remove o prefixo dados1/ do caminho completo
    sub(/^dados1\//, "", $0)
    print $0
    seen[fname]=1
  }
}
'