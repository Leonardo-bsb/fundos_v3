#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/scripts_dados_cvm/DOC/tabelas_colunas.sh
# ---------------------------------------------------------------------------
# Objetivo:
#   Receber dois arquivos JSON:
#     1. headers.json: {"tabela1": ["col1", "col2", ...], ...}
#     2. meta.json: {"col1": ["tipo", "tamanho"], ...}
#   Gerar um novo JSON:
#     {"tabela1": {"col1": ["tipo", "tamanho"], "col2": ...}, ...}
#   Só insere colunas que existem em meta.json.
#
# Uso:
#   bash tabelas_colunas.sh headers.json meta.json > tabelas_colunas.json
# ---------------------------------------------------------------------------

if [ $# -ne 2 ]; then
  echo "Uso: $0 headers.json meta.json" >&2
  exit 1
fi

headers_json="$1"
meta_json="$2"

# Gera o resultado usando jq
jq -n --argfile headers "$headers_json" --argfile meta "$meta_json" '
  ($headers | to_entries) as $tables
  | reduce $tables[] as $tbl ({}; 
      .[$tbl.key] = (
        $tbl.value
        | map(select(. as $col | $meta[$col] != null)
              | {key: ., value: $meta[.]})
        | from_entries
      )
    )
'