CREATE DATABASE bd_alana_dw;
USE bd_alana_dw;

-- ---- DIMENSÕES COMPARTILHADAS ---- --
CREATE TABLE dim_tempo (
    sk_tempo INT AUTO_INCREMENT PRIMARY KEY,
    data_completa DATE,
    dia INT,
    mes INT,
    nome_mes VARCHAR(20),
    ano INT,
    semestre INT,
    trimestre INT,
    dia_semana VARCHAR(20)
);

-- ---- ESTRELA FINANCEIRA ---- --
CREATE TABLE dim_forma_pagamento (
    sk_forma_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    forma_pagamento VARCHAR(50)
);

CREATE TABLE dim_pessoa_fin (
    sk_pessoa INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    tipo_pessoa ENUM('Cliente', 'Fornecedor'),
    cpf_cnpj VARCHAR(20)
);

CREATE TABLE fato_financeiro (
    id_fato INT AUTO_INCREMENT PRIMARY KEY,
    fk_tempo INT,
    fk_forma_pagamento INT,
    fk_pessoa INT,
    valor DECIMAL(10,2),
    tipo_movimento ENUM('Pagar','Receber'),
    status_movimento ENUM('Pendente','Pago','Atrasado'),
    FOREIGN KEY (fk_tempo) REFERENCES dim_tempo(sk_tempo),
    FOREIGN KEY (fk_forma_pagamento) REFERENCES dim_forma_pagamento(sk_forma_pagamento),
    FOREIGN KEY (fk_pessoa) REFERENCES dim_pessoa_fin(sk_pessoa)
);

-- ---- ESTRELA RH ---- --
CREATE TABLE dim_Funcionario (
    sk_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    documento VARCHAR(14),
    nome VARCHAR(150),
    data_nasc DATE
);

CREATE TABLE fato_RH (
    id_fato_rh INT AUTO_INCREMENT PRIMARY KEY,
    fk_funcionario INT,
    fk_tempo INT,
    tempo_colab_dias INT,
    salario DECIMAL(10, 2),
    FOREIGN KEY (fk_funcionario) REFERENCES dim_Funcionario(sk_funcionario),
    FOREIGN KEY (fk_tempo) REFERENCES dim_tempo(sk_tempo)
);

-- ---- ESTRELA MATRÍCULA ---- --
CREATE TABLE dim_aluno (
    sk_aluno INT AUTO_INCREMENT PRIMARY KEY,
    cpf CHAR(11),
    nome VARCHAR(150)
);

CREATE TABLE dim_curso (
    sk_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(50)
);

CREATE TABLE fato_matricula (
    id_fato_matricula INT AUTO_INCREMENT PRIMARY KEY,
    fk_aluno INT,
    fk_curso INT,
    fk_tempo INT,
    qtd_matricula INT DEFAULT 1,
    FOREIGN KEY (fk_aluno) REFERENCES dim_aluno(sk_aluno),
    FOREIGN KEY (fk_curso) REFERENCES dim_curso(sk_curso),
    FOREIGN KEY (fk_tempo) REFERENCES dim_tempo(sk_tempo)
);







-- 1. Populando Dimensão Tempo (Exemplo para o ano de 2026)
INSERT INTO bd_alana_dw.dim_tempo (data_completa, dia, mes, nome_mes, ano, semestre, trimestre)
SELECT 
    data_vencimento, DAY(data_vencimento), MONTH(data_vencimento), 
    MONTHNAME(data_vencimento), YEAR(data_vencimento),
    IF(MONTH(data_vencimento) <= 6, 1, 2),
    QUARTER(data_vencimento)
FROM bd_alana.tb_Conta_Pagar
GROUP BY data_vencimento;

-- 2. Carga da Dimensão Pessoa (Financeiro)
INSERT INTO bd_alana_dw.dim_pessoa_fin (nome, tipo_pessoa, cpf_cnpj)
SELECT nome, 'Fornecedor', pk_cpf FROM bd_alana.tb_Pessoa;

-- 3. Carga da Fato Financeira (Exemplo: Contas a Pagar)
INSERT INTO bd_alana_dw.fato_financeiro (fk_tempo, fk_pessoa, valor, tipo_movimento, status_movimento)
SELECT 
    t.sk_tempo,
    p.sk_pessoa,
    cp.valor,
    'Pagar',
    cp.status_pagamento
FROM bd_alana.tb_Conta_Pagar cp
JOIN bd_alana_dw.dim_tempo t ON cp.data_vencimento = t.data_completa
JOIN bd_alana_dw.dim_pessoa_fin p ON cp.fk_cpf_favorecido = p.cpf_cnpj;

-- 4. Carga da Fato Matrícula
INSERT INTO bd_alana_dw.fato_matricula (fk_aluno, fk_curso, fk_tempo, qtd_matricula)
SELECT 
    da.sk_aluno,
    dc.sk_curso,
    dt.sk_tempo,
    1
