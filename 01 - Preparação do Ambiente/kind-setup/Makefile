CLUSTER_NAME=dev-cluster

up:
	@echo "[INFO] Criando cluster Kind..."
	kind create cluster --config kind-cluster.yaml --name $(CLUSTER_NAME)

ingress:
	bash deploy-nginx-ingress.sh

metallb:
	bash deploy-metallb.sh

# demo:
# 	kubectl apply -f hello-ingress.yaml

# hosts:
# 	@echo "[INFO] Adicionando hello.local ao /etc/hosts"
# 	echo "127.0.0.1 hello.local" | sudo tee -a /etc/hosts

destroy:
	@echo "[INFO] Removendo cluster..."
	kind delete cluster --name $(CLUSTER_NAME)

rebuild: destroy up ingress metallb
