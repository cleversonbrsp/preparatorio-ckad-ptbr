# Troubleshooting com Helm

Helm é uma ferramenta poderosa de gerenciamento de pacotes para Kubernetes, facilitando a implantação e o gerenciamento de aplicativos através de "charts". No entanto, em certos casos, você pode enfrentar problemas durante o uso do Helm. Abaixo estão alguns passos fundamentais para realizar troubleshooting com Helm, baseados na documentação oficial do Kubernetes.

## Passo 1: Verifique o Status da Release

Sempre que você enfrentar problemas com uma aplicação implantada via Helm, o primeiro passo é verificar o status da release.

```bash
helm status <release_name>
```

Este comando retorna informações sobre o status da release, incluindo quais recursos foram implantados, se a implantação foi bem-sucedida ou se houve falhas.

## Passo 2: Verifique o Histórico de Releases

Caso tenha ocorrido uma falha após uma atualização ou rollback, é possível investigar o histórico da release usando:

```bash
helm history <release_name>
```

Este comando lista as revisões anteriores, permitindo verificar se houve alguma alteração significativa na configuração da release.

## Passo 3: Debugando os Templates do Chart

Se você suspeita que o problema está nos templates do chart Helm, use o comando `helm template` para renderizar os templates localmente. Isso permite que você visualize os manifests de Kubernetes antes da aplicação ser de fato implantada no cluster:

```bash
helm template <chart_name> --values <values_file>
```

Isso gera os arquivos YAML finais, possibilitando que você identifique erros na estrutura ou valores incorretos.

## Passo 4: Verifique os Logs dos Pods

Muitas vezes, problemas nas aplicações gerenciadas por Helm estão diretamente relacionados ao comportamento dos pods. Use o comando `kubectl` para verificar os logs dos pods que fazem parte da release:

```bash
kubectl logs <pod_name>
```

Se a aplicação utiliza múltiplos containers no mesmo pod, especifique o container que deseja inspecionar:

```bash
kubectl logs <pod_name> -c <container_name>
```

Isso pode ajudar a identificar erros de execução no nível da aplicação.

## Passo 5: Verifique os Eventos do Kubernetes

Outra etapa importante é verificar os eventos relacionados aos recursos que fazem parte da release Helm. O Kubernetes emite eventos para qualquer problema que ocorra com os objetos gerenciados.

```bash
kubectl get events --namespace <namespace>
```

Isso pode ajudar a identificar problemas com agendamento, criação de pods, volumes ou falhas de inicialização.

## Passo 6: Validar ConfigMap e Secret

Se o seu chart Helm utiliza `ConfigMaps` ou `Secrets`, certifique-se de que as configurações foram aplicadas corretamente. Verifique o conteúdo do `ConfigMap` ou `Secret` no namespace correto:

```bash
kubectl get configmap <configmap_name> -o yaml
kubectl get secret <secret_name> -o yaml
```

Confirme se os dados correspondem ao esperado e se as aplicações têm acesso a essas configurações.

## Passo 7: Debugando Erros de Dependências

Se o seu chart Helm tem dependências de outros charts, use o comando `helm dependency list` para verificar as dependências e o status de cada uma:

```bash
helm dependency list <chart_name>
```

Se houver problemas com as dependências, como versões incompatíveis ou dependências ausentes, resolva esses problemas primeiro.

## Passo 8: Rollback de uma Release

Se o problema persistir após uma atualização, pode ser necessário fazer rollback para uma versão anterior da release:

```bash
helm rollback <release_name> <revision_number>
```

Verifique qual revisão foi estável antes do problema ocorrer e faça o rollback. Isso pode rapidamente restaurar o sistema para um estado funcional.

## Passo 9: Verifique as Permissões de Acesso (RBAC)

Muitas vezes, problemas com Helm podem estar relacionados à falta de permissões adequadas para instalar ou modificar recursos no cluster. Verifique as permissões usando o comando abaixo:

```bash
kubectl auth can-i <verb> <resource> --namespace <namespace>
```

Por exemplo, para verificar se o usuário tem permissão para criar um pod:

```bash
kubectl auth can-i create pods --namespace <namespace>
```

Se houver problemas com permissões, ajuste as políticas de RBAC (Role-Based Access Control) no cluster.

## Passo 10: Use o Helm Debug

Se você não conseguiu identificar o problema com os passos anteriores, use o comando `--debug` para ativar o modo de depuração do Helm, que fornece mais detalhes sobre a execução:

```bash
helm install <release_name> <chart_name> --debug --dry-run
```

Isso executa um "dry-run", simulando a instalação sem realmente aplicar as mudanças, permitindo que você veja exatamente o que o Helm está tentando fazer.

## Conclusão

O troubleshooting de Helm envolve uma combinação de ferramentas do próprio Helm e do Kubernetes. Seguindo esses passos de verificação de status, logs, eventos, permissões e templates, você pode identificar e corrigir problemas rapidamente.