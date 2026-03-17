require('dotenv').config(); // Load .env in local environment
const express = require('express');
const fetch = require('node-fetch');
const cors = require('cors');

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

// Return 400 (instead of crashing) on invalid JSON
app.use((err, _req, res, next) => {
  if (err && err.type === 'entity.parse.failed') {
    return res.status(400).json({ error: 'Invalid JSON body' });
  }
  return next(err);
});

async function handleGroqGenerate(req, res) {
  try {
    const prompt = req.body.prompt || '';
    if (!prompt) return res.status(400).json({ error: 'Missing prompt' });

    // Support both legacy and new env var names.
    const apiKey = process.env.GROQ_API_KEY || process.env.GEN_API_KEY;
    const model =
      process.env.GROQ_MODEL ||
      process.env.GEN_MODEL ||
      'llama-3.1-8b-instant';
    if (!apiKey) {
      return res.status(500).json({
        error: 'Missing API key',
        expectedEnv: ['GROQ_API_KEY', 'GEN_API_KEY'],
      });
    }

    // Groq OpenAI-compatible endpoint
    const response = await fetch('https://api.groq.com/openai/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        model,
        messages: [
          { role: 'system', content: 'You are a helpful travel assistant for Sri Lanka.' },
          { role: 'user', content: prompt }
        ],
        temperature: 0.7
      })
    });

    const data = await response.json().catch(() => ({}));
    if (!response.ok) {
      return res.status(response.status).json({
        error: 'Groq API error',
        status: response.status,
        details: data,
      });
    }

    const reply =
      data?.choices?.[0]?.message?.content ||
      data?.choices?.[0]?.text ||
      'No reply from model';

    res.json({ reply });

  } catch (err) {
    console.error('Groq AI error', err);
    res.status(500).json({ error: 'Internal server error', details: String(err) });
  }
}

// Backward compatible aliases
app.post('/groq-generate', handleGroqGenerate);
app.post('/generate', handleGroqGenerate);

// Only for local testing
if (require.main === module) {
  const port = process.env.PORT || 3000;
  app.listen(port, () => console.log(`Local Groq AI server running at http://localhost:${port}`));
}

module.exports = app; // For Firebase deploy later