#!/bin/bash
# filepath: /home/leo/linguagens/fundos_v3/new_data_preparation/DOC_data_prep/scripts/utils_pipes.sh

# Função: extract_csv_headers_json
# Objetivo:
#   Para cada arquivo .txt em subpastas META, procura todos os arquivos .csv que comecem
#   com esse nome nas subpastas /DADOS/ do base_dir e gera um objeto JSON onde
#   as chaves são o clean_name e os valores são arrays com os nomes únicos das colunas
#   encontradas nos headers desses csvs.
#
# Uso:
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
# Objetivo:
#   Processa o conteúdo de um arquivo META recebido via stdin e gera pares "campo": ["tipo","tamanho"] em JSON.
#
# Uso:
#   cat arquivo_meta.txt | build_object_from_meta_file

build_object_from_meta_file() {
  echo "{"
  sed -e 's/\r//g' \
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
# Objetivo:
#   Recebe uma lista de arquivos META via stdin, processa cada um e gera um único JSON com todos os campos.
#
# Uso:
#   find pasta -name '*.txt' | format_meta_json

format_meta_json() {
  echo "{"
  first=1
  while read -r f; do
    [[ -f "$f" ]] || continue
    cat "$f" | build_object_from_meta_file | sed '1d;$d' > tmp_obj.txt
    obj=$(cat tmp_obj.txt)
    [[ -z "$obj" ]] && continue
    if [[ $first -eq 0 ]]; then echo ","; fi
    echo "$obj"
    first=0
  done
  echo "}"
  rm -f tmp_obj.txt
}

# Função: find_meta_files_json
# Objetivo:
#   Recebe uma lista de arquivos META via stdin, extrai as chaves (colunas) e arrays de valores (tipo, tamanho)
#   e gera um objeto JSON onde cada chave é o nome único da coluna encontrada nos arquivos META,
#   e o valor é a array correspondente (ex: ["numeric","Precis�o:17"]), sem repetir a chave dentro da array.
#   As chaves aparecem em ordem alfabética.
#
# Uso:
#   find pasta -name '*.txt' | find_meta_files_json

find_meta_files_json() {
  local tmp_json
  tmp_json=$(mktemp)
  while read -r f; do
    cat "$f" | build_object_from_meta_file | jq -c 'to_entries[] | [ .key, .value[0], .value[1] ]' >> "$tmp_json"
  done
  echo "{"
  awk -F\" '
    {
      key = $2;
      value_start = index($0, "[");
      value = substr($0, value_start);
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
#   Recebe um diretório como argumento, processa todos os arquivos META dentro dele e gera um JSON
#   onde cada chave é o nome único da coluna encontrada nos arquivos META, e o valor é a array correspondente.
#   As chaves aparecem em ordem alfabética.
#
# Uso:
#   find_meta_files_json_flat /caminho/para/pasta > meta_files_columns.json

find_meta_files_json_flat() {
  local base_dir="$1"
  if [ -z "$base_dir" ]; then
    echo "Uso: find_meta_files_json_flat <base_dir>" >&2
    return 1
  fi

  local tmp_json
  tmp_json=$(mktemp)

  find "$base_dir" -type f -path "*/META/meta_*.txt" | while read -r f; do
    cat "$f" | build_object_from_meta_file | jq -c 'to_entries[] | [ .key, .value[0], .value[1] ]' >> "$tmp_json"
  done

  echo "{"
  awk -F\" '
    {
      key = $2;
      value_start = index($0, "[");
      value = substr($0, value_start);
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
#   Recebe dois JSONs via stdin (primeiro headers, depois meta), e gera um novo JSON:
#   {"tabela1": {"col1": ["tipo", "tamanho"], "col2": ...}, ...}
#   Só insere colunas que existem em meta.json.
#
# Uso:
#   cat headers.json meta.json | generate_table_columns_json

generate_table_columns_json() {
  # Lê dois JSONs do stdin, separados por um delimitador ___DELIM___
  headers_json=""
  meta_json=""
  reading_meta=0
  while IFS= read -r line; do
    if [[ "$line" == "___DELIM___" ]]; then
      reading_meta=1
      continue
    fi
    if [[ $reading_meta -eq 0 ]]; then
      headers_json+="$line"
    else
      meta_json+="$line"
    fi
  done
  jq -n --argjson headers "$headers_json" --argjson meta "$meta_json" '
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

# Função: generate_sql
# Objetivo:
#   Recebe o caminho de um arquivo JSON de tabelas e gera o SQL para DROP e CREATE TABLEs.
#
# Uso:
#   generate_sql tabelas.json

generate_sql() {
  local tabelas_json_file="$1"
  # Adiciona o comando DROP TABLE IF EXISTS antes da lista de tabelas
  echo "DROP TABLE IF EXISTS"
  jq -r 'keys_unsorted | join(",\n    ") + " CASCADE;"' "$tabelas_json_file"
  echo

  # Para cada tabela, gera o comando CREATE TABLE
  jq -c 'to_entries[]' "$tabelas_json_file" | while read -r entry; do
    table=$(echo "$entry" | jq -r '.key')
    echo "-- Table: $table"
    echo "CREATE TABLE $table ("
    cols=$(echo "$entry" | jq -c '.value')
    col_lines=()
    mapfile -t col_entries < <(echo "$cols" | jq -c 'to_entries[]')
    for col_entry in "${col_entries[@]}"; do
      col=$(echo "$col_entry" | jq -r '.key')
      val=$(echo "$col_entry" | jq -r '.value')
      typ=$(echo "$val" | jq -r '.[0]' | tr '[:upper:]' '[:lower:]')
      size=$(echo "$val" | jq -r '.[1]')
      case "$typ" in
        varchar|char)
          coltype="${typ}"; [[ -n "$size" && "$size" != "null" ]] && coltype="${typ}(${size//[^0-9]/})"
          ;;
        numeric|real|date|bigint)
          coltype="$typ"
          ;;
        *)
          coltype="text"
          ;;
      esac
      col_lines+=("    \"$col\" $coltype")
    done
    (IFS=$'\n'; echo "${col_lines[*]}" | sed '$!s/$/,/')
    echo ");"
    echo
  done
  echo '\echo Script finished successfully!'
}
