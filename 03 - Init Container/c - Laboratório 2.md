### Simulado 2: Configuração Dinâmica de Arquivos de Configuração

**Contexto**:  
Você está implantando uma aplicação que depende de um arquivo de configuração gerado dinamicamente no momento da inicialização. Esse arquivo precisa ser criado antes que a aplicação seja iniciada. Para isso, você usa um **Init Container** para gerar o arquivo de configuração e colocá-lo em um volume compartilhado, que será lido pelo contêiner principal da aplicação.

#### Requisitos:

1. Crie um Pod chamado `config-generator-pod` que contenha:
   - Um Init Container chamado `config-generator` que cria um arquivo de configuração `config.json` com o conteúdo `{ "app": "CKAD" }`.
   - O Init Container deve usar a imagem `busybox` e criar o arquivo em `/usr/share/config/` dentro de um volume compartilhado.
   - O contêiner principal chamado `app-container` deve usar a imagem `nginx` e servir o arquivo de configuração gerado em `/usr/share/nginx/html/`.
   - Ambos os contêineres devem compartilhar o volume `config-volume`, que será do tipo `emptyDir`.

#### Solução:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-generator-pod
spec:
  initContainers:
    - name: config-generator
      image: busybox
      command: ["sh", "-c"]
      args: ['echo "{ \\"app\\": \\"CKAD\\" }" > /usr/share/config/config.json']
      volumeMounts:
        - name: config-volume
          mountPath: /usr/share/config

  containers:
    - name: app-container
      image: nginx
      volumeMounts:
        - name: config-volume
          mountPath: /usr/share/nginx/html
      ports:
        - containerPort: 80

  volumes:
    - name: config-volume
      emptyDir: {}
```

#### Teste:

1. Aplique o Pod:

   ```bash
   kubectl apply -f config-generator-pod.yaml
   ```

2. Verifique os logs do Init Container para confirmar que o arquivo de configuração foi gerado:

   ```bash
   kubectl logs config-generator-pod -c config-generator
   ```

3. Exponha o serviço Nginx e verifique se o arquivo de configuração está sendo servido:

   ```bash
   kubectl port-forward pod/config-generator-pod 8080:80
   ```

4. Acesse o arquivo de configuração via [http://localhost:8080/config.json](http://localhost:8080/config.json).

---

### Conclusão

Esses exercícios simulam casos reais onde os **Init Containers** são usados para garantir que os contêineres principais só iniciem após a verificação de dependências ou a criação de arquivos necessários. Esses cenários são comuns em ambientes de produção e são frequentemente abordados no exame CKAD.
