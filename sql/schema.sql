-- ============================================================
-- Esquema normalizado (4FN) - Sistema de Gestão de Funcionários
-- Universidade Licungo - Trabalho II
-- ============================================================

CREATE TABLE Cidade (
    NomeCidade   VARCHAR(50)  PRIMARY KEY,
    Provincia    VARCHAR(50)  NOT NULL,
    Pais         VARCHAR(50)  NOT NULL
);

CREATE TABLE Cargo (
    CodCargo         VARCHAR(5)   PRIMARY KEY,
    DescricaoCargo   VARCHAR(100) NOT NULL
);

CREATE TABLE Funcao (
    CodFuncao        VARCHAR(5)   PRIMARY KEY,
    DescricaoFuncao  VARCHAR(100) NOT NULL
);

CREATE TABLE Funcionario (
    NUIT            VARCHAR(9)   PRIMARY KEY,
    Nome            VARCHAR(100) NOT NULL,
    DataNasc        DATE         NOT NULL,
    BI              VARCHAR(20)  NOT NULL UNIQUE,
    Email           VARCHAR(100) NOT NULL UNIQUE,
    Via             VARCHAR(100),
    Numero          VARCHAR(10),
    Bairro          VARCHAR(50),
    NomeCidade      VARCHAR(50)  NOT NULL,
    CodCargo        VARCHAR(5)   NOT NULL,
    CodFuncao       VARCHAR(5)   NOT NULL,
    PostoTrabalho   VARCHAR(50),
    DataAdmissao    DATE,
    CONSTRAINT fk_funcionario_cidade
        FOREIGN KEY (NomeCidade) REFERENCES Cidade(NomeCidade),
    CONSTRAINT fk_funcionario_cargo
        FOREIGN KEY (CodCargo) REFERENCES Cargo(CodCargo),
    CONSTRAINT fk_funcionario_funcao
        FOREIGN KEY (CodFuncao) REFERENCES Funcao(CodFuncao)
);

CREATE TABLE Filho (
    NUIT       VARCHAR(9)   NOT NULL,
    NomeFilho  VARCHAR(100) NOT NULL,
    PRIMARY KEY (NUIT, NomeFilho),
    CONSTRAINT fk_filho_funcionario
        FOREIGN KEY (NUIT) REFERENCES Funcionario(NUIT)
        ON DELETE CASCADE
);

CREATE TABLE Telefone (
    NUIT            VARCHAR(9)  NOT NULL,
    NumeroCelular   VARCHAR(15) NOT NULL,
    PRIMARY KEY (NUIT, NumeroCelular),
    CONSTRAINT fk_telefone_funcionario
        FOREIGN KEY (NUIT) REFERENCES Funcionario(NUIT)
        ON DELETE CASCADE
);
