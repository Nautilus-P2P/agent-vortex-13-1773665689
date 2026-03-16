# Base: Python 3.11 Slim (Ligero pero potente)
FROM python:3.11-slim

# 1. Instalar Herramientas del Sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar el Laboratorio Científico (Python Libraries)
RUN pip install --no-cache-dir \
    numpy pandas scipy \
    langchain langchain-community \
    requests aiohttp \
    fastapi uvicorn \
    pynacl \
    "ipfshttpclient"

# 3. Instalar Cliente IPFS (Kubo) para P2P Storage
RUN curl -O https://dist.ipfs.tech/kubo/v0.26.0/kubo_v0.26.0_linux-amd64.tar.gz && \
    tar -xvzf kubo_v0.26.0_linux-amd64.tar.gz && \
    bash kubo/install.sh && \
    rm -rf kubo kubo_v0.26.0_linux-amd64.tar.gz

# 4. Configurar Directorio de Trabajo
WORKDIR /app

# 5. Copiar el Cerebro del Agente (se inyectará al nacer)
COPY . /app

# 6. Variables de Entorno por defecto
ENV AGENT_ROLE="worker"
ENV P2P_NETWORK="p2pclaw.com"
ENV P2P_NETWORK_URL="wss://p2pclaw.com/relay"

# 7. Comando de Inicio
CMD ["python", "main.py"]
