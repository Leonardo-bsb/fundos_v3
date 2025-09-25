#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/find_meta_files.sh
# ---------------------------------------------------------------------------
# Objetivo:
#   Gerar um objeto JSON onde cada chave é o nome único da coluna (segunda ordem)
#   encontrada nos arquivos meta_*.txt das subpastas META, e o valor é a array
#   correspondente (ex: ["numeric","Precis�o:17"]), sem repetir a chave dentro da array.
#   As chaves aparecem em ordem alfabética.
#
# Uso:
#   bash find_meta_files.sh <base_dir> > meta_files_columns.json
#   Este script chama extract_meta_fields.sh para extrair os campos dos arquivos META.
# ---------------------------------------------------------------------------

if [ $# -ne 1 ]; then
  echo "Uso: $0 <base_dir>" >&2
  exit 1
fi

base_dir="$1"
tmp_json=$(mktemp)

# Para cada arquivo meta_*.txt, extrai as chaves (colunas) e arrays de valores (apenas o array interno)
find "$base_dir" -type f -path "*/META/meta_*.txt" | while read -r f; do
  bash new_data_preparation/DOC_data_prep/scripts/extract_meta_fields.sh "$f" | jq -c 'to_entries[] | [ .key, .value[0], .value[1] ]' >> "$tmp_json"
done

# Monta o JSON final, garantindo unicidade das chaves (a última ocorrência prevalece) e ordenando alfabeticamente
echo "{"
awk -F\" '
  {
    key = $2;
    value_start = index($0, "[");
    value = substr($0, value_start);
    # value é do tipo ["key","tipo","tamanho"]
    # Queremos ["tipo","tamanho"]
    sub(/^\["[^"]+",/, "[", value);
    data[key] = value;
  }
  END {
    n = asorti(data, sorted_keys);
    for (i = 1; i <= n; i++) {
      k = sorted_keys[i];
      if (i > 1) printf(",\n");
      printf("  \"%s\": %s", k, data[k]);
    }
  }
' "$tmp_json"
echo
echo "}"

rm "$tmp_json"