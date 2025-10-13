DROP TABLE IF EXISTS
cad_fi_hist_denom_comerc,
    cad_fi_hist_sit,
    cad_fi_hist_admin,
    cad_fi_hist_diretor_resp,
    cad_fi,
    cad_fi_hist_trib_lprazo,
    cad_fi_hist_custodiante,
    cad_fi_hist_classe,
    cad_fi_hist_auditor,
    registro_subclasse,
    cad_fi_hist_condom,
    registro_classe,
    cad_fi_hist_publico_alvo,
    cad_fi_hist_controlador,
    cad_fi_hist_fic,
    cad_fi_hist_rentab,
    cad_fi_hist_exclusivo,
    cad_fi_hist_taxa_adm,
    cad_fi_hist_denom_social,
    registro_fundo,
    cad_fi_hist_taxa_perfm,
    cad_fi_hist_gestor,
    cad_fi_hist_exerc_social CASCADE;

-- Table: cad_fi_hist_denom_comerc
CREATE TABLE cad_fi_hist_denom_comerc (
    "CNPJ_FUNDO" varchar(20),
    "DENOM_COMERC" varchar(100),
    "DT_FIM_DENOM_COMERC" date,
    "DT_INI_DENOM_COMERC" date,
    "DT_REG" date
);

-- Table: cad_fi_hist_sit
CREATE TABLE cad_fi_hist_sit (
    "CNPJ_FUNDO" varchar(20),
    "DT_FIM_SIT" date,
    "DT_INI_SIT" date,
    "DT_REG" date,
    "SIT" varchar(100)
);

-- Table: cad_fi_hist_admin
CREATE TABLE cad_fi_hist_admin (
    "ADMIN" varchar(100),
    "CNPJ_ADMIN" varchar(20),
    "CNPJ_FUNDO" varchar(20),
    "DT_FIM_ADMIN" date,
    "DT_INI_ADMIN" date,
    "DT_REG" date
);

-- Table: cad_fi_hist_diretor_resp
CREATE TABLE cad_fi_hist_diretor_resp (
    "CNPJ_FUNDO" varchar(20),
    "DIRETOR" varchar(100),
    "DT_FIM_DIRETOR" date,
    "DT_INI_DIRETOR" date,
    "DT_REG" date
);

-- Table: cad_fi
CREATE TABLE cad_fi (
    "ADMIN" varchar(100),
    "AUDITOR" varchar(100),
    "CD_CVM" numeric,
    "CLASSE" varchar(100),
    "CLASSE_ANBIMA" varchar(100),
    "CNPJ_ADMIN" varchar(20),
    "CNPJ_AUDITOR" varchar(20),
    "CNPJ_CONTROLADOR" varchar(20),
    "CNPJ_CUSTODIANTE" varchar(20),
    "CNPJ_FUNDO" varchar(20),
    "CONDOM" varchar(100),
    "CONTROLADOR" varchar(100),
    "CPF_CNPJ_GESTOR" varchar(20),
    "CUSTODIANTE" varchar(100),
    "DENOM_COMERC" varchar(100),
    "DENOM_SOCIAL" varchar(100),
    "DIRETOR" varchar(100),
    "DS_TAXA_PERFM" varchar(400),
    "DT_CANCEL" date,
    "DT_CONST" date,
    "DT_FIM_ADMIN" date,
    "DT_FIM_AUDITOR" date,
    "DT_FIM_CLASSE" date,
    "DT_FIM_CONDOM" date,
    "DT_FIM_CONTROLADOR" date,
    "DT_FIM_CUSTODIANTE" date,
    "DT_FIM_DENOM_COMERC" date,
    "DT_FIM_DENOM_SOCIAL" date,
    "DT_FIM_DIRETOR" date,
    "DT_FIM_EXERC" date,
    "DT_FIM_GESTOR" date,
    "DT_FIM_PUBLICO_ALVO" date,
    "DT_FIM_RENTAB" date,
    "DT_FIM_SIT" date,
    "DT_FIM_ST_COTAS" date,
    "DT_FIM_ST_EXCLUSIVO" date,
    "DT_FIM_ST_TRIB_LPRAZO" date,
    "DT_INI_ADMIN" date,
    "DT_INI_ATIV" date,
    "DT_INI_AUDITOR" date,
    "DT_INI_CLASSE" date,
    "DT_INI_CONDOM" date,
    "DT_INI_CONTROLADOR" date,
    "DT_INI_CUSTODIANTE" date,
    "DT_INI_DENOM_COMERC" date,
    "DT_INI_DENOM_SOCIAL" date,
    "DT_INI_DIRETOR" date,
    "DT_INI_EXERC" date,
    "DT_INI_GESTOR" date,
    "DT_INI_PUBLICO_ALVO" date,
    "DT_INI_RENTAB" date,
    "DT_INI_SIT" date,
    "DT_INI_ST_COTAS" date,
    "DT_INI_ST_EXCLUSIVO" date,
    "DT_INI_ST_TRIB_LPRAZO" date,
    "DT_INI_TAXA_ADM" date,
    "DT_INI_TAXA_PERFM" date,
    "DT_PATRIM_LIQ" date,
    "DT_REG" date,
    "ENTID_INVEST" varchar(1),
    "FUNDO_COTAS" varchar(1),
    "FUNDO_EXCLUSIVO" varchar(1),
    "GESTOR" varchar(100),
    "INF_TAXA_ADM" varchar(400),
    "INF_TAXA_PERFM" varchar(400),
    "INVEST_CEMPR_EXTER" varchar(1),
    "PF_PJ_GESTOR" char(2),
    "PUBLICO_ALVO" varchar(15),
    "RENTAB_FUNDO" varchar(100),
    "SIT" varchar(100),
    "TAXA_ADM" numeric,
    "TAXA_PERFM" real,
    "TP_FUNDO" varchar(20),
    "TRIB_LPRAZO" varchar(3),
    "VL_PATRIM_LIQ" numeric,
    "VL_TAXA_PERFM" numeric
);

