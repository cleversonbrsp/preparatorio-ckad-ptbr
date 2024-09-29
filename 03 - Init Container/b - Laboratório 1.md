### Simulado 1: Validação de Conexão com Banco de Dados (MySQL)

**Contexto**:  
Você faz parte de uma equipe DevOps que está migrando uma aplicação para o Kubernetes. A aplicação depende de um banco de dados MySQL, e você quer garantir que o contêiner da aplicação só inicie após o banco de dados estar disponível. Para isso, você vai usar um **Init Container** para verificar a conectividade com o banco de dados antes que o contêiner principal inicie.

### Etapas do Exercício

#### Passo 1: Criar o Pod e Service para o MySQL

O primeiro passo é criar um **Pod** e um **Service** para rodar o banco de dados MySQL dentro do cluster Kubernetes.

##### 1.1. Manifesto YAML para o Pod do MySQL (`mysql-pod.yaml`):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  containers:
    - name: mysql
      image: mysql:5.7
      env:
        - name: MYSQL_ROOT_PASSWORD
          value: "rootpassword"
      ports:
        - containerPort: 3306
```

- **Descrição**: Este manifesto cria um Pod chamado `mysql`, que usa a imagem `mysql:5.7`. Ele define a variável de ambiente `MYSQL_ROOT_PASSWORD` com valor `"rootpassword"` para o usuário root do MySQL.

##### 1.2. Manifesto YAML para o Service do MySQL (`mysql-service.yaml`):

```yaml
apiVersion: v1
kind: Service
metadata:
  name: db-service
spec:
  selector:
    app: mysql
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306
```

- **Descrição**: Este manifesto cria um **Service** chamado `db-service`, que expõe o Pod `mysql` para o restante do cluster na porta 3306, que é a porta padrão do MySQL.

##### Comandos para aplicar os manifestos:

```bash
kubectl apply -f mysql-pod.yaml
kubectl apply -f mysql-service.yaml
```

##### Verificação:

Após aplicar os manifestos, você pode verificar se o Pod do MySQL e o Service foram criados corretamente:

```bash
kubectl get pods
kubectl get svc
```

#### Passo 2: Criar o Pod Principal com Init Container

Agora, criaremos o Pod principal, que só deve iniciar seu contêiner principal após o Init Container verificar se o serviço de banco de dados está disponível.

##### 2.1. Manifesto YAML para o Pod Principal (`db-check-pod.yaml`):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: db-check-pod
spec:
  initContainers:
    - name: init-db-check
      image: busybox
      command: ["sh", "-c"]
      args: ["until nslookup db-service; do echo waiting for db; sleep 5; done"]

  containers:
    - name: app-container
      image: nginx
      ports:
        - containerPort: 80
```

- **Init Container**: O Init Container `init-db-check` usa a imagem `busybox` e executa o comando `nslookup` para verificar a resolução do serviço `db-service`. Ele continua tentando até que o serviço esteja disponível, aguardando 5 segundos entre cada tentativa.
- **Contêiner Principal**: O contêiner principal `app-container` usa a imagem `nginx` e só será iniciado após o sucesso do Init Container.

##### Comando para aplicar o manifesto:

```bash
kubectl apply -f db-check-pod.yaml
```

##### Verificação:

1. Verifique o status do Pod `db-check-pod` para garantir que o Init Container está verificando a conectividade com o banco de dados:

   ```bash
   kubectl describe pod db-check-pod
   ```

2. Verifique se o contêiner principal (`nginx`) só será iniciado após o sucesso do Init Container.

3. Para verificar os logs do Init Container (opcional):

   ```bash
   kubectl logs db-check-pod -c init-db-check
   ```

#### Passo 3: Exponha o Nginx para Teste (Opcional)

Para verificar se o Nginx está funcionando corretamente após a verificação do Init Container, você pode expor o Pod `db-check-pod` localmente.

```bash
kubectl port-forward pod/db-check-pod 8080:80
```

Acesse [http://localhost:8080](http://localhost:8080) em seu navegador para ver a página inicial do Nginx.

---

### Resumo dos Arquivos YAML

- **mysql-pod.yaml**: Define o Pod para o MySQL.
- **mysql-service.yaml**: Expõe o MySQL dentro do cluster.
- **db-check-pod.yaml**: Define o Pod principal com um Init Container que verifica a conectividade com o MySQL.

### Passos Finais

1. Crie o banco de dados MySQL com os manifestos.
2. Verifique se o Init Container está funcionando corretamente, só iniciando o Nginx quando o banco estiver disponível.
3. Teste o funcionamento do Nginx, garantindo que a dependência do banco de dados foi respeitada.
