### Troubleshooting

Output:

```bash
Error: short-name "nginx" did not resolve to an alias and no unqualified-search registries are defined in "/etc/containers/registries.conf"
```

Esse erro ocorre porque o **Podman** não conseguiu resolver o nome da imagem `nginx`, pois não há registros de busca definidos no arquivo de configuração `/etc/containers/registries.conf`.

Para resolver isso, você pode usar o nome completo da imagem, referenciando o repositório oficial do Docker Hub. Experimente rodar o seguinte comando:

```bash
podman run -d --name nginx-rootless -p 8080:80 docker.io/library/nginx:latest
```

Se o problema persistir, verifique ou adicione os repositórios de busca (registries) no arquivo `/etc/containers/registries.conf`. Aqui está como você pode fazer isso:

1. Abra o arquivo de configuração com um editor de texto (por exemplo, o `nano`):

   ```bash
   sudo nano /etc/containers/registries.conf
   ```

2. Procure a seção `[registries.search]` e adicione o Docker Hub como um registro de busca, caso não esteja lá:

   ```
   [registries.search]
   registries = ['docker.io']
   ```

3. Salve o arquivo e saia do editor. Em seguida, tente novamente o comando para rodar o Nginx:

```bash
podman run -d --name nginx-rootless -p 8080:80 nginx
```

Isso deve corrigir o problema e permitir que você execute o container Nginx usando o Podman.
