USE bateponto;
SET NAMES utf8mb4;

ALTER TABLE solicitacoes
  MODIFY COLUMN tipo ENUM('Justificativa', 'Compensação') NOT NULL;

UPDATE servidores
SET nome_completo = 'João da Silva', materia = 'Matemática Discreta'
WHERE matricula = 'TESTE001';

DELETE s FROM solicitacoes s
JOIN servidores p ON p.id = s.servidor_id
WHERE p.matricula IN ('DEMO-002', 'DEMO-003', 'DEMO-004', 'DEMO-005');

DELETE r FROM registros_ponto r
JOIN servidores p ON p.id = r.servidor_id
WHERE p.matricula IN ('DEMO-002', 'DEMO-003', 'DEMO-004', 'DEMO-005');

DELETE g FROM grades_aulas g
JOIN servidores p ON p.id = g.servidor_id
WHERE p.matricula IN ('DEMO-002', 'DEMO-003', 'DEMO-004', 'DEMO-005');

DELETE u FROM usuarios u
JOIN servidores p ON p.id = u.servidor_id
WHERE p.matricula IN ('DEMO-002', 'DEMO-003', 'DEMO-004', 'DEMO-005');

DELETE FROM servidores
WHERE matricula IN ('DEMO-002', 'DEMO-003', 'DEMO-004', 'DEMO-005');

INSERT INTO servidores (
  nome_completo, cpf, matricula, cargo, materia, regime, data_admissao,
  email_institucional, status
)
SELECT 'João Pedro Almeida Costa', '00000000002', 'TESTE002', 'Professor',
       'Lógica de Programação', '40 horas', '2026-03-02',
       'joaopedro@fatec.sp.gov.br', 'Ativo'
WHERE NOT EXISTS (SELECT 1 FROM servidores WHERE matricula = 'TESTE002');

INSERT INTO servidores (
  nome_completo, cpf, matricula, cargo, materia, regime, data_admissao,
  email_institucional, status
)
SELECT 'Maria Clara Ferreira Lima', '00000000003', 'TESTE003', 'Professor',
       'Programação Web', '40 horas', '2026-03-02',
       'mariaclara@fatec.sp.gov.br', 'Ativo'
WHERE NOT EXISTS (SELECT 1 FROM servidores WHERE matricula = 'TESTE003');

INSERT INTO servidores (
  nome_completo, cpf, matricula, cargo, materia, regime, data_admissao,
  email_institucional, status
)
SELECT 'Lucas André Ribeiro Santos', '00000000004', 'TESTE004', 'Professor',
       'Banco de Dados', '40 horas', '2026-03-02',
       'lucasandre@fatec.sp.gov.br', 'Ativo'
WHERE NOT EXISTS (SELECT 1 FROM servidores WHERE matricula = 'TESTE004');

INSERT INTO servidores (
  nome_completo, cpf, matricula, cargo, materia, regime, data_admissao,
  email_institucional, status
)
SELECT 'Ana Júlia Martins Rocha', '00000000005', 'TESTE005', 'Professor',
       'Engenharia de Software', '40 horas', '2026-03-02',
       'anajulia@fatec.sp.gov.br', 'Ativo'
WHERE NOT EXISTS (SELECT 1 FROM servidores WHERE matricula = 'TESTE005');

INSERT INTO servidores (
  nome_completo, cpf, matricula, cargo, materia, regime, data_admissao,
  email_institucional, status
)
SELECT 'Rafael Henrique Oliveira Souza', '00000000006', 'TESTE006', 'Professor',
       'Redes de Computadores', '40 horas', '2026-03-02',
       'rafaelhenrique@fatec.sp.gov.br', 'Ativo'
WHERE NOT EXISTS (SELECT 1 FROM servidores WHERE matricula = 'TESTE006');

INSERT INTO servidores (
  nome_completo, cpf, matricula, cargo, materia, regime, data_admissao,
  email_institucional, status
)
SELECT 'Beatriz Luísa Carvalho Mendes', '00000000007', 'TESTE007', 'Professor',
       'Sistemas Operacionais', '40 horas', '2026-03-02',
       'beatrizluisa@fatec.sp.gov.br', 'Ativo'
