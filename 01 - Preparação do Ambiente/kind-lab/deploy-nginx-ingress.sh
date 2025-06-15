#!/bin/bash
echo "[INFO] Deploying Ingress NGINX..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.5/deploy/static/provider/kind/deploy.yaml

# Lista os nodes e adiciona a label ingress-ready=true
for node in $(kubectl get nodes -o name); do
  kubectl label "$node" ingress-ready=true --overwrite
done

echo "[INFO] Aguardando Ingress Controller ficar pronto..."
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s
