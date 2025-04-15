require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');
const { OpenAI } = require('openai');

const app = express();
const port = 3000;

console.log("🛠️ Loaded Pegasus index.js from:", __dirname);

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

app.use(bodyParser.json());

// ✅ Root route for debug
app.get('/', (req, res) => {
  res.send('✅ Root route is working');
});

// ✅ Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ✅ Read markdown files from the knowledge base
app.get('/read/:section/:file', (req, res) => {
  const section = req.params.section;
  const file = req.params.file;

  const fullPath = path.join(__dirname, 'gpt-actions-knowledge-base', section, file);

  if (!fs.existsSync(fullPath)) {
    return res.status(404).json({ error: 'File not found' });
  }

  const content = fs.readFileSync(fullPath, 'utf8');
  res.json({ file, content });
});

// ✅ OpenAI chat proxy
app.post('/gpt/chat', async (req, res) => {
  const prompt = req.body.prompt;

  try {
    const response = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: prompt }],
    });

    res.json({ response: response.choices[0].message.content });
  } catch (error) {
    console.error('OpenAI error:', error);
    res.status(500).json({ error: 'OpenAI request failed', details: error.message });
  }
});

app.listen(port, () => {
  console.log(`🟢 Pegasus API listening at http://localhost:${port}`);
});