-- Table: cad_fi_hist_trib_lprazo
CREATE TABLE cad_fi_hist_trib_lprazo (
    "CNPJ_FUNDO" varchar(20),
    "DT_FIM_ST_TRIB_LPRAZO" date,
    "DT_INI_ST_TRIB_LPRAZO" date,
    "DT_REG" date,
    "TRIB_LPRAZO" varchar(3)
);

-- Table: cad_fi_hist_custodiante
CREATE TABLE cad_fi_hist_custodiante (
    "CNPJ_CUSTODIANTE" varchar(20),
    "CNPJ_FUNDO" varchar(20),
    "CUSTODIANTE" varchar(100),
    "DT_FIM_CUSTODIANTE" date,
    "DT_INI_CUSTODIANTE" date,
    "DT_REG" date
);

-- Table: cad_fi_hist_classe
CREATE TABLE cad_fi_hist_classe (
    "CLASSE" varchar(100),
    "CNPJ_FUNDO" varchar(20),
    "DT_FIM_CLASSE" date,
    "DT_INI_CLASSE" date,
    "DT_REG" date
);

-- Table: cad_fi_hist_auditor
CREATE TABLE cad_fi_hist_auditor (
    "AUDITOR" varchar(100),
    "CNPJ_AUDITOR" varchar(20),
    "CNPJ_FUNDO" varchar(20),
    "DT_FIM_AUDITOR" date,
    "DT_INI_AUDITOR" date,
    "DT_REG" date
);

-- Table: registro_subclasse
CREATE TABLE registro_subclasse (
    "Codigo_CVM" numeric,
    "Data_Constituicao" date,
    "Data_Inicio" date,
    "Denominacao_Social" varchar(100),
    "Exclusivo" varchar(1),
    "Forma_Condominio" varchar(100),
    "ID_Registro_Classe" bigint,
    "ID_Subclasse" varchar(15),
    "Publico_Alvo" varchar(15),
    "Data_Inicio_Situacao" date,
    "Situacao" varchar(100)
);

-- Table: cad_fi_hist_condom
CREATE TABLE cad_fi_hist_condom (
    "CNPJ_FUNDO" varchar(20),
    "CONDOM" varchar(100),
    "DT_FIM_CONDOM" date,
    "DT_INI_CONDOM" date,
    "DT_REG" date
);

-- Table: registro_classe
CREATE TABLE registro_classe (
    "Auditor" varchar(100),
    "CNPJ_Auditor" numeric,
    "CNPJ_Classe" numeric,
    "CNPJ_Controlador" numeric,
    "CNPJ_Custodiante" numeric,
    "Classe_Cotas" varchar(1),
    "Classe_ESG" varchar(1),
    "Classificacao" varchar(100),
    "Classificacao_Anbima" varchar(100),
    "Codigo_CVM" numeric,
    "Controlador" varchar(100),
    "Custodiante" varchar(100),
    "Data_Constituicao" date,
    "Data_Inicio" date,
    "Data_Patrimonio_Liquido" date,
    "Data_Registro" date,
    "Denominacao_Social" varchar(100),
    "Entidade_Investimento" varchar(1),
    "Exclusivo" varchar(1),
    "Forma_Condominio" varchar(100),
    "ID_Registro_Classe" bigint,
    "ID_Registro_Fundo" bigint,
    "Indicador_Desempenho" varchar(100),
    "Patrimonio_Liquido" numeric,
    "Permitido_Aplicacao_CemPorCento_Exterior" varchar(1),
    "Publico_Alvo" varchar(15),
    "Data_Inicio_Situacao" date,
    "Situacao" varchar(100),
    "Tipo_Classe" varchar(100),
    "Tributacao_Longo_Prazo" varchar(3)
);