WHERE NOT EXISTS (SELECT 1 FROM servidores WHERE matricula = 'TESTE007');

INSERT INTO servidores (
  nome_completo, cpf, matricula, cargo, materia, regime, data_admissao,
  email_institucional, status
)
SELECT 'Gabriel Antônio Nogueira Reis', '00000000008', 'TESTE008', 'Professor',
       'Estrutura de Dados', '40 horas', '2026-03-02',
       'gabrielantonio@fatec.sp.gov.br', 'Ativo'
WHERE NOT EXISTS (SELECT 1 FROM servidores WHERE matricula = 'TESTE008');

INSERT INTO servidores (
  nome_completo, cpf, matricula, cargo, materia, regime, data_admissao,
  email_institucional, status
)
SELECT 'Camila Vitória Barbosa Freitas', '00000000009', 'TESTE009', 'Professor',
       'Desenvolvimento Mobile', '40 horas', '2026-03-02',
       'camilavitoria@fatec.sp.gov.br', 'Ativo'
WHERE NOT EXISTS (SELECT 1 FROM servidores WHERE matricula = 'TESTE009');

INSERT INTO servidores (
  nome_completo, cpf, matricula, cargo, materia, regime, data_admissao,
  email_institucional, status
)
SELECT 'Matheus Ícaro Gomes Pereira', '00000000010', 'TESTE010', 'Professor',
       'Segurança da Informação', '40 horas', '2026-03-02',
       'matheusicaro@fatec.sp.gov.br', 'Ativo'
WHERE NOT EXISTS (SELECT 1 FROM servidores WHERE matricula = 'TESTE010');

INSERT INTO usuarios (email, senha, cargo, servidor_id)
SELECT 'joaopedro@fatec.sp.gov.br', '123456', 'Professor', id
FROM servidores WHERE matricula = 'TESTE002'
ON DUPLICATE KEY UPDATE senha = '123456', cargo = 'Professor',
  servidor_id = (SELECT id FROM servidores WHERE matricula = 'TESTE002');

INSERT INTO usuarios (email, senha, cargo, servidor_id)
SELECT 'mariaclara@fatec.sp.gov.br', '123456', 'Professor', id
FROM servidores WHERE matricula = 'TESTE003'
ON DUPLICATE KEY UPDATE senha = '123456', cargo = 'Professor',
  servidor_id = (SELECT id FROM servidores WHERE matricula = 'TESTE003');

INSERT INTO usuarios (email, senha, cargo, servidor_id)
SELECT 'lucasandre@fatec.sp.gov.br', '123456', 'Professor', id
FROM servidores WHERE matricula = 'TESTE004'
ON DUPLICATE KEY UPDATE senha = '123456', cargo = 'Professor',
  servidor_id = (SELECT id FROM servidores WHERE matricula = 'TESTE004');

INSERT INTO usuarios (email, senha, cargo, servidor_id)
SELECT 'anajulia@fatec.sp.gov.br', '123456', 'Professor', id
FROM servidores WHERE matricula = 'TESTE005'
ON DUPLICATE KEY UPDATE senha = '123456', cargo = 'Professor',
  servidor_id = (SELECT id FROM servidores WHERE matricula = 'TESTE005');

INSERT INTO usuarios (email, senha, cargo, servidor_id)
SELECT 'rafaelhenrique@fatec.sp.gov.br', '123456', 'Professor', id
FROM servidores WHERE matricula = 'TESTE006'
ON DUPLICATE KEY UPDATE senha = '123456', cargo = 'Professor',
  servidor_id = (SELECT id FROM servidores WHERE matricula = 'TESTE006');

INSERT INTO usuarios (email, senha, cargo, servidor_id)
SELECT 'beatrizluisa@fatec.sp.gov.br', '123456', 'Professor', id
FROM servidores WHERE matricula = 'TESTE007'
ON DUPLICATE KEY UPDATE senha = '123456', cargo = 'Professor',
  servidor_id = (SELECT id FROM servidores WHERE matricula = 'TESTE007');

