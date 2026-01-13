# Mentoria-edu - Airflow

## Sumário

- [Descrição](##Descrição)
- [Estrutura](##Estrutura)
- [Get Started](##Get_started)
    - [Pré-requisitos](###Pré-requisitos)
    - [Prepare-o-Ambiente](###Passo 1: Clone e Prepare o Ambiente)
    - [Inicialize-a-Plataforma](###Passo 2: Inicialize a Plataforma)
    - [Acesse-a-Interface](###Passo 3: Acesse a Interface)
    - [Verifique-os-Serviços](###Passo 4: Verifique os Serviços)
    - [Crie-sua-Primeira_DAG](###Passo 5: Crie sua Primeira DAG)
    - [Comandos-Úteis-para-Começar](###Comandos Úteis para Começar)
    - [Configurações-Iniciais-Recomendadas](###Configurações Iniciais Recomendadas)
    - [Solução-de-Problemas-Comuns](###Solução de Problemas Comuns)
- [Documentação](##Documentação)
- [Créditos](##Créditos)

## Descrição

Plataforma Apache Airflow containerizada para orquestração de fluxos de trabalho (DAGs) utilizando Docker Compose.

## Estrutura

```
plataforma_dados/
├── CODEOWNERS.txt
├── docker-compose.yaml
├── LICENCE
├── README.md
└── start_airflow.sh
```

## Get_started

### Pré-requisitos
- Docker Engine 20.10+

- Docker Compose 2.0+

- 4GB RAM, 2 CPUs, 10GB espaço livre

### Passo 1: Clone e Prepare o Ambiente
```bash
# Clone o repositório (se aplicável) ou navegue até o diretório do projeto
cd airflow-platform 

# Dê permissão de execução ao script de inicialização
chmod +x start_airflow.sh
```

### Passo 2: Inicialize a Plataforma
```bash
# Execute o script de inicialização (recomendado para primeira execução)
./start_airflow.sh
```
OU manualmente:

```bash
# 1. Crie os diretórios necessários
mkdir -p dags logs plugins config

# 2. Configure o UID do usuário
echo "AIRFLOW_UID=$(id -u)" > .env

# 3. Inicialize o banco de dados e crie usuário admin
docker compose up airflow-init

# 4. Inicie todos os serviços
docker compose up -d
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

# Acompanhe os logs em tempo real
docker compose logs -f

# Verifique a saúde dos serviços
docker compose exec airflow-scheduler curl http://localhost:8974/health
```

### Passo 5: Crie sua Primeira DAG
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
```

Agora você está pronto para começar a construir e gerenciar seus pipelines de dados com Apache Airflow! Consulte a documentação oficial para aprender mais sobre a criação de DAGs e operadores.

## Documentação

Se você está planejando contribuir ou apenas deseja saber mais sobre este projeto, leia nossa [documentation](https://www.notion.so/1c408c995dce8017827cf53f445a924d?v=1c408c995dce803eb025000cdbd98892&p=29908c995dce8021ad68f9924a4e221c&pm=s).

## Creditos

- [Leonardo Adelmo](https://github.com/Leo-Adelmo)
- [Luiz Vaz](https://github.com/luiz-vaz)
- [Phill Andrade](https://github.com/Phill-Andrade)
- [Eduardo Katsurayama](https://github.com/eduardoKatsurayama)