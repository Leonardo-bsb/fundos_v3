#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/data_preparation/download_data/scripts/baixar_dados_FI.sh

# Baixa recursivamente arquivos .zip, .csv e .txt do site da CVM,
# salvando todos na pasta 'dados/' e mantendo a estrutura de subpastas a partir de FI/

wget -r -np -nH --cut-dirs=2 -A "zip,csv,txt" -P dados1 https://dados.cvm.gov.br/dados/FI/