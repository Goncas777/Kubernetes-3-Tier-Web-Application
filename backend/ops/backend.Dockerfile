# Usa uma imagem base Python slim (mais leve)
FROM python:3.11-slim AS builder

# Define o diretório de trabalho
WORKDIR /app
ENV PYTHONPATH=/app
# Instala ferramentas essenciais (incluindo dependências do psycopg2)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        libpq-dev \
        git \
    && pip install poetry \
    && rm -rf /var/lib/apt/lists/*

# 1. Copia apenas os ficheiros de dependência
COPY pyproject.toml poetry.lock ./

# 2. Instala as dependências usando o Poetry (sem a necessidade de requirements.txt)
# O --no-root e --no-dev são essenciais para um ambiente de produção/deploy
RUN poetry install --no-root --only main

# ----------------------------------------------------------------------
# FASE FINAL: Imagem Leve (Opcional, mas altamente recomendado)
# ----------------------------------------------------------------------

# FROM python:3.11-slim
# WORKDIR /app
# 
# # Copia apenas o ambiente virtual e o código da fase builder
# COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
# COPY backend/ .
# 
# EXPOSE 8000
# # ----------------------------------------------------------------------

# Para o seu MVP (simplificado):
# 3. Copia o código da aplicação (assumindo que o código está em 'backend/')
COPY backend/ /app/backend/

# Define a porta de exposição (para documentação)
EXPOSE 8000

# Comando de Iniciação do Uvicorn (Corrigido e simplificado para o Docker Compose)
# O Docker Compose fornecerá o comando para o container 'api'
# Se for usar apenas o Docker run, use:
CMD ["poetry", "run", "uvicorn", "backend.src.main:app", "--host", "0.0.0.0", "--port", "8000"]