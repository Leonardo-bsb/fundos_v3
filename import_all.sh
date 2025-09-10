# ---------------------------------------------------------------------------
# Objetivo:
#   Gerar um arquivo import_all.sql contendo comandos \copy para importar
#   todos os arquivos CSV da pasta dados/CAD/DADOS para suas respectivas
#   tabelas no PostgreSQL.
#
# Como usar:
#   1. Execute este script no terminal (não dentro do psql):
#        bash import_all.sh
#   2. No prompt do psql, execute:
#        \i /home/leo/linguagens/fundos_v3/import_all.sql
#
# Observações:
#   - O nome da tabela deve ser igual ao nome do arquivo CSV (sem .csv).
#   - O comando usa DELIMITER ';', CSV HEADER e ENCODING 'LATIN1'.
# ---------------------------------------------------------------------------

for f in /home/leo/linguagens/fundos_v3/dados/CAD/DADOS/*.csv; do
  t=$(basename "$f" .csv)
  echo "\\copy $t FROM '$f' DELIMITER ';' CSV HEADER ENCODING 'LATIN1';"
done