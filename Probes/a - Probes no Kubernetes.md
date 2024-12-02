# Probes no Kubernetes

## Introdução

No Kubernetes, **probes** são mecanismos utilizados para verificar a saúde de um contêiner em execução. Eles são usados para garantir que os aplicativos estejam funcionando corretamente e prontos para receber tráfego. Se um contêiner falha em um dos testes realizados pelas probes, o Kubernetes pode executar ações como reiniciar o contêiner ou removê-lo do balanceamento de carga.

Existem três tipos principais de probes no Kubernetes:

1. **Liveness Probe** - Verifica se o contêiner está vivo.
2. **Readiness Probe** - Verifica se o contêiner está pronto para receber tráfego.
3. **Startup Probe** - Verifica se a aplicação dentro do contêiner terminou de inicializar.

Essas probes são configuradas nos manifestos dos Pods, sendo geralmente aplicadas em recursos como **Deployments** ou **StatefulSets**. Elas são executadas periodicamente pelo **Kubelet**, que é o agente responsável por gerenciar os contêineres em cada nó do cluster.

---

## Tipos de Probes

### 1. **Liveness Probe**

A **Liveness Probe** determina se o contêiner está em um estado saudável e funcionando corretamente. Caso a probe falhe, o Kubernetes assume que o contêiner está travado ou em um estado de falha e o reinicia automaticamente.

Isso é útil, por exemplo, para detectar situações onde o aplicativo está em execução, mas não consegue mais responder a solicitações.

#### Exemplo de uso:

- Um aplicativo que entra em deadlock pode ser reiniciado com uma **Liveness Probe**.

#### Métodos Suportados:

- **Exec Command**: Executa um comando no contêiner. Se o comando retornar 0, o contêiner é considerado saudável.
- **HTTP GET**: Envia uma requisição HTTP GET para um endpoint do contêiner. Se a resposta for 200-399, o contêiner é considerado saudável.
- **TCP Socket**: Tenta abrir uma conexão TCP com o contêiner. Se conseguir, o contêiner é considerado saudável.

### 2. **Readiness Probe**

A **Readiness Probe** verifica se o contêiner está pronto para receber tráfego. Se o contêiner não passar no teste de readiness, ele será temporariamente removido do balanceamento de carga até que seja considerado saudável novamente.

Diferente da **Liveness Probe**, a **Readiness Probe** não reinicia o contêiner. Ela apenas informa ao Kubernetes quando um contêiner está apto a processar requisições. Isso é especialmente útil para contêineres que demoram para iniciar ou que precisam carregar dependências externas antes de começar a operar.

#### Exemplo de uso:

- Um serviço que depende de uma conexão com um banco de dados pode usar uma **Readiness Probe** para evitar tráfego antes que a conexão seja estabelecida.

#### Métodos Suportados:

- **Exec Command**
- **HTTP GET**
- **TCP Socket**

### 3. **Startup Probe**

A **Startup Probe** é usada para verificar se o aplicativo foi inicializado corretamente. Se a aplicação demorar muito para iniciar, o Kubernetes pode encerrar o contêiner e tentar reiniciá-lo. Isso é útil para aplicativos que precisam de um tempo maior para inicialização, sem que o Kubernetes marque a aplicação como inativa ou falha.

Se a **Startup Probe** estiver configurada, ela desabilita temporariamente as outras probes (Liveness e Readiness) até que o aplicativo seja inicializado com sucesso. Depois disso, as outras probes voltam a ser ativadas.

#### Exemplo de uso:

- Um sistema que tem um tempo de inicialização prolongado (como um servidor de banco de dados complexo) pode se beneficiar da **Startup Probe**.

#### Métodos Suportados:

- **Exec Command**
- **HTTP GET**
- **TCP Socket**

---

## Configuração de Probes

As probes podem ser configuradas utilizando diferentes parâmetros que controlam seu comportamento, como o tempo de espera antes da execução, o intervalo entre verificações e quantas tentativas falhas são permitidas antes de o contêiner ser reiniciado.

### Parâmetros Comuns:

- **initialDelaySeconds**: Define o tempo de espera antes que a probe seja executada pela primeira vez.
- **periodSeconds**: Intervalo de tempo entre as execuções consecutivas da probe.
- **timeoutSeconds**: Tempo máximo que a probe pode esperar por uma resposta antes de considerar a execução como falha.
- **failureThreshold**: Número de falhas consecutivas permitidas antes de o contêiner ser considerado não saudável.
- **successThreshold**: Número de sucessos consecutivos necessários para que o contêiner seja considerado saudável (usado principalmente em **Readiness Probes**).

---

## Importância das Probes

As probes desempenham um papel crucial na manutenção da saúde e estabilidade dos aplicativos dentro de um cluster Kubernetes. Elas garantem que os contêineres estejam funcionando corretamente e prontos para receber tráfego. Além disso, as probes ajudam o Kubernetes a realizar ações corretivas automaticamente, como reiniciar contêineres que falham ou removê-los temporariamente do balanceamento de carga, evitando indisponibilidade.

A correta configuração das probes pode melhorar significativamente a resiliência dos serviços e prevenir downtime, mesmo em cenários complexos de falhas ou inicializações demoradas.

---

## Conclusão

**Probes** são uma ferramenta poderosa e flexível no Kubernetes para monitorar e gerenciar a saúde dos contêineres. Elas permitem que o Kubernetes tome decisões automatizadas para garantir que os aplicativos estejam sempre disponíveis e funcionando corretamente, desde a inicialização até a operação contínua em um ambiente de produção.

As três probes principais—**Liveness**, **Readiness** e **Startup**—têm diferentes finalidades, mas juntas fornecem um mecanismo robusto para lidar com as necessidades de saúde e disponibilidade de contêineres em qualquer ambiente Kubernetes.
