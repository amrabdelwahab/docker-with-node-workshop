const express = require('express');
const app = express();
const HOST = '0.0.0.0'
const PORT = 5000;
const User = require('./User');

app.get('/', (req, res) => {
  res.send({ message: 'endpoint working' });
});

app.get('/users', User.readAll);

app.listen(PORT, () => {
  console.log(`Server running at: http://localhost:${PORT}/`);
});
