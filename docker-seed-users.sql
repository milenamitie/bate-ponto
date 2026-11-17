SET NAMES utf8mb4;
USE bateponto;

CREATE TABLE IF NOT EXISTS solicitacoes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  servidor_id INT UNSIGNED NOT NULL,
  tipo ENUM('Justificativa', 'Compensação') NOT NULL,
  data DATE NOT NULL,
  motivo VARCHAR(255) NOT NULL,
  horario_compensacao VARCHAR(100) DEFAULT NULL,
  observacoes TEXT,
  horas VARCHAR(20) DEFAULT NULL,
  anexos JSON DEFAULT NULL,
  status ENUM('Pendente', 'Aprovado', 'Reprovado') NOT NULL DEFAULT 'Pendente',
  gestor_usuario_id INT UNSIGNED DEFAULT NULL,
  decisao_observacao TEXT,
  decidida_em DATETIME DEFAULT NULL,
  criada_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY fk_solicitacoes_gestor (gestor_usuario_id),
  KEY idx_solicitacoes_status_data (status, criada_em),
  KEY idx_solicitacoes_servidor_data (servidor_id, criada_em),
  CONSTRAINT solicitacoes_gestor_usuario
    FOREIGN KEY (gestor_usuario_id) REFERENCES usuarios (id),
  CONSTRAINT solicitacoes_servidor
    FOREIGN KEY (servidor_id) REFERENCES servidores (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELETE FROM usuarios;

DELETE FROM servidores;

INSERT INTO servidores (id, nome_completo, cpf, matricula, cargo, materia, regime, data_admissao, email_institucional, status) VALUES
(1, 'João da Silva', '12345678910', 'TESTE001', 'Professor', 'Matemática Discreta', '40h', '2026-09-11', 'joao.teste@instituicao.sp.gov.br', 'Ativo');

INSERT INTO usuarios (id, email, senha, cargo, servidor_id) VALUES
(1, 'rh@instituicao.sp.gov.br', '987654', 'RH', NULL),
(2, 'joao.teste@instituicao.sp.gov.br', '123456', 'Professor', 1),
(3, 'gestor@instituicao.sp.gov.br', '123456', 'Gestor', NULL);
