🎼 SisGESC - Sistema de Gestão Escolar (BandaAlana)
O SisGESC é uma solução robusta de banco de dados desenvolvida para a BandaAlana, um programa socio-musical de impacto que atua no Jardim Pantanal (Extremo Leste de SP). O sistema foi projetado para automatizar e integrar a gestão acadêmica, financeira e de recursos humanos, apoiando a missão da instituição de promover a cidadania através da música.

🎵 Sobre a BandaAlana
A BandaAlana oferece formação musical gratuita em modalidades como Violão, Canto Popular, Percussão e Iniciação Musical. O programa fundamenta-se nas diretrizes do ECA e da BNCC, utilizando a arte como ferramenta estratégica para a emancipação de jovens e crianças.

🛠️ Ciclo de Desenvolvimento (6 Fases)
O projeto foi estruturado seguindo um rigoroso roteiro técnico para garantir a escalabilidade e a segurança das informações:

Fase 1: Arquitetura de Dados (DDL): Criação de tabelas com integridade referencial completa, organizadas pelos módulos estratégicos da instituição.

Fase 2: Inteligência de Carga (DML): Implementação de scripts de inserção de dados garantindo a idempotência (execução segura sem duplicidade de registros).

Fase 3: Operações Estruturais (OLTP): Desenvolvimento de consultas transacionais avançadas e controle de transações (COMMIT/ROLLBACK) para máxima consistência.

Fase 4: Modelagem Analítica (OLAP): Conversão do modelo operacional para um modelo analítico (Star Schema), focado em fornecer suporte à tomada de decisão.

Fase 5: Otimização e Performance: Análise de desempenho via EXPLAIN e criação de índices para garantir respostas rápidas mesmo sob carga.

Fase 6: Governança e Versão: Organização de scripts comentados e controle de versão integral via Git.

📊 Entrega de Valor (Exemplos de Gestão)
O SisGESC transforma dados brutos em informações cruciais para a diretoria da ONG:

Visão Pedagógica: Mapeamento detalhado de monitores (formação interna ou superior) e gestão das turmas.

Gestão de Talentos: Relatórios de tempo de casa, cargos e histórico completo dos colaboradores.

Rastreabilidade: Acompanhamento da trajetória de todos os envolvidos no ecossistema da instituição.

🏛️ Boas Práticas e Qualidade
O código foi desenvolvido priorizando a manutenção e a clareza para futuros desenvolvedores:

Padronização Profissional: Uso consistente do padrão snake_case e nomenclatura semântica.

Segurança de Dados: Estrutura desenhada para evitar redundâncias e garantir a integridade de cada registro.

Modularidade: Scripts organizados para serem executados de forma independente ou via processo automatizado.
