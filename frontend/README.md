# Task Manager App

Este é um aplicativo Flutter para gerenciamento de tarefas. Ele permite aos usuários criar, editar, deletar e marcar tarefas como completas.

## Widgets

### `TaskListWidget`

Este widget é a tela principal do aplicativo onde todas as tarefas são listadas.

#### Funcionalidades:

- **Listar Tarefas**: Mostra todas as tarefas com o título e status.
- **Adicionar Tarefa**: Botão para navegar para a tela de criação de tarefas.
- **Editar Tarefa**: Cada tarefa pode ser editada clicando no ícone de edição.
- **Deletar Tarefa**: Tarefas podem ser deletadas usando o ícone de lixeira.
- **Marcar Tarefa como Completa**: Tarefas podem ser marcadas como completas usando o checkbox.

### LoginPage
Este widget é a tela de login do aplicativo, onde os usuários podem inserir suas credenciais para acessar o sistema.

#### Funcionalidades:
Login: Permite que o usuário insira seu nome de usuário e senha para fazer login.
Criar Conta: Navega para a página de criação de conta.
Capturar Imagem: Navega para a página de captura de imagem.

### CreateAccountPage
Este widget é usado para criar uma nova conta de usuário.

#### Funcionalidades:
Criar Conta: Permite que o usuário insira um nome de usuário e senha, e confirma a senha antes de criar a conta.

### ImageCapturePage
Este widget permite ao usuário capturar uma imagem usando a câmera do dispositivo ou selecionar uma imagem da galeria.

#### Funcionalidades:
Capturar Imagem: Abre a câmera do dispositivo para tirar uma foto.
Selecionar da Galeria: Abre a galeria de fotos do dispositivo para selecionar uma imagem.

### `TaskEditWidget`

Este widget é usado tanto para adicionar novas tarefas quanto para editar tarefas existentes.

#### Funcionalidades:

- **Criar Tarefa**: Permite inserir os detalhes da tarefa e salvar.
- **Editar Tarefa**: Carrega os detalhes da tarefa existente para edição.
- **Salvar Tarefa**: Salva as alterações feitas em uma tarefa ou cria uma nova tarefa no banco de dados.

### Serviços

#### `ApiService`

Esta classe gerencia todas as chamadas de API.

##### Métodos:

- **getTasks()**: Retorna todas as tarefas.
- **createTask(String text, String status)**: Cria uma nova tarefa.
- **updateTaskName(int id, String name)**: Atualiza o nome de uma tarefa existente.
- **updateTaskStatus(int id, bool newStatus)**: Atualiza o status de uma tarefa existente.
- **deleteTask(int id)**: Deleta uma tarefa.

## Estrutura de Navegação

O aplicativo usa uma navegação baseada em rotas nomeadas para transição entre os widgets `TaskListWidget` e `TaskEditWidget`.

## Dependências

Este aplicativo utiliza o pacote `http` para chamadas de API e `flutter/material.dart` para a UI.

## Configuração e Instalação

Instruções sobre como configurar e instalar o aplicativo.

### Pré-requisitos

- Flutter SDK
- Android Studio ou Visual Studio Code

### Instalação

1. Clone o repositório.
2. Abra o diretório do projeto no terminal.
3. Execute `flutter pub get` para instalar as dependências.
4. Execute `flutter run` para iniciar o aplicativo no dispositivo ou emulador conectado.