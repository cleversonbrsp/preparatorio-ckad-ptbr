### Simulado 1: Aplicação Web com Geração de Conteúdo Dinâmico

**Contexto**:
Você trabalha em uma equipe DevOps que precisa criar uma aplicação que gera conteúdo dinâmico e o serve via um servidor web. A aplicação consiste em dois componentes: um gerador de conteúdo e um servidor web para servir esse conteúdo aos usuários. Esses dois componentes precisam compartilhar um volume para a troca de arquivos.

#### Requisitos:

1. Crie um Pod chamado `content-generator-pod` que tenha dois contêineres:
   - O contêiner `content-generator` deve usar a imagem `busybox` e gerar um arquivo `index.html` com o conteúdo "Bem-vindo ao CKAD!" no diretório `/usr/share/nginx/html`.
   - O contêiner `web-server` deve usar a imagem `nginx` e servir o arquivo gerado.
2. Ambos os contêineres devem compartilhar o volume `shared-content` para que o arquivo gerado pelo `content-generator` possa ser servido pelo `web-server`.
3. O volume `shared-content` deve ser do tipo `emptyDir`, e os logs de ambos os contêineres devem ser acessíveis.

#### Solução:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: content-generator-pod
spec:
  containers:
    - name: content-generator
      image: busybox
      command: ["/bin/sh", "-c"]
      args:
        [
          "echo 'Bem-vindo ao CKAD!' > /usr/share/nginx/html/index.html; sleep 3600",
        ]
      volumeMounts:
        - name: shared-content
          mountPath: /usr/share/nginx/html
    - name: web-server
      image: nginx:latest
      volumeMounts:
        - name: shared-content
          mountPath: /usr/share/nginx/html
  volumes:
    - name: shared-content
      emptyDir: {}
```

#### Comandos para Testar:

1. Aplique o Pod:

   ```bash
   kubectl apply -f content-generator-pod.yaml
   ```

2. Verifique os pods:

   ```bash
   kubectl get pods
   ```

3. Exponha o serviço Nginx:

   ```bash
   kubectl port-forward pod/content-generator-pod 8080:80
   ```

4. Acesse o conteúdo gerado via [http://localhost:8080](http://localhost:8080).
