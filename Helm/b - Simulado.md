## Simulado CKAD - Helm

### Desafio 1: Implantando uma Aplicação Multi-Container com Helm

**Contexto:**  
Você trabalha em uma empresa que mantém um serviço web baseado em Kubernetes. Esse serviço consiste em um contêiner de front-end (nginx) e um back-end de banco de dados (PostgreSQL). A equipe de DevOps quer criar um pacote Helm para facilitar o gerenciamento dessas duas partes do serviço.

Sua tarefa é criar um chart Helm que inclua o front-end (nginx) e o back-end (PostgreSQL) para implantação no cluster.

<details>
  <summary><strong>Solução...</strong></summary>

- Crie um diretório para o chart:
  ```bash
  helm create web-app
  ```

- Modifique o `values.yaml` com as imagens necessárias:
  ```yaml
  replicaCount: 1
  image:
    repository: nginx
    tag: "1.19"
  postgresql:
    enabled: true
    image:
      repository: postgres
      tag: "13"
  ```

- Configure os templates de Deployment para front-end e back-end.

- Implante a aplicação no cluster:
  ```bash
  helm install web-app ./web-app
  ```
</details>

---

### Desafio 2: Atualizando a Versão de uma Aplicação com Helm

**Contexto:**  
Sua equipe foi informada de uma nova versão do back-end da aplicação que utiliza PostgreSQL. A nova versão do PostgreSQL (14) deve ser atualizada no ambiente de produção. A versão antiga (13) ainda está rodando, e sua tarefa é realizar a atualização sem interromper o serviço.

<details>
  <summary><strong>Solução...</strong></summary>

- Verifique a versão atual do Helm release:
  ```bash
  helm ls
  ```

- Atualize o chart com a nova versão do PostgreSQL:
  Modifique o `values.yaml`:
  ```yaml
  postgresql:
    image:
      repository: postgres
      tag: "14"
  ```

- Execute o comando de atualização:
  ```bash
  helm upgrade web-app ./web-app
  ```

- Verifique o status da atualização:
  ```bash
  kubectl get pods
  ```
</details>

---

### Desafio 3: Rollback de uma Release de Helm

**Contexto:**  
Após uma atualização de produção, a equipe descobriu que a nova versão do front-end (nginx) introduziu um bug que impede o funcionamento correto da interface web. Você foi solicitado a reverter a atualização para a versão anterior.

<details>
  <summary><strong>Solução...</strong></summary>

- Liste todas as releases e suas revisões:
  ```bash
  helm history web-app
  ```

- Roleback para a versão anterior (use o número da revisão da versão estável):
  ```bash
  helm rollback web-app 1
  ```

- Verifique se o rollback foi realizado com sucesso:
  ```bash
  helm ls
  kubectl get pods
  ```
</details>

---

### Desafio 4: Configurando Variáveis de Ambiente em um Chart Helm

**Contexto:**  
A equipe precisa adicionar algumas variáveis de ambiente à aplicação para configurar o comportamento do banco de dados PostgreSQL. As variáveis incluem o nome do banco de dados, o usuário e a senha. Essas variáveis devem ser configuradas dinamicamente no Helm chart para facilitar a implantação em diferentes ambientes.

<details>
  <summary><strong>Solução...</strong></summary>

- Modifique o `values.yaml` para incluir as variáveis:
  ```yaml
  postgresql:
    env:
      - name: POSTGRES_DB
        value: mydb
      - name: POSTGRES_USER
        value: admin
      - name: POSTGRES_PASSWORD
        value: mypassword
  ```

- Atualize o template do Deployment para refletir essas variáveis:
  ```yaml
  containers:
    - name: postgres
      image: "{{ .Values.postgresql.image.repository }}:{{ .Values.postgresql.image.tag }}"
      env:
        - name: POSTGRES_DB
          value: {{ .Values.postgresql.env.POSTGRES_DB }}
        - name: POSTGRES_USER
          value: {{ .Values.postgresql.env.POSTGRES_USER }}
        - name: POSTGRES_PASSWORD
          value: {{ .Values.postgresql.env.POSTGRES_PASSWORD }}
  ```

- Implante a aplicação com as variáveis configuradas:
  ```bash
  helm upgrade web-app ./web-app
  ```
</details>

---

### Desafio 5: Criando um Repositório Helm e Adicionando um Chart

**Contexto:**  
Você foi encarregado de configurar um repositório Helm interno para que a equipe possa compartilhar seus charts. A primeira tarefa é publicar o chart da aplicação `web-app` que foi criado anteriormente no repositório.

<details>
  <summary><strong>Solução...</strong></summary>

- Crie um repositório de charts (exemplo com GitHub Pages ou outro servidor web):
  ```bash
  helm repo index ./charts --url https://your-repo-url/charts
  ```

- Empacote o chart:
  ```bash
  helm package ./web-app
  ```

- Mova o chart empacotado para o diretório do repositório:
  ```bash
  mv web-app-0.1.0.tgz ./charts/
  ```

- Atualize o índice do repositório:
  ```bash
  helm repo index ./charts
  ```

- Adicione o repositório ao Helm local:
  ```bash
  helm repo add myrepo https://your-repo-url/charts
  ```

- Instale a aplicação a partir do repositório:
  ```bash
  helm install web-app myrepo/web-app
  ```
</details>

--- 

Esses desafios simulam situações reais que podem ser encontradas no dia a dia de um ambiente Kubernetes, proporcionando uma experiência prática e focada no uso do Helm como ferramenta de automação e gerenciamento de aplicações no cluster.