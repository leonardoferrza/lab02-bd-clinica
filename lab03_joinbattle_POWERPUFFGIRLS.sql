-- ATIVIDADE: LAB 03 - JOIN BATTLE
-- GRUPO: POWERPUFFGIRLS (Cássia Irene, Leonardo Ferreira, Melissa Wolff)
-- DATA: 06/05/2026

-- 1. CRIAÇÃO DO BANCO E DAS TABELAS (RESET)

DROP DATABASE IF EXISTS clinicaveterinaria_cao;
CREATE DATABASE clinicaveterinaria_cao;
USE clinicaveterinaria_cao;

CREATE TABLE especie (
    id_especie SERIAL PRIMARY KEY,
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
    id_vet SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crmv VARCHAR(20) NOT NULL UNIQUE,
    especialidade VARCHAR(50),
    salario DECIMAL(10,2)
);

CREATE TABLE animal (
    id_animal SERIAL PRIMARY KEY,
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
    id_consulta SERIAL PRIMARY KEY,
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
    id_vacina SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    fabricante VARCHAR(50),
    validade_meses INT
);

CREATE TABLE vacina_aplicada (
    id_aplicacao SERIAL PRIMARY KEY,
    id_animal INT NOT NULL,
    id_vacina INT NOT NULL,
    id_vet INT NOT NULL,
    data_aplicacao DATE NOT NULL,
    lote VARCHAR(50),
    CONSTRAINT fk_vac_animal FOREIGN KEY (id_animal) REFERENCES animal (id_animal) ON DELETE CASCADE,
    CONSTRAINT fk_vac_cat FOREIGN KEY (id_vacina) REFERENCES vacina_catalogo (id_vacina),
    CONSTRAINT fk_vac_vet FOREIGN KEY (id_vet) REFERENCES veterinario (id_vet)
);

-- 2. CARGA INICIAL DE DADOS (BASE LAB 02)

INSERT INTO especie (nome) VALUES ('Cachorro'), ('Gato'), ('Ave'), ('Roedor'), ('Réptil'), ('Lagomorfo');

INSERT INTO veterinario (nome, crmv, especialidade, salario) VALUES 
('Dr. Fernando Ribeiro', 'MA-1234', 'Clínica Geral', 7500.00),
('Dra. Marina Souza', 'MA-2345', 'Cirurgia', 9200.00),
('Dr. Ricardo Almeida', 'MA-3456', 'Dermatologia', 6800.00);

INSERT INTO tutor (cpf, nome, telefone, email, cidade, data_cadastro) VALUES 
('111.222.333-44', 'Ana Paula Mendes', '(98) 98123-4567', 'ana.mendes@email.com', 'São Luís', '2024-03-15'),
('222.333.444-55', 'Carlos Eduardo Silva', '(98) 98234-5678', 'carlos.silva@email.com', 'São Luís', '2024-05-20'),
('333.444.555-66', 'Beatriz Oliveira Costa', '(98) 98345-6789', 'beatriz.costa@email.com', 'São José de Ribamar', '2024-07-10'),
('444.555.666-77', 'Daniel Ferreira Lima', '(98) 98456-7890', NULL, 'São Luís', '2025-01-08'),
('555.666.777-88', 'Eliane Rodrigues Sousa', '(98) 98567-8901', 'eliane.sousa@email.com', 'Paço do Lumiar', '2025-02-14'),
('777.888.999-00', 'Luciana Matos', '(98) 99888-7766', 'luciana.matos@email.com', 'São Luís', '2026-05-06');

INSERT INTO animal (nome, id_especie, cpf_tutor, data_nasc, peso, sexo) VALUES 
('Thor', 1, '111.222.333-44', '2020-06-12', 28.50, 'Macho'),
('Mel', 2, '111.222.333-44', '2022-03-08', 4.20, 'Fêmea'),
('Bolinha', 1, '222.333.444-55', '2018-11-25', 12.80, 'Macho'),
('Nina', 2, '333.444.555-66', '2023-01-15', 3.50, 'Fêmea'),
('Rex', 1, '333.444.555-66', '2019-09-30', 35.00, 'Macho'),
('Pipoca', 4, '444.555.666-77', '2023-08-10', 0.35, 'Fêmea'),
('Lila', 2, '555.666.777-88', '2021-05-22', 5.10, 'Fêmea'),
('Apolo', 1, '555.666.777-88', '2022-12-01', 22.00, 'Macho'),
('Abelha', 1, '777.888.999-00', '2024-01-10', 8.00, 'Fêmea'),
('Formiga', 1, '777.888.999-00', '2024-01-10', 8.00, 'Fêmea'),
('Moranguinho', 2, '777.888.999-00', '2023-02-15', 5.00, 'Macho'),
('Banana', 6, '777.888.999-00', '2024-05-03', 1.20, 'Macho');

