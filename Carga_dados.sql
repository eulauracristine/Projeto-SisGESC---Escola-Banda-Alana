-- ============================================================================
-- 1. MÓDULO PESSOA (Base para todos os perfis)
-- ============================================================================
INSERT INTO tb_Pessoa VALUES ('11122233344', 'Ana', 'Carolina', '2012-05-20'); -- Aluna
INSERT INTO tb_Pessoa VALUES ('22233344455', 'Roberto', 'Carlos', '1980-01-15'); -- Responsável
INSERT INTO tb_Pessoa VALUES ('33344455566', 'Julia', 'Mendes', '1995-10-30'); -- Funcionária
INSERT INTO tb_Pessoa VALUES ('44455566677', 'Marcos', 'Oliveira', '2011-03-12'); -- Aluno
INSERT INTO tb_Pessoa VALUES ('55566677788', 'Sandra', 'Souza', '1982-07-22'); -- Responsável

-- Telefones
INSERT INTO tb_Telefone VALUES ('11122233344', '988881111', '11', 'Celular');
INSERT INTO tb_Telefone VALUES ('33344455566', '33445566', '11', 'Comercial');

-- Endereços
INSERT INTO tb_Endereco VALUES ('11122233344', '01001000', 500, 'Apto 12');
INSERT INTO tb_Endereco VALUES ('33344455566', '04545000', 10, 'Sala 02');

-- ============================================================================
-- 2. ALUNO / RESPONSÁVEL
-- ============================================================================
INSERT INTO tb_Aluno VALUES ('11122233344', 'Escola Estadual Alana', 'Manhã');
INSERT INTO tb_Aluno VALUES ('44455566677', 'Escola Estadual Alana', 'Tarde');

INSERT INTO tb_Responsavel VALUES ('22233344455');
INSERT INTO tb_Responsavel VALUES ('55566677788');

INSERT INTO tb_Aluno_Responsavel VALUES ('11122233344', '22233344455', 'Pai', TRUE);
INSERT INTO tb_Aluno_Responsavel VALUES ('44455566677', '55566677788', 'Mãe', TRUE);

-- ============================================================================
-- 3. FUNCIONÁRIOS, TIPOS E CARGOS
-- ============================================================================
INSERT INTO tb_Funcionario VALUES ('33344455566');

INSERT INTO tb_Tipo_monitor (tipo_monitor, descricao_tipo_monitor) 
VALUES ('Multiplicador', 'Responsável pelo ensino técnico e coordenação de ensaios.');

INSERT INTO tb_Cargo (cargo) VALUES ('Coordenador');

INSERT INTO tb_Funcionario_cargo VALUES ('33344455566', 1, '2024-01-01', NULL);

-- ============================================================================
-- 4. CURSOS, TURMAS E MATRÍCULAS
-- ============================================================================
INSERT INTO tb_Curso (nome_curso, descricao_curso, idade_min, idade_max) 
VALUES ('Violão Popular', 'Iniciação ao violão com foco em ritmos brasileiros.', 10, 18);

INSERT INTO tb_Turma VALUES ('VIO-2026-T1', 1, 15, '14:00:00', '16:00:00');

-- Matrículas
INSERT INTO tb_Matricula (pk_cpf, fk_nome_Turma, fk_cod_Curso, data_matricula, periodo, status_matricula)
VALUES ('11122233344', 'VIO-2026-T1', 1, '2026-01-10', 'Manhã', 'Ativo');

INSERT INTO tb_Matricula (pk_cpf, ano, semestre, fk_nome_Turma, fk_cod_Curso, data_matricula, periodo, status_matricula)
VALUES ('44455566677', 2026, 1, 'VIO-2026-T1', 1, '2026-01-12', 'Tarde', 'Ativo');

-- Vínculo Turma-Professor
INSERT INTO tb_Turma_funcionario VALUES ('VIO-2026-T1', 1, '33344455566', 1);

-- Frequência
INSERT INTO tb_Frequencia (data_aula, id_Matricula, presenca, observacao_frequencia) 
VALUES ('2026-05-08', 1, TRUE, 'Aluno demonstrou grande evolução');

-- ============================================================================
-- 5. BANDA, INSTRUMENTOS E MÚSICA
-- ============================================================================
INSERT INTO tb_Banda (nome_banda) VALUES ('banda alana');

