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