INSERT INTO usuarios (email, senha, cargo, servidor_id)
SELECT 'gabrielantonio@fatec.sp.gov.br', '123456', 'Professor', id
FROM servidores WHERE matricula = 'TESTE008'
ON DUPLICATE KEY UPDATE senha = '123456', cargo = 'Professor',
  servidor_id = (SELECT id FROM servidores WHERE matricula = 'TESTE008');

INSERT INTO usuarios (email, senha, cargo, servidor_id)
SELECT 'camilavitoria@fatec.sp.gov.br', '123456', 'Professor', id
FROM servidores WHERE matricula = 'TESTE009'
ON DUPLICATE KEY UPDATE senha = '123456', cargo = 'Professor',
  servidor_id = (SELECT id FROM servidores WHERE matricula = 'TESTE009');

INSERT INTO usuarios (email, senha, cargo, servidor_id)
SELECT 'matheusicaro@fatec.sp.gov.br', '123456', 'Professor', id
FROM servidores WHERE matricula = 'TESTE010'
ON DUPLICATE KEY UPDATE senha = '123456', cargo = 'Professor',
  servidor_id = (SELECT id FROM servidores WHERE matricula = 'TESTE010');

UPDATE grades_aulas g
JOIN servidores s ON s.id = g.servidor_id
SET g.disciplina = s.materia
WHERE s.matricula IN (
  'TESTE001', 'TESTE002', 'TESTE003', 'TESTE004', 'TESTE005',
  'TESTE006', 'TESTE007', 'TESTE008', 'TESTE009', 'TESTE010'
)
  AND g.disciplina <> s.materia;

SET @professor_id := (
  SELECT servidor_id FROM usuarios
  WHERE cargo = 'Professor' AND servidor_id IS NOT NULL
  ORDER BY id LIMIT 1
);
SET @gestor_id := (
  SELECT id FROM usuarios WHERE cargo = 'Gestor' ORDER BY id LIMIT 1
);
SET @prof2_id := (SELECT id FROM servidores WHERE matricula = 'TESTE002');
SET @prof3_id := (SELECT id FROM servidores WHERE matricula = 'TESTE003');
SET @prof4_id := (SELECT id FROM servidores WHERE matricula = 'TESTE004');
SET @prof5_id := (SELECT id FROM servidores WHERE matricula = 'TESTE005');
SET @prof6_id := (SELECT id FROM servidores WHERE matricula = 'TESTE006');
SET @prof7_id := (SELECT id FROM servidores WHERE matricula = 'TESTE007');
SET @prof8_id := (SELECT id FROM servidores WHERE matricula = 'TESTE008');
SET @prof9_id := (SELECT id FROM servidores WHERE matricula = 'TESTE009');
SET @prof10_id := (SELECT id FROM servidores WHERE matricula = 'TESTE010');
SET @d1 := CASE
  WHEN DAYOFWEEK(CURDATE()) = 2 THEN DATE_SUB(CURDATE(), INTERVAL 3 DAY)
  WHEN DAYOFWEEK(CURDATE()) = 1 THEN DATE_SUB(CURDATE(), INTERVAL 2 DAY)
  ELSE DATE_SUB(CURDATE(), INTERVAL 1 DAY)
END;
SET @d2 := CASE
  WHEN DAYOFWEEK(@d1) = 2 THEN DATE_SUB(@d1, INTERVAL 3 DAY)
  WHEN DAYOFWEEK(@d1) = 1 THEN DATE_SUB(@d1, INTERVAL 2 DAY)
  ELSE DATE_SUB(@d1, INTERVAL 1 DAY)
END;
SET @d3 := CASE
  WHEN DAYOFWEEK(@d2) = 2 THEN DATE_SUB(@d2, INTERVAL 3 DAY)
  WHEN DAYOFWEEK(@d2) = 1 THEN DATE_SUB(@d2, INTERVAL 2 DAY)
  ELSE DATE_SUB(@d2, INTERVAL 1 DAY)
