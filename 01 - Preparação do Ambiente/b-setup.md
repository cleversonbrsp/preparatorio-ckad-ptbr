Aqui vai um **pacote completo do laboratório Kind**, pronto para rodar com `make` e simular um cluster Kubernetes real com:

* 3 nodes (1 control-plane, 2 workers)
* NGINX Ingress Controller
* MetalLB com IP pool
* Aplicação demo acessível via `http://hello.local`

---

## 📁 Estrutura final

```text
kind-lab/
├── Makefile
├── cluster.yaml
├── deploy-nginx-ingress.sh
├── deploy-metallb.sh
├── hello-ingress.yaml
└── README.md
```

---

## 1. `cluster.yaml` – define a topologia do cluster

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: dev-cluster
nodes:
- role: control-plane
- role: worker
- role: worker
networking:
  disableDefaultCNI: false
  apiServerAddress: "127.0.0.1"
  apiServerPort: 6443
```

---

## 2. `deploy-nginx-ingress.sh`

```bash
#!/bin/bash
echo "[INFO] Deploying Ingress NGINX..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.5/deploy/static/provider/kind/deploy.yaml

echo "[INFO] Aguardando Ingress Controller ficar pronto..."
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s
```

---

## 3. `deploy-metallb.sh`

```bash
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
  - 172.18.255.200-172.18.255.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2
  namespace: metallb-system
EOF
```

> Ajuste o range `172.18.255.200-250` conforme o subnet Docker (ver com `docker network inspect kind | grep Subnet`).

---

## 4. `hello-ingress.yaml` – serviço e ingress

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello
        image: nginxdemos/hello
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: hello
spec:
  selector:
    app: hello
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: LoadBalancer
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: hello.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hello
            port:
              number: 80
```

---

## 5. `Makefile`

```makefile
CLUSTER_NAME=dev-cluster

up:
	@echo "[INFO] Criando cluster Kind..."
	kind create cluster --config cluster.yaml --name $(CLUSTER_NAME)

ingress:
	bash deploy-nginx-ingress.sh

metallb:
	bash deploy-metallb.sh

demo:
	kubectl apply -f hello-ingress.yaml

hosts:
	@echo "[INFO] Adicionando hello.local ao /etc/hosts"
	echo "127.0.0.1 hello.local" | sudo tee -a /etc/hosts

destroy:
	@echo "[INFO] Removendo cluster..."
	kind delete cluster --name $(CLUSTER_NAME)

rebuild: destroy up ingress metallb demo hosts
```

---

## 6. `README.md` (opcional)

```markdown
# kind-lab

Laboratório local com Kubernetes usando Kind + Ingress + MetalLB.

## Comandos

- `make up` – cria o cluster
- `make ingress` – instala NGINX Ingress
- `make metallb` – instala MetalLB
- `make demo` – sobe app de teste com Ingress e LoadBalancer
- `make hosts` – adiciona entrada no `/etc/hosts`
- `make destroy` – remove o cluster
- `make rebuild` – recria tudo do zero
```

---

## 🚀 Como usar

```bash
git clone https://github.com/SEU_USUARIO/kind-lab.git
cd kind-lab

make rebuild
```

Depois, acesse: [http://hello.local](http://hello.local)

---
