start:
	minikube start

addons:
	minikube addons enable ingress
	minikube addons enable registry

images:
	docker build -f backend/ops/backend.Dockerfile -t cstrader .
	docker build -f frontend/Dockerfile -t mynginx .
	minikube image load cstrader
	minikube image load mynginx

secrets:
	kubectl create secret generic database-credentials \
		--from-env-file=.env \
		--dry-run=client -o yaml | kubectl apply -f -

db:
	kubectl apply -f infra/database/
	kubectl wait --for=condition=ready pod -l app=postgres --timeout=20s



api:
	kubectl apply -f infra/api/
	kubectl wait --for=condition=ready pod -l app=api --timeout=30s

apply_frontend:
	kubectl apply -f infra/frontend/

ingress:
	kubectl apply -f infra/ingress.yaml

admin:
	kubectl apply -f infra/api/admin-credentials.yaml
	kubectl apply -f infra/api/admin_job.yaml

access:
	kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80 --address 0.0.0.0

start_JARVIS: start addons images secrets db migrations api apply_frontend ingress admin

clean:
	minikube delete