INSERT INTO vacina_catalogo (nome, fabricante, validade_meses) VALUES 
('V10', 'Zoetis', 12),
('Antirrábica', 'MSD Saúde Animal', 12),
('Giárdia', 'Merial', 12),
('Tríplice Felina', 'Virbac', 12),
('Leucemia Felina', 'Boehringer', 12);

INSERT INTO vacina_aplicada (id_animal, id_vacina, id_vet, data_aplicacao, lote) VALUES 
(1, 1, 1, '2025-06-15', 'L2025-V10-A1'),
(1, 2, 1, '2025-06-15', 'L2025-ANT-A3'),
(2, 4, 1, '2025-07-20', 'L2025-TRF-B2'),
(3, 1, 2, '2025-09-01', 'L2025-V10-C1'),
(4, 4, 3, '2025-10-10', 'L2025-TRF-B5'),
(5, 1, 1, '2026-01-05', 'L2026-V10-A2'),
(5, 2, 1, '2026-01-05', 'L2026-ANT-A7'),
(7, 4, 3, '2026-02-20', 'L2026-TRF-C3'),
(8, 1, 2, '2026-03-18', 'L2026-V10-D1'),
(2, 2, 1, '2026-03-10', 'L2026-ANT-B9');

INSERT INTO consulta (id_animal, id_vet, data_consulta, motivo, valor, status) VALUES 
(1, 1, '2026-03-05', 'Check-up anual', 150.00, 'Realizada'),
(2, 1, '2026-03-10', 'Vacinação antirrábica', 80.00, 'Realizada'),
(3, 2, '2026-03-15', 'Castração', 450.00, 'Realizada'),
(4, 3, '2026-03-20', 'Dermatite alérgica', 180.00, 'Realizada'),
(5, 1, '2026-04-02', 'Emergência — corte na pata', 250.00, 'Realizada'),
(6, 1, '2026-04-10', 'Consulta de rotina', 120.00, 'Agendada'),
(7, 3, '2026-04-15', 'Problema de pele', 180.00, 'Cancelada'),
(8, 2, '2026-04-22', 'Castração', 450.00, 'Agendada');

-- 3. NOVOS INSERTS PARA O DESAFIO (RODADA 2 - LEFT JOIN E TESTES DE NULOS)

INSERT INTO tutor (nome, cpf, telefone, email, cidade, data_cadastro) VALUES
('Henrique Castro Pinto', '111.222.333-00', '(98) 98789-0123', 'henrique.castro@email.com', 'São Luís', '2026-04-30');

INSERT INTO veterinario (nome, crmv, especialidade, salario) VALUES
('Dra. Patrícia Lima', 'MA-4567', 'Oftalmologia', 7000.00);

INSERT INTO animal (nome, id_especie, cpf_tutor, data_nasc, peso, sexo) VALUES
('Bidu', 1, '111.222.333-00', '2024-02-10', 18.00, 'Macho');

-- 4. JOIN BATTLE - RODADA 1 (INNER JOIN)

-- 1.1 Listar Animal e seu Tutor
SELECT a.nome AS nome_animal, t.nome AS nome_tutor
FROM animal a
INNER JOIN tutor t ON a.cpf_tutor = t.cpf;

-- 1.2 Listar Consultas com Animal e Veterinário
SELECT c.data_consulta AS data_consulta, a.nome AS nome_animal, v.nome AS veterinario
FROM consulta c
INNER JOIN animal a ON c.id_animal = a.id_animal
INNER JOIN veterinario v ON c.id_vet = v.id_vet;

-- 1.3 Histórico de Vacinas (Cruzamento de 4 tabelas)
SELECT va.data_aplicacao AS vacina_data_aplicacao, a.nome AS nome_animal, vc.nome AS nome_vacina, ve.nome AS nome_veterinario
FROM vacina_aplicada va
INNER JOIN animal a ON va.id_animal = a.id_animal
INNER JOIN vacina_catalogo vc ON va.id_vacina = vc.id_vacina
INNER JOIN veterinario ve ON va.id_vet = ve.id_vet;

-- 1.4 Tutores, Animais e Espécies (Ordenado)
SELECT t.nome AS nome_tutor, a.nome AS nome_animal, e.nome AS especie
FROM tutor t
INNER JOIN animal a ON a.cpf_tutor = t.cpf
INNER JOIN especie e ON a.id_especie = e.id_especie
ORDER BY nome_tutor ASC;

