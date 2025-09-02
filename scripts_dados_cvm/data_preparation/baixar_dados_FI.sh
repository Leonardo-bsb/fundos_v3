# Baixa recursivamente arquivos .zip, .csv e .txt do site da CVM,
# salvando todos na pasta 'dados/' e mantendo a estrutura de subpastas a partir de FI/
wget -r -np -nH --cut-dirs=2 -A "zip,csv,txt" -P dados https://dados.cvm.gov.br/dados/FI/