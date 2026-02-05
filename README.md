# Mentoria-edu - Airflow

## Sumário

- [Descrição](##Descrição)
- [Estrutura](##Estrutura)
- [Serviços-em-Execução](##Serviços em Execução)
- [Get Started](##Get_started)
    - [Pré-requisitos](###Pré-requisitos)
    - [Prepare-o-Ambiente](###Passo 1: Execute o Script de Inicialização)
    - [Verificando-a-Instalação](###Passo 2: Verificando a Instalação)
    - [Acesse-a-Interface](###Passo 3: Acesse a Interface)
    - [Verifique-os-Serviços](###Passo 4: Verifique os Serviços)
    - [Crie-sua-Primeira_DAG](###Passo 5: Crie sua Primeira DAG)
    - [Comandos-Úteis-para-Começar](###Comandos Úteis para Começar)
    - [Configurações-Iniciais-Recomendadas](###Configurações Iniciais Recomendadas)
    - [Solução-de-Problemas-Comuns](###Solução de Problemas Comuns)
    - [Informações-Técnicas](###Informações Técnicas)
- [Documentação](##Documentação)
- [Créditos](##Créditos)

## Descrição

Plataforma de orquestração de fluxos de trabalho (ETL/ELT) baseada no Apache Airflow 3.1.5, totalmente containerizada com Docker Compose. Esta implementação fornece um ambiente completo e pronto para uso com todos os componentes necessários para gerenciar, agendar e monitorar pipelines de dados de forma eficiente.

A stack inclui serviços separados para cada componente do Airflow, garantindo alta disponibilidade e escalabilidade, com PostgreSQL como backend de banco de dados e configurações otimizadas para desenvolvimento e produção. O script de inicialização automatizada (start_airflow.sh) simplifica todo o processo de configuração e execução.

## Estrutura

```
airflow-platform/
├── docker-compose.yaml          # Definição completa dos serviços Docker
├── start_airflow.sh            # Script de inicialização automatizada
├── .env                        # Variáveis de ambiente (gerado automaticamente pelo script)
├── dags/                       # Diretório para suas DAGs (Directed Acyclic Graphs)
│   ├── example_dag.py          # Exemplos de DAGs (se load_examples=true)
│   └── (seus_dags_aqui)        # Coloque suas próprias DAGs aqui
├── plugins/                    # Plugins e operadores customizados
│   ├── __init__.py
│   └── (seus_plugins_aqui)     # Plugins personalizados do Airflow
├── config/                     # Configurações do Airflow
│   └── airflow.cfg             # Configuração principal (gerada automaticamente)
├── logs/                       # Logs de execução das DAGs
│   ├── scheduler/              # Logs do scheduler
│   ├── dag_processor/          # Logs do processador de DAGs
│   └── (logs_das_dags)         # Logs individuais das DAGs
└── README.md                   # Esta documentação
```

## Serviços em Execução:

```text
postgres:16          → Banco de dados PostgreSQL (porta 5432)
airflow-apiserver    → API REST + Interface Web (porta 8080)
airflow-scheduler    → Orchestrador de tarefas
airflow-triggerer    → Gerenciador de triggers
airflow-dag-processor → Processador de definições DAG
airflow-init         → Inicializador (execução única)
airflow-cli          → CLI para operações (apenas debug)
```
O que o start_airflow.sh faz automaticamente:

1. Cria diretórios necessários (dags, logs, plugins, config)

2. Configura variáveis de ambiente (.env file com AIRFLOW_UID)

3. Inicializa o banco de dados e cria usuário admin

4. Inicia todos os serviços em background

5. Fornece informações de acesso e status

## Get_started

### Pré-requisitos
- Docker Engine 20.10+

- Docker Compose 2.0+

- 4GB RAM, 2 CPUs, 10GB espaço livre

### Passo 1: Passo Único: Execute o Script de Inicialização
```bash
# 1. Dê permissão de execução ao script
chmod +x start_airflow.sh

# 2. Execute o script (ele faz tudo automaticamente!)
./start_airflow.sh
```

O que Acontece Durante a Execução:

```text
✅ Criando diretórios necessários... (dags/, logs/, plugins/, config/)
✅ Configurando AIRFLOW_UID... (cria/verifica .env file)
✅ Inicializando banco de dados Airflow e criando usuário admin...
✅ Iniciando serviços Airflow...
✅ Airflow está rodando! Acesse: http://localhost:8080
```

### Passo 2: Verificando a Instalação
```bash
# Execute o script de inicialização (recomendado para primeira execução)
./start_airflow.sh
```
OU manualmente:

```bash
# Verifique se todos os serviços estão rodando
docker compose ps

# Acompanhe os logs em tempo real
docker compose logs -f

# Teste o CLI do Airflow
docker compose run --rm airflow-cli version
```

### Passo 3: Acesse a Interface
1. Abra seu navegador em: http://localhost:8080

2. Faça login com:

    - Usuário: airflow

    - Senha: airflow

### Passo 4: Verifique os Serviços
```bash
# Verifique se todos os serviços estão rodando
docker compose ps

# Ver logs de um serviço específico
docker compose logs airflow-scheduler

# Ver logs em tempo real
docker compose logs -f airflow-apiserver

# Verifique a saúde dos serviços
docker compose exec airflow-scheduler curl http://localhost:8974/health
```

### Passo 5: Crie sua Primeira DAG
> Diretorio: dags/meu_primeiro_dag.py
```python
# Crie um arquivo em dags/meu_primeiro_dag.py
from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG(
    dag_id='meu_primeiro_dag',
    start_date=datetime(2024, 1, 1),
    schedule='@daily',
    catchup=False
) as dag:
    
    tarefa_hello = BashOperator(
        task_id='hello_world',
        bash_command='echo "Hello Airflow!"'
    )
```

As DAGs aparecem automaticamente na interface web (pode levar 30-60 segundos)

### Comandos Úteis para Começar

```bash
# Listar DAGs disponíveis
docker compose run --rm airflow-cli dags list

# Pausar/Despausar uma DAG
docker compose run --rm airflow-cli dags pause <dag_id>
docker compose run --rm airflow-cli dags unpause <dag_id>

# Testar uma tarefa
docker compose run --rm airflow-cli tasks test <dag_id> <task_id> <execution_date>

# Limpar a plataforma (cuidado: remove dados)
docker compose down -v
```

### Configurações Iniciais Recomendadas
- Altere a senha padrão após o primeiro login

- Configure conexões em Admin → Connections

- Ajuste variáveis em Admin → Variables

- Revise as configurações em config/airflow.cfg

### Solução de Problemas Comuns
```bash
# Se a interface web não carregar:
docker compose logs airflow-apiserver

# Se DAGs não aparecerem:
docker compose restart airflow-scheduler

# Erros de permissão:
sudo chown -R $USER:$USER dags logs plugins config

# Recriar ambiente do zero:
docker compose down -v
rm -rf dags/* logs/* plugins/* config/*
./start_airflow.sh
```

### Informações Técnicas

Airflow Version: 3.1.5

Database: PostgreSQL 16

Executor: LocalExecutor

Web Port: 8080

Data Persistence: Volumes Docker para PostgreSQL e diretórios mapeados

Pronto para uso! Sua plataforma Airflow está configurada e funcionando. Consulte a [documentação oficial do Airflow](https://airflow.apache.org/docs/) para aprender mais sobre criação de DAGs, operadores e boas práticas.

## Documentação

Se você está planejando contribuir ou apenas deseja saber mais sobre este projeto, leia nossa [documentation](https://www.notion.so/1c408c995dce8017827cf53f445a924d?v=1c408c995dce803eb025000cdbd98892&p=29908c995dce8021ad68f9924a4e221c&pm=s).

## Creditos

- [Leonardo Adelmo](https://github.com/Leo-Adelmo)
- [Luiz Vaz](https://github.com/luiz-vaz)
- [Phill Andrade](https://github.com/Phill-Andrade)
- [Eduardo Katsurayama](https://github.com/eduardoKatsurayama)