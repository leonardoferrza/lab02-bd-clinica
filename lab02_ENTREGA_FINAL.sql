--Alunos: Cássia Irene, Leonardo Ferreira, Melissa Wolff

-- 1. CRIAÇÃO DO BANCO E DAS TABELAS

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

-- 2. CARGA INICIAL DE DADOS

-- Espécies Iniciais
INSERT INTO especie (nome) VALUES ('Cachorro'), ('Gato'), ('Ave'), ('Roedor'), ('Réptil');

-- Equipe de Veterinários
INSERT INTO veterinario (nome, crmv, especialidade, salario) VALUES 
('Dr. Fernando Ribeiro', 'MA-1234', 'Clínica Geral', 7500.00),
('Dra. Marina Souza', 'MA-2345', 'Cirurgia', 9200.00),
('Dr. Ricardo Almeida', 'MA-3456', 'Dermatologia', 6800.00);

-- Tutores Cadastrados
INSERT INTO tutor (cpf, nome, telefone, email, cidade, data_cadastro) VALUES 
('111.222.333-44', 'Ana Paula Mendes', '(98) 98123-4567', 'ana.mendes@email.com', 'São Luís', '2024-03-15'),
('222.333.444-55', 'Carlos Eduardo Silva', '(98) 98234-5678', 'carlos.silva@email.com', 'São Luís', '2024-05-20'),
('333.444.555-66', 'Beatriz Oliveira Costa', '(98) 98345-6789', 'beatriz.costa@email.com', 'São José de Ribamar', '2024-07-10'),
('444.555.666-77', 'Daniel Ferreira Lima', '(98) 98456-7890', NULL, 'São Luís', '2025-01-08'),
('555.666.777-88', 'Eliane Rodrigues Sousa', '(98) 98567-8901', 'eliane.sousa@email.com', 'Paço do Lumiar', '2025-02-14');

-- Animais
INSERT INTO animal (nome, id_especie, cpf_tutor, data_nasc, peso, sexo) VALUES 
('Thor', (SELECT id_especie FROM especie WHERE nome='Cachorro'), '111.222.333-44', '2020-06-12', 28.50, 'Macho'),
('Mel', (SELECT id_especie FROM especie WHERE nome='Gato'), '111.222.333-44', '2022-03-08', 4.20, 'Fêmea'),
('Bolinha', (SELECT id_especie FROM especie WHERE nome='Cachorro'), '222.333.444-55', '2018-11-25', 12.80, 'Macho'),
('Nina', (SELECT id_especie FROM especie WHERE nome='Gato'), '333.444.555-66', '2023-01-15', 3.50, 'Fêmea'),
('Rex', (SELECT id_especie FROM especie WHERE nome='Cachorro'), '333.444.555-66', '2019-09-30', 35.00, 'Macho'),
('Pipoca', (SELECT id_especie FROM especie WHERE nome='Roedor'), '444.555.666-77', '2023-08-10', 0.35, 'Fêmea'),
('Lila', (SELECT id_especie FROM especie WHERE nome='Gato'), '555.666.777-88', '2021-05-22', 5.10, 'Fêmea'),
('Apolo', (SELECT id_especie FROM especie WHERE nome='Cachorro'), '555.666.777-88', '2022-12-01', 22.00, 'Macho');

-- Catálogo de Vacinas
INSERT INTO vacina_catalogo (nome, fabricante, validade_meses) VALUES 
('V10', 'Zoetis', 12),
('Antirrábica', 'MSD Saúde Animal', 12),
('Giárdia', 'Merial', 12),
('Tríplice Felina', 'Virbac', 12),
('Leucemia Felina', 'Boehringer', 12);

-- Vacinas Aplicadas
INSERT INTO vacina_aplicada (id_animal, id_vacina, id_vet, data_aplicacao, lote) VALUES 
((SELECT id_animal FROM animal WHERE nome='Thor' AND cpf_tutor='111.222.333-44'), (SELECT id_vacina FROM vacina_catalogo WHERE nome='V10'), 1, '2025-06-15', 'L2025-V10-A1'),
((SELECT id_animal FROM animal WHERE nome='Thor' AND cpf_tutor='111.222.333-44'), (SELECT id_vacina FROM vacina_catalogo WHERE nome='Antirrábica'), 1, '2025-06-15', 'L2025-ANT-A3'),
((SELECT id_animal FROM animal WHERE nome='Mel'), (SELECT id_vacina FROM vacina_catalogo WHERE nome='Tríplice Felina'), 1, '2025-07-20', 'L2025-TRF-B2'),
((SELECT id_animal FROM animal WHERE nome='Bolinha'), (SELECT id_vacina FROM vacina_catalogo WHERE nome='V10'), 2, '2025-09-01', 'L2025-V10-C1'),
((SELECT id_animal FROM animal WHERE nome='Nina'), (SELECT id_vacina FROM vacina_catalogo WHERE nome='Tríplice Felina'), 3, '2025-10-10', 'L2025-TRF-B5'),
((SELECT id_animal FROM animal WHERE nome='Rex'), (SELECT id_vacina FROM vacina_catalogo WHERE nome='V10'), 1, '2026-01-05', 'L2026-V10-A2'),
((SELECT id_animal FROM animal WHERE nome='Rex'), (SELECT id_vacina FROM vacina_catalogo WHERE nome='Antirrábica'), 1, '2026-01-05', 'L2026-ANT-A7'),
((SELECT id_animal FROM animal WHERE nome='Lila'), (SELECT id_vacina FROM vacina_catalogo WHERE nome='Tríplice Felina'), 3, '2026-02-20', 'L2026-TRF-C3'),
((SELECT id_animal FROM animal WHERE nome='Apolo'), (SELECT id_vacina FROM vacina_catalogo WHERE nome='V10'), 2, '2026-03-18', 'L2026-V10-D1'),
((SELECT id_animal FROM animal WHERE nome='Mel'), (SELECT id_vacina FROM vacina_catalogo WHERE nome='Antirrábica'), 1, '2026-03-10', 'L2026-ANT-B9');

