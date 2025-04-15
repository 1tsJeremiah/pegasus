const express = require('express');
const app = express();
const port = 3001;

app.get('/', (req, res) => {
  res.send('✅ Test route working');
});

app.listen(port, () => {
  console.log(`Test Express server on http://localhost:${port}`);
});
