# Observações Importantes

## Correções em arquivos META e CSV

- **Erro no arquivo:** `dados/DOC/CDA/META/meta_cda_fiim.txt`
  - O campo deve ser definido assim:
    ```
    Campo: CPF_CNPJ_EMISSOR
    -----------------------
       Descrição : Informa o código de identificação do emissor, pessoa física ou jurídica
       Domínio   : Alfanumérico
       Tipo Dados: varchar
       Tamanho   : 20
    ```
  - Antes estava como tipo de dados `numeric`, precisão 18, scale 0.

- **Remover linhas dos arquivos CSV em `dados/DOC/CDA/` que apresentam a palavra 'Warning' na primeira linha:**
  ```bash
  for file in ./*.csv; do sed -i '/Warning/d' "$file"; done
  ```

- **Erro na coluna "CNPJ_FUNDO_COTA" da tabela "cda_fi_blc_2":**
  - Falta a definição desse campo no arquivo `meta.txt`.
  - A definição deve ser a mesma dos outros campos `CNPJ_FUNDO_XXXX`:
    ```
    Campo: CNPJ_FUNDO_COTA
    -----------------------
       Descrição : Informa o código de identificação do fundo de investimento
       Domínio   : Alfanumérico
       Tipo Dados: varchar
       Tamanho   : 20
    ```
  - Correção será feita diretamente no script de criação da tabela:
    ```sql
    "CNPJ_FUNDO_COTA" varchar(20),
    "NM_FUNDO_COTA" varchar(100)
    ```

- **Tamanho do campo `DS_ATIVO` em `cda_fi_BLC_8`:**
  - Deve ser de 1000 e não 255.

## Arquivos e Funções Envolvidas no Processo

- **Arquivo: `utils_pipes.sh`**
  - `extract_csv_headers_json`: Gera JSON de headers das tabelas.
  - `build_object_from_meta_file`: Usada por outras funções para processar arquivos META.
  - `format_meta_json`: Chama `build_object_from_meta_file`.
  - `find_meta_files_json_flat`: Chama `build_object_from_meta_file` e usa `jq` para processar JSON intermediário.
  - `generate_table_columns_json`: Recebe JSONs de headers e meta, usa `jq` para cruzar.
  - `generate_sql`: Lê JSON final de tabelas e gera SQL.

- **Arquivo: `generate_create_tables_sql_pipes.sh`**
  - Função `main`:
    - Chama `extract_csv_headers_json` (de `utils_pipes.sh`).
    - Chama `find_meta_files_json_flat` (de `utils_pipes.sh`).
    - Chama `generate_table_columns_json` (de `utils_pipes.sh`).
    - Chama `generate_sql` (de `utils_pipes.sh`).

## Fluxo Geral

- **Fluxo Principal:**
  - `main` (em `generate_create_tables_sql_pipes.sh`)
    - Chama `extract_csv_headers_json`
    - Chama `find_meta_files_json_flat`
      - Chama `build_object_from_meta_file`
    - Chama `generate_table_columns_json`
    - Chama `generate_sql`
    - Gera arquivo SQL final.

## Resumo Visual

```
[main]
  │
  ├─> [extract_csv_headers_json]
  │
  ├─> [find_meta_files_json_flat]
  │        └─> [build_object_from_meta_file]
  │
  ├─> [generate_table_columns_json]
  │
  └─> [generate_sql]
```

psql:new_data_preparation/DOC_data_prep/results/import_file.sql:559: ERROR:  column "CNPJ_FUNDO_COTA" of relation "cda_fi_blc_2" does not exist

graph TD
    main
    extract_csv_headers_json
    find_meta_files_json_flat
    build_object_from_meta_file
    generate_table_columns_json
    generate_sql

    main --> extract_csv_headers_json
    main --> find_meta_files_json_flat
    find_meta_files_json_flat --> build_object_from_meta_file
    main --> generate_table_columns_json
    main --> generate_sql
    generate_table_columns_json --> generate_sql
```