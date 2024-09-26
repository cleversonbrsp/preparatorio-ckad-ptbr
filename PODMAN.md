## Aviso

Conhecimentos específicos acerca do podman não é exigido na prova mas a destreza em gerenciar containers é necessário e faremos uso do podman para desenvolvimento dessa finalidade.

## O que é o Podman?

O Podman é uma ferramenta de código aberto para gerenciar containers e pods, similar ao Docker. Ele permite a criação, gerenciamento e execução de containers de forma rootless (sem privilégios de root) e compatível com o OCI (Open Container Initiative). O Podman foi criado como uma alternativa ao Docker, com foco em segurança, simplicidade e integração com as ferramentas nativas de Linux.
Fonte: https://podman.io/

## Para que serve?

Podman é utilizado para criar, executar e gerenciar containers e pods. Ele oferece suporte a múltiplos formatos de imagens, gerenciamento de redes e volumes, e é compatível com a maioria das imagens OCI/Docker. Uma das suas principais funcionalidades é permitir a execução de containers em modo rootless, o que significa que não é necessário ter privilégios de administrador para gerenciar containers.

## O que ele resolve?

Podman resolve questões relacionadas à segurança e flexibilidade que existiam com o Docker. Ele elimina a necessidade de um daemon de execução (diferente do Docker, que depende do dockerd) e permite que containers sejam executados por usuários normais, sem permissões de root. Isso reduz o risco de falhas de segurança e a complexidade de gerenciamento de containers.

## Vantagens:

1. **Rootless**: Podman permite que usuários executem containers sem permissões de administrador, aumentando a segurança.
2. **Sem Daemon**: Não há necessidade de um processo em segundo plano (daemon) para executar containers, diferente do Docker.
3. **Compatibilidade OCI**: Suporte para imagens no padrão OCI, o que garante compatibilidade com muitas imagens já existentes.
4. **Criação de Pods**: Podman pode criar e gerenciar pods (grupo de containers), como no Kubernetes.
5. **Integração com Kubernetes**: Ele pode exportar pods como YAML compatível com Kubernetes, facilitando a migração.

## Desvantagens:

1. **Menor adoção**: Apesar de estar crescendo, o Podman ainda tem uma base de usuários menor que o Docker.
2. **Compatibilidade parcial**: Algumas ferramentas e pipelines ainda estão fortemente acopladas ao Docker, o que pode gerar desafios ao integrar o Podman.
3. **Complexidade inicial**: Para usuários já acostumados com Docker, a transição pode requerer ajustes em fluxos de trabalho.

## **Laboratório 1: Criando e Executando Containers Rootless com Podman**

### **Objetivo**:

Criar e executar um container sem permissões de root usando o Podman.

### **Passos**:

### 1. Instalar o Podman:

Se você estiver em um sistema Linux (como Ubuntu ou Fedora), pode instalar o Podman com os seguintes comandos:

- No Fedora:
  ```bash
  sudo dnf install podman
  ```
- No Ubuntu:
  ```bash
  sudo apt-get -y update
  sudo apt-get -y install podman
  ```

### 2. Verificar a versão do Podman:

```bash
podman --version
```

### 3. Rodar um container de forma rootless:

Como um usuário normal, rode um container Nginx usando o Podman:

```bash
podman run -d --name nginx-rootless -p 8080:80 nginx:latest

```

### 4. Verificar se o container está rodando:

```bash
podman ps
```

### 5. Acessar o Nginx através do navegador:

Abra o navegador e acesse `http://localhost:8080` para ver a página padrão do Nginx.

### 6. Remover o container:

```bash
podman stop nginx-rootless
podman rm nginx-rootless
```

### **Explicação**:

Neste exercício, você executa um container sem permissões de root, utilizando o Podman em modo rootless. A execução rootless é uma vantagem em termos de segurança, especialmente em ambientes multiusuário.

## **Laboratório 2: Exportar um Podman Pod como YAML para Kubernetes**

### **Objetivo**:

Criar um pod com containers múltiplos no Podman e exportá-lo como YAML compatível com Kubernetes.

### **Passos**:

### 1. Criar um pod no Podman:

```bash
podman pod create --name multi-container-pod -p 8080:80
```

### 2. Adicionar o container Nginx ao pod:

```bash
podman run -d --pod multi-container-pod --name nginx-container nginx:latest
```

### 3. Adicionar um segundo container (Busybox) ao pod:

```bash
podman run -d --pod multi-container-pod --name busybox-container busybox:latest sleep 3600
```

### 4. Verificar o status dos containers no pod:

```bash
podman ps --pod
```

### 5. Exportar o pod como YAML compatível com Kubernetes:

```bash
podman generate kube multi-container-pod > podman-pod.yaml
```

### 6. Verificar o conteúdo do arquivo gerado:

```bash
cat podman-pod.yaml
```

### 7. Aplicar o arquivo YAML no cluster Kubernetes:

Se você tiver um cluster Kubernetes configurado, aplique o pod exportado:

```bash
kubectl apply -f podman-pod.yaml
```

### 8. Verificar se o pod foi criado no Kubernetes:

```bash
kubectl get pods
```

### **Explicação**:

