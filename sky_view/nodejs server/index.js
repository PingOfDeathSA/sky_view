  const express = require('express');
const request = require('request');
const cors = require('cors');

const app = express();

app.use(cors());

app.get('/proxy', (req, res) => {
  const url = req.query.url;
  if (!url) {
    return res.status(400).send('missing url parameter');
  }
  request(url).pipe(res);
  console.log(`Proxying request to ${url}`);
});

app.get('/stars', (req, res) => {
  const url = req.query.url;
  if (!url) {
    return res.status(400).send('missing url parameter');
  }
  request(url).pipe(res);
  console.log(`Proxying request to ${url}`);
});

app.listen(3000, () => console.log('Proxy running on http://localhost:3000'));
