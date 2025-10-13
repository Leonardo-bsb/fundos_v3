# Scripts de Download de Dados da CVM

## Objetivo

Esta pasta contém scripts Bash para **baixar automaticamente os arquivos públicos de fundos de investimento** (FI) disponibilizados pela CVM.  
Os scripts garantem que os dados estejam organizados na estrutura de pastas correta para processamento posterior.

## Sequência Recomendada de Execução

1. **baixar_dados_FI.sh**  
   - **Objetivo:** Baixar todos os arquivos `.zip`, `.csv` e `.txt` da área de fundos de investimento do site da CVM.
   - **Como executar:**  
     ```bash
     bash baixar_dados_FI.sh
     ```
   - **Resultado:** Os dados serão salvos na pasta [dados](http://_vscodecontentref_/0), mantendo a estrutura de subpastas a partir de `FI/`.

2. **unzip_cvm_files.sh**  
   - **Objetivo:** Descompactar todos os arquivos `.zip` baixados, organizando os arquivos extraídos nas pastas corretas.
   - **Como executar:**  
     ```bash
     bash unzip_cvm_files.sh
     ```

3. **dos2unix.sh**  
   - **Objetivo:** Converter arquivos de texto do formato DOS/Windows (CRLF) para o formato Unix (LF), garantindo compatibilidade com scripts e ferramentas Linux.
   - **Como executar:**  
     ```bash
     bash dos2unix.sh
     ```

## Observações

- Certifique-se de ter espaço suficiente em disco antes de iniciar o download.
- Os arquivos baixados e processados serão usados em etapas posteriores de preparação e importação dos dados.

---