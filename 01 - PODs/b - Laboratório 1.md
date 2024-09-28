### **Laboratório 1: Criação de um Pod Simples com Nginx**

**Objetivo**: Criar um Pod que execute o servidor web Nginx e exiba uma página HTML customizada.

#### **Passos:**

1. **Criar o arquivo YAML** que define o Pod com o contêiner Nginx:

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: nginx-pod
   spec:
     containers:
       - name: nginx
         image: nginx:latest
         ports:
           - containerPort: 80
         volumeMounts:
           - name: html-volume
             mountPath: /usr/share/nginx/html
     volumes:
       - name: html-volume
         hostPath:
           path: /data/nginx
   ```

2. **Criar o diretório** para o volume host e adicionar uma página HTML customizada:

   ```bash
   mkdir -p /data/nginx
   echo "Bem-vindo ao Nginx no Kubernetes!" > /data/nginx/index.html
   ```

3. **Aplicar o arquivo YAML** no Kubernetes:

   ```bash
   kubectl apply -f nginx-pod.yaml
   ```

4. **Verificar o status** do Pod:

   ```bash
   kubectl get pods
   ```

5. **Expor a porta** para acessar o serviço Nginx no navegador:

   ```bash
   kubectl port-forward pod/nginx-pod 8080:80
   ```

6. **Acessar a aplicação** via navegador em [http://localhost:8080](http://localhost:8080).

---
