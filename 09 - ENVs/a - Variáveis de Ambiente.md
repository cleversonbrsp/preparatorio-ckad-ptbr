# Variáveis de Ambiente (Envs) no Kubernetes

No Kubernetes, as variáveis de ambiente (ou **envs**) são uma maneira de fornecer dados de configuração aos contêineres em execução dentro dos **Pods**. Elas permitem que as aplicações tenham acesso a informações importantes, como URLs de serviços, credenciais, parâmetros de configuração e outros dados necessários para a execução dos contêineres.

## Tipos de Variáveis de Ambiente

Existem várias formas de definir e utilizar variáveis de ambiente no Kubernetes. Abaixo estão os principais métodos:

### 1. **Variáveis de Ambiente Estáticas**
Essas variáveis são definidas diretamente no manifesto de um Pod ou Deployment. Elas são úteis quando o valor da variável é fixo e não precisa ser dinâmico.

#### Exemplo:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: example-container
    image: nginx
    env:
    - name: ENVIRONMENT
      value: "production"
    - name: APP_VERSION
      value: "1.0.0"
```

Neste exemplo, o contêiner terá acesso às variáveis de ambiente `ENVIRONMENT` e `APP_VERSION` com os valores definidos.

### 2. **Usando Valores de ConfigMaps**
Um **ConfigMap** no Kubernetes é usado para armazenar dados de configuração não confidenciais em pares chave-valor. As variáveis de ambiente podem ser preenchidas com valores armazenados em um **ConfigMap**.

#### Exemplo de ConfigMap:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-configmap
data:
  APP_NAME: "my-app"
  APP_MODE: "debug"
```

#### Referenciando o ConfigMap em um Pod:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: example-container
    image: nginx
    envFrom:
    - configMapRef:
        name: example-configmap
```

Neste exemplo, as variáveis de ambiente `APP_NAME` e `APP_MODE` serão carregadas diretamente do **ConfigMap**.

### 3. **Usando Segredos (Secrets)**
Segredos (**Secrets**) no Kubernetes são usados para armazenar dados confidenciais, como senhas, tokens e chaves. Você pode referenciar esses segredos como variáveis de ambiente para garantir que informações sensíveis não sejam expostas diretamente no código.

#### Exemplo de Secret:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: example-secret
type: Opaque
data:
  DATABASE_PASSWORD: YWRtaW4=  # Base64 encoding de 'admin'
```

#### Referenciando o Secret em um Pod:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: example-container
    image: nginx
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: example-secret
          key: DATABASE_PASSWORD
```

Aqui, a variável de ambiente `DB_PASSWORD` será preenchida com o valor do segredo codificado em base64 armazenado no **Secret**.

### 4. **Referenciando Campos de Recursos Kubernetes**
Você pode definir variáveis de ambiente que referenciam valores de atributos dos recursos do Kubernetes, como o nome do Pod ou o IP do Pod. Isso é útil quando você precisa de informações específicas sobre o Pod onde o contêiner está sendo executado.

#### Exemplo:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: example-container
    image: nginx
    env:
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
```

Neste exemplo, o contêiner terá duas variáveis de ambiente, `POD_NAME` e `POD_IP`, que são preenchidas dinamicamente com o nome e o IP do Pod.

### 5. **Referenciando Recursos de Limite do Contêiner**
Você também pode definir variáveis de ambiente que obtêm informações dos limites de recursos, como CPU e memória, atribuídos ao contêiner.

#### Exemplo:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: example-container
    image: nginx
    env:
    - name: CONTAINER_CPU_LIMIT
      valueFrom:
        resourceFieldRef:
          containerName: example-container
          resource: limits.cpu
    - name: CONTAINER_MEMORY_LIMIT
      valueFrom:
        resourceFieldRef:
          containerName: example-container
          resource: limits.memory
```

Neste exemplo, as variáveis de ambiente `CONTAINER_CPU_LIMIT` e `CONTAINER_MEMORY_LIMIT` serão preenchidas com os limites de CPU e memória do contêiner.

## Boas Práticas

- **Uso de Secrets**: Sempre que possível, utilize **Secrets** para armazenar informações sensíveis, como senhas e tokens, garantindo a segurança dos dados.
  
- **Uso de ConfigMaps**: Armazene dados de configuração não sensíveis em **ConfigMaps** para facilitar a reutilização e modificação de configurações sem precisar alterar os manifestos de recursos.

- **Gerenciamento Centralizado**: Usar **ConfigMaps** e **Secrets** permite que você gerencie variáveis de ambiente de forma centralizada, facilitando a manutenção e atualizações no ambiente.

## Conclusão

As variáveis de ambiente são uma forma poderosa de fornecer dados de configuração aos contêineres no Kubernetes. Usando **ConfigMaps**, **Secrets** e referências de campos, você pode fornecer essas variáveis de maneira dinâmica e segura, garantindo que os contêineres tenham as informações necessárias para sua execução.