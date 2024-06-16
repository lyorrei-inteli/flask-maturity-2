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
app.use('/event', eventRouter);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

