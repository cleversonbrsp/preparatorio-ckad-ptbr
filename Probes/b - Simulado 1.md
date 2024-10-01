# Simulado CKAD: Configuração de Probes no Kubernetes

## Contexto

Você trabalha como engenheiro DevOps em uma empresa de e-commerce que tem várias aplicações distribuídas em um cluster Kubernetes. Uma dessas aplicações é o **Order Processing Service**, responsável por processar os pedidos de compra dos clientes.

Esse serviço possui uma interface HTTP para aceitar requisições, mas depende de várias etapas internas para se preparar antes de processar os pedidos, como conexão com o banco de dados e carregamento de várias configurações. Além disso, após o serviço estar pronto, ele precisa ser monitorado para garantir que está funcionando corretamente e não trave durante o processamento dos pedidos.

Você foi encarregado de implementar uma solução que garanta que:

- O serviço só seja considerado pronto para receber tráfego quando estiver completamente inicializado.
- A saúde do serviço seja monitorada continuamente, e ele seja reiniciado caso algo dê errado.

### Objetivo do Simulado

Implemente probes para garantir que o **Order Processing Service**:

1. **Startup Probe**: O serviço deve ser reiniciado se demorar mais de 60 segundos para inicializar.
2. **Readiness Probe**: O serviço só deve começar a receber tráfego HTTP quando estiver pronto. Ele deve responder com sucesso em seu endpoint `/ready`.
3. **Liveness Probe**: O serviço deve ser monitorado continuamente para garantir que não travou. Se não responder ao endpoint `/health` dentro de 5 segundos, deve ser reiniciado.

### Informações Adicionais

- A aplicação roda no contêiner com a imagem `ecommerce/order-processing-service:latest`.
- O contêiner está exposto na porta 8080.
- A aplicação responde com `200 OK` em `/ready` quando estiver pronta para receber tráfego.
- O endpoint de saúde da aplicação está em `/health` e deve retornar `200 OK` quando o serviço estiver operando corretamente.

### Requisitos:

1. Crie um arquivo YAML para definir o Deployment do **Order Processing Service** com 3 réplicas.
2. Configure a **Startup Probe** para garantir que o serviço inicialize corretamente dentro de 60 segundos.
3. Configure a **Readiness Probe** para verificar o endpoint `/ready` a cada 10 segundos, com um tempo limite de 5 segundos.
4. Configure a **Liveness Probe** para verificar o endpoint `/health` a cada 30 segundos, com um tempo limite de 5 segundos e um `initialDelaySeconds` de 10 segundos.

### Dicas:

- Utilize a documentação oficial do Kubernetes para configurar os diferentes tipos de probes.
- Certifique-se de que as sondas estão configuradas corretamente no arquivo de manifesto YAML.
- Após aplicar o Deployment, verifique o comportamento das probes com `kubectl describe pod` e `kubectl logs` para garantir que tudo está funcionando como esperado.

---

````markdown
# Solução do Simulado CKAD: Probes no Kubernetes

Clique abaixo para revelar a solução.

<details>
  <summary>Mostrar Solução</summary>

### Manifesto YAML do Deployment com Probes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: order-processing-service
  labels:
    app: order-processing-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: order-processing-service
  template:
    metadata:
      labels:
        app: order-processing-service
    spec:
      containers:
        - name: order-processing
          image: ecommerce/order-processing-service:latest
          ports:
            - containerPort: 8080
          startupProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 0
            periodSeconds: 10
            failureThreshold: 6
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 10
            timeoutSeconds: 5
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 30
            timeoutSeconds: 5
```
````

Neste manifesto:

- A **Startup Probe** garante que a aplicação inicialize corretamente dentro de 60 segundos.
- A **Readiness Probe** verifica o endpoint `/ready` a cada 10 segundos para garantir que o serviço esteja pronto antes de receber tráfego.
- A **Liveness Probe** monitora o endpoint `/health` e, se o contêiner não estiver respondendo corretamente, ele será reiniciado.

</details>
```
