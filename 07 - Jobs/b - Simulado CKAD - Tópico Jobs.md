### Simulado CKAD - Tópico: Jobs

---

#### **Desafio 1: Processamento de Pedidos de Compra**

**Contexto:**

Sua empresa administra uma plataforma de e-commerce, e todas as noites os pedidos precisam ser processados e enviados para o sistema de faturamento. Este processo deve ser executado uma vez por dia, onde um script específico processa a fila de pedidos.

Você precisa criar um **Job** no Kubernetes para processar esses pedidos de compra. Certifique-se de que o Job seja executado até a conclusão com sucesso e defina um limite de tentativas em caso de falha.

**Tarefa:**

- Crie um Job chamado `processar-pedidos`.
- Utilize a imagem `processador-pedidos:2.0`.
- O script a ser executado é `/bin/processar.sh`.
- O Job deve ter no máximo 4 tentativas de execução em caso de falhas.
- Verifique o status de execução e a conclusão do Job.

<details>
  <summary><strong>Clique para ver a solução</strong></summary>

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: processar-pedidos
spec:
  backoffLimit: 4
  template:
    spec:
      containers:
      - name: processador
        image: processador-pedidos:2.0
        command: ["/bin/sh", "-c", "/bin/processar.sh"]
      restartPolicy: Never
```

- O campo `backoffLimit: 4` define que o Job tentará até quatro vezes em caso de falha.
- O Job executa o script `/bin/processar.sh` no container `processador`.

Verifique o status do Job com:

```bash
kubectl get jobs
```

</details>

---

#### **Desafio 2: Migração de Banco de Dados**

**Contexto:**

Você está gerenciando uma aplicação que passa por atualizações frequentes de seu banco de dados. Para aplicar essas atualizações, um script de migração precisa ser executado, o que ocorre apenas uma vez sempre que uma nova versão do aplicativo é lançada.

Crie um Job no Kubernetes que execute o script de migração no banco de dados.

**Tarefa:**

- Crie um Job chamado `migra-banco` no namespace `database`.
- Utilize a imagem `db-migrator:1.0`.
- O comando de migração é `db-migrate.sh`.
- O Job deve ser configurado para excluir automaticamente os Pods após 120 segundos da conclusão.
  
<details>
  <summary><strong>Clique para ver a solução</strong></summary>

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: migra-banco
  namespace: database
spec:
  ttlSecondsAfterFinished: 120
  template:
    spec:
      containers:
      - name: migrator
        image: db-migrator:1.0
        command: ["sh", "-c", "db-migrate.sh"]
      restartPolicy: Never
```

- O campo `ttlSecondsAfterFinished: 120` define que o Pod será removido 120 segundos após a conclusão do Job.
- O script `db-migrate.sh` realiza a migração do banco de dados.

</details>

---

#### **Desafio 3: Processamento de Dados em Lote**

**Contexto:**

Uma vez por semana, sua equipe precisa processar grandes volumes de dados em lote. Esse processamento pode ser feito de forma paralela, onde cada parte do lote é processada por uma réplica separada.

Você deve criar um Job paralelo que execute múltiplos Pods em paralelo para processar partes dos dados simultaneamente.

**Tarefa:**

- Crie um Job chamado `processa-lote` no namespace `dados`.
- Use a imagem `data-processor:latest`.
- O comando para processar é `data-process.sh`.
- O Job deve processar o lote utilizando 5 réplicas paralelas.
  
<details>
  <summary><strong>Clique para ver a solução</strong></summary>

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: processa-lote
  namespace: dados
spec:
  parallelism: 5
  completions: 5
  template:
    spec:
      containers:
      - name: processor
        image: data-processor:latest
        command: ["sh", "-c", "data-process.sh"]
      restartPolicy: Never
```

- O campo `parallelism: 5` define que 5 Pods serão executados simultaneamente.
- O Job é considerado completo após as 5 réplicas terminarem sua execução.

</details>

---

#### **Desafio 4: Geração de Relatórios Financeiros**

**Contexto:**

Sua equipe gera relatórios financeiros mensais baseados em um grande volume de dados. Este processo não precisa ser contínuo, mas deve ser executado uma vez por mês para garantir que os relatórios estejam atualizados.

Crie um Job que execute a geração desses relatórios, garantindo que ele seja reiniciado até sua conclusão em caso de falhas.

**Tarefa:**

- Crie um Job chamado `gera-relatorios` no namespace `financeiro`.
- Use a imagem `report-generator:3.2`.
- O comando para gerar os relatórios é `generate-report.sh`.
- Defina o limite de tentativas para 2.
  
<details>
  <summary><strong>Clique para ver a solução</strong></summary>

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: gera-relatorios
  namespace: financeiro
spec:
  backoffLimit: 2
  template:
    spec:
      containers:
      - name: report-generator
        image: report-generator:3.2
        command: ["sh", "-c", "generate-report.sh"]
      restartPolicy: Never
```

- O campo `backoffLimit: 2` garante que o Job tentará novamente até duas vezes em caso de falha.
- O Job executa o comando `generate-report.sh` para gerar os relatórios financeiros.

</details>

---

#### **Desafio 5: Backup de Banco de Dados**

**Contexto:**

Sua equipe precisa realizar backups do banco de dados todas as noites. O backup deve ser feito por meio de um Job no Kubernetes, que faz o dump do banco de dados para uma unidade de armazenamento externo.

Crie o Job que realiza o backup do banco de dados diariamente, executando um script para fazer o dump dos dados.

**Tarefa:**

- Crie um Job chamado `backup-banco` no namespace `backup`.
- Utilize a imagem `db-backup:1.0`.
- O comando para realizar o backup é `backup.sh`.
- Defina o Job para ser executado com 2 tentativas em caso de falhas.
  
<details>
  <summary><strong>Clique para ver a solução</strong></summary>

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: backup-banco
  namespace: backup
spec:
  backoffLimit: 2
  template:
    spec:
      containers:
      - name: db-backup
        image: db-backup:1.0
        command: ["sh", "-c", "backup.sh"]
      restartPolicy: Never
```

- O campo `backoffLimit: 2` define que o Job tentará até duas vezes em caso de falha.
- O script `backup.sh` realiza o dump do banco de dados.

</details>

---

### Fim do Simulado