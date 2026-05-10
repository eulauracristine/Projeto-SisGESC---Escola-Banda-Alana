USE bd_alana_dw;

-- ---- CARGA DIMENSÃO TEMPO ----
-- Extrai todas as datas únicas que existem no financeiro, matrículas e manutenções
INSERT INTO dim_tempo (data_completa, dia, mes, nome_mes, ano, semestre, trimestre, dia_semana)
SELECT 
    dt, DAY(dt), MONTH(dt), MONTHNAME(dt), YEAR(dt),
    IF(MONTH(dt) <= 6, 1, 2), QUARTER(dt), DAYNAME(dt)
FROM (
    SELECT data_vencimento AS dt FROM bd_alana.tb_Conta_Pagar
    UNION SELECT data_matricula FROM bd_alana.tb_Matricula
    UNION SELECT data_manutencao FROM bd_alana.tb_Manutencao_Instrumento
) AS datas_unificadas;

-- ---- CARGA DIMENSÃO PESSOA (FINANCEIRO) ----
INSERT INTO dim_pessoa_fin (nome, tipo_pessoa, cpf_cnpj)
SELECT CONCAT(nome, ' ', sobrenome), 'Cliente', pk_cpf FROM bd_alana.tb_Pessoa;

-- ---- CARGA DIMENSÃO FUNCIONÁRIO (RH) ----
INSERT INTO dim_Funcionario (documento, nome, data_nasc)
SELECT pk_cpf, CONCAT(nome, ' ', sobrenome), data_nasc 
FROM bd_alana.tb_Pessoa 
WHERE pk_cpf IN (SELECT pk_cpf_func FROM bd_alana.tb_Funcionario);

-- ---- CARGA DIMENSÃO ALUNO E CURSO (MATRÍCULA) ----
INSERT INTO dim_aluno (cpf, nome)
SELECT pk_cpf, CONCAT(nome, ' ', sobrenome) FROM bd_alana.tb_Pessoa
WHERE pk_cpf IN (SELECT pk_cpf FROM bd_alana.tb_Aluno);

INSERT INTO dim_curso (nome_curso)
SELECT nome_curso FROM bd_alana.tb_Curso;

-- ---- CARGA DIMENSÕES MANUTENÇÃO ----
INSERT INTO Dim_Instrumento (num_serie, nome_instrumento, tipo, estado)
SELECT pk_num_serie, nome_instrumento, tipo_instrumento, estado_Inst FROM bd_alana.tb_Instrumento;

INSERT INTO Dim_Fornecedor (nome, cnpj, tipo_pessoa)
SELECT nome_favorecido_externo, cnpj_favorecido, 'Jurídica' 
FROM bd_alana.tb_Conta_Pagar WHERE cnpj_favorecido IS NOT NULL;


-- ---- CARGA FATO FINANCEIRO ----
INSERT INTO fato_financeiro (fk_tempo, fk_pessoa, valor, tipo_movimento, status_movimento)
SELECT 
    (SELECT sk_tempo FROM dim_tempo WHERE data_completa = cp.data_vencimento LIMIT 1),
    (SELECT sk_pessoa FROM dim_pessoa_fin WHERE cpf_cnpj = cp.fk_cpf_favorecido OR cpf_cnpj = cp.cnpj_favorecido LIMIT 1),
    cp.valor, 'Pagar', cp.status_pagamento
FROM bd_alana.tb_Conta_Pagar cp;

INSERT INTO fato_financeiro (fk_tempo, fk_pessoa, valor, tipo_movimento, status_movimento)
SELECT 
    (SELECT sk_tempo FROM dim_tempo WHERE data_completa = cr.data_vencimento LIMIT 1),
    (SELECT sk_pessoa FROM dim_pessoa_fin WHERE cpf_cnpj = cr.fk_cpf_pagador LIMIT 1),
    cr.valor, 'Receber', cr.status_recebimento
FROM bd_alana.tb_Conta_Receber cr;

-- ---- CARGA FATO MATRÍCULA ----
INSERT INTO fato_matricula (fk_aluno, fk_curso, fk_tempo, qtd_matricula)
SELECT 
    (SELECT sk_aluno FROM dim_aluno WHERE cpf = m.pk_cpf LIMIT 1),
    (SELECT sk_curso FROM dim_curso WHERE nome_curso = (SELECT nome_curso FROM bd_alana.tb_Curso WHERE pk_cod_curso = m.fk_cod_Curso) LIMIT 1),
    (SELECT sk_tempo FROM dim_tempo WHERE data_completa = m.data_matricula LIMIT 1),
    1
FROM bd_alana.tb_Matricula m;

-- ---- CARGA FATO RH ----
INSERT INTO fato_RH (fk_funcionario, fk_tempo, salario)
SELECT 
    (SELECT sk_funcionario FROM dim_Funcionario WHERE documento = fc.fk_cpf_funcionario LIMIT 1),
    (SELECT sk_tempo FROM dim_tempo WHERE data_completa = fc.data_entrada LIMIT 1),
    1200.00 -- Valor exemplo, já que o salário não estava no seu INSERT original
FROM bd_alana.tb_Funcionario_cargo fc;

-- ---- CARGA FATO MANUTENÇÃO ----
INSERT INTO Fato_Manutencao (SK_tempo, SK_instrumento, SK_fornecedor, custo_manutencao)
SELECT 
    (SELECT sk_tempo FROM dim_tempo WHERE data_completa = mi.data_manutencao LIMIT 1),
    (SELECT SK_instrumento FROM Dim_Instrumento WHERE num_serie = mi.fk_num_serie LIMIT 1),
    (SELECT SK_fornecedor FROM Dim_Fornecedor LIMIT 1), -- Pega o primeiro fornecedor cadastrado
    mi.custo_instrumento
FROM bd_alana.tb_Manutencao_Instrumento 