# Makefile atualizado com secret a partir de .env

# Nome das imagens Docker
FRONTEND_IMAGE=mynginx
BACKEND_IMAGE=cstrader

# Nome do cluster Minikube
MINIKUBE_PROFILE=minikube

# Nome do secret
DB_SECRET=database-credentials
ENV_FILE=.env

.PHONY: all start-cluster build deploy migrations test cleanup run

all: run

# --- Cluster ---
start-cluster:
	@echo "Iniciando Minikube..."
	minikube start -p $(MINIKUBE_PROFILE)
	@echo "Habilitando addons registry e ingress..."
	minikube addons enable registry -p $(MINIKUBE_PROFILE)
	minikube addons enable ingress -p $(MINIKUBE_PROFILE)
	@echo "Minikube pronto!"

# --- Docker Build ---
build:
	@echo "Construindo imagem frontend..."
	docker build -f frontend/Dockerfile -t $(FRONTEND_IMAGE) frontend
	@echo "Construindo imagem backend..."
	docker build -f backend/ops/Dockerfile -t $(BACKEND_IMAGE) .
	@echo "Build concluído!"

# --- Deploy Manifests ---
# --- Deploy Manifests ---
deploy:
	@echo "Criando secret de database (se não existir)..."
	@if ! kubectl get secret $(DB_SECRET) >/dev/null 2>&1; then \
		echo "Secret $(DB_SECRET) não existe, criando..."; \
		kubectl create secret generic $(DB_SECRET) --from-env-file=$(ENV_FILE); \
	else \
		echo "Secret $(DB_SECRET) já existe, pulando..."; \
	fi
	@echo "Aplicando manifests do backend..."
	kubectl apply -f infra/api
	@echo "Aplicando manifests do database..."
	kubectl apply -f infra/database
	@echo "Aplicando manifests do frontend..."
	kubectl apply -f infra/frontend

	# --- Espera o pod do ingress ficar pronto ---
	@echo "Aguardando pod do ingress ficar pronto..."
	kubectl wait --namespace ingress-nginx \
	  --for=condition=ready pod \
	  --selector=app.kubernetes.io/component=controller \
	  --timeout=120s

	@echo "Aplicando manifests gerais..."
	sleep 15
	kubectl apply -f infra/
	@echo "Deploy concluído!"


# --- Migrations ---
migrations:
	@echo "Aguardando pod do database ficar pronto..."
	kubectl wait --for=condition=ready pod \
	  --selector=app=postgres \
	  --timeout=120s
	@echo "Aguardando pod do backend ficar pronto..."
	$(eval BACKEND_POD := $(shell kubectl get pods -l app=api -o jsonpath='{.items[0].metadata.name}'))
	@echo "Rodando migrations no pod $(BACKEND_POD)..."
	kubectl exec -it $(BACKEND_POD) -- poetry run alembic -c backend/alembic.ini upgrade head
	@echo "Migrations concluídas!"

# --- Teste ---
test:
	@echo "Aguardando pod do frontend ficar pronto..."
	$(eval FRONTEND_POD := $(shell kubectl get pods -l app=frontend -o jsonpath='{.items[0].metadata.name}'))
	@echo "A Registar user de teste no pod $(FRONTEND_POD)..."
	kubectl exec $(FRONTEND_POD) -- curl -s -X POST http://api:8000/register_user \
	-H "Content-Type: application/json" \
	-d '{"name": "Teste", "email": "testa@test.com", "password": "Secure1!"}' 
	@echo "Teste concluído!"


# --- Cleanup ---
cleanup:
	@echo "Deletando todos os recursos e parando Minikube..."
	kubectl delete -f infra/api || true
	kubectl delete -f infra/database || true
	kubectl delete -f infra/frontend || true
	kubectl delete -f infra/ || true
	@if kubectl get secret $(DB_SECRET) >/dev/null 2>&1; then \
		kubectl delete secret $(DB_SECRET); \
	fi
	minikube delete -p $(MINIKUBE_PROFILE)
	@echo "Cleanup concluído!"

# --- Run completo ---
run: start-cluster build deploy migrations test
	@echo "Aplicação totalmente iniciada e testada no cluster!"
	@echo "Frontend e backend funcionando. Secret $(DB_SECRET) aplicado."
