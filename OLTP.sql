/*Projeto SisGESC - Script atualizado: 09/05/2026 - 232h04*/

-- SCRIPT OLTP --
-- Criação do banco de dados --
CREATE DATABASE bd_alana;
USE bd_alana;

-- ---- MÓDULO PESSOA ---- --
CREATE TABLE tb_Pessoa (
    pk_cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    data_nasc DATE NOT NULL
);

CREATE TABLE tb_Telefone (
    fk_cpf CHAR(11),
    pk_numero VARCHAR(15) NOT NULL,
    pk_DDD CHAR(2) NOT NULL,
    tipo_telefone ENUM('Celular', 'Residencial', 'Comercial') NOT NULL,
    PRIMARY KEY (fk_cpf, pk_numero, pk_DDD, tipo_telefone),
    FOREIGN KEY (fk_cpf) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Endereco (
    pk_cpf CHAR(11),
    pk_CEP CHAR(8),
    numero_endereco INT NOT NULL,
    complemento VARCHAR(100),
    PRIMARY KEY (pk_cpf, pk_CEP),
    FOREIGN KEY (pk_cpf) REFERENCES tb_Pessoa(pk_cpf)
);

-- ---- ALUNO / RESPONSÁVEL ---- --

CREATE TABLE tb_Aluno (
    pk_cpf CHAR(11) PRIMARY KEY,
    nome_escola VARCHAR(100) NOT NULL,
    periodo_escola VARCHAR(20) NOT NULL,
    FOREIGN KEY (pk_cpf) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Responsavel (
    pk_cpf CHAR(11) PRIMARY KEY,
    FOREIGN KEY (pk_cpf) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Aluno_Responsavel (
    fk_cpf_aluno CHAR(11),
    fk_cpf_responsavel CHAR(11),
    grau_parentesco VARCHAR(30) NOT NULL,
    autorizado_busca BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (fk_cpf_aluno, fk_cpf_responsavel),
    FOREIGN KEY (fk_cpf_aluno) REFERENCES tb_Aluno(pk_cpf),
    FOREIGN KEY (fk_cpf_responsavel) REFERENCES tb_Responsavel(pk_cpf)
);

-- ---- FUNCIONÁRIOS ---- --

CREATE TABLE tb_Funcionario (
    pk_cpf_func CHAR(11) PRIMARY KEY,
    FOREIGN KEY (pk_cpf_func) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Tipo_monitor (
    pk_cod_tipo INT AUTO_INCREMENT PRIMARY KEY,
    tipo_monitor ENUM('Monitor', 'Auxiliar', 'Multiplicador') NOT NULL UNIQUE,
    descricao_tipo_monitor TEXT
);

CREATE TABLE tb_Cargo (
    pk_cod_cargo INT AUTO_INCREMENT PRIMARY KEY,
    cargo ENUM('Coordenador', 'Produtor', 'Mídia') NOT NULL UNIQUE
);

CREATE TABLE tb_Funcionario_cargo (
    fk_cpf_funcionario CHAR(11),
    fk_cod_cargo INT,
    data_entrada DATE NOT NULL,
    data_saida DATE,
    PRIMARY KEY (fk_cpf_funcionario, fk_cod_cargo, data_entrada),
    FOREIGN KEY (fk_cpf_funcionario) REFERENCES tb_Funcionario(pk_cpf_func),
    FOREIGN KEY (fk_cod_cargo) REFERENCES tb_Cargo(pk_cod_cargo)
);

-- ---- CURSO / TURMA ---- --

CREATE TABLE tb_Curso (
    pk_cod_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(50) NOT NULL UNIQUE,
    descricao_curso TEXT NOT NULL,
    idade_min INT NOT NULL,
    idade_max INT NOT NULL
);

CREATE TABLE tb_Turma (
    pk_nome_turma VARCHAR(20),
    fk_cod_Curso INT,
    qtd_alunos INT NOT NULL,
    horario_inicio TIME NOT NULL,
    horario_fim TIME NOT NULL,
    PRIMARY KEY (pk_nome_turma, fk_cod_Curso),
    FOREIGN KEY (fk_cod_Curso) REFERENCES tb_Curso(pk_cod_curso)
);

CREATE TABLE tb_Matricula (
    id_matricula INT AUTO_INCREMENT UNIQUE,
    pk_cpf CHAR(11),
    ano INT,
    semestre INT,
    fk_nome_Turma VARCHAR(20),
    fk_cod_Curso INT,
    data_matricula DATE NOT NULL,
    periodo ENUM('Manhã', 'Tarde') NOT NULL,
    status_matricula ENUM('Ativo', 'Inativo'),
    PRIMARY KEY (pk_cpf, ano, semestre, fk_nome_Turma, fk_cod_Curso),
    FOREIGN KEY (pk_cpf) REFERENCES tb_Aluno(pk_cpf) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (fk_nome_Turma, fk_cod_Curso) REFERENCES tb_Turma(pk_nome_turma, fk_cod_Curso) ON DELETE RESTRICT
);

CREATE TABLE tb_Turma_funcionario (
    fk_nome_turma VARCHAR(20),
    fk_cod_curso INT,
    fk_cpf_funcionario CHAR(11),
    fk_cod_tipo INT,
    PRIMARY KEY (fk_nome_turma, fk_cod_curso, fk_cpf_funcionario), 
    FOREIGN KEY (fk_nome_turma, fk_cod_curso) REFERENCES tb_Turma(pk_nome_turma, fk_cod_Curso),
    FOREIGN KEY (fk_cpf_funcionario) REFERENCES tb_Funcionario(pk_cpf_func),
    FOREIGN KEY (fk_cod_tipo) REFERENCES tb_Tipo_monitor(pk_cod_tipo)
);

CREATE TABLE tb_Frequencia (
    id_frequencia INT AUTO_INCREMENT UNIQUE,
    data_aula DATE NOT NULL,
    id_Matricula INT NOT NULL,
    presenca BOOLEAN NOT NULL,
    observacao_frequencia VARCHAR(200),
    PRIMARY KEY (data_aula, id_Matricula), -- Impede duplicidade de data + aluno
    FOREIGN KEY (id_Matricula) REFERENCES tb_Matricula(id_matricula)
);

-- ---- BANDA / MÚSICA / INSTRUMENTO ---- --

CREATE TABLE tb_Banda (
    pk_cod_Banda INT AUTO_INCREMENT PRIMARY KEY,
    nome_banda VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE tb_Instrumento (
    pk_num_serie VARCHAR(20) PRIMARY KEY,
    nome_instrumento VARCHAR(50) NOT NULL,
    tipo_instrumento VARCHAR(30) NOT NULL,
    qtd_instrumento INT DEFAULT 1,
    estado_Inst VARCHAR(30),
    fk_cod_banda INT,
    FOREIGN KEY (fk_cod_banda) REFERENCES tb_Banda(pk_cod_Banda)
);

CREATE TABLE tb_Banda_Pessoa (
    pk_cod_Banda INT,
    pk_cpf_banda CHAR(11),
    funcao_Banda VARCHAR(30) NOT NULL,
    data_ingresso DATE,
    data_saida DATE,
    status_Banda ENUM('Ativo', 'Saiu') NOT NULL,
    PRIMARY KEY (pk_cod_Banda, pk_cpf_banda),
    FOREIGN KEY (pk_cod_Banda) REFERENCES tb_Banda(pk_cod_Banda),
    FOREIGN KEY (pk_cpf_banda) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Artista (
    pk_cod_artista INT AUTO_INCREMENT PRIMARY KEY,
    pk_nome_artistico VARCHAR(100) NOT NULL UNIQUE,
    nome_real VARCHAR(100),
    data_nascimento DATE
);

CREATE TABLE tb_Genero (
    pk_cod_genero INT AUTO_INCREMENT PRIMARY KEY,
    nome_genero VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE tb_Musica (
    pk_ISRC CHAR(12) PRIMARY KEY,
    nome_musica VARCHAR(100) NOT NULL,
    tom VARCHAR(30) NOT NULL,
    bpm INT NOT NULL,
    fk_cod_genero INT,
    FOREIGN KEY (fk_cod_genero) REFERENCES tb_Genero(pk_cod_genero)
);

-- solução para mais de um artista em música, uma tabela associativa --
CREATE TABLE tb_Musica_Artista (
    fk_ISRC CHAR(12),
    fk_cod_artista INT,
    tipo_participacao ENUM('Principal', 'Participação', 'Compositor') DEFAULT 'Principal',
    PRIMARY KEY (fk_ISRC, fk_cod_artista), -- Chave composta: impede repetir o mesmo artista na mesma música
    FOREIGN KEY (fk_ISRC) REFERENCES tb_Musica(pk_ISRC),
    FOREIGN KEY (fk_cod_artista) REFERENCES tb_Artista(pk_cod_artista)
);

CREATE TABLE tb_Banda_Musica (
    pk_cod_Banda INT,
    pk_ISRC CHAR(12),
    ordem_Repertorio INT,
    PRIMARY KEY (pk_cod_Banda, pk_ISRC),
    FOREIGN KEY (pk_cod_Banda) REFERENCES tb_Banda(pk_cod_Banda),
    FOREIGN KEY (pk_ISRC) REFERENCES tb_Musica(pk_ISRC)
);

CREATE TABLE tb_Gravacao (
    pk_id_gravacao INT AUTO_INCREMENT PRIMARY KEY,
    nome_arquivo VARCHAR(100) NOT NULL UNIQUE, -- Nome do arquivo deve ser único
    caminho_arquivo TEXT NOT NULL,
    data_gravacao DATE NOT NULL,
    fk_cod_banda INT,
    fk_ISRC CHAR(12),
    UNIQUE (fk_cod_banda, fk_ISRC, data_gravacao), -- Impede duplicar a mesma gravação técnica
    FOREIGN KEY (fk_cod_banda) REFERENCES tb_Banda(pk_cod_Banda),
    FOREIGN KEY (fk_ISRC) REFERENCES tb_Musica(pk_ISRC)
);
-- ---- EVENTOS ---- --

CREATE TABLE tb_Evento (
    pk_cod_evento INT AUTO_INCREMENT PRIMARY KEY,
    local_evento VARCHAR(100) NOT NULL,
    nome_evento VARCHAR(100) NOT NULL,
    data_evento DATETIME NOT NULL,
    fk_cod_banda INT NOT NULL,
    UNIQUE (local_evento, data_evento), -- Impede dois eventos no mesmo lugar/hora
    FOREIGN KEY (fk_cod_banda) REFERENCES tb_Banda(pk_cod_Banda)
);

CREATE TABLE tb_Pessoa_Evento (
    fk_cpf_evento CHAR(11),
    fk_cod_evento INT,
    PRIMARY KEY (fk_cpf_evento, fk_cod_evento),
    FOREIGN KEY (fk_cpf_evento) REFERENCES tb_Pessoa(pk_cpf),
    FOREIGN KEY (fk_cod_evento) REFERENCES tb_Evento(pk_cod_evento)
);

CREATE TABLE tb_Autorizacao_Evento (
    pk_cpf_aluno CHAR(11),
    pk_cod_evento INT,
    pk_cpf_responsavel CHAR(11),
    data_emissao DATE NOT NULL,
    autorizacao_evento BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (pk_cpf_aluno, pk_cod_evento, pk_cpf_responsavel),
    FOREIGN KEY (pk_cpf_aluno) REFERENCES tb_Aluno(pk_cpf),
    FOREIGN KEY (pk_cod_evento) REFERENCES tb_Evento(pk_cod_evento),
    FOREIGN KEY (pk_cpf_responsavel) REFERENCES tb_Responsavel(pk_cpf)
);

CREATE TABLE tb_Autorizacao_imagem (
    pk_id_autorizacao INT AUTO_INCREMENT PRIMARY KEY,
    data_autorizacao DATE NOT NULL,
    autorizacao_imagem BOOLEAN NOT NULL,
    observacao_imagem VARCHAR(200),
    fk_cpf_aluno CHAR(11) NOT NULL,
    fk_cpf_responsavel CHAR(11) NOT NULL,
    UNIQUE (fk_cpf_aluno, fk_cpf_responsavel), -- garante apenas um registro
    FOREIGN KEY (fk_cpf_aluno) REFERENCES tb_Aluno(pk_cpf),
    FOREIGN KEY (fk_cpf_responsavel) REFERENCES tb_Responsavel(pk_cpf)
);

-- ---- FINANCEIRO ---- --

CREATE TABLE tb_Conta_Pagar (
    id_conta_pagar INT AUTO_INCREMENT PRIMARY KEY,
    descricao_conta_pagar VARCHAR(200) NOT NULL,
    tipo_gasto ENUM('Salário', 'Conta de Luz', 'Água', 'Internet', 'Lanche', 'Transporte', 'Aluguel', 'Material', 'Outros') NOT NULL,
    data_vencimento DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status_pagamento ENUM('Pendente', 'Pago', 'Atrasado') NOT NULL,
    data_pagamento DATE,
    forma_pagamento ENUM('Dinheiro', 'PIX', 'Cartão', 'Boleto') NOT NULL,
    comprovante_pagamento LONGBLOB NOT NULL,
    fk_cpf_favorecido CHAR(11), 
    cnpj_favorecido CHAR(14),
    nome_favorecido_externo VARCHAR(100),
    data_criacao DATETIME NOT NULL UNIQUE,
    ultima_atualizacao DATETIME NOT NULL,
    FOREIGN KEY (fk_cpf_favorecido) REFERENCES tb_Pessoa(pk_cpf) ON DELETE RESTRICT,
    UNIQUE (descricao_conta_pagar, data_vencimento, valor, fk_cpf_favorecido, cnpj_favorecido),
    CONSTRAINT check_identificacao_pagar CHECK (fk_cpf_favorecido IS NOT NULL OR cnpj_favorecido IS NOT NULL),
    CONSTRAINT chk_valor_positivo_pagar CHECK (valor > 0) -- verificar valor negativo, não deixa
);

CREATE TABLE tb_Conta_Receber (
    id_conta_receber INT AUTO_INCREMENT PRIMARY KEY,
    descricao_conta_receber VARCHAR(100) NOT NULL,
    data_vencimento DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status_recebimento ENUM('Pendente', 'Pago', 'Atrasado') NOT NULL,
    data_recebimento DATE NOT NULL,
    forma_pagamento ENUM('Dinheiro', 'PIX', 'Cartão', 'Boleto') NOT NULL,
    comprovante_recebimento LONGBLOB NOT NULL,
    fk_cpf_pagador CHAR(11),
    cnpj_pagador CHAR(14),
    nome_pagador_externo VARCHAR(100),
    data_criacao DATETIME NOT NULL UNIQUE,
    ultima_atualizacao DATETIME NOT NULL,
    FOREIGN KEY (fk_cpf_pagador) REFERENCES tb_Pessoa(pk_cpf) ON DELETE RESTRICT,
	UNIQUE (descricao_conta_receber, data_vencimento, valor, fk_cpf_pagador, cnpj_pagador),
    CONSTRAINT chk_valor_positivo_receber CHECK (valor > 0), -- verificar valor negativo, não deixa
    CONSTRAINT check_identificacao_receber CHECK (fk_cpf_pagador IS NOT NULL OR cnpj_pagador IS NOT NULL)
);

-- ---- EMPRÉSTIMO INST. ---- --

CREATE TABLE tb_Emprestimo (
    cod_emprestimo INT PRIMARY KEY,
    data_retirada DATE NOT NULL,
    data_devolucao DATE NOT NULL,
    data_devolvida DATE,
    status ENUM('Em andamento', 'Devolvido', 'Atrasado'),
    descricao_emprestimo VARCHAR(255),
    cpf_responsavel CHAR(11) NOT NULL,
    cpf_autorizador CHAR(11) NOT NULL,
    assinatura_responsavel TEXT,
    assinatura_autorizador VARCHAR(255),
    FOREIGN KEY (cpf_responsavel) REFERENCES tb_Pessoa(pk_cpf),
    FOREIGN KEY (cpf_autorizador) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Item_Emprestimo (
    id_item INT PRIMARY KEY,
    id_emprestimo INT NOT NULL,
    id_instrumento VARCHAR(20) NOT NULL,
    estado_devolucao ENUM('Integridade', 'Quebrado', 'Perdido', 'Roubo'),
    FOREIGN KEY (id_emprestimo) REFERENCES tb_Emprestimo(cod_emprestimo),
    FOREIGN KEY (id_instrumento) REFERENCES tb_Instrumento(pk_num_serie) ON DELETE RESTRICT
);

CREATE TABLE tb_Ocorrencia_Instrumento (
    pk_ocorrencia INT PRIMARY KEY AUTO_INCREMENT,
    fk_num_serie INT,
    tipo_ocorrencia ENUM('Roubo','Perda','Quebra','Dano','Furto'),
    data_ocorrencia DATE,
    descricao_ocr TEXT,
    recuperado BOOLEAN
);

-- ---- AVALIAÇÃO ---- --

CREATE TABLE tb_Avaliacao (
    fk_id_matricula INT,
    data_avaliacao DATE,
    fk_cpf_funcionario CHAR(11),
    descricao_avaliacao TEXT NOT NULL,
    tipo_avaliacao VARCHAR(50),
    PRIMARY KEY (fk_id_matricula, data_avaliacao, fk_cpf_funcionario),
    FOREIGN KEY (fk_id_matricula) REFERENCES tb_Matricula(id_matricula),
    FOREIGN KEY (fk_cpf_funcionario) REFERENCES tb_Funcionario(pk_cpf_func)
);

-- ---- MANUTENÇÃO INSTRUMENTOS ---- --

CREATE TABLE tb_Manutencao_Instrumento (
    fk_num_serie VARCHAR(20),
    data_manutencao DATE,
    descricao_manutencao TEXT,
    custo_instrumento DECIMAL(10,2),
    fk_conta_pagar INT,
    PRIMARY KEY (fk_num_serie, data_manutencao),
    FOREIGN KEY (fk_num_serie) REFERENCES tb_Instrumento(pk_num_serie),
    FOREIGN KEY (fk_conta_pagar) REFERENCES tb_Conta_Pagar(id_conta_pagar)
);

-- CRIAÇÃO DE VIEWS --
CREATE VIEW vw_operacional_corpo_docente AS
SELECT 
    p.nome AS funcionario,
    cg.cargo,
    tm.tipo_monitor,
    t.pk_nome_turma AS turma,
    c.nome_curso,
    t.horario_inicio,
    t.horario_fim
FROM tb_Funcionario f
JOIN tb_Pessoa p ON f.pk_cpf_func = p.pk_cpf
JOIN tb_Funcionario_cargo fc ON f.pk_cpf_func = fc.fk_cpf_funcionario
JOIN tb_Cargo cg ON fc.fk_cod_cargo = cg.pk_cod_cargo
JOIN tb_Turma_funcionario tf ON f.pk_cpf_func = tf.fk_cpf_funcionario
JOIN tb_Tipo_monitor tm ON tf.fk_cod_tipo = tm.pk_cod_tipo
JOIN tb_Turma t ON tf.fk_nome_turma = t.pk_nome_turma AND tf.fk_cod_curso = t.fk_cod_curso
JOIN tb_Curso c ON t.fk_cod_Curso = c.pk_cod_curso
WHERE fc.data_saida IS NULL; -- Apenas cargos atuais

-- Agenda do corpo docente
SELECT funcionario, cargo, tipo_monitor, turma, horario_inicio 
FROM vw_operacional_corpo_docente;

-- Filtro: Ver apenas quem ocupa o cargo de 'Coordenador'
SELECT funcionario, turma 
FROM vw_operacional_corpo_docente 
WHERE cargo = 'Coordenador';

CREATE VIEW vw_patrimonio_instrumentos_status AS
SELECT 
    i.pk_num_serie,
    i.nome_instrumento,
    i.tipo_instrumento,
    b.nome_banda,
    i.estado_Inst AS estado_atual,
    ocr.tipo_ocorrencia,
    ocr.descricao_ocr AS ultima_ocorrencia,
    ocr.data_ocorrencia
FROM tb_Instrumento i
LEFT JOIN tb_Banda b ON i.fk_cod_banda = b.pk_cod_Banda
LEFT JOIN tb_Ocorrencia_Instrumento ocr ON i.pk_num_serie = ocr.fk_num_serie
ORDER BY ocr.data_ocorrencia DESC;

-- Relatório de estado dos instrumentos e bandas
SELECT nome_instrumento, nome_banda, estado_atual, ultima_ocorrencia 
FROM vw_patrimonio_instrumentos_status;

-- Filtro: Buscar instrumentos que tiveram 'Quebra' ou 'Dano'
SELECT pk_num_serie, nome_instrumento, ultima_ocorrencia 
FROM vw_patrimonio_instrumentos_status 
WHERE tipo_ocorrencia IN ('Quebra', 'Dano');

CREATE VIEW vw_eventos_autorizacoes_check AS
SELECT 
    e.nome_evento,
    e.data_evento,
    e.local_evento,
    p.nome AS aluno,
    ae.autorizacao_evento AS autorizado_pelo_responsavel,
    ai.autorizacao_imagem AS autorizou_uso_imagem
FROM tb_Evento e
JOIN tb_Pessoa_Evento pe ON e.pk_cod_evento = pe.fk_cod_evento
JOIN tb_Pessoa p ON pe.fk_cpf_evento = p.pk_cpf
LEFT JOIN tb_Autorizacao_Evento ae ON e.pk_cod_evento = ae.pk_cod_evento AND p.pk_cpf = ae.pk_cpf_aluno
LEFT JOIN tb_Autorizacao_imagem ai ON p.pk_cpf = ai.fk_cpf_aluno;


-- Check-list para o próximo evento
SELECT nome_evento, aluno, autorizado_pelo_responsavel, autorizou_uso_imagem 
FROM vw_eventos_autorizacoes_check;

-- Filtro: Alunos que NÃO possuem autorização de imagem
SELECT aluno, nome_evento 
FROM vw_eventos_autorizacoes_check 
WHERE autorizou_uso_imagem = FALSE;


CREATE VIEW vw_pedagogico_presenca_avaliacao AS
SELECT 
    p.nome AS aluno,
    c.nome_curso,
    COUNT(f.id_frequencia) AS total_aulas,
    SUM(CASE WHEN f.presenca = 1 THEN 1 ELSE 0 END) AS presencas,
    -- Cálculo de porcentagem tratando divisão por zero
    IFNULL((SUM(CASE WHEN f.presenca = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(f.id_frequencia), 0)) * 100, 0) AS pct_presenca,
    av.descricao_avaliacao,
    av.tipo_avaliacao
FROM tb_Matricula m
JOIN tb_Pessoa p ON m.pk_cpf = p.pk_cpf
JOIN tb_Curso c ON m.fk_cod_Curso = c.pk_cod_curso
LEFT JOIN tb_Frequencia f ON m.id_matricula = f.id_Matricula
LEFT JOIN tb_Avaliacao av ON m.id_matricula = av.fk_id_matricula
GROUP BY m.id_matricula, av.data_avaliacao, av.fk_cpf_funcionario;

-- Ranking de presença por aluno
SELECT aluno, total_aulas, presencas, pct_presenca 
FROM vw_pedagogico_presenca_avaliacao 
ORDER BY pct_presenca DESC;

-- Ver observações técnicas (avaliações)
SELECT aluno, tipo_avaliacao, descricao_avaliacao 
FROM vw_pedagogico_presenca_avaliacao;

-- INDICES --
-- ACADEMICO
-- indices de fks
-- Indice --Matrícula --> Curso
EXPLAIN
SELECT *
FROM tb_Matricula
WHERE fk_cod_curso = 1;

CREATE INDEX idx_matricula_curso
ON tb_Matricula(fk_cod_curso);

-- FK — Funcionário → Tipo Monitor
EXPLAIN
SELECT *
FROM tb_Turma_funcionario
WHERE fk_cod_tipo = 1;

CREATE INDEX idx_fk_turma_funcionario_tipo
ON tb_Turma_funcionario(fk_cod_tipo);


-- indices join 
-- Índice JOIN — Matrícula + turma
EXPLAIN
SELECT t.pk_nome_turma,
       m.status_matricula
FROM tb_Matricula m
JOIN tb_Turma t
ON t.pk_nome_turma = m.fk_nome_turma
AND t.fk_cod_Curso = m.fk_cod_Curso;

CREATE INDEX idx_join_matricula_turma
ON tb_Matricula(fk_nome_turma, fk_cod_curso);


-- Índice JOIN — Frequência + Matrícula
EXPLAIN
SELECT f.data_aula,
       m.id_matricula
FROM tb_Frequencia f
JOIN tb_Matricula m
ON m.id_matricula = f.id_Matricula;

CREATE INDEX idx_join_frequencia_matricula
ON tb_Frequencia(id_Matricula);

-- MODELO RH
-- Índice — Telefone → Pessoa
EXPLAIN
SELECT *
FROM tb_Telefone
WHERE fk_cpf = '11111111111';

CREATE INDEX idx_telefone_pessoa
ON tb_Telefone(fk_cpf);

-- Índice — Aluno Responsável → Responsável 
EXPLAIN
SELECT *
FROM tb_Aluno_Responsavel
WHERE fk_cpf_responsavel = '44444444444';

CREATE INDEX idx_aluno_responsavel
ON tb_Aluno_Responsavel(fk_cpf_responsavel);

-- joins

-- Índice JOIN — Funcionário + Pessoa
EXPLAIN
SELECT p.nome,
       fc.fk_cod_cargo
FROM tb_Funcionario_cargo fc
JOIN tb_Pessoa p
ON p.pk_cpf = fc.fk_cpf_funcionario;

CREATE INDEX idx_join_funcionario_pessoa
ON tb_Funcionario_cargo(fk_cpf_funcionario);

-- Índice JOIN — Funcionário + Cargo
EXPLAIN
SELECT p.nome,
       c.cargo
FROM tb_Funcionario_cargo fc
JOIN tb_Pessoa p
ON p.pk_cpf = fc.fk_cpf_funcionario
JOIN tb_Cargo c
ON c.pk_cod_cargo = fc.fk_cod_cargo;

CREATE INDEX idx_join_funcionario_cargo
ON tb_Funcionario_cargo(fk_cod_cargo);

-- MODULO FINANCEIRO
-- fks
-- Pagar → Favorecido
EXPLAIN
SELECT *
FROM tb_Conta_Pagar
WHERE fk_cpf_favorecido = '66666666666';

CREATE INDEX idx_fk_conta_pagar_favorecido
ON tb_Conta_Pagar(fk_cpf_favorecido);

-- Receber → Pagador
EXPLAIN
SELECT *
FROM tb_Conta_Receber
WHERE fk_cpf_pagador = '11111111111';

CREATE INDEX idx_fk_conta_receber_pagador
ON tb_Conta_Receber(fk_cpf_pagador);

-- joins
-- Conta Pagar + Pessoa
EXPLAIN
SELECT p.nome,
       cp.valor
FROM tb_Conta_Pagar cp
JOIN tb_Pessoa p
ON p.pk_cpf = cp.fk_cpf_favorecido;

CREATE INDEX idx_join_conta_pagar_pessoa
ON tb_Conta_Pagar(fk_cpf_favorecido);

-- Conta Receber + Pessoa
EXPLAIN
SELECT p.nome,
       cr.valor
FROM tb_Conta_Receber cr
JOIN tb_Pessoa p
ON p.pk_cpf = cr.fk_cpf_pagador;

CREATE INDEX idx_join_conta_receber_pessoa
ON tb_Conta_Receber(fk_cpf_pagador);


-- MODULO MANUTENÇÃO
-- fks
-- Manutenção → Conta Pagar
EXPLAIN
SELECT *
FROM tb_Manutencao_Instrumento
WHERE fk_conta_pagar = 1;

CREATE INDEX idx_fk_manutencao_conta
ON tb_Manutencao_Instrumento(fk_conta_pagar);

-- Empréstimo → Empréstimo
EXPLAIN
SELECT *
FROM tb_Item_Emprestimo
WHERE id_emprestimo = 1;

CREATE INDEX idx_fk_item_emprestimo
ON tb_Item_Emprestimo(id_emprestimo);

-- join 
-- Manutenção + Instrumento
EXPLAIN
SELECT i.nome_instrumento,
       mi.custo_instrumento
FROM tb_Manutencao_Instrumento mi
JOIN tb_Instrumento i
ON i.pk_num_serie = mi.fk_num_serie;

CREATE INDEX idx_join_manutencao_instrumento
ON tb_Manutencao_Instrumento(fk_num_serie);

-- Empréstimo + Instrumento
EXPLAIN
SELECT e.cod_emprestimo,
       i.nome_instrumento
FROM tb_Item_Emprestimo ie
JOIN tb_Emprestimo e
ON e.cod_emprestimo = ie.id_emprestimo
JOIN tb_Instrumento i
ON i.pk_num_serie = ie.id_instrumento;

CREATE INDEX idx_join_item_instrumento
ON tb_Item_Emprestimo(id_instrumento);