#!/bin/bash
# Função: extract_csv_headers_json
# Objetivo:
#   Para cada arquivo .txt em subpastas META, procura todos os arquivos .csv que comecem
#   com esse nome nas subpastas /DADOS/ do base_dir e gera um objeto JSON onde
#   as chaves são o clean_name e os valores são arrays com os nomes únicos das colunas
#   encontradas nos headers desses csvs.
#
# Uso:
#   source utils.sh
#   extract_csv_headers_json /caminho/para/pasta

extract_csv_headers_json() {
  local base_dir="$1"
  if [ -z "$base_dir" ]; then
    echo "Uso: extract_csv_headers_json /caminho/para/pasta" >&2
    return 1
  fi

  find "$base_dir" -type f -path "*/META/meta_*.txt" | while read -r f; do
    fname=$(basename "$f")
    clean_name="${fname#meta_}"
    clean_name="${clean_name%.txt}"

    # Procura todos os CSVs que começam com o clean_name
    find "$base_dir" -type f -path "*/DADOS/${clean_name}*.csv" | while read -r csv_file; do
      head -n 1 "$csv_file"
    done | tr ';' '\n' | awk 'NF' | sort -u | awk '{printf "%s\"%s\"", (NR==1?"[":","), $0} END{if(NR>0)print "]"; else print "[]"}' | \
    awk -v name="$clean_name" 'BEGIN{ORS=""} {print name "|" $0 "\n"}'
  done | {
    echo "{"
    first=1
    while IFS='|' read -r name header_arr; do
      if [ $first -eq 0 ]; then
        echo ","
      fi
      echo -n "  \"${name}\": ${header_arr}"
      first=0
    done
    echo
    echo "}"
  }
}

# Função: build_object_from_meta_file
# Processa um arquivo META e gera pares "campo": ["tipo","tamanho"]
build_object_from_meta_file() {
  local in="$1"
  echo "{"
  sed -e 's/\r//g' "$in" \
    | sed '/^-/d' \
    | sed '/Descrição/d' \
    | sed '/Descricao/d' \
    | sed '/Domínio/d' \
    | sed '/Dominio/d' \
    | awk '
BEGIN {
  RS=""; FS="\n"; count=0;
}
{
  name=$1; sub(/^[^:]*:\s*/, "", name)
  typ =$4; sub(/^[^:]*:\s*/, "", typ)
  size=$5; sub(/^[^:]*:\s*/, "", size)
  gsub(/[[:space:]]+/, "", name)
  gsub(/[[:space:]]+/, "", typ)
  gsub(/[[:space:]]+/, "", size)
  gsub(/"/, "\\\"", name)
  gsub(/"/, "\\\"", typ)
  gsub(/"/, "\\\"", size)
  if (length(name)==0) next
  if (count++ > 0) printf ",\n"
  printf "  \"%s\": [\"%s\",\"%s\"]", name, typ, size
}
END { print "" }'
  echo "}"
}

# Função: format_meta_json
# Recebe um arquivo ou diretório e gera o JSON correspondente
format_meta_json() {
  local in="$1"
  if [[ -z "$in" ]]; then
    echo "Usage: format_meta_json <meta_file_or_directory>" >&2
    return 1
  fi

  if [[ -d "$in" ]]; then
    echo "{"
    first=1
    shopt -s nullglob
    for f in "$in"/*.txt; do
      [[ -f "$f" ]] || continue
      obj="$(build_object_from_meta_file "$f")"
      [[ -z "$obj" ]] && continue
      if [[ $first -eq 0 ]]; then echo ","; fi
      echo "$obj"
      first=0
    done
    echo "}"
  elif [[ -f "$in" ]]; then
    obj="$(build_object_from_meta_file "$in")"
    echo "{"
    echo "$obj"
    echo "}"
  else
    echo "Erro: caminho não encontrado: $in" >&2
    return 1
  fi
}

# Função: find_meta_files_json
# Objetivo:
#   Gerar um objeto JSON onde cada chave é o nome único da coluna encontrada nos arquivos meta_*.txt das subpastas META,
#   e o valor é a array correspondente (ex: ["numeric","Precis�o:17"]), sem repetir a chave dentro da array.
#   As chaves aparecem em ordem alfabética.
# Uso:
#   source utils.sh
#   find_meta_files_json <base_dir>

find_meta_files_json() {
  local base_dir="$1"
  if [ -z "$base_dir" ]; then
    echo "Uso: find_meta_files_json <base_dir>" >&2
    return 1
  fi

  local tmp_json
  tmp_json=$(mktemp)

  # Para cada arquivo meta_*.txt, extrai as chaves (colunas) e arrays de valores (apenas o array interno)
  find "$base_dir" -type f -path "*/META/meta_*.txt" | while read -r f; do
    build_object_from_meta_file "$f" | jq -c 'to_entries[] | [ .key, .value[0], .value[1] ]' >> "$tmp_json"
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
}

# Função: find_meta_files_json_flat
# Objetivo:
#   Gerar um objeto JSON onde cada chave é o nome único da coluna encontrada nos arquivos meta_*.txt das subpastas META,
#   e o valor é a array correspondente (ex: ["numeric","Precis�o:17"]), sem repetir a chave dentro da array.
#   As chaves aparecem em ordem alfabética.
# Uso:
#   source utils.sh
#   find_meta_files_json_flat <base_dir> > meta_files_columns.json

find_meta_files_json_flat() {
  local base_dir="$1"
  if [ -z "$base_dir" ]; then
    echo "Uso: find_meta_files_json_flat <base_dir>" >&2
    return 1
  fi

  local tmp_json
  tmp_json=$(mktemp)

  # Para cada arquivo meta_*.txt, extrai as chaves (colunas) e arrays de valores (apenas o array interno)
  find "$base_dir" -type f -path "*/META/meta_*.txt" | while read -r f; do
    build_object_from_meta_file "$f" | jq -c 'to_entries[] | [ .key, .value[0], .value[1] ]' >> "$tmp_json"
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
}

# Função: generate_table_columns_json
# Objetivo:
#   Receber dois arquivos JSON:
#     1. headers.json: {"tabela1": ["col1", "col2", ...], ...}
#     2. meta.json: {"col1": ["tipo", "tamanho"], ...}
#   Gerar um novo JSON:
#     {"tabela1": {"col1": ["tipo", "tamanho"], "col2": ...}, ...}
#   Só insere colunas que existem em meta.json.
# Uso:
#   source utils.sh
#   generate_table_columns_json headers.json meta.json > tabelas_colunas.json

generate_table_columns_json() {
  local headers_json="$1"
  local meta_json="$2"
  if [ -z "$headers_json" ] || [ -z "$meta_json" ]; then
    echo "Uso: generate_table_columns_json headers.json meta.json" >&2
    return 1
  fi

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
}