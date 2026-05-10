🎼 SisGESC - Sistema de Gestão Escolar (BandaAlana)
Bem-vindo ao repositório do SisGESC! Este é um projeto de banco de dados desenvolvido para a BandaAlana, uma iniciativa socio-musical localizada no Jardim Pantanal, extremo leste de São Paulo.

O objetivo deste sistema é transformar a gestão da instituição, automatizando processos de RH, Financeiro e Acadêmico para que a equipe possa focar no que realmente importa: o desenvolvimento de crianças e jovens através da música.

🎹 Sobre a Banda Alana
A instituição oferece cursos gratuitos de Violão, Canto Popular, Percussão e Iniciação Musical. O projeto utiliza a música como ferramenta de cidadania, sempre fundamentado no ECA e na BNCC.

🛠️ Estrutura e Desenvolvimento
O projeto foi construído seguindo um roteiro técnico dividido em seis fases fundamentais para garantir um banco de dados robusto:

Fase 1: Preparação e DDL – Criação das tabelas com integridade referencial (PK/FK) organizada pelos módulos Acadêmico, Financeiro e RH.

Fase 2: Carga de Dados (DML) – Inserção de dados garantindo a idempotência (o script pode ser executado várias vezes sem gerar duplicidade).

Fase 3: Operações OLTP – Implementação de consultas transacionais, subselects avançados e controle de transações (COMMIT/ROLLBACK) para garantir a consistência dos dados.

Fase 4: Modelagem OLAP (Star Schema) – Conversão do modelo operacional para um modelo analítico (Fato e Dimensões) visando a tomada de decisão estratégica.

Fase 5: Desempenho – Otimização de consultas através da criação de índices e análise detalhada via EXPLAIN.

Fase 6: Governança – Padronização rigorosa, scripts comentados e versionamento contínuo via Git.

📊 O que o sistema responde?
Graças à implementação das operações OLTP, o sistema permite extrair informações críticas para a gestão da ONG, como:

Gestão de RH: Quantidade de funcionários por cargo e tempo de casa.

Gestão Pedagógica: Mapeamento de monitores (formados internamente ou com nível superior) e suas respectivas turmas.

Histórico: Rastreamento completo da trajetória de alunos e colaboradores na instituição.

📝 Governança e Padrões de Organização
Para manter o código profissional e fácil de manter por toda a equipe (incluindo colaboradores como a Geovana), seguimos estas regras:

Nomenclatura: Tabelas iniciadas com tb_ e chaves identificadas como pk_ ou fk_.

Estilo: SQL totalmente em conformidade com o padrão snake_case.

Documentação: Scripts comentados e organizados para facilitar futuras manutenções.

🚀 Como usar
Atualmente, o projeto conta com os scripts principais:

script_banco.sql: Script principal com a criação de toda a estrutura.

script_RESET_OFICIAL.sql: Utilitário para limpar o banco de dados e recriá-lo do zero de forma segura.