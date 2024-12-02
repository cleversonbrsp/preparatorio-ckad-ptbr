Você está trabalhando como DevOps em uma empresa de e-commerce que utiliza microserviços para oferecer diferentes funcionalidades, como gerenciamento de produtos, carrinho de compras e sistemas de pagamento. Recentemente, o time de desenvolvimento entregou uma nova versão do serviço de **Catálogo de Produtos**, e sua responsabilidade é fazer o deploy dessa nova versão no cluster Kubernetes.

Esse serviço é fundamental para o negócio, pois qualquer indisponibilidade pode impactar diretamente as vendas. Portanto, o processo de atualização deve ser realizado de maneira **segura**, garantindo que sempre existam instâncias saudáveis em execução e que o novo serviço seja verificado antes de começar a receber tráfego.

Além disso, você deve garantir que o serviço escale automaticamente durante picos de acesso, aumentando o número de réplicas conforme a demanda.

---

### Objetivo do Exercício

1. **Criar um Deployment** chamado `catalogue-service` com **três réplicas** da versão `1.0.0` da aplicação `product-catalogue`, rodando na porta 8080.
2. Configurar uma **readiness probe** e uma **liveness probe** para garantir que os Pods estejam saudáveis antes de receber tráfego e que o Kubernetes reinicie os Pods em caso de falha.

3. Configurar o Deployment para **escalar automaticamente** o número de réplicas quando a utilização de CPU ultrapassar 50%.

4. **Atualizar o Deployment** para a versão `2.0.0` da aplicação, garantindo que o serviço não sofra interrupções (downtime).

---

### Requisitos

- O nome do Deployment deve ser `catalogue-service`.
- O aplicativo roda a imagem `product-catalogue` na versão `1.0.0`.
- O serviço deve ter **três réplicas** inicialmente.
- O contêiner deve expor a porta `8080`.
- Configure uma **readiness probe** para verificar o caminho `/ready` no serviço.
- Configure uma **liveness probe** para verificar o caminho `/healthz` e reiniciar o Pod quando necessário.
- O Deployment deve escalar automaticamente se o uso de CPU ultrapassar **50%**.
- Atualize o Deployment para a versão `2.0.0`, garantindo **zero downtime** durante o processo de atualização.

---

### Dicas

- Consulte a [documentação oficial do Kubernetes](https://kubernetes.io/docs/home/) para configurar as probes, autoescalonamento e atualizar o Deployment sem interrupção.
- Use boas práticas para garantir que o serviço continue disponível durante a atualização e configure as verificações de saúde adequadamente para evitar downtime.

---

### Conclusão

Este simulado visa recriar um cenário real do exame **CKAD**, onde você precisará implementar um **Deployment** completo, configurar probes para garantir a saúde dos Pods, configurar escalonamento automático e gerenciar atualizações sem causar interrupções no serviço.