-- 5. JOIN BATTLE - RODADA 2 (LEFT JOIN)

-- 2.1 Todos os Tutores e seus Animais (incluindo os sem pets)
SELECT t.nome AS nome_tutor, a.nome AS nome_animal
FROM tutor t
LEFT JOIN animal a ON t.cpf = a.cpf_tutor;

-- 2.2 Quantidade de consultas por Veterinário (mesmo sem consultas)
SELECT v.nome AS nome_veterinario, COUNT(c.id_consulta) AS numero_consultas
FROM veterinario v
LEFT JOIN consulta c ON v.id_vet = c.id_vet
GROUP BY v.nome;

-- 2.3 Tutores que possuem animais, mas esses animais nunca consultaram
SELECT t.nome AS tutor
FROM tutor t
INNER JOIN animal a ON t.cpf = a.cpf_tutor
LEFT JOIN consulta c ON c.id_animal = a.id_animal
WHERE c.id_consulta IS NULL
GROUP BY tutor;

-- 2.4 Total de aplicações por tipo de vacina (mesmo as nunca aplicadas)
SELECT vc.nome AS vacina, COUNT(va.id_aplicacao) AS qntd_aplicacoes
FROM vacina_catalogo vc
LEFT JOIN vacina_aplicada va ON vc.id_vacina = va.id_vacina
GROUP BY vacina;

-- 6. JOIN BATTLE - RODADA 3 (RIGHT JOIN)

-- 3.1 Todos os Tutores e seus Animais (reproduzindo a 2.1 com RIGHT JOIN)
SELECT t.nome AS tutor, a.nome AS animal
FROM animal a
RIGHT JOIN tutor t ON a.cpf_tutor = t.cpf;

-- 3.2: INTERPRETAÇÃO — A vs B (LEFT JOIN vs RIGHT JOIN)

-- Consulta A: LEFT JOIN
SELECT t.nome AS tutor, a.nome AS animal 
FROM tutor t 
LEFT JOIN animal a ON t.cpf = a.cpf_tutor;

-- Consulta B: RIGHT JOIN
SELECT t.nome AS tutor, a.nome AS animal 
FROM tutor t 
RIGHT JOIN animal a ON t.cpf = a.cpf_tutor;

/*
1. Quem fica de fora em A? E em B?
Resposta: No LEFT JOIN (Consulta A), ninguém da tabela 'tutor' fica de fora. 
Tutores sem animais (como o Henrique Castro Pinto) aparecem na lista com o campo 
do animal como NULL. Fariam de fora apenas animais que não tivessem um tutor 
vinculado (o que é impossível no nosso banco devido à restrição NOT NULL).

Resposta: No RIGHT JOIN (Consulta B), os tutores que NÃO possuem animais cadastrados 
ficam de fora (ex: Henrique). Isso acontece porque a consulta prioriza a tabela 
da direita (animal), e como não há um registro de animal para o Henrique, o 
banco descarta o nome dele do resultado.

2. Em qual situação real cada uma seria a escolha certa?

ESCOLHA A (LEFT JOIN): Seria a escolha certa para um relatório de Marketing ou 
Comunicação. Se o Adriano (da AM Consultoria) quiser enviar um "Feliz Aniversário" 
ou um informativo para TODOS os clientes cadastrados na clínica, ele deve usar 
o LEFT JOIN, para garantir que até quem ainda não trouxe o bicho apareça na lista.

ESCOLHA B (RIGHT JOIN): Seria a escolha certa para um relatório de Ocupação da 
Clínica ou Inventário de Pacientes. Se o objetivo é saber quem são os donos de 
todos os animais que estão ocupando espaço nos canis hoje, o RIGHT JOIN garante 
que o foco seja o animal, listando apenas os tutores que realmente têm um pet 
vinculado.
*/

-- 7. JOIN BATTLE - RODADA 4 (NÍVEL P2 - RELATÓRIOS DE GESTÃO)

-- 4.1 Tutores cujos animais tomaram a vacina "Antirrábica" (id_vacina = 2)
SELECT t.nome AS tutor, a.nome AS animal
FROM tutor t
INNER JOIN animal a
ON t.cpf = a.cpf_tutor
JOIN vacina_aplicada va
ON va.id_animal = a.id_animal
WHERE va.id_vacina = 2;

-- 4.2 Cães (id_especie = 1) que nunca realizaram uma consulta (Anti-join)
SELECT a.nome AS animal
FROM animal a
INNER JOIN especie e
ON a.id_especie = e.id_especie
LEFT JOIN consulta c
ON c.id_animal = a.id_animal
WHERE a.id_especie = 1
AND c.id_animal IS NULL;

