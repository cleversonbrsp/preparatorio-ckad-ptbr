### Simulado CKAD: **DaemonSet** – Nível Básico

---

#### Desafio 1: **Implantação de um Agente de Coleta de Logs**

##### Contexto:

A empresa em que você trabalha está implementando um sistema centralizado de coleta de logs para todos os nós de um cluster Kubernetes. Foi decidido usar o **Fluentd** para realizar essa coleta. O objetivo é garantir que cada nó tenha um agente do Fluentd em execução, que será responsável por coletar os logs locais e enviá-los para um serviço externo de agregação de logs.

##### Tarefa:

Crie um **DaemonSet** chamado `fluentd-logs` que executa a imagem `fluent/fluentd:v1.12.3`. O DaemonSet deve garantir que haja uma instância do Fluentd em execução em cada nó do cluster. Garanta também que a porta `24224` do container esteja exposta para comunicação externa.

- Nome do DaemonSet: `fluentd-logs`
- Imagem: `fluent/fluentd:v1.12.3`
- Porta: `24224`

<details>
  <summary><strong>Ver solução</strong></summary>

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd-logs
spec:
  selector:
    matchLabels:
      app: fluentd
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      containers:
        - name: fluentd
          image: fluent/fluentd:v1.12.3
          ports:
            - containerPort: 24224
```

</details>

---

#### Desafio 2: **Execução de Serviços de Rede com DaemonSet**

##### Contexto:

Seu time de SRE está configurando o networking do Kubernetes em um novo cluster de produção. Para isso, foi escolhido o **Calico** como o provedor de rede, que deve ser implantado como um **DaemonSet**. Seu trabalho é criar um DaemonSet que implemente o serviço de rede **Calico** em cada nó do cluster para gerenciar as políticas de rede e permitir a comunicação entre Pods.

##### Tarefa:

Crie um **DaemonSet** chamado `calico-networking` que execute a imagem `calico/node:v3.19`. Esse DaemonSet será responsável por garantir que o agente de rede Calico esteja em execução em todos os nós.

- Nome do DaemonSet: `calico-networking`
- Imagem: `calico/node:v3.19`

<details>
  <summary><strong>Ver solução</strong></summary>

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: calico-networking
spec:
  selector:
    matchLabels:
      app: calico
  template:
    metadata:
      labels:
        app: calico
    spec:
      containers:
        - name: calico
          image: calico/node:v3.19
```

</details>

---

#### Desafio 3: **Implantação Condicional de um DaemonSet com Node Selector**

##### Contexto:

Em um cluster Kubernetes, existem nós com diferentes tipos de armazenamento. Alguns possuem discos SSD, enquanto outros utilizam HDDs. O time de DevOps deseja que o agente de monitoramento **Prometheus Node Exporter** seja executado somente nos nós que possuem discos SSD, para evitar sobrecarga nos nós de HDD.

##### Tarefa:

Crie um **DaemonSet** chamado `ssd-node-monitor` que execute a imagem `prom/node-exporter:v1.0.1`. O DaemonSet deve ser implantado apenas em nós que possuem o rótulo `diskType=ssd`.

- Nome do DaemonSet: `ssd-node-monitor`
- Imagem: `prom/node-exporter:v1.0.1`
- Node Selector: `diskType=ssd`

<details>
  <summary><strong>Ver solução</strong></summary>

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ssd-node-monitor
spec:
  selector:
    matchLabels:
      app: node-monitor
  template:
    metadata:
      labels:
        app: node-monitor
    spec:
      containers:
        - name: node-exporter
          image: prom/node-exporter:v1.0.1
      nodeSelector:
        diskType: ssd
```

</details>

---

#### Desafio 4: **Tolerations no DaemonSet para Nós Reservados**

##### Contexto:

Alguns nós no seu cluster Kubernetes são reservados para workloads críticos de infraestrutura e possuem um **taint** específico que impede a execução de Pods regulares. Esses nós utilizam o taint `critical-infra=true:NoSchedule`. O time de operações precisa garantir que um DaemonSet seja implantado nesses nós críticos para monitorar seu desempenho.

##### Tarefa:

Crie um **DaemonSet** chamado `infra-monitor` que execute a imagem `monitoring/agent:v2.3.4`. O DaemonSet deve ser configurado para tolerar o taint `critical-infra=true:NoSchedule`, garantindo que os Pods sejam agendados nos nós com esse taint.

- Nome do DaemonSet: `infra-monitor`
- Imagem: `monitoring/agent:v2.3.4`
- Toleration: `critical-infra=true:NoSchedule`

<details>
  <summary><strong>Ver solução</strong></summary>

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: infra-monitor
spec:
  selector:
    matchLabels:
      app: infra-monitor
  template:
    metadata:
      labels:
        app: infra-monitor
    spec:
      containers:
        - name: monitoring-agent
          image: monitoring/agent:v2.3.4
      tolerations:
        - key: "critical-infra"
          operator: "Equal"
          value: "true"
          effect: "NoSchedule"
```

</details>
