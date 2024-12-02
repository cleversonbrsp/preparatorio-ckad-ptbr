# Simulado CKAD - CronJobs

Neste simulado, você enfrentará desafios envolvendo a criação e o gerenciamento de CronJobs no Kubernetes, abordando cenários do mundo real. Todos os exemplos utilizam imagens disponíveis no Docker Hub. Para visualizar as soluções, basta clicar no título de cada desafio.

---

## 1. **Agendamento de Backup Diário**

### Cenário
Você está trabalhando em uma empresa que precisa realizar backups diários do banco de dados. Para isso, deve ser criado um **CronJob** que execute o backup todos os dias às 2:00 da manhã. O backup será feito por meio de um script básico de cópia de arquivos. Utilize a imagem `busybox` do Docker Hub para simular o backup.

- O script de backup apenas imprime a data e uma mensagem dizendo "Backup realizado com sucesso".
- O **CronJob** não deve permitir múltiplas execuções simultâneas.
- O histórico deve armazenar os últimos 3 backups bem-sucedidos e 2 falhos.

<details>
  <summary><strong>Solução - Backup Diário</strong></summary>

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-job
spec:
  schedule: "0 2 * * *"  # Executa todos os dias às 2:00 da manhã
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo "Backup realizado com sucesso"
          restartPolicy: OnFailure
  concurrencyPolicy: Forbid  # Evita múltiplas execuções simultâneas
  successfulJobsHistoryLimit: 3  # Limita histórico de jobs bem-sucedidos
  failedJobsHistoryLimit: 2  # Limita histórico de jobs falhos
```

</details>

---

## 2. **Relatório Semanal de Vendas**

### Cenário
Sua equipe de vendas precisa gerar relatórios semanalmente, sempre às segundas-feiras, às 7:30 da manhã. O **CronJob** será responsável por gerar um arquivo CSV de relatórios de vendas. Para simular a tarefa, use a imagem `busybox`, que imprimirá uma mensagem no formato de um CSV com dados fictícios.

- A saída do comando deve incluir a data, um nome fictício de produto e o total de vendas.
- Configure o **CronJob** para ser executado toda segunda-feira às 7:30 da manhã.
- O job deve ser reiniciado em caso de falha.

<details>
  <summary><strong>Solução - Relatório Semanal de Vendas</strong></summary>

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: vendas-relatorio
spec:
  schedule: "30 7 * * 1"  # Toda segunda-feira às 7:30 da manhã
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: vendas
            image: busybox
            args:
            - /bin/sh
            - -c
            - |
              echo "Data,Produto,Total";
              date; echo "ProdutoX,1000"
          restartPolicy: OnFailure
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 2
```

</details>

---

## 3. **Limpeza de Arquivos Temporários Mensal**

### Cenário
Seu sistema gera muitos arquivos temporários ao longo do mês e você precisa automatizar a limpeza desses arquivos. Um **CronJob** deve ser configurado para executar no primeiro dia de cada mês às 23:00 e remover todos os arquivos temporários localizados no diretório `/tmp`. Use a imagem `busybox` para simular a tarefa.

- A tarefa deve exibir uma mensagem confirmando a remoção dos arquivos temporários.
- O **CronJob** deve ser configurado para rodar no primeiro dia de cada mês às 23:00.

<details>
  <summary><strong>Solução - Limpeza de Arquivos Temporários Mensal</strong></summary>

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: limpeza-temporarios
spec:
  schedule: "0 23 1 * *"  # No primeiro dia de cada mês às 23:00
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: limpeza
            image: busybox
            args:
            - /bin/sh
            - -c
            - echo "Limpando arquivos temporários do /tmp"
          restartPolicy: OnFailure
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 2
```

</details>

---

## 4. **Notificação de Serviço Diária**

### Cenário
Você precisa enviar uma notificação todos os dias às 8:00 da manhã sobre o status de um serviço interno. Para este desafio, crie um **CronJob** que simule o envio de uma notificação ao exibir uma mensagem simples na linha de comando usando a imagem `busybox`.

- O **CronJob** deve ser executado todos os dias às 8:00 da manhã.
- A mensagem deve ser "Serviço funcionando corretamente" seguida da data e hora da execução.

<details>
  <summary><strong>Solução - Notificação de Serviço Diária</strong></summary>

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: servico-notificacao
spec:
  schedule: "0 8 * * *"  # Todos os dias às 8:00 da manhã
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: notificacao
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo "Serviço funcionando corretamente"
          restartPolicy: OnFailure
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 2
```

</details>

---

## 5. **Limpeza de Logs a Cada 2 Horas**

### Cenário
Em um sistema de produção, os logs podem se acumular rapidamente. Você precisa configurar um **CronJob** para executar a cada 2 horas e limpar arquivos de log armazenados no diretório `/var/log/app`. Simule a tarefa usando a imagem `busybox`.

- O comando deve imprimir "Limpando logs do sistema" e a data/hora da execução.
- O **CronJob** deve ser configurado para rodar a cada 2 horas.

<details>
  <summary><strong>Solução - Limpeza de Logs a Cada 2 Horas</strong></summary>

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: limpeza-logs
spec:
  schedule: "0 */2 * * *"  # A cada 2 horas
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: limpeza-logs
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo "Limpando logs do sistema"
          restartPolicy: OnFailure
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 2
```

</details>

---

Esses desafios cobrem situações reais que você pode enfrentar ao lidar com **CronJobs** no Kubernetes. Eles são um exemplo de como o exame CKAD pode testar sua capacidade de configurar, monitorar e otimizar esses recursos em ambientes de produção.