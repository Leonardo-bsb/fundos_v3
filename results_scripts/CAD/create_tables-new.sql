DROP TABLE IF EXISTS
cad_fi,
    cad_fi_hist_admin,
    cad_fi_hist_auditor,
    cad_fi_hist_classe,
    cad_fi_hist_condom,
    cad_fi_hist_controlador,
    cad_fi_hist_custodiante,
    cad_fi_hist_denom_comerc,
    cad_fi_hist_denom_social,
    cad_fi_hist_diretor_resp,
    cad_fi_hist_exclusivo,
    cad_fi_hist_exerc_social,
    cad_fi_hist_fic,
    cad_fi_hist_gestor,
    cad_fi_hist_publico_alvo,
    cad_fi_hist_rentab,
    cad_fi_hist_sit,
    cad_fi_hist_taxa_adm,
    cad_fi_hist_taxa_perfm,
    cad_fi_hist_trib_lprazo,
    registro_classe,
    registro_fundo,
    registro_subclasse CASCADE;

-- Table: cad_fi
CREATE TABLE cad_fi (
    "TP_FUNDO" varchar(20),
    "CNPJ_FUNDO" varchar(20),
    "DENOM_SOCIAL" varchar(100),
    "DT_REG" date,
    "DT_CONST" date,
    "CD_CVM" numeric,
    "DT_CANCEL" date,
    "SIT" varchar(100),
    "DT_INI_SIT" date,
    "DT_INI_ATIV" date,
    "DT_INI_EXERC" date,
    "DT_FIM_EXERC" date,
    "CLASSE" varchar(100),
    "DT_INI_CLASSE" date,
    "RENTAB_FUNDO" varchar(100),
    "CONDOM" varchar(100),
    "FUNDO_COTAS" varchar(1),
    "FUNDO_EXCLUSIVO" varchar(1),
    "TRIB_LPRAZO" varchar(3),
    "PUBLICO_ALVO" varchar(15),
    "ENTID_INVEST" varchar(1),
    "TAXA_PERFM" real,
    "INF_TAXA_PERFM" varchar(400),
    "TAXA_ADM" real,
    "INF_TAXA_ADM" varchar(400),
    "VL_PATRIM_LIQ" numeric,
    "DT_PATRIM_LIQ" date,
    "DIRETOR" varchar(100),
    "CNPJ_ADMIN" varchar(20),
    "ADMIN" varchar(100),
    "PF_PJ_GESTOR" char(2),
    "CPF_CNPJ_GESTOR" varchar(20),
    "GESTOR" varchar(100),
    "CNPJ_AUDITOR" varchar(20),
    "AUDITOR" varchar(100),
    "CNPJ_CUSTODIANTE" varchar(20),
    "CUSTODIANTE" varchar(100),
    "CNPJ_CONTROLADOR" varchar(20),
    "CONTROLADOR" varchar(100),
    "INVEST_CEMPR_EXTER" varchar(1),
    "CLASSE_ANBIMA" varchar(100)
);

-- Table: cad_fi_hist_admin
CREATE TABLE cad_fi_hist_admin (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "CNPJ_ADMIN" varchar(20),
    "ADMIN" varchar(100),
    "DT_INI_ADMIN" date,
    "DT_FIM_ADMIN" date
);

-- Table: cad_fi_hist_auditor
CREATE TABLE cad_fi_hist_auditor (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "CNPJ_AUDITOR" varchar(20),
    "AUDITOR" varchar(100),
    "DT_INI_AUDITOR" date,
    "DT_FIM_AUDITOR" date
);

-- Table: cad_fi_hist_classe
CREATE TABLE cad_fi_hist_classe (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "CLASSE" varchar(100),
    "DT_INI_CLASSE" date,
    "DT_FIM_CLASSE" date
);

-- Table: cad_fi_hist_condom
CREATE TABLE cad_fi_hist_condom (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "CONDOM" varchar(100),
    "DT_INI_CONDOM" date,
    "DT_FIM_CONDOM" date
);

-- Table: cad_fi_hist_controlador
CREATE TABLE cad_fi_hist_controlador (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "CNPJ_CONTROLADOR" varchar(20),
    "CONTROLADOR" varchar(100),
    "DT_INI_CONTROLADOR" date,
    "DT_FIM_CONTROLADOR" date
);

-- Table: cad_fi_hist_custodiante
CREATE TABLE cad_fi_hist_custodiante (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "CNPJ_CUSTODIANTE" varchar(20),
    "CUSTODIANTE" varchar(100),
    "DT_INI_CUSTODIANTE" date,
    "DT_FIM_CUSTODIANTE" date
);

-- Table: cad_fi_hist_denom_comerc
CREATE TABLE cad_fi_hist_denom_comerc (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "DENOM_COMERC" varchar(100),
    "DT_INI_DENOM_COMERC" date,
    "DT_FIM_DENOM_COMERC" date
);

-- Table: cad_fi_hist_denom_social
CREATE TABLE cad_fi_hist_denom_social (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "DENOM_SOCIAL" varchar(100),
    "DT_INI_DENOM_SOCIAL" date,
    "DT_FIM_DENOM_SOCIAL" date
);

-- Table: cad_fi_hist_diretor_resp
CREATE TABLE cad_fi_hist_diretor_resp (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "DIRETOR" varchar(100),
    "DT_INI_DIRETOR" date,
    "DT_FIM_DIRETOR" date
);

