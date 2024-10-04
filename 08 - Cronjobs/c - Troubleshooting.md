# Troubleshooting de CronJobs no Kubernetes

Quando você enfrenta problemas com **CronJobs** no Kubernetes, há um processo sistemático que você pode seguir para diagnosticar e resolver a maioria dos problemas. Abaixo estão os passos recomendados para realizar o troubleshooting de **CronJobs**, conforme a documentação oficial do Kubernetes.

## 1. **Verificar o Agendamento do CronJob**
A primeira etapa ao diagnosticar problemas com um **CronJob** é verificar se ele está agendado corretamente. Isso pode ser feito inspecionando o objeto do **CronJob** para garantir que a sintaxe do cron esteja correta.

### Comando:
```bash
kubectl get cronjob <cronjob-name> -o yaml
```

### Verificar o campo `schedule`
No manifesto YAML, verifique se o valor do campo `schedule` está definido corretamente. Lembre-se de que a sintaxe segue o padrão cron, no formato `MIN HORA DIA_MÊS MÊS DIA_SEMANA`.

### Exemplo:
```yaml
spec:
  schedule: "0 2 * * *"  # Executa todos os dias às 2:00 AM
```

### Problemas comuns:
- Erros de sintaxe na expressão cron.
- Configurações de horários que não correspondem à expectativa do usuário.

## 2. **Inspecionar o Histórico de Execuções**
Por padrão, os **CronJobs** mantêm um histórico dos últimos `successfulJobsHistoryLimit` e `failedJobsHistoryLimit`. Se o **CronJob** não está executando corretamente, você pode precisar verificar o histórico de execuções de **Jobs**.

### Comando:
```bash
kubectl get jobs --selector=job-name=<cronjob-name> --namespace=<namespace>
```

Isso listará todos os **Jobs** criados pelo **CronJob**. Verifique se os **Jobs** foram gerados de acordo com o cron.

### Problemas comuns:
- O **CronJob** não cria **Jobs** conforme esperado.
- Jobs falham logo após serem criados.

## 3. **Verificar Logs do Job**
Se um **Job** foi criado pelo **CronJob**, mas falhou ou está pendente, inspecione os logs do pod associado ao **Job**. Isso ajudará a identificar erros no script ou no comando que está sendo executado pelo **Job**.

### Comando:
```bash
kubectl logs <pod-name>
```

### Problemas comuns:
- Erros no script ou comando executado pelo **Job**.
- Problemas relacionados à imagem do contêiner (como imagens ausentes ou falhas na execução).

## 4. **Inspecionar o Manifesto do CronJob**
Além do agendamento, existem outras configurações no manifesto YAML que podem causar problemas:

- **ConcurrencyPolicy**: Define se múltiplos **Jobs** podem ser executados simultaneamente (`Allow`, `Forbid`, ou `Replace`).
- **StartingDeadlineSeconds**: Se um **CronJob** falha ao ser agendado dentro deste limite de tempo, ele será perdido.
- **SuccessfulJobsHistoryLimit** e **FailedJobsHistoryLimit**: Controlam quantos **Jobs** bem-sucedidos ou falhos devem ser mantidos no histórico.

### Exemplo:
```yaml
spec:
  concurrencyPolicy: Forbid  # Evita múltiplas execuções simultâneas
  startingDeadlineSeconds: 200  # Limita o tempo de início para o Job
```

### Problemas comuns:
- O **CronJob** não inicia devido à configuração de `startingDeadlineSeconds`.
- A política de concorrência impede execuções simultâneas, resultando em **Jobs** que não são criados conforme o esperado.

## 5. **Verificar Erros de Job Pendente ou Falho**
Se o **Job** está com status `Pending` ou `Failed`, você pode verificar os eventos associados ao **Job** ou ao pod para entender melhor o que está ocorrendo.

### Comando:
```bash
kubectl describe job <job-name>
```

Este comando mostra informações detalhadas sobre o **Job**, incluindo eventos e problemas como falta de recursos ou erros de imagem.

### Problemas comuns:
- Falta de recursos, como CPU ou memória, impedindo a execução do **Job**.
- O contêiner não consegue puxar a imagem do Docker Hub, resultando em falhas de execução.

## 6. **Verificar Recursos e Limitações do Cluster**
Alguns problemas de **CronJobs** podem estar relacionados a limitações de recursos no cluster. Verifique se há recursos suficientes (CPU, memória, etc.) disponíveis no cluster para executar o **CronJob**.

### Comando:
```bash
kubectl top nodes
```

Isso exibirá o uso de recursos no cluster, o que pode ajudar a identificar se os nós estão sobrecarregados.

### Problemas comuns:
- Nós do cluster sem capacidade para executar novos **Jobs**.
- Limitações de cotas de recursos impedindo o agendamento dos **Jobs**.

## 7. **Verificar Logs do Controlador do CronJob**
Se nenhuma das etapas anteriores resolver o problema, pode ser útil verificar os logs do controlador do **CronJob** no plano de controle do Kubernetes. Isso pode fornecer insights adicionais sobre o que está impedindo o **CronJob** de funcionar corretamente.

### Comando:
```bash
kubectl logs -n kube-system <cronjob-controller-pod>
```

### Problemas comuns:
- Problemas com o controlador do **CronJob** que não estão visíveis no nível do namespace ou do pod.

## Conclusão
O troubleshooting de **CronJobs** no Kubernetes envolve uma abordagem sistemática de inspeção de agendamentos, histórico de execuções, logs de pods e verificação de eventos e recursos do cluster. Seguir esses passos permite identificar rapidamente a causa raiz do problema e aplicar as correções necessárias para garantir que o **CronJob** funcione conforme o esperado.