Este exercício mostra como o Podman pode ser utilizado para criar pods, assim como no Kubernetes. A capacidade de exportar pods como YAML compatível com Kubernetes permite que você migre facilmente suas aplicações do ambiente de desenvolvimento local (usando Podman) para um ambiente Kubernetes real.

Esses exercícios mostram como usar o Podman para gerenciar containers e pods, sem depender de privilégios de root ou de um daemon centralizado, e como integrar suas criações com o Kubernetes.

---

## **Laboratório 3: Criando uma build com Dockerfile**

### **Objetivo:**

Neste laboratório, você irá construir uma imagem de container customizada usando um **Dockerfile**, fazer o upload dessa imagem para o seu **Minikube** e criar um pod no Kubernetes para rodar essa imagem. Esse exercício foca na criação de containers e no uso de imagens customizadas no Kubernetes, seguindo o estilo de questões da prova CKAD.

---

### **Passos:**

### **1. Criar um Dockerfile**

1. Crie um diretório para o seu projeto e navegue até ele:

   ```bash
   mkdir dockerfile-lab
   cd dockerfile-lab
   ```

2. Crie um arquivo chamado `Dockerfile` com o seguinte conteúdo, que irá criar uma imagem base do Nginx e adicionar uma página customizada:

   ```
   FROM nginx:alpine
   COPY index.html /usr/share/nginx/html/index.html
   ```

3. Crie um arquivo `index.html` no mesmo diretório com o seguinte conteúdo:

   ```html
   <!DOCTYPE html>
   <html>
     <head>
       <title>Hello from CKAD Lab</title>
     </head>
     <body>
       <h1>Hello from CKAD Docker Build Lab</h1>
     </body>
   </html>
   ```

### **2. Criar e Testar a Imagem no Minikube**

1. Certifique-se de que o **Minikube** está rodando:

   ```bash
   minikube start
   ```

2. Utilize o Docker interno do Minikube para criar a imagem. Primeiramente, conecte-se ao ambiente Docker do Minikube:

   ```bash
   eval $(minikube docker-env)
   ```

3. Construa a imagem usando o Dockerfile criado:

   ```bash
   docker build -t custom-nginx:lab3 .
   ```

4. Verifique se a imagem foi construída corretamente:

   ```bash
   docker images | grep custom-nginx
   ```

### **3. Criar um Pod no Kubernetes usando a Imagem Customizada**

1. Crie um arquivo YAML chamado `pod-lab3.yaml` para definir o pod que usará a imagem customizada:

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: custom-nginx-pod
   spec:
     containers:
       - name: nginx-container
         image: custom-nginx:lab3
         ports:
           - containerPort: 80
   ```

2. Aplique o pod no cluster do Minikube:

   ```bash
   kubectl apply -f pod-lab3.yaml
   ```

3. Verifique se o pod foi criado corretamente:

   ```bash
   kubectl get pods
   ```

4. Exponha o pod para testar a aplicação:

   ```bash
   kubectl port-forward pod/custom-nginx-pod 8080:80
   ```

5. Acesse o navegador e visite `http://localhost:8080`. Você deverá ver a mensagem "Hello from CKAD Docker Build Lab" que foi definida no arquivo `index.html`.

### **4. Limpar o Ambiente**

1. Delete o pod:

   ```bash
   kubectl delete pod custom-nginx-pod
   ```

2. Opcionalmente, se quiser limpar as imagens Docker criadas, você pode rodar:

   ```bash
   docker rmi custom-nginx:lab3
   ```

---

### **Resumo:**

Neste laboratório, você aprendeu a criar uma imagem customizada a partir de um Dockerfile, carregá-la no Minikube e rodá-la como um pod no Kubernetes. Este exercício simula uma situação comum da CKAD, onde você é testado na construção e no gerenciamento de imagens e containers em um cluster Kubernetes.

---

### Troubleshooting

Output:

```bash
Error: short-name "nginx" did not resolve to an alias and no unqualified-search registries are defined in "/etc/containers/registries.conf"
```

Esse erro ocorre porque o **Podman** não conseguiu resolver o nome da imagem `nginx`, pois não há registros de busca definidos no arquivo de configuração `/etc/containers/registries.conf`.

Para resolver isso, você pode usar o nome completo da imagem, referenciando o repositório oficial do Docker Hub. Experimente rodar o seguinte comando:

```bash
podman run -d --name nginx-rootless -p 8080:80 docker.io/library/nginx:latest
```

Se o problema persistir, verifique ou adicione os repositórios de busca (registries) no arquivo `/etc/containers/registries.conf`. Aqui está como você pode fazer isso:

1. Abra o arquivo de configuração com um editor de texto (por exemplo, o `nano`):

   ```bash
   sudo nano /etc/containers/registries.conf
   ```

2. Procure a seção `[registries.search]` e adicione o Docker Hub como um registro de busca, caso não esteja lá:

   ```
   [registries.search]
   registries = ['docker.io']
   ```

3. Salve o arquivo e saia do editor. Em seguida, tente novamente o comando para rodar o Nginx:

```bash
podman run -d --name nginx-rootless -p 8080:80 nginx
```

Isso deve corrigir o problema e permitir que você execute o container Nginx usando o Podman.