-- Consultas Recentes
INSERT INTO consulta (id_animal, id_vet, data_consulta, motivo, valor, status) VALUES 
((SELECT id_animal FROM animal WHERE nome='Thor' AND cpf_tutor='111.222.333-44'), 1, '2026-03-05', 'Check-up anual', 150.00, 'Realizada'),
((SELECT id_animal FROM animal WHERE nome='Mel'), 1, '2026-03-10', 'Vacinação antirrábica', 80.00, 'Realizada'),
((SELECT id_animal FROM animal WHERE nome='Bolinha'), 2, '2026-03-15', 'Castração', 450.00, 'Realizada'),
((SELECT id_animal FROM animal WHERE nome='Nina'), 3, '2026-03-20', 'Dermatite alérgica', 180.00, 'Realizada'),
((SELECT id_animal FROM animal WHERE nome='Rex'), 1, '2026-04-02', 'Emergência — corte na pata', 250.00, 'Realizada'),
((SELECT id_animal FROM animal WHERE nome='Pipoca'), 1, '2026-04-10', 'Consulta de rotina', 120.00, 'Agendada'),
((SELECT id_animal FROM animal WHERE nome='Lila'), 3, '2026-04-15', 'Problema de pele', 180.00, 'Cancelada'),
((SELECT id_animal FROM animal WHERE nome='Apolo'), 2, '2026-04-22', 'Castração', 450.00, 'Agendada');

-- 3. A MANHÃ MAIS AGITADA (Eventos das 08h12 às 11h55)

/*
[08h12] Evento 1: Carol atende Luciana na recepção e faz pré-cadastro.

Comentário: Inserindo apenas os dados iniciais fornecidos.
*/

INSERT INTO tutor (cpf, nome, cidade, data_cadastro) 
VALUES ('777.888.999-00', 'Luciana Matos', 'São Luís', CURRENT_DATE);

/*
[08h30] Evento 2: Luciana chega, passa contatos e cadastra 3 animais.

Comentário: Primeiro fazemos o UPDATE no tutor, depois os INSERTs na tabela animal.
*/

UPDATE tutor 
SET telefone = '(98) 99888-7766', email = 'luciana.matos@email.com' 
WHERE cpf = '777.888.999-00';

INSERT INTO animal (nome, id_especie, cpf_tutor, data_nasc, peso, sexo) VALUES 
('Abelha', (SELECT id_especie FROM especie WHERE nome='Cachorro'), '777.888.999-00', '2024-01-10', 8.00, 'Fêmea'),
('Formiga', (SELECT id_especie FROM especie WHERE nome='Cachorro'), '777.888.999-00', '2024-01-10', 8.00, 'Fêmea'),
('Moranguinho', (SELECT id_especie FROM especie WHERE nome='Gato'), '777.888.999-00', '2023-02-15', 5.00, 'Macho');

/*
[09h00] Evento 3: Dra. Marina transfere a castração do Apolo.

Comentário: Alterando a data para o dia 24/04/2026.
*/

UPDATE consulta 
SET data_consulta = '2026-04-24' 
WHERE id_animal = (SELECT id_animal FROM animal WHERE nome='Apolo' AND cpf_tutor='555.666.777-88') 
  AND motivo = 'Castração' 
  AND status = 'Agendada';

/*
[09h25] Evento 4: Atualização de dados do Carlos Eduardo.

Comentário: UPDATE simples buscando pelo CPF ou Nome do tutor revoltado.
*/

UPDATE tutor 
SET telefone = '(98) 98111-2222', email = 'carlos.silva2026@email.com' 
WHERE cpf = '222.333.444-55';

/*
[09h45] Evento 5: Lista de gatos para campanha da Dra. Marina.

Comentário: JOIN entre animal, especie e tutor filtrando apenas por 'Gato'.
*/

