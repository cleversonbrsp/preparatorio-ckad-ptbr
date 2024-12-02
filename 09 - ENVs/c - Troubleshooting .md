# Troubleshooting de Variáveis de Ambiente (Envs) no Kubernetes

Quando você encontra problemas relacionados a variáveis de ambiente (Envs) em seus contêineres no Kubernetes, o processo de resolução de problemas segue uma abordagem sistemática para identificar a causa raiz. Aqui está um guia detalhado dos passos que você deve seguir para solucionar problemas com variáveis de ambiente no Kubernetes.

## Passos para Troubleshooting de Variáveis de Ambiente

### 1. Verificar o YAML de Definição do Pod ou Deployment

O primeiro passo é verificar se as variáveis de ambiente estão corretamente definidas no manifesto do Pod ou Deployment.

- **Verifique o arquivo YAML**: Certifique-se de que o manifesto YAML do Pod, Deployment, StatefulSet ou Job contém as definições corretas de variáveis de ambiente.
  
  Exemplos de definições corretas de variáveis de ambiente no YAML:

  ```yaml
  env:
    - name: API_URL
      value: "https://api.example.com"
    - name: API_KEY
      valueFrom:
        secretKeyRef:
          name: api-secret
          key: api-key
  ```

- **Erro comum**: Verifique se você está usando a chave correta (e.g., `valueFrom` com `secretKeyRef` ou `configMapKeyRef`) quando as variáveis são provenientes de **Secrets** ou **ConfigMaps**.

### 2. Inspecionar o Pod em Execução

Use o comando `kubectl` para inspecionar o Pod e verificar o status e as variáveis de ambiente ativas.

- **Comando para inspecionar o Pod**:

  ```bash
  kubectl describe pod <pod-name>
  ```

  Isso mostrará os detalhes do Pod, incluindo as variáveis de ambiente que foram atribuídas ao contêiner.

- **Erro comum**: Caso uma variável de ambiente esperada não esteja presente, isso pode indicar um erro de configuração no arquivo YAML ou um problema com o **ConfigMap** ou **Secret** associado.

### 3. Verificar Logs do Contêiner

Às vezes, o problema pode estar ocorrendo dentro da aplicação em execução no contêiner. Verificar os logs do contêiner pode fornecer pistas sobre problemas com variáveis de ambiente.

- **Comando para ver os logs do contêiner**:

  ```bash
  kubectl logs <pod-name>
  ```

- **Erro comum**: Mensagens como "chave de ambiente não encontrada" ou "erro de conexão" podem indicar que uma variável de ambiente essencial não foi configurada corretamente ou que o contêiner não conseguiu acessar o valor esperado.

### 4. Executar Comandos no Contêiner para Inspecionar Variáveis

Você pode executar comandos diretamente no contêiner em execução para verificar as variáveis de ambiente configuradas.

- **Comando para acessar o shell do contêiner**:

  ```bash
  kubectl exec -it <pod-name> -- /bin/sh
  ```

- **Comando para listar as variáveis de ambiente no contêiner**:

  ```bash
  env
  ```

  Isso mostrará todas as variáveis de ambiente disponíveis no contêiner. Verifique se as variáveis esperadas estão presentes e com os valores corretos.

### 5. Verificar a Existência de ConfigMaps e Secrets

Se as variáveis de ambiente forem definidas usando **ConfigMaps** ou **Secrets**, é importante verificar se eles estão corretamente configurados e acessíveis.

- **Verifique se o ConfigMap ou Secret existe**:

  ```bash
  kubectl get configmap <configmap-name>
  kubectl get secret <secret-name>
  ```

  Se o **ConfigMap** ou **Secret** estiver faltando ou estiver com as permissões incorretas, o contêiner não será capaz de acessar os valores esperados.

- **Verifique o conteúdo do ConfigMap ou Secret**:

  ```bash
  kubectl describe configmap <configmap-name>
  kubectl describe secret <secret-name>
  ```

  Isso garantirá que as chaves e valores corretos estão presentes no **ConfigMap** ou **Secret**.

### 6. Conferir Erros nos Eventos do Kubernetes

Além dos logs do contêiner, você pode verificar eventos relacionados ao Pod, que podem apontar problemas com a atribuição de variáveis de ambiente.

- **Comando para verificar eventos**:

  ```bash
  kubectl get events --field-selector involvedObject.name=<pod-name>
  ```

  Isso mostrará quaisquer eventos recentes, como erros de conexão ao tentar usar **Secrets** ou **ConfigMaps**, o que pode explicar por que as variáveis de ambiente não foram configuradas corretamente.

### 7. Verificar as Permissões RBAC

Se o Pod precisar acessar **Secrets** ou **ConfigMaps**, é importante garantir que o Pod tenha as permissões adequadas por meio do **Role-based Access Control (RBAC)**.

- **Verifique o RBAC**: Certifique-se de que o **ServiceAccount** usado pelo Pod tem permissões para acessar o **Secret** ou **ConfigMap** necessário.

  ```bash
  kubectl get rolebinding -n <namespace>
  kubectl get clusterrolebinding
  ```

  Isso pode revelar problemas de permissão que impedem o Pod de acessar os recursos esperados.

### 8. Validar o Agendamento do Pod

Em alguns casos, o Pod pode não estar sendo agendado corretamente, o que impede que ele use variáveis de ambiente do **ConfigMap** ou **Secret**. Verifique se o Pod está sendo agendado em um nó.

- **Verifique o status do Pod**:

  ```bash
  kubectl get pod <pod-name> -o wide
  ```

  Verifique se o Pod está sendo executado ou está travado em um estado como `Pending`.

## Conclusão

Ao seguir estes passos, você será capaz de diagnosticar e resolver a maioria dos problemas relacionados a variáveis de ambiente em contêineres no Kubernetes. Manter uma abordagem sistemática ao troubleshooting, verificando a configuração YAML, inspeção do Pod, logs, e recursos como **ConfigMaps** e **Secrets**, ajuda a isolar e resolver rapidamente os problemas.