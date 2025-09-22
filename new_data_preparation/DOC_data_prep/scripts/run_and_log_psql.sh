#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/run_and_log_psql.sh

# Defina suas variáveis
DB_NAME="fundos_8859"
DB_USER="leo"

# Verifica se o argumento foi passado
if [ $# -ne 1 ]; then
  echo "Uso: $0 <script_sql>"
  exit 1
fi

SCRIPT_SQL="$1"

# Imprime o nome do script e executa o comando, salvando tudo no log
{
  echo "Script SQL: $SCRIPT_SQL"
  psql -U "$DB_USER" -d "$DB_NAME" -f "$SCRIPT_SQL"
  echo "Script execution finished!"
} >> psql_log.txt 2>&1

echo "Script completed. Check psql_log.txt for details."