# CronJobs no Kubernetes

### Introdução
Um **CronJob** no Kubernetes permite agendar a execução de tarefas periódicas. Ele é similar aos **Jobs**, mas é executado em intervalos de tempo especificados, como tarefas agendadas em sistemas Unix utilizando o cron. O **CronJob** cria automaticamente **Jobs** de acordo com o cronograma configurado, e cada Job, por sua vez, gera um ou mais Pods que realizam a tarefa.

Os **CronJobs** são amplamente usados em casos como:
- Execução de backups periódicos.
- Envio de relatórios.
- Limpeza regular de logs ou arquivos temporários.
  
---

### Conceitos Básicos

#### Estrutura de um CronJob
A estrutura de um CronJob é semelhante a de um Job, mas inclui um campo de agendamento adicional para definir a periodicidade de execução.

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: exemplo-cronjob
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: exemplo-container
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo "Executando CronJob"
          restartPolicy: OnFailure
```

Nesta estrutura:
- **schedule**: Define o cronograma de execução no formato cron (minutos, horas, dias do mês, meses, dias da semana).
- **jobTemplate**: Descreve o template do Job que será criado a cada execução do CronJob.
- **restartPolicy**: Configura a política de reinício dos Pods criados pelo Job (geralmente `OnFailure` ou `Never` para CronJobs).

---

### Campos Importantes

#### `schedule`
O campo `schedule` define quando o CronJob será executado. Ele segue a sintaxe de agendamento padrão do cron:
```
*    *    *    *    *
|    |    |    |    |
|    |    |    |    +---- Dia da semana (0–7) (Domingo=0 ou 7)
|    |    |    +--------- Mês (1–12)
|    |    +-------------- Dia do mês (1–31)
|    +------------------- Hora (0–23)
+------------------------ Minuto (0–59)
```
Exemplos de valores comuns para `schedule`:
- `"*/5 * * * *"`: Executa a cada 5 minutos.
- `"0 0 * * *"`: Executa diariamente à meia-noite.
- `"0 12 * * 1-5"`: Executa ao meio-dia de segunda a sexta-feira.

#### `concurrencyPolicy`
Controla como lidar com múltiplas execuções do mesmo Job:
- `Allow` (padrão): Permite múltiplas execuções simultâneas.
- `Forbid`: Não permite que novas execuções comecem se uma execução anterior ainda estiver em andamento.
- `Replace`: Mata a execução anterior antes de iniciar uma nova.

#### `startingDeadlineSeconds`
Especifica o tempo (em segundos) que o Kubernetes tem para iniciar um Job se ele foi perdido por algum motivo. Se um Job não puder ser iniciado nesse prazo, ele será ignorado.

#### `successfulJobsHistoryLimit` e `failedJobsHistoryLimit`
Controlam quantos Jobs bem-sucedidos ou falhos devem ser mantidos no histórico. Um valor padrão razoável é `3`, mas você pode ajustar isso conforme suas necessidades.

#### `suspend`
Permite pausar a execução do CronJob. Quando `true`, nenhum Job será criado até que o valor seja alterado para `false`.

---

### Funcionamento Interno

- **Agendamento**: Quando você cria um CronJob, o controlador do CronJob utiliza o valor do campo `schedule` para calcular quando o Job deverá ser iniciado.
- **Criação de Jobs**: No momento do agendamento, o CronJob cria um novo Job, que por sua vez gera um ou mais Pods para realizar a tarefa. O Job resultante se comporta exatamente como um Job comum no Kubernetes.
- **Persistência de Jobs**: O Kubernetes mantém um histórico dos Jobs criados por um CronJob, conforme os valores definidos nos campos `successfulJobsHistoryLimit` e `failedJobsHistoryLimit`.

---

### Boas Práticas e Considerações

1. **Controle de Concurrency**:
   Use `concurrencyPolicy` para evitar a execução simultânea de Jobs, principalmente se as execuções podem consumir muitos recursos ou causar conflitos.

2. **Limites de Histórico**:
   Sempre configure os campos `successfulJobsHistoryLimit` e `failedJobsHistoryLimit` para evitar acúmulo excessivo de Jobs antigos no cluster.

3. **BackoffLimit**:
   No template de Jobs, é possível configurar o campo `backoffLimit`, que define quantas vezes um Pod pode falhar antes que o Kubernetes desista de tentar executá-lo novamente.

4. **Erros de Agendamento**:
   Caso o controlador do CronJob perca uma execução programada (por exemplo, se o cluster estiver inativo), o campo `startingDeadlineSeconds` pode ser útil para especificar um limite de tempo para tentar iniciar a tarefa novamente.

5. **Monitoramento**:
   Utilize ferramentas de monitoramento como o **Prometheus** para rastrear o sucesso ou falha dos CronJobs. Isso garante que qualquer falha possa ser detectada e corrigida rapidamente.

6. **TTL para Limpar Jobs Concluídos**:
   Para evitar que Jobs antigos se acumulem, utilize o campo `ttlSecondsAfterFinished` para que os Jobs sejam automaticamente removidos após a conclusão.

---

### Exemplo Completo de um CronJob

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-job
spec:
  schedule: "0 1 * * *"  # Executa todos os dias à 1:00 da manhã
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup-container
            image: my-backup-image
            args:
            - /backup-script.sh
          restartPolicy: OnFailure
  concurrencyPolicy: "Forbid"
  successfulJobsHistoryLimit: 5
  failedJobsHistoryLimit: 2
  startingDeadlineSeconds: 3600
```

Neste exemplo:
- O CronJob `backup-job` executa um script de backup diariamente às 1:00 da manhã.
- Ele utiliza uma política de `Forbid` para evitar múltiplas execuções simultâneas.
- Mantém um histórico de até 5 Jobs bem-sucedidos e 2 falhos.
- Se o Job não puder iniciar em até 1 hora após o horário agendado, ele será ignorado.

---

### Conclusão
Os **CronJobs** no Kubernetes são uma maneira poderosa de automatizar tarefas periódicas no cluster. Eles fornecem flexibilidade através de várias opções de configuração, como controle de concorrência, limites de histórico e manejo de falhas. Seguir boas práticas, como limitar o número de Jobs no histórico e monitorar suas execuções, garante que seu cluster permaneça saudável e eficiente ao lidar com tarefas agendadas.