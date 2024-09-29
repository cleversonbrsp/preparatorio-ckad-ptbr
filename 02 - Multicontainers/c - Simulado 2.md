### Simulado 2: Logs Centralizados com Sidecar

**Contexto**:
Sua equipe está implementando uma aplicação onde os logs gerados pelo contêiner principal precisam ser processados e enviados para um serviço externo de monitoramento e análise de logs. Para isso, é necessário um contêiner **sidecar** que leia e processe os logs de um volume compartilhado.

#### Requisitos:

1. Crie um Pod chamado `log-processor-pod` com dois contêineres:
   - O contêiner `app-container` deve usar a imagem `busybox` e gerar logs para o arquivo `/var/logs/app.log` com a mensagem "Log gerado pela aplicação" a cada 5 segundos.
   - O contêiner `log-sidecar` deve usar a imagem `busybox` e monitorar o arquivo de logs, simulando o envio dos logs para um serviço externo usando o comando `tail`.
2. Ambos os contêineres devem compartilhar o volume `log-volume`, montado em `/var/logs/` para que o `app-container` escreva os logs, e o `log-sidecar` os processe.
3. O volume `log-volume` deve ser do tipo `emptyDir`, garantindo que os dados persistam durante o ciclo de vida do Pod.

#### Solução:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: log-processor-pod
spec:
  containers:
    - name: app-container
      image: busybox
      command: ["/bin/sh", "-c"]
      args:
        [
          "while true; do echo 'Log gerado pela aplicação' >> /var/logs/app.log; sleep 5; done",
        ]
      volumeMounts:
        - name: log-volume
          mountPath: /var/logs
    - name: log-sidecar
      image: busybox
      command: ["/bin/sh", "-c"]
      args: ["tail -f /var/logs/app.log"]
      volumeMounts:
        - name: log-volume
          mountPath: /var/logs
  volumes:
    - name: log-volume
      emptyDir: {}
```

#### Comandos para Testar:

1. Aplique o Pod:

   ```bash
   kubectl apply -f log-processor-pod.yaml
   ```

2. Verifique os pods:

   ```bash
   kubectl get pods
   ```

3. Visualize os logs do Pod:
   ```bash
   kubectl logs log-processor-pod -c log-sidecar
   ```
