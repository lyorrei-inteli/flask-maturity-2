# API de Lista de Tarefas

## Introdução

Este projeto é uma API simples desenvolvida como parte de um exercício acadêmico. Implementa uma API RESTful síncrona usando Flask em Python e inclui autenticação de usuário para gerenciar tarefas.

## Requisitos

- Python 3.6+
- Flask
- Flask-JWT-Extended
- Flask-Swagger-UI
- Flask-CORS
- Flask-SQLAlchemy
- SQLite

## Configuração e Instalação
1. Instale as dependências:
   ```bash
   pip install -r requirements.txt
   ```

2. Inicialize o banco de dados:
   ```bash
   python main.py create_db
   ```

4. Execute a aplicação:
   ```bash
   python main.py
   ```

   A aplicação estará disponível em `http://127.0.0.1:5000/`.

## Pontos de Extremidade da API

- `POST /login`: Autentica usuários e retorna um JWT.
- `GET /user-login`: Página de login.
- `GET /user-register`: Página de registro.
- `GET /content`: Página de conteúdo (requer JWT).
- `GET, POST, PUT, DELETE /users`: Pontos de extremidade para gerenciamento de usuários.
  - `GET /users`: Lista todos os usuários.
  - `POST /users`: Cria um novo usuário.
  - `GET /users/{id}`: Obtém um usuário específico.
  - `PUT /users/{id}`: Atualiza um usuário específico.
  - `DELETE /users/{id}`: Deleta um usuário específico.

## Estrutura do Projeto

- `app.py`: O arquivo principal da aplicação Flask.
- `database/`: Configuração do banco de dados e modelos.
- `templates/`: Modelos HTML para a interface do usuário.

## Informações Adicionais

- Os arquivos YAML do Insomnia e os arquivos JSON/YAML do Swagger estão localizados dentro da pasta `static`.