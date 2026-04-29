-- =============================================================================
-- 3. A MANHÃ MAIS AGITADA (Eventos das 08h12 às 11h55)
-- =============================================================================

-- [08h12] Evento 1: Carol atende Luciana na recepção e faz pré-cadastro.
INSERT INTO tutor (cpf, nome, cidade, data_cadastro) 
VALUES ('777.888.999-00', 'Luciana Matos', 'São Luís', CURDATE());

-- [08h30] Evento 2: Luciana chega, passa contatos e cadastra 3 animais.
UPDATE tutor 
SET telefone = '(98) 99888-7766', email = 'luciana.matos@email.com' 
WHERE cpf = '777.888.999-00';

INSERT INTO animal (nome, id_especie, cpf_tutor, data_nasc, peso, sexo) VALUES 
('Abelha', (SELECT id_especie FROM especie WHERE nome='Cachorro'), '777.888.999-00', '2024-01-10', 8.00, 'Fêmea'),
('Formiga', (SELECT id_especie FROM especie WHERE nome='Cachorro'), '777.888.999-00', '2024-01-10', 8.00, 'Fêmea'),
('Moranguinho', (SELECT id_especie FROM especie WHERE nome='Gato'), '777.888.999-00', '2023-02-15', 5.00, 'Macho');

-- [09h00] Evento 3: Dra. Marina transfere a castração do Apolo.
UPDATE consulta 
SET data_consulta = '2026-04-24' 
WHERE id_animal = (SELECT id_animal FROM animal WHERE nome='Apolo' AND cpf_tutor='555.666.777-88') 
  AND motivo = 'Castração' 
  AND status = 'Agendada';

-- [09h25] Evento 4: Atualização de dados do Carlos Eduardo.
UPDATE tutor 
SET telefone = '(98) 98111-2222', email = 'carlos.silva2026@email.com' 
WHERE cpf = '222.333.444-55';

-- [09h45] Evento 5: Lista de gatos para campanha da Dra. Marina.
SELECT a.nome AS Nome_Animal, t.nome AS Tutor, t.telefone AS Contato
FROM animal a
JOIN tutor t ON a.cpf_tutor = t.cpf
JOIN especie e ON a.id_especie = e.id_especie
WHERE e.nome = 'Gato';

-- [10h10] Evento 6: Carol pede duas listas para fechamento do caixa.
-- Lista 1: Consultas de março
SELECT data_consulta, motivo, valor 
FROM consulta 
WHERE MONTH(data_consulta) = 3;

-- Lista 2: Castrações de qualquer mês
SELECT data_consulta, motivo, valor 
FROM consulta 
WHERE motivo LIKE '%Castração%';

-- [10h40] Evento 7: Auditoria da Dona Regina.
SELECT data_consulta, motivo, valor, status
FROM consulta
WHERE status = 'Realizada' AND valor BETWEEN 100.00 AND 300.00;

-- [11h00] Evento 8: O ataque de fúria e o desafio da LGPD (Eliane Rodrigues).
-- Decisão: Anonimização dos dados para não quebrar relatórios financeiros com um DELETE.
UPDATE tutor 
SET nome = 'TUTOR ANONIMIZADO (LGPD)', telefone = 'APAGADO', email = 'APAGADO', cidade = 'APAGADO' 
WHERE cpf = '555.666.777-88';

UPDATE animal 
SET nome = 'ANIMAL ANONIMIZADO (LGPD)' 
WHERE cpf_tutor = '555.666.777-88';

-- [11h30] Evento 9: Carol pede atualização em bloco de consultas atrasadas.
UPDATE consulta 
SET status = 'Realizada' 
WHERE data_consulta < CURDATE() AND status = 'Agendada';

-- [11h55] Evento 10: Luciana tenta cadastrar um coelho.
-- Decisão: Criação da espécie Lagomorfo para preservar integridade biológica do banco.
INSERT INTO especie (nome) VALUES ('Lagomorfo');

INSERT INTO animal (nome, id_especie, cpf_tutor, data_nasc, peso, sexo) VALUES 
('Banana', (SELECT id_especie FROM especie WHERE nome='Lagomorfo'), '777.888.999-00', '2024-05-03', 1.20, 'Macho');