-- 4.3 Relatório de Gestão de Faturamento por Veterinário

/* NOTA DO GRUPO: Conforme solicitado, filtramos o status 'Realizada' diretamente 
na cláusula ON para não quebrar o comportamento do LEFT JOIN.
*/
SELECT 
    v.nome AS veterinario, 
    COUNT(c.id_consulta) AS consultas_realizadas,
    COALESCE(SUM(c.valor), 0) AS total_faturado
FROM veterinario v
LEFT JOIN consulta c 
    ON v.id_vet = c.id_vet AND c.status = 'Realizada'
GROUP BY v.nome;

-- 8. BÔNUS A: SELF JOIN - Pares de animais do mesmo tutor

-- Usando a1.id_animal < a2.id_animal para não listar Thor com Thor, nem espelhar os pares.
SELECT 
    t.nome AS tutor, 
    a1.nome AS animal_1, 
    a2.nome AS animal_2
FROM animal a1
INNER JOIN animal a2 
    ON a1.cpf_tutor = a2.cpf_tutor AND a1.id_animal < a2.id_animal
INNER JOIN tutor t 
    ON a1.cpf_tutor = t.cpf;

-- 9. BÔNUS B: CROSS JOIN - Matriz de Plantão

/* 
Quantas linhas devem aparecer na matriz de plantão?
Resposta: O CROSS JOIN gera o Produto Cartesiano. Como temos 4 veterinários 
cadastrados (incluindo a Dra. Patrícia inserida no Lab 03) e 6 espécies 
(Cachorro, Gato, Ave, Roedor, Réptil, Lagomorfo), o total de linhas geradas 
é de 4 x 6 = 24 linhas.
*/
SELECT 
    v.nome AS veterinario, 
    e.nome AS especie
FROM veterinario v
CROSS JOIN especie e
ORDER BY v.nome, e.nome;

-- 10. BÔNUS C: FULL OUTER JOIN (A Armadilha do MySQL)
-- =============================================================================

-- 1. Simulando o FULL OUTER JOIN com UNION
SELECT t.nome AS tutor, a.nome AS animal
FROM tutor t
LEFT JOIN animal a ON t.cpf = a.cpf_tutor
UNION
SELECT t.nome AS tutor, a.nome AS animal
FROM tutor t
RIGHT JOIN animal a ON t.cpf = a.cpf_tutor;

-- 2. LEFT JOIN puro para comparação (executando para ver que o resultado é o mesmo)
SELECT t.nome AS tutor, a.nome AS animal
FROM tutor t
LEFT JOIN animal a ON t.cpf = a.cpf_tutor;

-- 3. Respostas das Questões Teóricas do Bônus C
/* 
1. Por que o resultado do FULL OUTER simulado deu IGUAL ao do LEFT JOIN puro?
Resposta: Porque na estrutura do nosso banco (no CREATE TABLE animal), a coluna 
'cpf_tutor' possui a restrição 'NOT NULL'. Isso significa que o banco de dados 
proíbe a existência de um animal "órfão" (sem tutor cadastrado). O RIGHT JOIN 
tentaria trazer "animais sem tutor", mas como eles não existem por regra de 
negócio, o resultado final do FULL OUTER acaba sendo idêntico ao do LEFT JOIN.

2. Em quais situações reais um FULL OUTER traria linhas que o LEFT JOIN não traz?
Resposta: O FULL OUTER traria linhas diferentes se a clínica permitisse cadastrar 
animais de rua ou para adoção sem um tutor definido (ou seja, se o 'cpf_tutor' 
pudesse ser NULL). Nesse cenário, a consulta mostraria tanto os tutores sem 
animais (do LEFT JOIN) quanto os animais sem tutores (do RIGHT JOIN).

3. Por que UNION (e não UNION ALL) é importante aqui?
Resposta: Porque o UNION remove as linhas duplicadas. Tanto o LEFT JOIN quanto o 
RIGHT JOIN trazem os registros que têm correspondência exata (a interseção do 
INNER JOIN). Se usássemos UNION ALL, todos os tutores que possuem animais 
apareceriam duplicados no resultado final. O UNION junta os dois lados garantindo 
que a interseção apareça apenas uma vez.

4. Cite um SGBD que suporta FULL OUTER JOIN direto, sem esse truque.
Resposta: PostgreSQL (o banco open-source mais famoso com esse suporte nativo), 
Oracle Database e Microsoft SQL Server. Nesses bancos, bastaria escrever: 
"SELECT * FROM tutor FULL OUTER JOIN animal ON..."
*/