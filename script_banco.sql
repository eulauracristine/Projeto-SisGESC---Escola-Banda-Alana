-- ---- MÓDULO PESSOA ----
CREATE TABLE tb_Pessoa (
    pk_cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_Nasc DATE NOT NULL
);

CREATE TABLE tb_Telefone (
    fk_cpf CHAR(11),
    pk_numero VARCHAR(15) NOT NULL,
    pk_DDD CHAR(2) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    PRIMARY KEY (pk_numero, pk_DDD, tipo),
    FOREIGN KEY (fk_cpf) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Endereco (
    pk_cpf CHAR(11),
    pk_CEP CHAR(8),
    numero INT NOT NULL,
    complemento VARCHAR(100),
    PRIMARY KEY (pk_cpf, pk_CEP),
    FOREIGN KEY (pk_cpf) REFERENCES tb_Pessoa(pk_cpf)
);

-- ---- ALUNO / RESPONSÁVEL ----
CREATE TABLE tb_Aluno (
    pk_cpf CHAR(11) PRIMARY KEY,
    nome_Escola VARCHAR(100) NOT NULL,
    periodo_Escola VARCHAR(20) NOT NULL,
    FOREIGN KEY (pk_cpf) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Responsavel (
    pk_cpf CHAR(11) PRIMARY KEY,
    grau_parentesco VARCHAR(20) NOT NULL,
    FOREIGN KEY (pk_cpf) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Aluno_Responsavel (
    fk_cpf_aluno CHAR(11),
    fk_cpf_responsavel CHAR(11),
    PRIMARY KEY (fk_cpf_aluno, fk_cpf_responsavel),
    FOREIGN KEY (fk_cpf_aluno) REFERENCES tb_Aluno(pk_cpf),
    FOREIGN KEY (fk_cpf_responsavel) REFERENCES tb_Responsavel(pk_cpf)
);

-- ---- FUNCIONÁRIOS ----
CREATE TABLE tb_Funcionario (
    pk_cpf_func CHAR(11) PRIMARY KEY,
    FOREIGN KEY (pk_cpf_func) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Tipo_monitor (
    pk_cod_tipo INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50)
);

CREATE TABLE tb_Cargo (
    pk_cod_Cargo INT AUTO_INCREMENT PRIMARY KEY,
    cargo VARCHAR(20) NOT NULL
);

CREATE TABLE tb_Funcionario_cargo (
    fk_cpf_funcionario CHAR(11),
    fk_cod_cargo INT,
    PRIMARY KEY (fk_cpf_funcionario, fk_cod_cargo),
    FOREIGN KEY (fk_cpf_funcionario) REFERENCES tb_Funcionario(pk_cpf_func),
    FOREIGN KEY (fk_cod_cargo) REFERENCES tb_Cargo(pk_cod_Cargo)
);

-- ---- CURSO / TURMA ----
CREATE TABLE tb_Curso (
    pk_cod_Curso INT AUTO_INCREMENT PRIMARY KEY,
    nome_Curso VARCHAR(50),
    descricao VARCHAR(200) NOT NULL,
    duracao VARCHAR(20) NOT NULL
);

CREATE TABLE tb_Turma (
    pk_nome_Turma VARCHAR(20),
    pk_horario VARCHAR(20),
    fk_cod_Curso INT,
    idade_min INT NOT NULL,
    idade_max INT NOT NULL,
    qtd_alunos INT NOT NULL,
    horario_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    PRIMARY KEY (pk_nome_Turma, pk_horario),
    FOREIGN KEY (fk_cod_Curso) REFERENCES tb_Curso(pk_cod_Curso)
);

CREATE TABLE tb_Matricula (
    id_Matricula INT AUTO_INCREMENT,
    pk_cpf CHAR(11),
    data_Matricula DATE NOT NULL,
    fk_nome_Turma VARCHAR(20),
    fk_horario VARCHAR(20),
    periodo VARCHAR(10) NOT NULL,
    status VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_Matricula, pk_cpf),
    FOREIGN KEY (pk_cpf) REFERENCES tb_Aluno(pk_cpf),
    FOREIGN KEY (fk_nome_Turma, fk_horario) REFERENCES tb_Turma(pk_nome_Turma, pk_horario)
);

CREATE TABLE tb_Turma_funcionario (
    fk_nome_turma VARCHAR(20),
    fk_cpf_funcionario CHAR(11),
    fk_cod_tipo INT,
    PRIMARY KEY (fk_nome_turma, fk_cpf_funcionario),
    FOREIGN KEY (fk_nome_turma) REFERENCES tb_Turma(pk_nome_Turma),
    FOREIGN KEY (fk_cpf_funcionario) REFERENCES tb_Funcionario(pk_cpf_func),
    FOREIGN KEY (fk_cod_tipo) REFERENCES tb_Tipo_monitor(pk_cod_tipo)
);

CREATE TABLE tb_Frequencia (
    id_Frequencia INT AUTO_INCREMENT PRIMARY KEY,
    data_aula DATE NOT NULL,
    presenca BOOLEAN NOT NULL,
    observacao VARCHAR(200),
    id_Matricula INT NOT NULL,
    FOREIGN KEY (id_Matricula) REFERENCES tb_Matricula(id_Matricula)
);

-- ---- BANDA / INSTRUMENTO ----
CREATE TABLE tb_Banda (
    pk_cod_Banda INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(20) NOT NULL
);

CREATE TABLE tb_Instrumento (
    pk_num_Serie VARCHAR(20) PRIMARY KEY,
    nome_Instrumento VARCHAR(50) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    qtd INT DEFAULT 1,
    estado_Inst VARCHAR(30),
    fk_cod_banda INT,
    FOREIGN KEY (fk_cod_banda) REFERENCES tb_Banda(pk_cod_Banda)
);

CREATE TABLE tb_Banda_Pessoa (
    pk_cod_Banda INT,
    pk_cpf_banda CHAR(11),
    funcao_Banda VARCHAR(30) NOT NULL,
    data_Ingresso DATE,
    PRIMARY KEY (pk_cod_Banda, pk_cpf_banda),
    FOREIGN KEY (pk_cod_Banda) REFERENCES tb_Banda(pk_cod_Banda),
    FOREIGN KEY (pk_cpf_banda) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Artista (
    pk_nome_artistico VARCHAR(100) PRIMARY KEY,
    nome_real VARCHAR(100),
    data_nascimento DATE,
    nacionalidade VARCHAR(50)
);

CREATE TABLE tb_Genero (
    pk_cod_genero INT AUTO_INCREMENT PRIMARY KEY,
    nome_genero VARCHAR(50) NOT NULL
);

CREATE TABLE tb_Musica (
    pk_ISRC CHAR(12) PRIMARY KEY,
    nome_Musica VARCHAR(100) NOT NULL,
    tom VARCHAR(30) NOT NULL,
    bpm INT NOT NULL,
    fk_cod_genero INT,
    fk_nome_artista VARCHAR(100),
    FOREIGN KEY (fk_cod_genero) REFERENCES tb_Genero(pk_cod_genero),
    FOREIGN KEY (fk_nome_artista) REFERENCES tb_Artista(pk_nome_artistico)
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
    nome_arquivo VARCHAR(100) NOT NULL,
    caminho_arquivo VARCHAR(255) NOT NULL,
    data_gravacao DATE NOT NULL,
    fk_cod_banda INT,
    fk_ISRC CHAR(12),
    FOREIGN KEY (fk_cod_banda) REFERENCES tb_Banda(pk_cod_Banda),
    FOREIGN KEY (fk_ISRC) REFERENCES tb_Musica(pk_ISRC)
);

-- ---- EVENTOS ----
CREATE TABLE tb_Evento (
    pk_cod_evento INT AUTO_INCREMENT,
    local VARCHAR(100) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_evento DATETIME NOT NULL,
    fk_cod_banda INT,
    PRIMARY KEY (pk_cod_evento, fk_cod_banda),
    FOREIGN KEY (fk_cod_banda) REFERENCES tb_Banda(pk_cod_Banda)
);

CREATE TABLE tb_Pessoa_Evento (
    fk_cpf_evento CHAR(11),
    fk_cod_evento INT,
    PRIMARY KEY (fk_cpf_evento),
    FOREIGN KEY (fk_cpf_evento) REFERENCES tb_Pessoa(pk_cpf),
    FOREIGN KEY (fk_cod_evento) REFERENCES tb_Evento(pk_cod_evento)
);

CREATE TABLE tb_Autorizacao_Evento (
    pk_cpf_aluno CHAR(11),
    pk_cod_evento INT,
    pk_cpf_responsavel CHAR(11),
    data_emissao DATE NOT NULL,
    autorizado BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (pk_cpf_aluno, pk_cod_evento, pk_cpf_responsavel),
    FOREIGN KEY (pk_cpf_aluno) REFERENCES tb_Aluno(pk_cpf),
    FOREIGN KEY (pk_cod_evento) REFERENCES tb_Evento(pk_cod_evento),
    FOREIGN KEY (pk_cpf_responsavel) REFERENCES tb_Responsavel(pk_cpf)
);

CREATE TABLE tb_Autorizacao_imagem (
    pk_id_autorizacao INT AUTO_INCREMENT PRIMARY KEY,
    data_autorizacao DATE NOT NULL,
    autorizacao BOOLEAN NOT NULL,
    observacao VARCHAR(200),
    fk_cpf_aluno CHAR(11),
    fk_cpf_responsavel CHAR(11),
    FOREIGN KEY (fk_cpf_aluno) REFERENCES tb_Aluno(pk_cpf),
    FOREIGN KEY (fk_cpf_responsavel) REFERENCES tb_Responsavel(pk_cpf)
);

-- ---- FINANCEIRO ----
CREATE TABLE tb_Conta_Pagar (
    id_conta_pagar INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    data_vencimento DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    data_pagamento DATE,
    forma_pagamento VARCHAR(30),
    comprovante VARCHAR(255),
    fk_cpf_favorecido CHAR(11),
    data_criacao DATETIME NOT NULL,
    ultima_atualizacao DATETIME NOT NULL,
    FOREIGN KEY (fk_cpf_favorecido) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Conta_Receber (
    id_conta_receber INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    data_vencimento DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    data_recebimento DATE,
    forma_pagamento VARCHAR(30),
    comprovante VARCHAR(255),
    fk_cpf_pagador CHAR(11),
    data_criacao DATETIME NOT NULL,
    ultima_atualizacao DATETIME NOT NULL,
    FOREIGN KEY (fk_cpf_pagador) REFERENCES tb_Pessoa(pk_cpf)
);

-- ---- EMPRÉSTIMO ----
CREATE TABLE tb_Emprestimo (
    codigo_Emprestimo INT PRIMARY KEY,
    data_Retirada DATE NOT NULL,
    data_Devolucao DATE NOT NULL,
    data_Devolvida DATE,
    status ENUM('Em andamento', 'Devolvido', 'Atrasado'),
    descricao VARCHAR(255),
    cpf_Responsavel CHAR(11) NOT NULL,
    cpf_Autorizador CHAR(11) NOT NULL,
    assinatura_Responsavel VARCHAR(255),
    assinatura_Autorizador VARCHAR(255),
    FOREIGN KEY (cpf_Responsavel) REFERENCES tb_Pessoa(pk_cpf),
    FOREIGN KEY (cpf_Autorizador) REFERENCES tb_Pessoa(pk_cpf)
);

CREATE TABLE tb_Item_Emprestimo (
    id_Item INT PRIMARY KEY,
    id_Emprestimo INT NOT NULL,
    id_Instrumento VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_Emprestimo) REFERENCES tb_Emprestimo(codigo_Emprestimo),
    FOREIGN KEY (id_Instrumento) REFERENCES tb_Instrumento(pk_num_Serie)
);

-- ---- AVALIAÇÃO ----
CREATE TABLE tb_Avaliacao (
    fk_id_matricula INT,
    data_avaliacao DATE,
    fk_cpf_funcionario CHAR(11),
    descricao VARCHAR(500) NOT NULL,
    tipo VARCHAR(50),
    PRIMARY KEY (fk_id_matricula, data_avaliacao, fk_cpf_funcionario),
    FOREIGN KEY (fk_id_matricula) REFERENCES tb_Matricula(id_Matricula),
    FOREIGN KEY (fk_cpf_funcionario) REFERENCES tb_Funcionario(pk_cpf_func)
);

-- ---- MANUTENÇÃO ----
CREATE TABLE tb_Manutencao_Instrumento (
    fk_num_serie VARCHAR(20),
    data_manutencao DATE,
    descricao VARCHAR(255),
    custo DECIMAL(10,2),
    fk_conta_pagar INT,
    PRIMARY KEY (fk_num_serie, data_manutencao),
    FOREIGN KEY (fk_num_serie) REFERENCES tb_Instrumento(pk_num_Serie),
    FOREIGN KEY (fk_conta_pagar) REFERENCES tb_Conta_Pagar(id_conta_pagar)
);