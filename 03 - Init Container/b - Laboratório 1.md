Aqui estão dois simulados de exercícios do exame CKAD sobre **Init Containers**, cada um com um contexto de caso real.

---

### Simulado 1: Validação de Conexão com Banco de Dados

**Contexto**:  
Você faz parte de uma equipe DevOps que está migrando uma aplicação web para o Kubernetes. A aplicação depende de um banco de dados externo, e você quer garantir que o contêiner da aplicação só inicie depois que a conexão com o banco de dados estiver disponível. Para isso, você decide usar um **Init Container** para verificar a conectividade com o banco de dados antes que a aplicação inicie.

#### Requisitos:

1. Crie um Pod chamado `db-check-pod` que tenha:
   - Um Init Container chamado `init-db-check` que verifique se o serviço de banco de dados está disponível.
   - O Init Container deve usar a imagem `busybox` e executar o comando `nslookup` para verificar a resolução do nome `db-service`.
   - Caso o banco de dados não esteja disponível, o Init Container deve tentar novamente a cada 5 segundos.
   - O contêiner principal `app-container` deve usar a imagem `nginx` e só deve ser iniciado após a verificação bem-sucedida do Init Container.

#### Solução:

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

#### Teste:

1. Aplique o Pod:

   ```bash
   kubectl apply -f db-check-pod.yaml
   ```

2. Verifique o status do Init Container:

   ```bash
   kubectl describe pod db-check-pod
   ```

3. Verifique se o contêiner principal só inicia após o Init Container ser concluído.