-- Table: cad_fi_hist_publico_alvo
CREATE TABLE cad_fi_hist_publico_alvo (
    "CNPJ_FUNDO" varchar(20),
    "DT_FIM_PUBLICO_ALVO" date,
    "DT_INI_PUBLICO_ALVO" date,
    "DT_REG" date,
    "PUBLICO_ALVO" varchar(15)
);

-- Table: cad_fi_hist_controlador
CREATE TABLE cad_fi_hist_controlador (
    "CNPJ_CONTROLADOR" varchar(20),
    "CNPJ_FUNDO" varchar(20),
    "CONTROLADOR" varchar(100),
    "DT_FIM_CONTROLADOR" date,
    "DT_INI_CONTROLADOR" date,
    "DT_REG" date
);

-- Table: cad_fi_hist_fic
CREATE TABLE cad_fi_hist_fic (
    "CNPJ_FUNDO" varchar(20),
    "DT_FIM_ST_COTAS" date,
    "DT_INI_ST_COTAS" date,
    "DT_REG" date,
    "FUNDO_COTAS" varchar(1)
);

-- Table: cad_fi_hist_rentab
CREATE TABLE cad_fi_hist_rentab (
    "CNPJ_FUNDO" varchar(20),
    "DT_FIM_RENTAB" date,
    "DT_INI_RENTAB" date,
    "DT_REG" date,
    "RENTAB_FUNDO" varchar(100)
);

-- Table: cad_fi_hist_exclusivo
CREATE TABLE cad_fi_hist_exclusivo (
    "CNPJ_FUNDO" varchar(20),
    "DT_FIM_ST_EXCLUSIVO" date,
    "DT_INI_ST_EXCLUSIVO" date,
    "DT_REG" date,
    "FUNDO_EXCLUSIVO" varchar(1)
);

-- Table: cad_fi_hist_taxa_adm
CREATE TABLE cad_fi_hist_taxa_adm (
    "CNPJ_FUNDO" varchar(20),
    "DT_INI_TAXA_ADM" date,
    "DT_REG" date,
    "INF_TAXA_ADM" varchar(400),
    "TAXA_ADM" numeric
);

-- Table: cad_fi_hist_denom_social
CREATE TABLE cad_fi_hist_denom_social (
    "CNPJ_FUNDO" varchar(20),
    "DENOM_SOCIAL" varchar(100),
    "DT_FIM_DENOM_SOCIAL" date,
    "DT_INI_DENOM_SOCIAL" date,
    "DT_REG" date
);

-- Table: registro_fundo
CREATE TABLE registro_fundo (
    "Administrador" varchar(100),
    "CNPJ_Administrador" numeric,
    "CNPJ_Fundo" numeric,
    "CPF_CNPJ_Gestor" numeric,
    "Codigo_CVM" numeric,
    "Data_Adaptacao_RCVM175" date,
    "Data_Cancelamento" date,
    "Data_Constituicao" date,
    "Data_Fim_Exercicio_Social" date,
    "Data_Inicio_Exercicio_Social" date,
    "Data_Inicio_Situacao" date,
    "Data_Patrimonio_Liquido" date,
    "Data_Registro" date,
    "Denominacao_Social" varchar(100),
    "Diretor" varchar(100),
    "Gestor" varchar(100),
    "ID_Registro_Fundo" bigint,
    "Patrimonio_Liquido" numeric,
    "Situacao" varchar(100),
    "Tipo_Fundo" varchar(20),
    "Tipo_Pessoa_Gestor" char(2)
);

-- Table: cad_fi_hist_taxa_perfm
CREATE TABLE cad_fi_hist_taxa_perfm (
    "CNPJ_FUNDO" varchar(20),
    "DS_TAXA_PERFM" varchar(400),
    "DT_INI_TAXA_PERFM" date,
    "DT_REG" date,
    "VL_TAXA_PERFM" numeric
);

-- Table: cad_fi_hist_gestor
CREATE TABLE cad_fi_hist_gestor (
    "CNPJ_FUNDO" varchar(20),
    "CPF_CNPJ_GESTOR" varchar(20),
    "DT_FIM_GESTOR" date,
    "DT_INI_GESTOR" date,
    "DT_REG" date,
    "GESTOR" varchar(100),
    "PF_PJ_GESTOR" char(2)
);

-- Table: cad_fi_hist_exerc_social
CREATE TABLE cad_fi_hist_exerc_social (
    "CNPJ_FUNDO" varchar(20),
    "DT_FIM_EXERC" date,
    "DT_INI_EXERC" date,
    "DT_REG" date
);

\echo Script finished successfully!
