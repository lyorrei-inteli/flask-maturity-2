# Aplicativo de Gerenciamento de Tarefas com Flutter e Flask

Este repositório contém quatro projetos principais: uma API backend assíncrona construída com Flask para gerenciar tarefas, uma API backend assíncrona construída com Flask para gerenciar usuários, uma API backend construída com Node.js para gerenciar eventos e um frontend desenvolvido com Flutter para interagir com as APIs.

## Estrutura do Repositório

O repositório está dividido em quatro pastas principais:

### `users-api`

Este diretório contém o código para a API assíncrona Flask, que fornece os endpoints necessários para o gerenciamento de usuários.

- **Localização**: `users-api/`
- **Como executar**: Veja o [README](./users-api/README.md) no diretório `users-api`.

### `tasks-api`

Este diretório contém o código para a API assíncrona Flask, que fornece os endpoints necessários para o gerenciamento de tarefas.

- **Localização**: `tasks-api/`
- **Como executar**: Veja o [README](./tasks-api/README.md) no diretório `tasks-api`.

### `events-api`

Este diretório contém o código para a API em Node.js, que fornece os endpoints necessários para o gerenciamento de eventos.

- **Localização**: `events-api/`
- **Como executar**: Veja o [README](./events-api/README.md) no diretório `events-api`.

### `frontend`

Este diretório contém o código do aplicativo Flutter, que é a interface do usuário para interagir com as APIs de tarefas, usuários e eventos.

- **Localização**: `frontend/`
- **Como executar**: Veja o [README](./frontend/README.md) no diretório `frontend`.

## Configuração do Nginx

Para permitir que as APIs backend de gerenciamento de tarefas, usuários e eventos sejam acessadas de forma transparente por meio de uma única porta, utilizamos o Nginx como um servidor proxy reverso. Abaixo está a configuração utilizada no `nginx.conf` e uma explicação detalhada de como funciona.

### Arquivo `nginx.conf`

```nginx
events {}

http {
    upstream tasks-api {
        server tasks-api:5000;
    }

    upstream users-api {
        server users-api:5001;
    }

    upstream events-api {
        server events-api:5002;
    }

    server {
        listen 80;

        location /tasks {
            proxy_pass http://tasks-api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            access_log /var/log/nginx/tasks-access.log;
            error_log /var/log/nginx/tasks-error.log;
        }

        location /users {
            proxy_pass http://users-api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            access_log /var/log/nginx/users-access.log;
            error_log /var/log/nginx/users-error.log;
        }

        location /event {
            proxy_pass http://events-api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            access_log /var/log/nginx/events-access.log;
            error_log /var/log/nginx/events-error.log;
        }
    }
}
```

### Explicação

1. **Bloco `events`**:
    - Este bloco é obrigatório na configuração do Nginx, mas não requer nenhuma configuração específica para esta aplicação.

2. **Bloco `http`**:
    - Contém a configuração principal para encaminhamento de requisições HTTP.

3. **Blocos `upstream`**:
    - Define os grupos de servidores backend que o Nginx utilizará para encaminhar as requisições.
    - `tasks-api`: Define o grupo de servidores para a API de tarefas, apontando para o serviço `tasks-api` na porta `5000`.
    - `users-api`: Define o grupo de servidores para a API de usuários, apontando para o serviço `users-api` na porta `5001`.
    - `events-api`: Define o grupo de servidores para a API de eventos, apontando para o serviço `events-api` na porta `5002`.

4. **Bloco `server`**:
    - Define um servidor virtual que escuta na porta `80`.

5. **Bloco `location /tasks`**:
    - Captura todas as requisições que começam com `/tasks` e as encaminha para o grupo `tasks-api`.
    - `proxy_pass http://tasks-api`: Redireciona as requisições para o serviço `tasks-api`.
    - `proxy_set_header`: Define cabeçalhos adicionais para passar informações do cliente original para os servidores backend.

6. **Bloco `location /users`**:
    - Captura todas as requisições que começam com `/users` e as encaminha para o grupo `users-api`.
    - `proxy_pass http://users-api`: Redireciona as requisições para o serviço `users-api`.
    - `proxy_set_header`: Define cabeçalhos adicionais para passar informações do cliente original para os servidores backend.

7. **Bloco `location /event`**:
    - Captura todas as requisições que começam com `/event` e as encaminha para o grupo `events-api`.
    - `proxy_pass http://events-api`: Redireciona as requisições para o serviço `events-api`.
    - `proxy_set_header`: Define cabeçalhos adicionais para passar informações do cliente original para os servidores backend.

### Como Funciona

- Quando um usuário faz uma requisição para `/tasks`, o Nginx encaminha essa requisição para o serviço `tasks-api` que está rodando na porta `5000`.
- Similarmente, uma requisição para `/users` é encaminhada para o serviço `users-api` que está rodando na porta `5001`.
- Uma requisição para `/events` é encaminhada para o serviço `events-api` que está rodando na porta `5002`.
- O Nginx atua como um intermediário, facilitando a comunicação entre o frontend e os serviços backend, e garantindo que o usuário não precise se preocupar com as portas específicas dos serviços.

## Configuração de Logs

Utilizamos Filebeat para coletar logs de todas as APIs e do Nginx, Elasticsearch para armazenar esses logs e Kibana para visualizá-los.

### Arquivo `filebeat.yml`

```yaml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/*.log
    - /var/log/users-api/*.log
    - /var/log/tasks-api/*.log
    - /var/log/events-api/*.log

setup.kibana:
  host: "http://kibana:5601"
  username: "elastic"
  password: "changeme"

setup.dashboards.enabled: true

output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
  username: "elastic"
  password: "changeme"
```

### Arquivo `wait-for-kibana.sh`

```bash
#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

until curl -sSf "$host" > /dev/null; do
  echo "Kibana is unavailable - sleeping"
  sleep 10
done

echo "Kibana is up - executing command"
exec $cmd
```

### Executando o Projeto com Docker Compose

O `docker-compose.yml` está configurado para levantar todos os serviços necessários (APIs de usuários, tarefas e eventos, banco de dados PostgreSQL, MongoDB, Nginx, Filebeat, Elasticsearch e Kibana). Certifique-se de que todos os arquivos de configuração estejam corretos e execute o seguinte comando para iniciar os serviços:

```sh
docker-compose up --build
```

A aplicação estará disponível em `http://127.0.0.1`.

### Verificando os Logs no Kibana

1. **Acessar o Kibana**:
   - Abra o navegador e acesse o Kibana em `http://localhost:5601`.

2. **Configurar o Index Pattern**:
   - Vá para "Management" > "Index Patterns" e configure um novo padrão de índice `filebeat-*`.

3. **Visualizar os Logs**:
   - Use a aba "Discover" no Kibana para explorar os logs coletados.

## Demonstração do Projeto

Para ver uma demonstração completa do funcionamento do gerenciamento de tarefas, clique no link abaixo para acessar o vídeo:
[Assistir ao Vídeo](https://youtu.be/e7kYtUnUVnM)

Para ver uma demonstração completa do funcionamento do sistema de logs, clique no link abaixo para acessar o vídeo:
[Assistir ao Vídeo](https://youtu.be/v6FBOPMHhrk)

## Tecnologias Utilizadas

- **Backend**: Python, Flask, Node.js, Express, Docker
- **Frontend**: Flutter, Dart
- **Logs**: Filebeat, Elasticsearch, Kibana