FROM bd_alana.tb_Matricula m
JOIN bd_alana_dw.dim_aluno da ON m.pk_cpf = da.cpf
JOIN bd_alana_dw.dim_curso dc ON m.fk_cod_Curso = (SELECT pk_cod_curso FROM bd_alana.tb_Curso WHERE nome_curso = dc.nome_curso)
JOIN bd_alana_dw.dim_tempo dt ON m.data_matricula = dt.data_completa;


-- ---- DIMENSÕES DA MANUTENÇÃO ---- --

CREATE TABLE Dim_Instrumento (
    SK_instrumento INT AUTO_INCREMENT PRIMARY KEY,
    num_serie VARCHAR(20),
    nome_instrumento VARCHAR(50),
    tipo VARCHAR(50),
    estado VARCHAR(50)
);

CREATE TABLE Dim_Tipo_Manutencao (
    SK_tipo_manutencao INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(50),
    complexidade VARCHAR(20) DEFAULT 'Normal'
);

CREATE TABLE Dim_Fornecedor (
    SK_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150),
    cnpj VARCHAR(18),
    tipo_pessoa VARCHAR(20)
);

CREATE TABLE Dim_Ocorrencia (
    SK_ocorrencia INT AUTO_INCREMENT PRIMARY KEY,
    tipo_ocorrencia VARCHAR(50),
    recuperado BOOLEAN,
    descricao VARCHAR(255)
);

-- ---- TABELA FATO MANUTENÇÃO ---- --

CREATE TABLE Fato_Manutencao (
    id_fato_manutencao INT AUTO_INCREMENT PRIMARY KEY,
    SK_tempo INT,
    SK_instrumento INT,
    SK_tipo_manutencao INT,
    SK_fornecedor INT,
    SK_ocorrencia INT,
    custo_manutencao DECIMAL(10,2),
    qtd_manutencoes INT DEFAULT 1,
    
    FOREIGN KEY (SK_tempo) REFERENCES dim_tempo(sk_tempo),
    FOREIGN KEY (SK_instrumento) REFERENCES Dim_Instrumento(SK_instrumento),
    FOREIGN KEY (SK_tipo_manutencao) REFERENCES Dim_Tipo_Manutencao(SK_tipo_manutencao),
    FOREIGN KEY (SK_fornecedor) REFERENCES Dim_Fornecedor(SK_fornecedor),
    FOREIGN KEY (SK_ocorrencia) REFERENCES Dim_Ocorrencia(SK_ocorrencia)
);


-- 1. Carga da Dimensão Instrumento
INSERT INTO bd_alana_dw.Dim_Instrumento (num_serie, nome_instrumento, tipo, estado)
SELECT pk_num_serie, nome_instrumento, tipo_instrumento, estado_Inst 
FROM bd_alana.tb_Instrumento;

-- 2. Carga da Dimensão Fornecedor (Extraído das contas a pagar de manutenção)
INSERT INTO bd_alana_dw.Dim_Fornecedor (nome, cnpj, tipo_pessoa)
SELECT DISTINCT 
    IFNULL(nome_favorecido_externo, 'Fornecedor Desconhecido'),
    cnpj_favorecido,
    'Jurídica'
FROM bd_alana.tb_Conta_Pagar
WHERE tipo_gasto = 'Material' OR descricao_conta_pagar LIKE '%Manutenção%';

-- 3. Carga da Dimensão Ocorrência
INSERT INTO bd_alana_dw.Dim_Ocorrencia (tipo_ocorrencia, recuperado, descricao)
SELECT tipo_ocorrencia, recuperado, descricao_ocr 
FROM bd_alana.tb_Ocorrencia_Instrumento;

-- 4. CARGA DA FATO MANUTENÇÃO (O cruzamento final)
INSERT INTO bd_alana_dw.Fato_Manutencao (
    SK_tempo, SK_instrumento, SK_tipo_manutencao, SK_fornecedor, SK_ocorrencia, custo_manutencao
)
SELECT 
    dt.sk_tempo,
    di.SK_instrumento,
    (SELECT SK_tipo_manutencao FROM bd_alana_dw.Dim_Tipo_Manutencao LIMIT 1), -- Simplificação para o exemplo
    df.SK_fornecedor,
    NULL, -- Ocorrência pode ser nula se for manutenção preventiva
    mi.custo_instrumento
FROM bd_alana.tb_Manutencao_Instrumento mi
JOIN bd_alana_dw.dim_tempo dt ON mi.data_manutencao = dt.data_completa
JOIN bd_alana_dw.Dim_Instrumento di ON mi.fk_num_serie = di.num_serie
LEFT JOIN bd_alana.tb_Conta_Pagar cp ON mi.fk_conta_pagar = cp.id_conta_pagar
LEFT JOIN bd_alana_dw.Dim_Fornecedor df ON cp.cnpj_favorecido = df.cnpj;