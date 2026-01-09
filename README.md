
# CSTrader API MVP: Marketplace de Skins

Este projeto é um Minimum Viable Product (MVP) para um sistema de marketplace de skins (itens virtuais) estilo CS:GO, implementado em Python usando FastAPI e SQLAlchemy.

## 🚀 Funcionalidades Principais

O sistema permite:

- **Autenticação de Utilizadores**: Registo e Login via JWT.
- **Gestão de Carteira**: Depósito de fundos e histórico de transações.
- **Inventário de Skins**: Consulta de itens que o utilizador possui.
- **Marketplace**: Listagem, consulta e compra/venda de skins entre utilizadores.
- **Administração**: Endpoints REST para criação e gestão de skins base (acessível apenas a utilizadores com a role admin).

## 🛠️ Tecnologias Utilizadas

- **Backend**: Python 3.11+
- **Framework**: FastAPI
- **Base de Dados**: PostgreSQL (via Docker)
- **ORM**: SQLAlchemy 2.0+
- **Gestão de Dependências**: Poetry
- **Automatização**: Makefile

## 📋 Pré-requisitos

Para rodar o projeto localmente, você precisará de:

- Python 3.11+
- Poetry: Para gerir o ambiente virtual e as dependências do Python.  
  Instalação (se necessário):  
  
  pip install poetry

- Docker e Docker Compose
- Make: Utilizado para simplificar os comandos de setup e inicialização.

## ⚙️ Configuração e Instalação (MVP Setup)

O processo de instalação está simplificado num único comando \`make setup\` que automatiza a instalação das dependências, o setup da base de dados e a criação inicial de dados.

### 1. Instalar Dependências Poetry

poetry install


### 2. Configurar Variáveis de Ambiente

As configurações da base de dados e da API são geridas através do ficheiro \`.env\`.  
Pode usar o \`.env.example\` como base.

### 3. Executar o Setup Completo (Comando Único)

Este comando:

- Levanta os serviços Docker (incluindo o PostgreSQL)
- Cria todas as tabelas na base de dados
- Cria um utilizador Admin
- Popula a base de dados com algumas skins iniciais

make setup

## ▶️ Como Rodar a API


make up


A API estará acessível em:

- URL Base: [http://localhost:3000/](http://localhost:3000/)
- Documentação Interativa (Swagger UI): [http://localhost:8000/docs](http://localhost:8000/docs])

## 📚 Estrutura do Projeto
```plaintext
my_project/
├── backend/
│   ├── src/
│   │   ├── database.py       # Serviço de persistência de dados (SQLAlchemy)
│   │   ├── db_models.py      # Definição de tabelas da DB (ORM Models)
│   │   ├── models.py         # Modelos Pydantic para validação de dados (Request/Response)
│   │   ├── main.py           # Endpoints da API (FastAPI)
│   │   └── settings.py       # Variáveis de ambiente e configurações
│   └── tests/                # Testes unitários e de integração
├── .env.example              # Exemplo de ficheiro de configuração de variáveis de ambiente
├── docker-compose.yml        # Configuração dos serviços Docker (PostgreSQL)
├── Makefile                  # Comandos de automação (setup, start, stop)
└── pyproject.toml            # Configuração do projeto e dependências (Poetry)
```

## 📌 Descrição das Pastas e Ficheiros

- **backend/src/**: Contém toda a lógica da aplicação, incluindo a base de dados, modelos e endpoints da API.
- **database.py**: Configuração do SQLAlchemy e criação da sessão de base de dados.
- **db_models.py**: Definição das tabelas e relacionamentos da base de dados.
- **models.py**: Modelos Pydantic usados para validação de dados em requests e responses.
- **main.py**: Definição dos endpoints da API usando FastAPI.
- **settings.py**: Variáveis de ambiente e configurações gerais do projeto.
- **tests/**: Pasta destinada a testes unitários e de integração.
- **.env**: ficheiro de variáveis de ambiente.
- **docker-compose.yml**: Configuração dos serviços Docker necessários para o projeto (ex.: PostgreSQL).
- **Makefile**: Comandos de automação para facilitar setup e execução do projeto.
- **pyproject.toml**: Ficheiro de configuração do Poetry, incluindo dependências e metadados do projeto.
