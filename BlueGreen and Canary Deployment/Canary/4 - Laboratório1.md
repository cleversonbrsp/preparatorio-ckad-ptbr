# LABORATÓRIO 01

- 1.  **Implante a versão atual (estável)**:
      Comece criando um Deployment para a versão atual do seu aplicativo, com o tráfego completo direcionado a ele.
      `yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: app-stable
    spec:
      replicas: 5
      selector:
        matchLabels:
          app: my-app
          version: stable
      template:
        metadata:
          labels:
            app: my-app
            version: stable
        spec:
          containers:
          - name: my-app
            image: app:stable
    `
  2.  **Crie o Service para direcionar o tráfego**:
      Um único Service será usado para rotear o tráfego tanto para a versão estável quanto para o Canary.
      `yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: app-service
    spec:
      selector:
        app: my-app
      ports:
        - protocol: TCP
          port: 80
          targetPort: 8080
    `
  3.  **Implante a versão canária**:
      Agora, implante a versão canária do seu aplicativo, mas com menos réplicas, para receber uma pequena porcentagem do tráfego.
      `yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: app-canary
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: my-app
          version: canary
      template:
        metadata:
          labels:
            app: my-app
            version: canary
        spec:
          containers:
          - name: my-app
            image: app:canary
    `
  4.  **Atualize o Service para atender ambas as versões**:
      Para redirecionar o tráfego tanto para a versão estável quanto para a canária, o Service deve selecionar ambas as versões. Isso pode ser feito ajustando o rótulo de correspondência no selector para `app: my-app`.
      `yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: app-service
    spec:
      selector:
        app: my-app
      ports:
        - protocol: TCP
          port: 80
          targetPort: 8080
    `

          A configuração atual balanceará o tráfego com base na quantidade de réplicas, onde a versão canária recebe uma parcela menor (ex: 1 canary vs. 5 estáveis).

  5.  **Monitore o comportamento da versão** canary :
      Acompanhe o comportamento da versão canária, observando logs, métricas de desempenho e erros. Ferramentas como Prometheus, Grafana ou observabilidade de serviços podem ajudar a detectar anomalias na versão canária.
  6.  **Escale gradualmente a versão canary**:
      Se o canary for validado com sucesso, você pode gradualmente aumentar o número de réplicas da versão canária para redirecionar mais tráfego para ela.
      `bash
    kubectl scale deployment app-canary --replicas=3
    `

          Continue aumentando até que a versão canária tenha o tráfego completo e, finalmente, remova a versão estável se tudo estiver funcionando corretamente.

  7.  **Rollback rápido (se necessário)**:
      Se o comportamento da versão canária não for satisfatório, você pode simplesmente reduzir as réplicas do canary ou excluí-lo:
      ```bash
      kubectl scale deployment app-canary --replicas=0

          ```

  ### Dicas:

  - **Ferramentas de automação**: Ferramentas como **Argo Rollouts**, **Flagger**, ou **Istio** podem gerenciar o Canary Deployment, controlando o tráfego de forma automática com regras inteligentes.
  - **A/B Testing**: Além do Canary Deployment, você pode combinar com estratégias de A/B testing para testar diferentes versões em paralelo para segmentos distintos de usuários.
    Esse processo simula um Canary Deployment no Kubernetes, permitindo testar progressivamente novas versões de forma controlada e segura.