END;
SET @d4 := CASE
  WHEN DAYOFWEEK(@d3) = 2 THEN DATE_SUB(@d3, INTERVAL 3 DAY)
  WHEN DAYOFWEEK(@d3) = 1 THEN DATE_SUB(@d3, INTERVAL 2 DAY)
  ELSE DATE_SUB(@d3, INTERVAL 1 DAY)
END;
SET @d5 := CASE
  WHEN DAYOFWEEK(@d4) = 2 THEN DATE_SUB(@d4, INTERVAL 3 DAY)
  WHEN DAYOFWEEK(@d4) = 1 THEN DATE_SUB(@d4, INTERVAL 2 DAY)
  ELSE DATE_SUB(@d4, INTERVAL 1 DAY)
END;

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @professor_id, 'Matemática Discreta', '8º A', 'Sala 12', 'Segunda', '08:00', '09:40', 'Ativo'
WHERE @professor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @professor_id AND disciplina = 'Matemática Discreta' AND turma = '8º A'
    AND dia_semana = 'Segunda' AND hora_inicio = '08:00'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @professor_id, 'Matemática Discreta', '8º A', 'Sala 12', 'Terça', '10:00', '11:40', 'Ativo'
WHERE @professor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @professor_id AND disciplina = 'Matemática Discreta' AND turma = '8º A'
    AND dia_semana = 'Terça' AND hora_inicio = '10:00'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @professor_id, 'Matemática Discreta', '9º B', 'Laboratório 2', 'Quinta', '13:30', '15:10', 'Ativo'
WHERE @professor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @professor_id AND disciplina = 'Matemática Discreta' AND turma = '9º B'
    AND dia_semana = 'Quinta' AND hora_inicio = '13:30'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @prof2_id, 'Lógica de Programação', '1º A', 'Lab 01', 'Segunda', '10:00', '11:40', 'Ativo'
WHERE @prof2_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @prof2_id AND disciplina = 'Lógica de Programação' AND turma = '1º A'
    AND dia_semana = 'Segunda' AND hora_inicio = '10:00'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @prof3_id, 'Programação Web', '2º A', 'Lab 02', 'Terça', '08:00', '09:40', 'Ativo'
WHERE @prof3_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @prof3_id AND disciplina = 'Programação Web' AND turma = '2º A'
    AND dia_semana = 'Terça' AND hora_inicio = '08:00'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @prof4_id, 'Banco de Dados', '2º B', 'Lab 03', 'Quarta', '10:00', '11:40', 'Ativo'
WHERE @prof4_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @prof4_id AND disciplina = 'Banco de Dados' AND turma = '2º B'
    AND dia_semana = 'Quarta' AND hora_inicio = '10:00'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @prof5_id, 'Engenharia de Software', '3º A', 'Lab 01', 'Quinta', '10:00', '11:40', 'Ativo'
WHERE @prof5_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @prof5_id AND disciplina = 'Engenharia de Software' AND turma = '3º A'
    AND dia_semana = 'Quinta' AND hora_inicio = '10:00'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @prof6_id, 'Redes de Computadores', '3º B', 'Lab 02', 'Sexta', '10:00', '11:40', 'Ativo'
WHERE @prof6_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @prof6_id AND disciplina = 'Redes de Computadores' AND turma = '3º B'
    AND dia_semana = 'Sexta' AND hora_inicio = '10:00'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @prof7_id, 'Sistemas Operacionais', '2º C', 'Lab 03', 'Segunda', '13:30', '15:10', 'Ativo'
WHERE @prof7_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @prof7_id AND disciplina = 'Sistemas Operacionais' AND turma = '2º C'
    AND dia_semana = 'Segunda' AND hora_inicio = '13:30'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @prof8_id, 'Estrutura de Dados', '1º B', 'Lab 01', 'Terça', '13:30', '15:10', 'Ativo'
