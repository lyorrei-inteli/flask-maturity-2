# Events API

Este é o serviço de API para gerenciamento de eventos, desenvolvido em Node.js com Express. A API permite criar, ler, atualizar e deletar eventos.

## Estrutura do Projeto

A estrutura do diretório do projeto é a seguinte:

```
events-api/
  ├── Dockerfile
  ├── package.json
  ├── server.js
  ├── .env
  ├── routes/
  │   └── event.js
  ├── models/
  │   └── event.js
```

## Dependências

As principais dependências utilizadas neste projeto são:

- express
- mongoose
- morgan
- dotenv

## Configuração

### Arquivo `.env`

Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis de ambiente:

```
DB_URL=mongodb://mongo:27017/eventsdb
PORT=5002
```

### Arquivo `package.json`

O arquivo `package.json` contém as dependências e scripts necessários para executar a aplicação.

```json
{
  "name": "events-api",
  "version": "1.0.0",
  "description": "Events API service",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "dotenv": "^10.0.0",
    "express": "^4.17.1",
    "mongoose": "^5.12.3",
    "morgan": "^1.10.0"
  }
}
```

### Arquivo `server.js`

O arquivo `server.js` configura o servidor Express e os middlewares necessários.

```javascript
const express = require('express');
const mongoose = require('mongoose');
const morgan = require('morgan');
const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.config();

const app = express();
const port = process.env.PORT || 5002;

app.use(express.json());

// Create a write stream (in append mode) for logging
const accessLogStream = fs.createWriteStream(path.join('/var/log/events-api', 'access.log'), { flags: 'a' });

// Setup the logger to write to the access log
app.use(morgan('combined', { stream: accessLogStream }));

mongoose.connect(process.env.DB_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

const db = mongoose.connection;
db.on('error', (error) => console.error(error));
db.once('open', () => console.log('Connected to Database'));

const eventRouter = require('./routes/event');
app.use('/events', eventRouter);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
```

### Arquivo `models/event.js`

Define o modelo de dados para os eventos utilizando Mongoose.

```javascript
const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  date: {
    type: Date,
    required: true
  },
  description: {
    type: String,
    required: true
  }
});

module.exports = mongoose.model('Event', eventSchema);
```

### Arquivo `routes/event.js`

Define as rotas para as operações CRUD de eventos.

```javascript
const express = require('express');
const router = express.Router();
const Event = require('../models/event');

// Create Event
router.post('/', async (req, res) => {
  const event = new Event({
    name: req.body.name,
    date: req.body.date,
    description: req.body.description
  });

  try {
    const newEvent = await event.save();
    console.log(`Event created: ${newEvent}`);
    res.status(201).json(newEvent);
  } catch (err) {
    console.error(`Error creating event: ${err.message}`);
    res.status(400).json({ message: err.message });
  }
});

// Get All Events
router.get('/', async (req, res) => {
  try {
    const events = await Event.find();
    console.log('Events retrieved');
    res.json(events);
  } catch (err) {
    console.error(`Error retrieving events: ${err.message}`);
    res.status(500).json({ message: err.message });
  }
});

// Get Event by ID
router.get('/:id', async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);
    if (event == null) {
      console.error('Event not found');
      return res.status(404).json({ message: 'Cannot find event' });
    }
    console.log(`Event retrieved: ${event}`);
    res.json(event);
  } catch (err) {
    console.error(`Error retrieving event: ${err.message}`);
    res.status(500).json({ message: err.message });
  }
});

// Update Event
router.patch('/:id', async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);
    if (event == null) {
      console.error('Event not found');
      return res.status(404).json({ message: 'Cannot find event' });
    }

    if (req.body.name != null) {
      event.name = req.body.name;
    }
    if (req.body.date != null) {
      event.date = req.body.date;
    }
    if (req.body.description != null) {
      event.description = req.body.description;
    }

    const updatedEvent = await event.save();
    console.log(`Event updated: ${updatedEvent}`);
    res.json(updatedEvent);
  } catch (err) {
    console.error(`Error updating event: ${err.message}`);
    res.status(400).json({ message: err.message });
  }
});

// Delete Event
router.delete('/:id', async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);
    if (event == null) {
      console.error('Event not found');
      return res.status(404).json({ message: 'Cannot find event' });
    }

    await event.remove();
    console.log('Event deleted');
    res.json({ message: 'Event deleted' });
  } catch (err) {
    console.error(`Error deleting event: ${err.message}`);
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
```

## Executando a Aplicação

### Com Docker

Certifique-se de que você tem o Docker instalado e execute os seguintes comandos na raiz do projeto:

```sh
docker-compose up --build
```

### Sem Docker

Certifique-se de que você tem o Node.js e o MongoDB instalados. Depois, siga os seguintes passos:

1. Instale as dependências:

```sh
npm install
```

2. Execute a aplicação:

```sh
node server.js
```

A aplicação estará disponível em `http://localhost:5002`.

## Logs

Os logs de acesso e erros são registrados no arquivo `access.log` localizado em `/var/log/events-api/access.log`.

## Endpoints

- `POST /events`: Cria um novo evento.
- `GET /events`: Recupera todos os eventos.
- `GET /events/:id`: Recupera um evento pelo ID.
- `PATCH /events/:id`: Atualiza um evento pelo ID.
- `DELETE /events/:id`: Deleta um evento pelo ID.

## Tecnologias Utilizadas

- **Backend**: Node.js, Express, MongoDB
- **Logs**: Morgan, Filebeat, Elasticsearch, Kibana
