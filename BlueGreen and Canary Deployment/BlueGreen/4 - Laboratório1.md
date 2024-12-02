# Para simular um deploy Blue-Green no seu cluster Kubernetes, você pode seguir este passo a passo:

1. **Crie duas versões do aplicativo**:
   - Tenha duas imagens diferentes do seu aplicativo (ex: `app:blue` e `app:green`). A versão Blue será a que está atualmente em produção, enquanto a Green será a nova versão que deseja implantar.
2. **Implante a versão Blue**:
   - Crie um Deployment para a versão Blue, apontando para a imagem `app:blue`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
      version: blue
  template:
    metadata:
      labels:
        app: my-app
        version: blue
    spec:
      containers:
        - name: my-app
          image: app:blue
```

1. **Crie um Service para o tráfego**:
   - Crie um Service que roteia o tráfego para a versão Blue.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  selector:
    app: my-app
    version: blue
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

1. **Implante a versão Green**:
   - Agora, implante o mesmo aplicativo com uma nova versão (Green). Crie um novo Deployment para a versão Green.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
      version: green
  template:
    metadata:
      labels:
        app: my-app
        version: green
    spec:
      containers:
        - name: my-app
          image: app:green
```

1. **Teste a versão Green**:

   - Use um Service temporário ou ferramentas como port-forwarding para testar a versão Green sem afetar os usuários da versão Blue. Por exemplo:

   ```bash
   kubectl port-forward deploy/app-green 8080:8080
   ```

   - Acesse o aplicativo no `localhost:8080` para garantir que está funcionando como esperado.

2. **Troque o tráfego para Green**:

   - Após testar a versão Green, altere o selector do Service `app-service` para redirecionar o tráfego para a versão Green:

   ```bash
   kubectl patch service app-service -p '{"spec":{"selector":{"version":"green"}}}'
   ```

   - Isso redireciona o tráfego para os Pods da versão Green sem interromper o serviço.

3. **Monitore o aplicativo**:
   - Observe o comportamento da nova versão (Green) em produção, monitorando logs, métricas, e saúde dos Pods.
4. **Remova a versão Blue (opcional)**:

   - Após a confirmação do sucesso do deploy, você pode remover o Deployment da versão Blue:

   ```bash
   kubectl delete deployment app-blue

   ```

### Dicas:

- **Rollback**: Se algo der errado com a versão Green, você pode rapidamente reverter para a versão Blue, alterando o selector do Service de volta para `version: blue`.
- **Automação**: Ferramentas como ArgoCD ou Flux podem automatizar esse processo de Blue-Green deploy, tornando-o mais eficiente.
- Para validar ou acessar a versão **Blue** durante o processo de deploy Blue-Green no Kubernetes, você pode utilizar algumas estratégias:

### 1. **Port-forwarding diretamente para a versão Blue**:

Você pode usar o comando `kubectl port-forward` para redirecionar o tráfego local para os Pods da versão Blue sem alterar o Service que atende aos usuários. Isso permite que você acesse a versão Blue diretamente para testes locais.

```bash
kubectl port-forward deployment/app-blue 8080:8080
```

- Agora, acesse o aplicativo Blue no navegador ou via `curl` em `http://localhost:8080`.

### 2. **Criando um Service específico para a versão Blue**:

Outra abordagem é criar um **Service temporário** exclusivo para a versão Blue. Isso permite o acesso simultâneo tanto à versão Blue quanto à Green.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: app-blue-service
spec:
  selector:
    app: my-app
    version: blue
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

Após criar esse Service, você pode acessá-lo diretamente pelo IP do Cluster ou usando port-forwarding:

```bash
kubectl port-forward service/app-blue-service 8080:80
```

### 3. **Usando Ingress ou Load Balancer**:

Se você estiver usando um **Ingress** ou **LoadBalancer**, é possível configurar um caminho ou subdomínio separado para acessar a versão Blue. Você poderia configurar algo como `blue.your-app.com` para rotear o tráfego para a versão Blue.

Exemplo de configuração de Ingress:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: blue-ingress
spec:
  rules:
    - host: blue.your-app.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: app-blue-service
                port:
                  number: 80
```

Com isso, você poderá acessar a versão Blue através de um domínio ou caminho específico (por exemplo: `http://blue.your-app.com`).

### 4. **Usar uma ferramenta de observabilidade**:

Caso tenha configurado ferramentas de monitoramento como **Prometheus**, **Grafana**, ou um **dashboard do Kubernetes**, você pode validar a versão Blue inspecionando as métricas e logs dos Pods da versão Blue. Isso garante que você esteja observando o comportamento da aplicação em produção sem redirecionar o tráfego de usuários.