WHERE @prof8_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @prof8_id AND disciplina = 'Estrutura de Dados' AND turma = '1º B'
    AND dia_semana = 'Terça' AND hora_inicio = '13:30'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @prof9_id, 'Desenvolvimento Mobile', '3º C', 'Lab 02', 'Quarta', '13:30', '15:10', 'Ativo'
WHERE @prof9_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @prof9_id AND disciplina = 'Desenvolvimento Mobile' AND turma = '3º C'
    AND dia_semana = 'Quarta' AND hora_inicio = '13:30'
);

INSERT INTO grades_aulas (servidor_id, disciplina, turma, sala, dia_semana, hora_inicio, hora_fim, status)
SELECT @prof10_id, 'Segurança da Informação', '3º A', 'Lab 03', 'Quinta', '15:30', '17:10', 'Ativo'
WHERE @prof10_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM grades_aulas
  WHERE servidor_id = @prof10_id AND disciplina = 'Segurança da Informação' AND turma = '3º A'
    AND dia_semana = 'Quinta' AND hora_inicio = '15:30'
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @professor_id, @d1, '08:00:00', '16:00:00', '08:00:00', 0, 'Regular'
WHERE @professor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @professor_id AND data = @d1
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @professor_id, @d2, '08:18:00', '16:05:00', '08:00:00', 18, 'Atrasado'
WHERE @professor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @professor_id AND data = @d2
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @professor_id, @d3, '07:55:00', '16:02:00', '08:00:00', 0, 'Regular'
WHERE @professor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @professor_id AND data = @d3
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @professor_id, @d4, '00:00:00', NULL, '08:00:00', 0, 'Falta'
WHERE @professor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @professor_id AND data = @d4
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @prof2_id, @d1, '09:58:00', '17:00:00', '10:00:00', 0, 'Regular'
WHERE @prof2_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @prof2_id AND data = @d1
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @prof3_id, @d1, '08:12:00', '16:00:00', '08:00:00', 12, 'Atrasado'
WHERE @prof3_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @prof3_id AND data = @d1
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @prof4_id, @d1, '09:58:00', '17:00:00', '10:00:00', 0, 'Regular'
WHERE @prof4_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @prof4_id AND data = @d1
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @prof5_id, @d1, '10:08:00', '17:00:00', '10:00:00', 8, 'Atrasado'
WHERE @prof5_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @prof5_id AND data = @d1
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @prof6_id, @d1, '09:56:00', '17:00:00', '10:00:00', 0, 'Regular'
WHERE @prof6_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @prof6_id AND data = @d1
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @prof7_id, @d2, '13:35:00', '17:00:00', '13:30:00', 5, 'Atrasado'
WHERE @prof7_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @prof7_id AND data = @d2
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @prof8_id, @d2, '13:25:00', '17:00:00', '13:30:00', 0, 'Regular'
WHERE @prof8_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @prof8_id AND data = @d2
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @prof9_id, @d2, '13:45:00', '17:00:00', '13:30:00', 15, 'Atrasado'
WHERE @prof9_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @prof9_id AND data = @d2
);

INSERT INTO registros_ponto (servidor_id, data, entrada, saida, horario_previsto, atraso_minutos, status)
SELECT @prof10_id, @d3, '15:30:00', '17:30:00', '15:30:00', 0, 'Regular'
WHERE @prof10_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM registros_ponto WHERE servidor_id = @prof10_id AND data = @d3
);

INSERT INTO solicitacoes (
  servidor_id, tipo, data, motivo, horario_compensacao, observacoes, horas, anexos,
  status, gestor_usuario_id, decisao_observacao, decidida_em, criada_em
)
SELECT @professor_id, 'Justificativa', @d2, 'Consulta médica (demo)', NULL,
       'Comprovante fictício para apresentação.', NULL, JSON_ARRAY('atestado-demo.pdf'),
       'Pendente', NULL, NULL, NULL, DATE_SUB(NOW(), INTERVAL 2 DAY)
