
# Cria um array associativo para armazenar os resultados dos arquivos META
declare -A meta_objs

# Para cada arquivo encontrado em subdiretórios META dentro de dados/, processa e armazena o resultado
while IFS= read -r arq; do
    fname=${arq##*/}                # Pega o nome do arquivo
    fname=${fname#meta_}            # Remove prefixo 'meta_'
    fname=${fname%.txt}             # Remove sufixo '.txt'
    meta_objs["$fname"]="$(./scripts_dados_cvm/data_preparation/format_meta.sh "$arq")"
done < <(find dados/ -type d -name META -type d -exec find {} -type f \;)

# Salva o resultado em formato tipo JSON simplificado
out=scripts_dados_cvm/data_preparation/resultado.txt
{
    echo "{"
    first=1
    for key in "${!meta_objs[@]}"; do
        [ $first -eq 0 ] && echo ","
        first=0
        echo -n "  \"$key\": [${meta_objs[$key]}]"
    done
    echo
    echo "}"
} > "$out"

# Exemplo de resultado.txt:
#[
#   "cad_fi_hist_custodiante": [CNPJ_CUSTODIANTE;varchar;20 ...],
#   "cad_fi_hist_publico_alvo": [CNPJ_FUNDO;varchar;20 ...]
#]
