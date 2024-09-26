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
