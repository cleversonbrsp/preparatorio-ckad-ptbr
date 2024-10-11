# Helm no Kubernetes

## O que é o Helm?

Helm é uma ferramenta de gerenciamento de pacotes para Kubernetes, permitindo definir, instalar e atualizar aplicações Kubernetes. Ele facilita a automação do gerenciamento de recursos complexos no cluster, organizando-os em pacotes chamados **charts**.

Um **Helm chart** é um pacote contendo todas as definições de recursos necessárias para rodar uma aplicação no Kubernetes. Ele pode conter arquivos de configuração, templates para os manifestos YAML e metadados adicionais para facilitar o uso e a distribuição.

## Benefícios do Helm

1. **Gestão de Aplicações Complexas**: Helm simplifica o processo de implantação e atualização de aplicações, agrupando recursos complexos em pacotes reutilizáveis (charts).
2. **Versionamento**: Helm suporta o versionamento de charts, permitindo a reversão para versões anteriores em caso de falhas.
3. **Templates Dinâmicos**: Com o Helm, você pode usar templates com parâmetros variáveis para gerar arquivos YAML dinâmicos, permitindo configurar diferentes ambientes (produção, desenvolvimento, etc.) sem a necessidade de editar diretamente os manifestos.
4. **Repositórios de Charts**: Helm oferece a capacidade de armazenar charts em repositórios públicos ou privados, facilitando o compartilhamento e a reutilização de definições de recursos.
5. **Rollbacks**: Caso uma atualização cause problemas, é possível realizar rollbacks rápidos para versões anteriores da aplicação.

## Conceitos Principais

### Charts

Os **charts** são o principal conceito no Helm. Eles representam um pacote de uma aplicação Kubernetes contendo os recursos necessários. Um chart consiste dos seguintes componentes:

- **Chart.yaml**: Arquivo de metadados do chart, que contém informações como nome, versão e descrição do pacote.
- **values.yaml**: Arquivo de valores padrão usado para preencher os templates.
- **templates/**: Diretório onde estão os arquivos YAML que definem os recursos Kubernetes, mas que são escritos de forma dinâmica para permitir substituições com valores do `values.yaml`.
- **NOTES.txt**: Opcional. Contém instruções pós-instalação ou mensagens que serão exibidas após a execução do chart.

### Releases

Uma **release** é uma instância de um chart instalado em um cluster Kubernetes. Sempre que um chart é instalado, o Helm cria uma release, permitindo que múltiplas instâncias de uma aplicação sejam gerenciadas com base no mesmo chart.

### Repositórios de Charts

Helm permite armazenar e recuperar charts em **repositórios**, que são coleções organizadas de charts, muito similares aos repositórios de pacotes usados por sistemas de gerenciamento de pacotes como apt ou yum.

### Valores e Configurações

Os valores são parâmetros definidos em arquivos `values.yaml` ou diretamente na linha de comando (`--set`), que podem personalizar a configuração de uma aplicação sem a necessidade de modificar diretamente os manifestos YAML.

## Como o Helm Funciona?

1. **Instalação**: Para instalar um chart, o Helm faz o download do pacote do repositório e, em seguida, aplica os templates YAML no cluster Kubernetes, gerando a release. 
   
   Exemplo:
   ```bash
   helm install my-release stable/mysql
   ```

2. **Atualização**: Se for necessário alterar alguma configuração ou atualizar a versão da aplicação, o Helm possibilita atualizar a release. Ele calculará a diferença e aplicará as mudanças necessárias no cluster.

   Exemplo:
   ```bash
   helm upgrade my-release stable/mysql --set mysqlUser=admin
   ```

3. **Rollback**: Caso algo dê errado após uma atualização, o Helm oferece um rollback fácil para versões anteriores da release.

   Exemplo:
   ```bash
   helm rollback my-release 1
   ```

4. **Uninstall**: Para remover uma release, o Helm deleta todos os recursos associados ao chart.

   Exemplo:
   ```bash
   helm uninstall my-release
   ```

## Estrutura de um Chart

Abaixo está a estrutura de diretórios comum encontrada em um chart do Helm:

```plaintext
mychart/
  Chart.yaml          # Metadados do chart
  values.yaml         # Valores padrão
  charts/             # Charts dependentes (subcharts)
  templates/          # Diretório com arquivos de templates YAML
    deployment.yaml   # Exemplo de manifesto Deployment
    service.yaml      # Exemplo de manifesto Service
    _helpers.tpl      # Funções auxiliares para os templates
  NOTES.txt           # Instruções de pós-instalação
```

### Arquivo Chart.yaml

O `Chart.yaml` contém os metadados do chart, como nome, versão e descrição. Um exemplo:

```yaml
apiVersion: v2
name: mychart
description: Um chart Helm para o Kubernetes
version: 0.1.0
appVersion: 1.0.0
```

### Arquivo values.yaml

O `values.yaml` contém valores padrão para preencher os templates. Esses valores podem ser sobrescritos pelo usuário no momento da instalação ou upgrade.

```yaml
replicaCount: 2
image:
  repository: nginx
  tag: 1.16
service:
  type: ClusterIP
  port: 80
```

### Templates

O diretório `templates/` contém arquivos de manifesto YAML que serão processados pelo Helm. Esses arquivos podem ser templates com variáveis que são substituídas pelos valores definidos no `values.yaml` ou pelo comando `--set`.

Exemplo de um template de Deployment (`deployment.yaml`):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-nginx
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}-nginx
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-nginx
    spec:
      containers:
      - name: nginx
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        ports:
        - containerPort: 80
```

### Helpers

Helm permite o uso de funções auxiliares em arquivos `.tpl` que podem ser reutilizados em diferentes partes do chart.

Exemplo de arquivo `_helpers.tpl`:

```yaml
{{- define "mychart.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end -}}
```

Isso pode ser usado no template principal assim:

```yaml
metadata:
  name: {{ include "mychart.fullname" . }}
```

## Gestão de Dependências

O Helm também suporta a inclusão de charts dependentes. Isso é especialmente útil ao trabalhar com aplicações complexas que precisam de outros serviços, como bancos de dados ou sistemas de cache.

Dependências podem ser definidas no arquivo `Chart.yaml` e gerenciadas usando o comando `helm dependency`.

Exemplo de dependência no `Chart.yaml`:

```yaml
dependencies:
  - name: mysql
    version: 1.6.2
    repository: https://charts.helm.sh/stable
```

## Helm 3

A partir do Helm 3, diversas melhorias foram introduzidas em comparação com o Helm 2, como:

- **Remoção do Tiller**: O Helm 3 não depende mais do Tiller, simplificando a segurança e a integração com clusters Kubernetes.
- **Namespace Scoped Releases**: As releases agora são vinculadas a namespaces, melhorando a organização.
- **Melhor Integração com RBAC**: Com a remoção do Tiller, o Helm 3 se integra melhor ao modelo de permissões RBAC do Kubernetes.

## Conclusão

O Helm é uma ferramenta poderosa e flexível para gerenciar pacotes de aplicações no Kubernetes. Ele facilita o processo de implantação, atualização e remoção de aplicações, além de permitir automação e reuso através de charts e templates dinâmicos. Ao usar o Helm, você pode reduzir a complexidade na gestão de recursos Kubernetes e melhorar a eficiência do ciclo de vida das suas aplicações.