INSERT INTO tb_Instrumento (pk_num_serie, nome_instrumento, tipo_instrumento, qtd_instrumento, estado_Inst, fk_cod_banda)
VALUES ('VIO-9988', 'Violão Giannini', 'Cordas', 1, 'Novo', 1);

INSERT INTO tb_Banda_Pessoa VALUES (1, '44455566677', 'Violonista', '2026-02-01', NULL, 'Ativo');

-- Música
INSERT INTO tb_Genero (nome_genero) VALUES ('Samba');
INSERT INTO tb_Artista (pk_nome_artistico, nome_real) VALUES ('Cartola', 'Angenor de Oliveira');
INSERT INTO tb_Musica VALUES ('BRXYZ1234567', 'Preciso Me Encontrar', 'D Maior', 95, 1);
INSERT INTO tb_Musica_Artista VALUES ('BRXYZ1234567', 1, 'Principal');
INSERT INTO tb_Banda_Musica VALUES (1, 'BRXYZ1234567', 1);

-- Gravação
INSERT INTO tb_Gravacao (nome_arquivo, caminho_arquivo, data_gravacao, fk_cod_banda, fk_ISRC)
VALUES ('ensaio_samba_v1.mp3', '/arquivos/gravacoes/', '2026-05-09', 1, 'BRXYZ1234567');

-- ============================================================================
-- 6. FINANCEIRO (Respeitando NOT NULL, UNIQUE data_criacao e CHECKs)
-- ============================================================================

-- Conta a Pagar (Empresa Externa)
INSERT INTO tb_Conta_Pagar (
    descricao_conta_pagar, tipo_gasto, data_vencimento, valor, status_pagamento, 
    data_pagamento, forma_pagamento, comprovante_pagamento, cnpj_favorecido, 
    nome_favorecido_externo, data_criacao, ultima_atualizacao
) VALUES (
    'Conta de Energia - Sede Central', 'Conta de Luz', '2026-05-15', 550.00, 'Pendente', 
    NULL, 'Boleto', 0x44554D4D59, '12345678000100', 
    'Enel Distribuição', '2026-05-09 19:20:01', NOW()
);


-- Conta a Receber (Responsável Aluno - Pago)
INSERT INTO tb_Conta_Receber (
    descricao_conta_receber, data_vencimento, valor, status_recebimento, 
    data_recebimento, forma_pagamento, comprovante_recebimento, fk_cpf_pagador, 
    data_criacao, ultima_atualizacao
) VALUES (
    'Mensalidade Maio - Ana Carolina', '2026-05-10', 100.00, 'Pago', 
    '2026-05-08', 'PIX', 0x44554D4D59, '22233344455', 
    '2026-05-09 19:20:02', NOW()
);

-- ============================================================================
-- 7. EVENTOS, EMPRÉSTIMOS E AVALIAÇÕES
-- ============================================================================
INSERT INTO tb_Evento (local_evento, nome_evento, data_evento, fk_cod_banda)
VALUES ('Teatro Alana', 'Recital de Cordas', '2026-06-15 20:00:00', 1);

INSERT INTO tb_Autorizacao_imagem (data_autorizacao, autorizacao_imagem, observacao_imagem, fk_cpf_aluno, fk_cpf_responsavel)
VALUES ('2026-01-15', TRUE, 'Uso em redes sociais', '11122233344', '22233344455');

-- Empréstimo de Instrumento
INSERT INTO tb_Emprestimo VALUES (2026001, '2026-02-01', '2026-11-30', NULL, 'Em andamento', 'Uso doméstico para estudos', '22233344455', '33344455566', 'Ass: Roberto', 'Ass: Julia');
INSERT INTO tb_Item_Emprestimo VALUES (1, 2026001, 'VIO-9988', 'Integridade');

-- Avaliação
INSERT INTO tb_Avaliacao VALUES (1, '2026-05-03', '33344455566', 'Excelente postura e afinação.', 'Avaliação Técnica Mensal');

-- Manutenção (Vinculada à conta pagar anterior)
INSERT INTO tb_Manutencao_Instrumento VALUES ('VIO-9988', '2026-04-05', 'Troca de cordas e regulagem de cavalete', 150.00, NULL);