SELECT a.nome AS Nome_Animal, t.nome AS Tutor, t.telefone AS Contato
FROM animal a
JOIN tutor t ON a.cpf_tutor = t.cpf
JOIN especie e ON a.id_especie = e.id_especie
WHERE e.nome = 'Gato';

/*
[10h10] Evento 6: Carol pede duas listas para fechamento do caixa.

Comentário: Primeira query filtra pelo mês 3 (Março). Segunda usa ILIKE para pegar qualquer castração.

Lista 1: Consultas de março
*/

SELECT data_consulta, motivo, valor 
FROM consulta 
WHERE EXTRACT(MONTH FROM data_consulta) = 3;

-- Lista 2: Castrações de qualquer mês
SELECT data_consulta, motivo, valor 
FROM consulta 
WHERE motivo ILIKE '%Castração%';

/*
[10h40] Evento 7: Auditoria da Dona Regina.

Comentário: Buscando faixa de valores e status específico.
*/

SELECT data_consulta, motivo, valor, status
FROM consulta
WHERE status = 'Realizada' AND valor BETWEEN 100.00 AND 300.00;

/*
[11h00] Evento 8: O ataque de fúria e o desafio da LGPD (Eliane Rodrigues).

Comentário: Em vez de usar DELETE e destruir o registro financeiro nas consultas e histórico de vacinas (exclusão em cascata), optamos por ANONIMIZAR os dados sensíveis. Assim, cumprimos a LGPD sem quebrar as estatísticas e finanças da clínica.
*/

UPDATE tutor 
SET nome = 'TUTOR ANONIMIZADO (LGPD)', telefone = 'APAGADO', email = 'APAGADO', cidade = 'APAGADO' 
WHERE cpf = '555.666.777-88';

UPDATE animal 
SET nome = 'ANIMAL ANONIMIZADO (LGPD)' 
WHERE cpf_tutor = '555.666.777-88';

/*
[11h30] Evento 9: Carol pede atualização em bloco de consultas atrasadas.

Comentário: Tudo que for anterior à data de hoje (22/04) e estiver agendado, vira 'Realizada'.
*/

UPDATE consulta 
SET status = 'Realizada' 
WHERE data_consulta < CURRENT_DATE AND status = 'Agendada';

/*
[11h55] Evento 10: Luciana tenta cadastrar um coelho.

Comentário (Decisão b): Optamos por criar a espécie "Lagomorfo" para manter a estrutura técnica correta do sistema e evitar problemas futuros de triagem.
*/

INSERT INTO especie (nome) VALUES ('Lagomorfo');
INSERT INTO animal (nome, id_especie, cpf_tutor, data_nasc, peso, sexo) VALUES 
('Banana', (SELECT id_especie FROM especie WHERE nome='Lagomorfo'), '777.888.999-00', '2024-05-03', 1.20, 'Macho');

-- 4. DISCUSSÃO FINAL

/*
1. Desafio com LGPD (evento das 11h)

O das 11h00 foi o ponto mais delicado do trabalho. A ideia inicial era usar DELETE CASCADE para remover os dados da cliente Eliane Rodrigues, mas logo percebemos que isso apagaria também consultas e registros de vacinas. Isso impactaria diretamente o financeiro da clínica e o histórico sanitário, o que não faz sentido na prática.

A solução que encontramos foi anonimizar os dados pessoais (nome, telefone, etc.), mantendo os registros no banco. Assim, conseguimos atender a LGPD sem perder informações importantes para auditoria e operação da clínica. Foi um ponto interessante porque mostrou que nem sempre a solução mais direta (deletar tudo) é a mais correta.

2. Classificação da espécie (evento das 11h55)

Aqui rolou uma pequena discussão no grupo. Uma opção era classificar o coelho como roedor para simplificar, mas isso geraria um dado incorreto logo na base. A outra opção era criar a espécie "Lagomorfo".

Decidimos criar a nova espécie. Pode parecer um detalhe pequeno, mas entendemos que esse tipo de decisão impacta no futuro. Se a clínica precisar filtrar ou aplicar algum protocolo específico por espécie, ter dados corretos desde o início evita problemas maiores depois.

3. Consultas recorrentes e melhoria do banco

Pensando no uso do sistema no dia a dia, percebemos que algumas consultas vão se repetir bastante, como a lista de gatos solicitada pela Dra. Marina.

Para evitar reescrever a mesma query toda vez, vimos que faz sentido usar uma VIEW. Isso permite salvar a consulta no banco e reutilizar de forma simples:

CREATE VIEW vw_lista_gatos AS
    SELECT a.nome AS nome_animal, t.nome AS tutor, t.telefone
    FROM animal a
    JOIN tutor t ON a.cpf_tutor = t.cpf
    JOIN especie e ON a.id_especie = e.id_especie
    WHERE e.nome = 'Gato';

Depois disso, basta rodar:
SELECT * FROM vw_lista_gatos;

Isso reduz erro, melhora a organização e facilita para quem vai usar o sistema no dia a dia.
*/