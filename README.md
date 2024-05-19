# Aplicativo de Gerenciamento de Tarefas com Flutter e Flask

Este repositório contém três projetos principais: uma API backend assíncrona construída com Flask para gerenciar tarefas, uma API backend assíncrona construída com Flask para gerenciar usuários e um frontend desenvolvido com Flutter para interagir com a API.

## Estrutura do Repositório

O repositório está dividido em três pastas principais:

### `users-api`

Este diretório contém o código para a API assíncrona Flask, que fornece os endpoints necessários para o gerenciamento de usuários.

- **Localização**: `users-api/`
- **Como executar**: Veja o [README](./users-api/README.md) no diretório `users-api`.

### `tasks-api`

Este diretório contém o código para a API assíncrona Flask, que fornece os endpoints necessários para o gerenciamento de tarefas.

- **Localização**: `tasks-api/`
- **Como executar**: Veja o [README](./tasks-api/README.md) no diretório `tasks-api`.

### `frontend`

Este diretório contém o código do aplicativo Flutter, que é a interface do usuário para interagir com a API de tarefas.

- **Localização**: `frontend/`
- **Como executar**: Veja o [README](./frontend/README.md) no diretório `frontend`.


## Configuração do Nginx

Para permitir que as APIs backend de gerenciamento de tarefas e usuários sejam acessadas de forma transparente por meio de uma única porta, utilizamos o Nginx como um servidor proxy reverso. Abaixo está a configuração utilizada no `nginx.conf` e uma explicação detalhada de como funciona.

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

    server {
        listen 80;

        location /tasks {
            proxy_pass http://tasks-api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /users {
            proxy_pass http://users-api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
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

### Como Funciona

- Quando um usuário faz uma requisição para `/tasks`, o Nginx encaminha essa requisição para o serviço `tasks-api` que está rodando na porta `5000`.
- Similarmente, uma requisição para `/users` é encaminhada para o serviço `users-api` que está rodando na porta `5001`.
- O Nginx atua como um intermediário, facilitando a comunicação entre o frontend e os serviços backend, e garantindo que o usuário não precise se preocupar com as portas específicas dos serviços.

### Executando o Projeto com Docker Compose

O `docker-compose.yml` está configurado para levantar todos os serviços necessários (APIs de usuários e tarefas, banco de dados PostgreSQL e Nginx). Certifique-se de que todos os arquivos de configuração estejam corretos e execute o seguinte comando para iniciar os serviços:

```sh
docker-compose up --build
```

Isso iniciará todos os serviços e configurará o Nginx para encaminhar as requisições corretamente para os serviços backend.

## Demonstração do Projeto

Para ver uma demonstração completa do funcionamento do gerenciamento de tarefas, clique no link abaixo para acessar o vídeo:
[Assistir ao Vídeo](https://youtu.be/e7kYtUnUVnM)

## Tecnologias Utilizadas

- **Backend**: Python, Flask, Docker
- **Frontend**: Flutter, Dart