WHERE @professor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM solicitacoes
  WHERE servidor_id = @professor_id AND motivo = 'Consulta médica (demo)'
);

INSERT INTO solicitacoes (
  servidor_id, tipo, data, motivo, horario_compensacao, observacoes, horas, anexos,
  status, gestor_usuario_id, decisao_observacao, decidida_em, criada_em
)
SELECT @professor_id, 'Compensação', DATE_ADD(CURDATE(), INTERVAL 2 DAY),
       'Reposição de aula', '14:00 - 15:30', 'Atividade de reposição para demonstração.',
       '1h30m', JSON_ARRAY('plano-reposicao-demo.pdf'), 'Pendente', NULL, NULL, NULL,
       DATE_SUB(NOW(), INTERVAL 1 DAY)
WHERE @professor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM solicitacoes
  WHERE servidor_id = @professor_id AND motivo = 'Reposição de aula'
);

INSERT INTO solicitacoes (
  servidor_id, tipo, data, motivo, horario_compensacao, observacoes, horas, anexos,
  status, gestor_usuario_id, decisao_observacao, decidida_em, criada_em
)
SELECT @professor_id, 'Justificativa', @d4, 'Consulta odontológica (demo)', NULL,
       'Solicitação fictícia aprovada.', NULL, JSON_ARRAY(), 'Aprovado', @gestor_id,
       'Aprovada para demonstração.', DATE_SUB(NOW(), INTERVAL 3 DAY),
       DATE_SUB(NOW(), INTERVAL 4 DAY)
WHERE @professor_id IS NOT NULL AND @gestor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM solicitacoes
  WHERE servidor_id = @professor_id AND motivo = 'Consulta odontológica (demo)'
);

INSERT INTO solicitacoes (
  servidor_id, tipo, data, motivo, horario_compensacao, observacoes, horas, anexos,
  status, gestor_usuario_id, decisao_observacao, decidida_em, criada_em
)
SELECT @professor_id, 'Justificativa', @d5, 'Ajuste de registro (demo)', NULL,
       'Solicitação fictícia reprovada.', NULL, JSON_ARRAY(), 'Reprovado', @gestor_id,
       'Exemplo de decisão para demonstração.', DATE_SUB(NOW(), INTERVAL 6 DAY),
       DATE_SUB(NOW(), INTERVAL 7 DAY)
WHERE @professor_id IS NOT NULL AND @gestor_id IS NOT NULL AND NOT EXISTS (
  SELECT 1 FROM solicitacoes
  WHERE servidor_id = @professor_id AND motivo = 'Ajuste de registro (demo)'
);

INSERT INTO regras_ponto (tipo, nome, valor, unidade, editavel)
SELECT 'tempo', 'Tolerância de atraso', '10', 'minutos', TRUE
WHERE NOT EXISTS (SELECT 1 FROM regras_ponto WHERE nome = 'Tolerância de atraso');

INSERT INTO regras_ponto (tipo, nome, valor, unidade, editavel)
SELECT 'carga', 'Carga horária diária', '8', 'horas', TRUE
WHERE NOT EXISTS (SELECT 1 FROM regras_ponto WHERE nome = 'Carga horária diária');

INSERT INTO regras_ponto (tipo, nome, valor, unidade, editavel)
SELECT 'limite', 'Marcações máximas por dia', '4', 'registros', FALSE
WHERE NOT EXISTS (SELECT 1 FROM regras_ponto WHERE nome = 'Marcações máximas por dia');

INSERT INTO regras_ponto (tipo, nome, valor, unidade, editavel)
SELECT 'prazo', 'Prazo para justificativa', '5', 'dias', TRUE
WHERE NOT EXISTS (SELECT 1 FROM regras_ponto WHERE nome = 'Prazo para justificativa');

INSERT INTO regras_ponto (tipo, nome, valor, unidade, editavel)
SELECT 'booleano', 'Correção de ponto permitida', 'Sim', '', TRUE
WHERE NOT EXISTS (SELECT 1 FROM regras_ponto WHERE nome = 'Correção de ponto permitida');
