/*Projeto SisGESC - Script RESET atualizado: 09/05/2026 - 20H25*/

-- desativação para travas de fk
SET FOREIGN_KEY_CHECKS = 0;

-- truncate: esvaziamento de tabelas
TRUNCATE TABLE tb_Manutencao_Instrumento;
TRUNCATE TABLE tb_Avaliacao;
TRUNCATE TABLE tb_Ocorrencia_Instrumento;
TRUNCATE TABLE tb_Item_Emprestimo;
TRUNCATE TABLE tb_Emprestimo;
TRUNCATE TABLE tb_Conta_Receber;
TRUNCATE TABLE tb_Conta_Pagar;
TRUNCATE TABLE tb_Autorizacao_imagem;
TRUNCATE TABLE tb_Autorizacao_Evento;
TRUNCATE TABLE tb_Pessoa_Evento;
TRUNCATE TABLE tb_Evento;
TRUNCATE TABLE tb_Gravacao;
TRUNCATE TABLE tb_Banda_Musica;
TRUNCATE TABLE tb_Musica_Artista;
TRUNCATE TABLE tb_Musica;
TRUNCATE TABLE tb_Genero;
TRUNCATE TABLE tb_Artista;
TRUNCATE TABLE tb_Banda_Pessoa;
TRUNCATE TABLE tb_Instrumento;
TRUNCATE TABLE tb_Banda;
TRUNCATE TABLE tb_Frequencia;
TRUNCATE TABLE tb_Turma_funcionario;
TRUNCATE TABLE tb_Matricula;
TRUNCATE TABLE tb_Turma;
TRUNCATE TABLE tb_Curso;
TRUNCATE TABLE tb_Funcionario_cargo;
TRUNCATE TABLE tb_Cargo;
TRUNCATE TABLE tb_Tipo_monitor;
TRUNCATE TABLE tb_Funcionario;
TRUNCATE TABLE tb_Aluno_Responsavel;
TRUNCATE TABLE tb_Responsavel;
TRUNCATE TABLE tb_Aluno;
TRUNCATE TABLE tb_Endereco;
TRUNCATE TABLE tb_Telefone;
TRUNCATE TABLE tb_Pessoa;

-- drop: exclusão de tabelas (com a condição de existência)
DROP TABLE IF EXISTS tb_Manutencao_Instrumento;
DROP TABLE IF EXISTS tb_Avaliacao;
DROP TABLE IF EXISTS tb_Ocorrencia_Instrumento;
DROP TABLE IF EXISTS tb_Item_Emprestimo;
DROP TABLE IF EXISTS tb_Emprestimo;
DROP TABLE IF EXISTS tb_Conta_Receber;
DROP TABLE IF EXISTS tb_Conta_Pagar;
DROP TABLE IF EXISTS tb_Autorizacao_imagem;
DROP TABLE IF EXISTS tb_Autorizacao_Evento;
DROP TABLE IF EXISTS tb_Pessoa_Evento;
DROP TABLE IF EXISTS tb_Evento;
DROP TABLE IF EXISTS tb_Gravacao;
DROP TABLE IF EXISTS tb_Banda_Musica;
DROP TABLE IF EXISTS tb_Musica_Artista;
DROP TABLE IF EXISTS tb_Musica;
DROP TABLE IF EXISTS tb_Genero;
DROP TABLE IF EXISTS tb_Artista;
DROP TABLE IF EXISTS tb_Banda_Pessoa;
DROP TABLE IF EXISTS tb_Instrumento;
DROP TABLE IF EXISTS tb_Banda;
DROP TABLE IF EXISTS tb_Frequencia;
DROP TABLE IF EXISTS tb_Turma_funcionario;
DROP TABLE IF EXISTS tb_Matricula;
DROP TABLE IF EXISTS tb_Turma;
DROP TABLE IF EXISTS tb_Curso;
DROP TABLE IF EXISTS tb_Funcionario_cargo;
DROP TABLE IF EXISTS tb_Cargo;
DROP TABLE IF EXISTS tb_Tipo_monitor;
DROP TABLE IF EXISTS tb_Funcionario;
DROP TABLE IF EXISTS tb_Aluno_Responsavel;
DROP TABLE IF EXISTS tb_Responsavel;
DROP TABLE IF EXISTS tb_Aluno;
DROP TABLE IF EXISTS tb_Endereco;
DROP TABLE IF EXISTS tb_Telefone;
DROP TABLE IF EXISTS tb_Pessoa;

-- reativação de travas para fk
SET FOREIGN_KEY_CHECKS = 1;

-- exclusão total --
DROP DATABASE IF EXISTS bd_alana;
CREATE DATABASE bd_alana;
USE bd_alana;