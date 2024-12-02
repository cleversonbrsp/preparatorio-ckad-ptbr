#### **Contexto de Caso Real:**
Você foi recentemente designado para gerenciar um cluster Kubernetes em uma empresa de desenvolvimento de software que está expandindo rapidamente. Para garantir que as diferentes equipes de desenvolvimento possam trabalhar sem interferir nos projetos umas das outras, você deve criar ambientes isolados. Cada equipe requer seu próprio espaço para gerenciar seus recursos de forma independente.

Neste cenário, você precisa configurar Namespaces para diferentes times de desenvolvimento: **frontend** e **backend**. Além disso, você deve garantir que o ambiente do time de **backend** tenha uma cota de recursos para limitar o uso de CPU e memória.

---

#### **Desafio 1: Criação de Namespaces**
Sua primeira tarefa é criar dois Namespaces, um chamado `frontend` e outro chamado `backend`, para organizar os recursos de cada equipe.

<details>
  <summary><strong>Ver Solução</strong></summary>

```bash
kubectl create namespace frontend
kubectl create namespace backend
```

</details>

---

#### **Desafio 2: Configuração de uma Quota de Recursos no Namespace Backend**
Agora que os Namespaces foram criados, o time de operações deseja impor uma limitação no uso de CPU e memória para o Namespace `backend`. A equipe deve ter no máximo 4 CPUs e 2Gi de memória para seus Pods.

<details>
  <summary><strong>Ver Solução</strong></summary>

Crie um arquivo YAML com a seguinte configuração:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: backend-quota
  namespace: backend
spec:
  hard:
    requests.cpu: "2"
    requests.memory: "1Gi"
    limits.cpu: "4"
    limits.memory: "2Gi"
```

Aplique o arquivo:

```bash
kubectl apply -f quota-backend.yaml
```

</details>

---

#### **Desafio 3: Verificar os Namespaces Criados**
Verifique se os Namespaces `frontend` e `backend` foram criados corretamente no cluster.

<details>
  <summary><strong>Ver Solução</strong></summary>

```bash
kubectl get namespaces
```

</details>

---

#### **Desafio 4: Definir o Contexto de Trabalho para o Namespace Backend**
Configure o `kubectl` para que todos os comandos sejam executados no Namespace `backend` por padrão, sem precisar especificá-lo em cada comando.

<details>
  <summary><strong>Ver Solução</strong></summary>

```bash
kubectl config set-context --current --namespace=backend
```

</details>

---

#### **Desafio 5: Restrição de Comunicação Entre Pods de Diferentes Namespaces**
Você foi informado que a comunicação entre os Pods do Namespace `frontend` e os do Namespace `backend` deve ser proibida por questões de segurança. Crie uma Política de Rede (*Network Policy*) que bloqueie o tráfego de Pods entre esses dois Namespaces.

<details>
  <summary><strong>Ver Solução</strong></summary>

Crie um arquivo YAML com a seguinte configuração para o Namespace `backend`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-frontend-traffic
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector: {}
    - namespaceSelector:
        matchLabels:
          name: backend
```

Aplique o arquivo:

```bash
kubectl apply -f deny-frontend-traffic.yaml
```

Essa política de rede garante que somente Pods dentro do Namespace `backend` possam se comunicar entre si, bloqueando qualquer tráfego proveniente do Namespace `frontend`.

</details>

---

#### **Conclusão:**
Neste simulado básico, você foi desafiado a criar Namespaces, configurar quotas de recursos, ajustar o contexto de trabalho, e criar políticas de rede para isolar tráfego entre diferentes equipes. Essas são habilidades essenciais para o gerenciamento de clusters Kubernetes em ambientes multi-tenant e são frequentemente abordadas no exame CKAD.

