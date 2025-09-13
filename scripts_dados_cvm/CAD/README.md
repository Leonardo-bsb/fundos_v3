# Resumo dos Scripts CAD

Este diretório contém scripts para preparar metadados e gerar comandos SQL para criar tabelas no PostgreSQL.

## Fluxo dos Scripts

1. **`json_cad_headers.sh`**: Extrai os nomes das colunas dos arquivos CSV.
2. **`format_meta.sh`**: Lê os arquivos de metadados e gera um JSON com tipos e tamanhos das colunas.
3. **`sort_meta_by_headers.py`**: Ordena as colunas dos metadados conforme os headers extraídos.
4. **`main.py`**: Orquestra todos os passos em memória e gera o script SQL final para criar as tabelas.

## Como usar

Execute:
```bash
python3 [main.py](http://_vscodecontentref_/0) > [create_tables.sql](http://_vscodecontentref_/1)
```

