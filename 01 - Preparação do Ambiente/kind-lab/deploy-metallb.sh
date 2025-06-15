#!/bin/bash
echo "[INFO] Deploying MetalLB..."
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml

echo "[INFO] Aguardando pods do MetalLB ficarem prontos..."
kubectl wait --namespace metallb-system \
  --for=condition=Ready pod \
  --selector=component=controller \
  --timeout=120s

echo "[INFO] Aplicando configuração de IP Pool..."
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: kind-pool
  namespace: metallb-system
spec:
  addresses:
  - 172.19.255.200-172.19.255.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2
  namespace: metallb-system
EOF
