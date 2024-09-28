### Laboratório 2: Pod com Dois Contêineres Compartilhando um Volume

**Objetivo**: Criar um Pod que contém dois contêineres. Um contêiner escreve um arquivo em um volume compartilhado e o outro contêiner serve esse arquivo através de um servidor web.

#### Passos:

1. **Criar o arquivo YAML** com dois contêineres:

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: multi-container-pod
   spec:
     containers:
       - name: generator
         image: busybox
         command: ["/bin/sh", "-c"]
         args:
           [
             "echo 'Arquivo gerado por busybox' > /shared-data/output.txt; sleep 3600",
           ]
         volumeMounts:
           - name: shared-volume
             mountPath: /shared-data
       - name: web-server
         image: nginx:latest
         volumeMounts:
           - name: shared-volume
             mountPath: /usr/share/nginx/html
     volumes:
       - name: shared-volume
         emptyDir: {}
   ```

2. **Aplicar o arquivo YAML**:

   ```bash
   kubectl apply -f multi-container-pod.yaml
   ```

3. **Verificar o status** do Pod:

   ```bash
   kubectl get pods
   ```

4. **Expor a porta** do servidor Nginx:

   ```bash
   kubectl port-forward pod/multi-container-pod 8080:80
   ```

5. **Acessar o arquivo** gerado pelo contêiner busybox:

   [http://localhost:8080/output.txt](http://localhost:8080/output.txt)

```

```
