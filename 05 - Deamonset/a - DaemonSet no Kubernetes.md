#### 1. **Introdução ao DaemonSet**

O **DaemonSet** é um objeto do Kubernetes que garante que uma cópia de um determinado **Pod** seja executada em cada nó de um cluster. O principal objetivo de um DaemonSet é garantir que certas tarefas, como coleta de logs, monitoramento ou outros serviços de infraestrutura, estejam disponíveis em cada nó do cluster, independentemente do seu tamanho ou configuração.

---

#### 2. **Funcionamento do DaemonSet**

Ao criar um DaemonSet, o Kubernetes automaticamente cria um **Pod** em cada nó do cluster. Conforme novos nós são adicionados, o DaemonSet garante que os Pods correspondentes sejam programados nesses novos nós também. Da mesma forma, quando um nó é removido, o Pod associado é deletado.

##### Exemplo de cenários comuns para DaemonSets:

- Execução de agentes de monitoramento como o **Prometheus Node Exporter**.
- Configuração de agentes de coleta de logs, como o **Fluentd**.
- Execução de serviços de rede, como o **Calico** ou o **Weave**.

---

#### 3. **Criação de um DaemonSet**

A definição de um DaemonSet é semelhante à de um **Deployment**, com a diferença de que o DaemonSet se assegura de que exista exatamente um Pod por nó. Abaixo, um exemplo básico de YAML para criar um DaemonSet:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: exemplo-daemonset
spec:
  selector:
    matchLabels:
      app: exemplo-app
  template:
    metadata:
      labels:
        app: exemplo-app
    spec:
      containers:
        - name: exemplo-container
          image: nginx
          ports:
            - containerPort: 80
```

Neste exemplo, o DaemonSet irá garantir que um container **nginx** seja executado em cada nó.

---

#### 4. **Campos Importantes do DaemonSet**

1. **apiVersion**: Define a versão da API usada (neste caso, `apps/v1`).
2. **kind**: Define o tipo de objeto, que é `DaemonSet`.
3. **metadata**: Contém informações como o nome e rótulos do DaemonSet.
4. **spec**: Contém a definição do DaemonSet:
   - **selector**: Define como o DaemonSet identifica os Pods correspondentes.
   - **template**: Descreve o Pod que será executado em cada nó, incluindo contêineres, imagens, portas, etc.

---

#### 5. **Estratégia de Atualização**

O DaemonSet pode ser atualizado de forma controlada, garantindo que a interrupção nos serviços seja mínima. A estratégia de atualização padrão é o **RollingUpdate**, que permite a atualização dos Pods de forma gradual, garantindo que haja sempre um Pod em execução no nó.

##### Exemplo de configuração da estratégia de atualização:

```yaml
updateStrategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 1
```

Neste exemplo, o Kubernetes permite que, no máximo, 1 Pod fique indisponível por vez durante a atualização.

---

#### 6. **Escalonamento de DaemonSets**

Uma característica marcante do DaemonSet é que ele não segue as políticas de escalonamento normais, pois seu objetivo é garantir que haja uma instância do Pod em cada nó. No entanto, há flexibilidade ao configurar para que o DaemonSet seja executado apenas em um subconjunto de nós, utilizando **Node Selectors** ou **Tolerations**.

##### Exemplo de Node Selector:

```yaml
spec:
  template:
    spec:
      nodeSelector:
        diskType: ssd
```

Aqui, o DaemonSet executará Pods apenas nos nós que têm a label `diskType=ssd`.

---

#### 7. **Tolerations e Affinity**

DaemonSets também podem ser configurados para respeitar as características dos nós usando **Tolerations** e **Node Affinity**. Essas configurações permitem que um DaemonSet seja agendado em nós com **taints** específicos ou afinidades configuradas.

##### Exemplo de Toleration:

```yaml
spec:
  template:
    spec:
      tolerations:
        - key: "dedicated"
          operator: "Equal"
          value: "infra"
          effect: "NoSchedule"
```

Isso permite que o DaemonSet seja agendado em nós que têm o taint `dedicated=infra:NoSchedule`.

---

#### 8. **Gerenciamento e Manutenção**

- **kubectl get daemonset**: Para listar todos os DaemonSets no cluster.
- **kubectl describe daemonset [nome]**: Para obter detalhes específicos sobre um DaemonSet.
- **kubectl delete daemonset [nome]**: Para deletar um DaemonSet, o que também removerá os Pods gerenciados por ele.

---

#### 9. **Vantagens do DaemonSet**

- **Eficiência**: Garante que serviços críticos estejam presentes em todos os nós.
- **Escalabilidade**: Se ajusta automaticamente ao adicionar ou remover nós.
- **Facilidade de Gerenciamento**: Simplifica a configuração de agentes que precisam rodar em todos os nós.

---

#### 10. **Limitações do DaemonSet**

- **Sobrecarga**: Em clusters muito grandes, pode gerar uma sobrecarga devido à quantidade de Pods gerados.
- **Complexidade na Atualização**: A atualização de DaemonSets exige cautela, pois pode impactar a execução de serviços críticos no cluster.

---

#### 11. **Conclusão**

O DaemonSet é uma poderosa ferramenta do Kubernetes para garantir a execução de serviços e agentes essenciais em cada nó do cluster, permitindo o gerenciamento centralizado de componentes como monitoramento, coleta de logs e rede. A capacidade de adaptação e a facilidade de uso fazem do DaemonSet uma escolha ideal para garantir a operação eficiente de ambientes Kubernetes.