-- Table: cad_fi_hist_exclusivo
CREATE TABLE cad_fi_hist_exclusivo (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "FUNDO_EXCLUSIVO" varchar(1),
    "DT_INI_ST_EXCLUSIVO" date,
    "DT_FIM_ST_EXCLUSIVO" date
);

-- Table: cad_fi_hist_exerc_social
CREATE TABLE cad_fi_hist_exerc_social (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "DT_INI_EXERC" date,
    "DT_FIM_EXERC" date
);

-- Table: cad_fi_hist_fic
CREATE TABLE cad_fi_hist_fic (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "FUNDO_COTAS" varchar(1),
    "DT_INI_ST_COTAS" date,
    "DT_FIM_ST_COTAS" date
);

-- Table: cad_fi_hist_gestor
CREATE TABLE cad_fi_hist_gestor (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "PF_PJ_GESTOR" char(2),
    "CPF_CNPJ_GESTOR" varchar(20),
    "GESTOR" varchar(100),
    "DT_INI_GESTOR" date,
    "DT_FIM_GESTOR" date
);

-- Table: cad_fi_hist_publico_alvo
CREATE TABLE cad_fi_hist_publico_alvo (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "PUBLICO_ALVO" varchar(15),
    "DT_INI_PUBLICO_ALVO" date,
    "DT_FIM_PUBLICO_ALVO" date
);

-- Table: cad_fi_hist_rentab
CREATE TABLE cad_fi_hist_rentab (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "RENTAB_FUNDO" varchar(100),
    "DT_INI_RENTAB" date,
    "DT_FIM_RENTAB" date
);

-- Table: cad_fi_hist_sit
CREATE TABLE cad_fi_hist_sit (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "SIT" varchar(40),
    "DT_INI_SIT" date,
    "DT_FIM_SIT" date
);

-- Table: cad_fi_hist_taxa_adm
CREATE TABLE cad_fi_hist_taxa_adm (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "TAXA_ADM" numeric,
    "INF_TAXA_ADM" varchar(400),
    "DT_INI_TAXA_ADM" date
);

-- Table: cad_fi_hist_taxa_perfm
CREATE TABLE cad_fi_hist_taxa_perfm (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "VL_TAXA_PERFM" numeric,
    "DS_TAXA_PERFM" varchar(400),
    "DT_INI_TAXA_PERFM" date
);

-- Table: cad_fi_hist_trib_lprazo
CREATE TABLE cad_fi_hist_trib_lprazo (
    "CNPJ_FUNDO" varchar(20),
    "DT_REG" date,
    "TRIB_LPRAZO" varchar(3),
    "DT_INI_ST_TRIB_LPRAZO" date,
    "DT_FIM_ST_TRIB_LPRAZO" date
);

-- Table: registro_classe
CREATE TABLE registro_classe (
    "ID_Registro_Fundo" bigint,
    "ID_Registro_Classe" bigint,
    "CNPJ_Classe" numeric,
    "Codigo_CVM" numeric,
    "Data_Registro" date,
    "Data_Constituicao" date,
    "Data_Inicio" date,
    "Tipo_Classe" varchar(100),
    "Denominacao_Social" varchar(100),
    "Situacao" varchar(100),
    "Classificacao" varchar(100),
    "Indicador_Desempenho" varchar(100),
    "Classe_Cotas" varchar(1),
    "Classificacao_Anbima" varchar(100),
    "Tributacao_Longo_Prazo" varchar(3),
    "Entidade_Investimento" varchar(1),
    "Permitido_Aplicacao_CemPorCento_Exterior" varchar(1),
    "Classe_ESG" varchar(1),
    "Forma_Condominio" varchar(100),
    "Exclusivo" varchar(1),
    "Publico_Alvo" varchar(15),
    "Patrimonio_Liquido" numeric,
    "Data_Patrimonio_Liquido" date,
    "CNPJ_Auditor" numeric,
    "Auditor" varchar(100),
    "CNPJ_Custodiante" numeric,
    "Custodiante" varchar(100),
    "CNPJ_Controlador" numeric,
    "Controlador" varchar(100)
);

-- Table: registro_fundo
CREATE TABLE registro_fundo (
    "ID_Registro_Fundo" bigint,
    "CNPJ_Fundo" numeric,
    "Codigo_CVM" numeric,
    "Data_Registro" date,
    "Data_Constituicao" date,
    "Tipo_Fundo" varchar(20),
    "Denominacao_Social" varchar(100),
    "Data_Cancelamento" date,
    "Situacao" varchar(100),
    "Data_Inicio_Situacao" date,
    "Data_Adaptacao_RCVM175" date,
    "Data_Inicio_Exercicio_Social" date,
    "Data_Fim_Exercicio_Social" date,
    "Patrimonio_Liquido" numeric,
    "Data_Patrimonio_Liquido" date,
    "Diretor" varchar(100),
    "CNPJ_Administrador" numeric,
    "Administrador" varchar(100),
    "Tipo_Pessoa_Gestor" char(2),
    "CPF_CNPJ_Gestor" numeric,
    "Gestor" varchar(100)
);

-- Table: registro_subclasse
CREATE TABLE registro_subclasse (
    "ID_Registro_Classe" bigint,
    "ID_Subclasse" varchar(15),
    "Codigo_CVM" numeric,
    "Data_Constituicao" date,
    "Data_Inicio" date,
    "Denominacao_Social" varchar(100),
    "Situacao" varchar(100),
    "Forma_Condominio" varchar(100),
    "Exclusivo" varchar(1),
    "Publico_Alvo" varchar(15)
);

