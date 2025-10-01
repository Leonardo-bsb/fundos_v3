\copy cad_fi_hist_custodiante("CNPJ_FUNDO","DT_REG","CNPJ_CUSTODIANTE","CUSTODIANTE","DT_INI_CUSTODIANTE","DT_FIM_CUSTODIANTE") FROM 'dados/CAD/DADOS/cad_fi_hist_custodiante.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_custodiante
\copy registro_subclasse("ID_Registro_Classe","ID_Subclasse","Codigo_CVM","Data_Constituicao","Data_Inicio","Denominacao_Social","Situacao","Forma_Condominio","Exclusivo","Publico_Alvo") FROM 'dados/CAD/DADOS/registro_subclasse.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into registro_subclasse
\copy registro_fundo("ID_Registro_Fundo","CNPJ_Fundo","Codigo_CVM","Data_Registro","Data_Constituicao","Tipo_Fundo","Denominacao_Social","Data_Cancelamento","Situacao","Data_Inicio_Situacao","Data_Adaptacao_RCVM175","Data_Inicio_Exercicio_Social","Data_Fim_Exercicio_Social","Patrimonio_Liquido","Data_Patrimonio_Liquido","Diretor","CNPJ_Administrador","Administrador","Tipo_Pessoa_Gestor","CPF_CNPJ_Gestor","Gestor") FROM 'dados/CAD/DADOS/registro_fundo.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into registro_fundo
\copy cad_fi_hist_diretor_resp("CNPJ_FUNDO","DT_REG","DIRETOR","DT_INI_DIRETOR","DT_FIM_DIRETOR") FROM 'dados/CAD/DADOS/cad_fi_hist_diretor_resp.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_diretor_resp
\copy cad_fi("TP_FUNDO","CNPJ_FUNDO","DENOM_SOCIAL","DT_REG","DT_CONST","CD_CVM","DT_CANCEL","SIT","DT_INI_SIT","DT_INI_ATIV","DT_INI_EXERC","DT_FIM_EXERC","CLASSE","DT_INI_CLASSE","RENTAB_FUNDO","CONDOM","FUNDO_COTAS","FUNDO_EXCLUSIVO","TRIB_LPRAZO","PUBLICO_ALVO","ENTID_INVEST","TAXA_PERFM","INF_TAXA_PERFM","TAXA_ADM","INF_TAXA_ADM","VL_PATRIM_LIQ","DT_PATRIM_LIQ","DIRETOR","CNPJ_ADMIN","ADMIN","PF_PJ_GESTOR","CPF_CNPJ_GESTOR","GESTOR","CNPJ_AUDITOR","AUDITOR","CNPJ_CUSTODIANTE","CUSTODIANTE","CNPJ_CONTROLADOR","CONTROLADOR","INVEST_CEMPR_EXTER","CLASSE_ANBIMA") FROM 'dados/CAD/DADOS/cad_fi.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi
\copy cad_fi_hist_fic("CNPJ_FUNDO","DT_REG","FUNDO_COTAS","DT_INI_ST_COTAS","DT_FIM_ST_COTAS") FROM 'dados/CAD/DADOS/cad_fi_hist_fic.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_fic
\copy cad_fi_hist_auditor("CNPJ_FUNDO","DT_REG","CNPJ_AUDITOR","AUDITOR","DT_INI_AUDITOR","DT_FIM_AUDITOR") FROM 'dados/CAD/DADOS/cad_fi_hist_auditor.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_auditor
\copy cad_fi_hist_rentab("CNPJ_FUNDO","DT_REG","RENTAB_FUNDO","DT_INI_RENTAB","DT_FIM_RENTAB") FROM 'dados/CAD/DADOS/cad_fi_hist_rentab.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_rentab
\copy cad_fi_hist_condom("CNPJ_FUNDO","DT_REG","CONDOM","DT_INI_CONDOM","DT_FIM_CONDOM") FROM 'dados/CAD/DADOS/cad_fi_hist_condom.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_condom
\copy cad_fi_hist_admin("CNPJ_FUNDO","DT_REG","CNPJ_ADMIN","ADMIN","DT_INI_ADMIN","DT_FIM_ADMIN") FROM 'dados/CAD/DADOS/cad_fi_hist_admin.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_admin
\copy cad_fi_hist_gestor("CNPJ_FUNDO","DT_REG","PF_PJ_GESTOR","CPF_CNPJ_GESTOR","GESTOR","DT_INI_GESTOR","DT_FIM_GESTOR") FROM 'dados/CAD/DADOS/cad_fi_hist_gestor.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_gestor
\copy cad_fi_hist_trib_lprazo("CNPJ_FUNDO","DT_REG","TRIB_LPRAZO","DT_INI_ST_TRIB_LPRAZO","DT_FIM_ST_TRIB_LPRAZO") FROM 'dados/CAD/DADOS/cad_fi_hist_trib_lprazo.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_trib_lprazo
\copy cad_fi_hist_controlador("CNPJ_FUNDO","DT_REG","CNPJ_CONTROLADOR","CONTROLADOR","DT_INI_CONTROLADOR","DT_FIM_CONTROLADOR") FROM 'dados/CAD/DADOS/cad_fi_hist_controlador.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_controlador
\copy cad_fi_hist_denom_comerc("CNPJ_FUNDO","DT_REG","DENOM_COMERC","DT_INI_DENOM_COMERC","DT_FIM_DENOM_COMERC") FROM 'dados/CAD/DADOS/cad_fi_hist_denom_comerc.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_denom_comerc
\copy cad_fi_hist_sit("CNPJ_FUNDO","DT_REG","SIT","DT_INI_SIT","DT_FIM_SIT") FROM 'dados/CAD/DADOS/cad_fi_hist_sit.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_sit
\copy cad_fi_hist_exerc_social("CNPJ_FUNDO","DT_REG","DT_INI_EXERC","DT_FIM_EXERC") FROM 'dados/CAD/DADOS/cad_fi_hist_exerc_social.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_exerc_social
\copy cad_fi_hist_denom_social("CNPJ_FUNDO","DT_REG","DENOM_SOCIAL","DT_INI_DENOM_SOCIAL","DT_FIM_DENOM_SOCIAL") FROM 'dados/CAD/DADOS/cad_fi_hist_denom_social.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_denom_social
\copy cad_fi_hist_taxa_adm("CNPJ_FUNDO","DT_REG","TAXA_ADM","INF_TAXA_ADM","DT_INI_TAXA_ADM") FROM 'dados/CAD/DADOS/cad_fi_hist_taxa_adm.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_taxa_adm
\copy cad_fi_hist_taxa_perfm("CNPJ_FUNDO","DT_REG","VL_TAXA_PERFM","DS_TAXA_PERFM","DT_INI_TAXA_PERFM") FROM 'dados/CAD/DADOS/cad_fi_hist_taxa_perfm.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_taxa_perfm
\copy cad_fi_hist_classe("CNPJ_FUNDO","DT_REG","CLASSE","DT_INI_CLASSE","DT_FIM_CLASSE") FROM 'dados/CAD/DADOS/cad_fi_hist_classe.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_classe
\copy cad_fi_hist_publico_alvo("CNPJ_FUNDO","DT_REG","PUBLICO_ALVO","DT_INI_PUBLICO_ALVO","DT_FIM_PUBLICO_ALVO") FROM 'dados/CAD/DADOS/cad_fi_hist_publico_alvo.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_publico_alvo
\copy registro_classe("ID_Registro_Fundo","ID_Registro_Classe","CNPJ_Classe","Codigo_CVM","Data_Registro","Data_Constituicao","Data_Inicio","Tipo_Classe","Denominacao_Social","Situacao","Classificacao","Indicador_Desempenho","Classe_Cotas","Classificacao_Anbima","Tributacao_Longo_Prazo","Entidade_Investimento","Permitido_Aplicacao_CemPorCento_Exterior","Classe_ESG","Forma_Condominio","Exclusivo","Publico_Alvo","Patrimonio_Liquido","Data_Patrimonio_Liquido","CNPJ_Auditor","Auditor","CNPJ_Custodiante","Custodiante","CNPJ_Controlador","Controlador") FROM 'dados/CAD/DADOS/registro_classe.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into registro_classe
\copy cad_fi_hist_exclusivo("CNPJ_FUNDO","DT_REG","FUNDO_EXCLUSIVO","DT_INI_ST_EXCLUSIVO","DT_FIM_ST_EXCLUSIVO") FROM 'dados/CAD/DADOS/cad_fi_hist_exclusivo.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'LATIN1');
\echo Imported into cad_fi_hist_exclusivo
