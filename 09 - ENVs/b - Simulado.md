# Simulado CKAD: Variáveis de Ambiente (Envs)

Abaixo estão 3 desafios práticos para simular a aplicação de variáveis de ambiente em cenários reais no Kubernetes, como seria em um exame CKAD. Cada desafio apresenta um contexto de caso real, e a solução pode ser visualizada clicando no título do respectivo item.

---

## Desafio 1: Configuração de Variáveis de Ambiente Estáticas

**Contexto:**

Uma aplicação rodando em um Pod precisa acessar informações sobre o ambiente no qual está sendo executada. O desenvolvedor deseja definir duas variáveis de ambiente: uma chamada `ENV` com o valor "production" e outra chamada `APP_NAME` com o valor "inventory-service".

Você deve criar um Pod no namespace `development` com essas variáveis de ambiente configuradas.

**Tarefa:**

- Crie um Pod chamado `inventory-app` rodando a imagem `nginx:latest`.
- Defina as variáveis de ambiente `ENV` e `APP_NAME` conforme o descrito acima.
- Assegure-se de que o Pod seja criado no namespace `development`.

<details>
  <summary><strong>Visualizar solução</strong></summary>

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: inventory-app
  namespace: development
spec:
  containers:
  - name: nginx-container
    image: nginx:latest
    env:
    - name: ENV
      value: "production"
    - name: APP_NAME
      value: "inventory-service"
```

</details>

---

## Desafio 2: Usando ConfigMap para Variáveis de Ambiente

**Contexto:**

Sua equipe de desenvolvimento criou um **ConfigMap** com informações sobre a configuração da aplicação. Eles querem usar as chaves `API_URL` e `API_PORT` do ConfigMap para fornecer os dados de configuração como variáveis de ambiente no contêiner da aplicação.

Você precisa criar um Pod que utiliza essas variáveis de ambiente provenientes do **ConfigMap**.

**Tarefa:**

- Crie um **ConfigMap** chamado `app-config` com as seguintes chaves:
  - `API_URL` com valor `https://api.example.com`
  - `API_PORT` com valor `8080`
- Crie um Pod chamado `api-consumer` que use a imagem `busybox:1.28`.
- O Pod deve consumir as variáveis de ambiente diretamente do **ConfigMap** `app-config`.

<details>
  <summary><strong>Visualizar solução</strong></summary>

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  API_URL: "https://api.example.com"
  API_PORT: "8080"
---
apiVersion: v1
kind: Pod
metadata:
  name: api-consumer
spec:
  containers:
  - name: busybox-container
    image: busybox:1.28
    command: ["sh", "-c", "env"]
    envFrom:
    - configMapRef:
        name: app-config
```

</details>

---

## Desafio 3: Variáveis de Ambiente Sensíveis com Secret

**Contexto:**

Uma aplicação precisa se conectar a um banco de dados, e você deve fornecer a senha do banco de dados como uma variável de ambiente. No entanto, por questões de segurança, a senha será armazenada em um **Secret**.

Você precisa criar um Secret com a senha do banco de dados e configurar um Pod que use essa senha como uma variável de ambiente.

**Tarefa:**

- Crie um **Secret** chamado `db-secret` com a chave `DB_PASSWORD` contendo o valor `my-secret-password`.
- Crie um Pod chamado `db-connector` usando a imagem `postgres:latest` que consuma a variável de ambiente `DB_PASSWORD` a partir do Secret `db-secret`.

<details>
  <summary><strong>Visualizar solução</strong></summary>

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  DB_PASSWORD: bXktc2VjcmV0LXBhc3N3b3Jk  # Base64 encoded 'my-secret-password'
---
apiVersion: v1
kind: Pod
metadata:
  name: db-connector
spec:
  containers:
  - name: postgres-container
    image: postgres:latest
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: DB_PASSWORD
```

</details>

---

Esses desafios simulam cenários comuns em que variáveis de ambiente são utilizadas no Kubernetes, seja por meio de configuração estática, ConfigMaps ou Secrets.