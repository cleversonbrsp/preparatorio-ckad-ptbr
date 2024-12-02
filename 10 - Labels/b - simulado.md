# Simulado CKAD: Labels

## Desafio 1: Organização de Pods por Ambiente

### Contexto

A empresa **TechSolutions** está desenvolvendo um sistema distribuído que será implantado em três diferentes ambientes: **desenvolvimento**, **teste** e **produção**. Eles precisam garantir que os pods estejam corretamente rotulados para que possam ser facilmente filtrados e gerenciados em cada um desses ambientes.

Você foi encarregado de criar um pod de **Nginx** no ambiente de produção, rotulando-o de maneira adequada para que ele seja identificado corretamente pelos administradores de sistema.

### Tarefa

1. Crie um pod com a seguinte especificação:
   - Nome: `nginx-production`
   - Imagem: `nginx`
   - Rótulos:
     - `app: web`
     - `environment: production`

<details>
  <summary><strong>Ver solução</strong></summary>

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-production
  labels:
    app: web
    environment: production
spec:
  containers:
    - name: nginx
      image: nginx
```

</details>

---

## Desafio 2: Seleção de Pods por Aplicação

### Contexto

A equipe de DevOps da **OnlineStore** está trabalhando para garantir que os pods de diferentes partes da aplicação possam ser facilmente selecionados e monitorados. Eles querem aplicar rótulos aos seus pods para diferenciar entre a aplicação **frontend** e **backend**.

Sua tarefa é criar dois pods, um para o **frontend** e outro para o **backend**, com rótulos apropriados que ajudem a identificar essas partes da aplicação.

### Tarefa

1. Crie dois pods com as seguintes especificações:
   - Primeiro Pod:
     - Nome: `frontend-app`
     - Imagem: `nginx`
     - Rótulos:
       - `app: frontend`
       - `tier: web`
   - Segundo Pod:
     - Nome: `backend-app`
     - Imagem: `redis`
     - Rótulos:
       - `app: backend`
       - `tier: cache`

<details>
  <summary><strong>Ver solução</strong></summary>

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: frontend-app
  labels:
    app: frontend
    tier: web
spec:
  containers:
    - name: nginx
      image: nginx
---
apiVersion: v1
kind: Pod
metadata:
  name: backend-app
  labels:
    app: backend
    tier: cache
spec:
  containers:
    - name: redis
      image: redis
```

</details>

---

## Desafio 3: Atualização de Labels em Pods Existentes

### Contexto

A empresa **DataCorp** está passando por uma reestruturação de sua arquitetura de microserviços. Parte dessa reestruturação inclui a aplicação de novos rótulos em pods já existentes para melhor gestão e monitoramento. Um dos pods que precisam ser atualizados é o `backend-service`.

Você foi solicitado a adicionar uma nova label ao pod já existente, sem removê-lo ou interromper sua operação.

### Tarefa

1. Adicione a seguinte label ao pod existente chamado `backend-service`:
   - `department: analytics`

### Observação

O pod já está em execução, você apenas precisa adicionar a nova label.

<details>
  <summary><strong>Ver solução</strong></summary>

```bash
kubectl label pod backend-service department=analytics
```

</details>

---

## Desafio 4: Filtragem de Pods com Seletor de Labels

### Contexto

A **FinTech Corp** possui uma aplicação distribuída composta por diversos pods, e deseja realizar uma auditoria apenas nos pods que pertencem ao componente **frontend** da aplicação. Todos os pods já foram rotulados com as labels apropriadas, mas eles querem saber como obter essa lista de forma eficiente.

### Tarefa

1. Usando `kubectl`, filtre e liste todos os pods que pertencem ao `frontend` da aplicação. Os pods têm a label `app=frontend`.

<details>
  <summary><strong>Ver solução</strong></summary>

```bash
kubectl get pods --selector app=frontend
```

</details>

---

## Desafio 5: Criação de ReplicaSet com Seletor de Labels

### Contexto

A **MediaStreaming Co.** está configurando um sistema para garantir alta disponibilidade de seu serviço de streaming. Eles precisam de um **ReplicaSet** que mantenha três réplicas de um pod **nginx**, garantindo que os pods possam ser facilmente identificados por seus rótulos.

Sua tarefa é criar o ReplicaSet, garantindo que ele aplique os rótulos corretos aos pods que gerencia.

### Tarefa

1. Crie um ReplicaSet com a seguinte especificação:
   - Nome: `nginx-replicaset`
   - Imagem: `nginx`
   - Réplicas: 3
   - Rótulos aplicados aos pods:
     - `app: nginx`
     - `tier: frontend`

<details>
  <summary><strong>Ver solução</strong></summary>

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
        tier: frontend
    spec:
      containers:
        - name: nginx
          image: nginx
```

</details>
