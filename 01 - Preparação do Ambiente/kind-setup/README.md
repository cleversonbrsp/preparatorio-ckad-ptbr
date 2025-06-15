Durante essa jornada, estarei utilizando o **Kind** como ambiente principal.

> **Fonte oficial do Kind:**  
> [https://kind.sigs.k8s.io/](https://kind.sigs.k8s.io/)

---

## Por que utilizar o Kind?

- Permite criar **múltiplos nodes com kubeadm**, simulando um cluster real de forma mais próxima da produção.
- Executa o **mesmo stack utilizado em clusters reais**.
- Utiliza **imagens oficiais do Kubernetes**, garantindo maior fidelidade ao ambiente real.
- É ideal para **testes automatizados e pipelines CI/CD**, onde o comportamento do cluster precisa ser realista.

Aqui vai um **pacote completo do meu setup Kind**, pronto para rodar com `make` e simular um cluster Kubernetes real com:

* 3 nodes (1 control-plane, 2 workers)
* NGINX Ingress Controller
* MetalLB com IP pool
* Aplicação demo acessível via `http://hello.local`

## Nota:
O Kind não suporta webhooks admission do ingress-nginx por padrão, porque:
- O service ingress-nginx-controller-admission é do tipo ClusterIP
- E Kind não tem DNS interno nem rede compatível para o kube-apiserver acessar o webhook via esse service
---

## 📁 Estrutura final

```text
kind-setup/
├── Makefile
├── cluster.yaml
├── deploy-nginx-ingress.sh
├── deploy-metallb.sh
├── hello-ingress.yaml
└── README.md
```

---

## 1. `kind-cluster.yaml` – define a topologia do cluster

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: dev-cluster
nodes:
- role: control-plane
  extraPortMappings:
    - containerPort: 80
      hostPort: 80
    - containerPort: 443
      hostPort: 443
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
  - 172.19.255.200-172.19.255.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2
  namespace: metallb-system
EOF
```

> Ajuste o range `172.19.255.200-250` conforme o subnet Docker (ver com `docker network inspect kind | grep Subnet`).

---

## 4. `hello-ingress.yaml` – serviço e ingress

```yaml
---
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
  ingressClassName: nginx
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
	echo "172.19.255.200 hello.local" | sudo tee -a /etc/hosts

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
cd kind-setup

make rebuild
```

Depois, acesse: [http://hello.local](http://hello.local)

---
