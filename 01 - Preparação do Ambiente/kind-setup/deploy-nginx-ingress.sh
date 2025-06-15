#!/bin/bash
set -e

echo "Instalando ingress-nginx no Kind (sem webhook admission)..."

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.admissionWebhooks.enabled=false \
  --set controller.ingressClassResource.default=true \
  --set controller.ingressClassResource.name=nginx \
  --set controller.service.type=LoadBalancer


# Label para identificar que o node está pronto para ingress (não obrigatório mas usado por outros setups)
for node in $(kubectl get nodes -o name); do
  kubectl label "$node" ingress-ready=true --overwrite
done

echo "Aguardando Ingress Controller ficar pronto..."
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s
