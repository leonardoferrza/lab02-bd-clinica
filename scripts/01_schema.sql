-- =============================================================================
-- 1. CRIAÇÃO DO BANCO E DAS TABELAS (DDL)
-- =============================================================================

DROP TABLE IF EXISTS vacina_aplicada;
DROP TABLE IF EXISTS vacina_catalogo;
DROP TABLE IF EXISTS consulta;
DROP TABLE IF EXISTS animal;
DROP TABLE IF EXISTS veterinario;
DROP TABLE IF EXISTS tutor;
DROP TABLE IF EXISTS especie;

CREATE TABLE especie (
    id_especie INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE tutor (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    cidade VARCHAR(50) DEFAULT 'São Luís',
    data_cadastro DATE NOT NULL
);

CREATE TABLE veterinario (
    id_vet INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crmv VARCHAR(20) NOT NULL UNIQUE,
    especialidade VARCHAR(50),
    salario DECIMAL(10,2)
);

CREATE TABLE animal (
    id_animal INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    id_especie INT NOT NULL,
    cpf_tutor VARCHAR(14) NOT NULL,
    data_nasc DATE,
    peso DECIMAL(5,2),
    sexo VARCHAR(10),
    CONSTRAINT fk_especie FOREIGN KEY (id_especie) REFERENCES especie (id_especie),
    CONSTRAINT fk_tutor FOREIGN KEY (cpf_tutor) REFERENCES tutor (cpf) ON DELETE CASCADE
);

CREATE TABLE consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_animal INT NOT NULL,
    id_vet INT NOT NULL,
    data_consulta DATE NOT NULL,
    motivo VARCHAR(100),
    valor DECIMAL(10,2),
    status VARCHAR(20) CHECK (status IN ('Agendada', 'Realizada', 'Cancelada')),
    CONSTRAINT fk_cons_animal FOREIGN KEY (id_animal) REFERENCES animal (id_animal) ON DELETE CASCADE,
    CONSTRAINT fk_cons_vet FOREIGN KEY (id_vet) REFERENCES veterinario (id_vet)
);

CREATE TABLE vacina_catalogo (
    id_vacina INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    fabricante VARCHAR(50),
    validade_meses INT
);

CREATE TABLE vacina_aplicada (
    id_aplicacao INT AUTO_INCREMENT PRIMARY KEY,
    id_animal INT NOT NULL,
    id_vacina INT NOT NULL,
    id_vet INT NOT NULL,
    data_aplicacao DATE NOT NULL,
    lote VARCHAR(50),
    CONSTRAINT fk_vac_animal FOREIGN KEY (id_animal) REFERENCES animal (id_animal) ON DELETE CASCADE,
    CONSTRAINT fk_vac_cat FOREIGN KEY (id_vacina) REFERENCES vacina_catalogo (id_vacina),
    CONSTRAINT fk_vac_vet FOREIGN KEY (id_vet) REFERENCES veterinario (id_vet)
);