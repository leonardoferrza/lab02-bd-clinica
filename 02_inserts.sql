-- =============================================================================
-- 2. CARGA INICIAL DE DADOS (DML)
-- =============================================================================

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