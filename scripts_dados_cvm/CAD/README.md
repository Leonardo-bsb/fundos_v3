# Scripts de Preparação e Criação de Tabelas CAD

Este diretório contém scripts para processar metadados dos arquivos CAD, ordenar colunas e gerar comandos SQL para criação de tabelas no PostgreSQL.

## Scripts e Fluxo de Execução

### 1. `format_meta.sh`
- **Objetivo:** Ler todos os arquivos de metadados (`meta_*.txt`) e gerar um arquivo JSON estruturado, onde cada tabela possui suas colunas, tipos e tamanhos.
- **Como funciona:**  
  - Remove linhas desnecessárias e formata os campos relevantes.
  - Pode ser executado passando um diretório com arquivos meta como argumento.
- **Exemplo de uso:**  
  ```bash
  ./format_meta.sh /caminho/para/dados/CAD/META > meta_cad.json
  ```

### 2. `sort_meta_by_headers.py`
- **Objetivo:** Ordenar as colunas de cada tabela no arquivo JSON gerado pelo `format_meta.sh` conforme a ordem definida em `headers.json`.
- **Como funciona:**  
  - Lê `headers.json` e `meta_cad.json`.
  - Reordena as chaves (colunas) de cada tabela para garantir que fiquem na mesma ordem dos arquivos CSV originais.
- **Exemplo de uso:**  
  ```bash
  python3 sort_meta_by_headers.py
  ```
  - Gera `meta_cad.sorted.json` com as colunas ordenadas.

### 3. `create_tables.py`
- **Objetivo:** Gerar comandos SQL `DROP TABLE` e `CREATE TABLE` para todas as tabelas, usando os metadados ordenados.
- **Como funciona:**  
  - Lê `meta_cad.sorted.json`.
  - Para cada tabela, gera o comando SQL com os tipos corretos para cada coluna.
- **Exemplo de uso:**  
  ```bash
  python3 create_tables.py > create_tables.sql
  ```
  - O arquivo gerado pode ser executado no prompt do `psql`:
    ```
    \i /home/leo/linguagens/fundos_v3/results_scripts/CAD/create_tables.sql
    ```

## Ordem Recomendada de Execução

1. Gere o arquivo de metadados:
   ```bash
   ./format_meta.sh /caminho/para/dados/CAD/META > meta_cad.json
   ```
2. Ordene as colunas conforme os headers:
   ```bash
   python3 sort_meta_by_headers.py
   ```
3. Gere o script SQL para criar as tabelas:
   ```bash
   python3 create_tables.py > create_tables.sql
   ```
4. Execute o script SQL no PostgreSQL:
   ```sql
   \i /home/leo/linguagens/fundos_v3/results_scripts/CAD/create_tables.sql
   ```

## Observações

- Os scripts garantem que os dados e metadados estejam organizados e prontos para importação no banco de dados, seguindo o padrão dos arquivos originais.
- O encoding dos arquivos JSON é `latin1` para compatibilidade com os dados originais.
- O arquivo `headers.json` deve conter a ordem correta das colunas conforme os arquivos CSV.
- O arquivo `meta_cad.json` (e o ordenado) deve conter os tipos e tamanhos de cada coluna para cada tabela.
- O script SQL gerado pode ser revisado e ajustado conforme necessidades específicas do projeto.

---

