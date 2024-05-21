// Import libraries
const express = require('express');
const bodyParser = require('body-parser');
var mustacheExpress = require('mustache-express');
const { route } = require('./routes');
const PATH = __dirname

// Initialise objects and declare constants
const app = express();
const webPort = 8088;

app.engine('mustache', mustacheExpress());

app.set('view engine', 'mustache');
app.set('views', __dirname + '/views');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(require('./routes/index.js'))

app.listen(webPort, () => console.log('App listening on port '+webPort)); // success callback

module.exports = app;