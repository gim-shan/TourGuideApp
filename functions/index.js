require('dotenv').config(); // Load .env in local environment
const express = require('express');
const fetch = require('node-fetch');
const cors = require('cors');
const admin = require('firebase-admin');

// Use Stripe secret key from environment variable (secure)
// For Firebase: Set using firebase functions:secrets:set STRIPE_SECRET_KEY
// Or use .env file locally
const stripeSecret = process.env.STRIPE_SECRET_KEY;
if (!stripeSecret) {
  console.error('ERROR: STRIPE_SECRET_KEY not set!');
}
const stripe = require('stripe')(stripeSecret);

// Initialize Firebase Admin
try {
  admin.initializeApp();
} catch (e) {
  // App already initialized
}

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

// Create Payment Intent for Stripe
async function handleCreatePaymentIntent(req, res) {
  try {
    const { amount, currency = 'usd', customerId } = req.body;

    if (!amount) {
      return res.status(400).json({ error: 'Missing amount' });
    }

    // Create payment intent with Stripe
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: currency,
      customer: customerId,
      automatic_payment_methods: {
        enabled: true,
      },
    });

    res.json({
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
    });

  } catch (err) {
    console.error('Stripe payment intent error', err);
    res.status(500).json({ 
      error: 'Failed to create payment intent', 
      details: String(err) 
    });
  }
}

// Save booking to Firestore (called after successful payment)
async function handleSaveBooking(req, res) {
  try {
    const { 
      userId, 
      userEmail, 
      packageName, 
      packageDetails, 
      totalAmount, 
      numberOfPeople,
      paymentIntentId 
    } = req.body;

    if (!userId || !packageName || !totalAmount) {
      return res.status(400).json({ error: 'Missing required booking details' });
    }

    const bookingData = {
      userId,
      userEmail,
      packageName,
      packageDetails,
      totalAmount,
      numberOfPeople,
      bookingDate: admin.firestore.FieldValue.serverTimestamp(),
      paymentStatus: 'paid',
      paymentId: paymentIntentId,
      status: 'confirmed',
    };

    const bookingRef = await admin.firestore().collection('bookings').add(bookingData);

    res.json({
      success: true,
      bookingId: bookingRef.id,
    });

  } catch (err) {
    console.error('Save booking error', err);
    res.status(500).json({ 
      error: 'Failed to save booking', 
      details: String(err) 
    });
  }
}

// Webhook handler for Stripe events
async function handleStripeWebhook(req, res) {
  const sig = req.headers['stripe-signature'];
  const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET;

  let event;

  try {
    if (endpointSecret && sig) {
      event = stripe.webhooks.constructEvent(req.body, sig, endpointSecret);
    } else {
      event = req.body;
    }
  } catch (err) {
    console.error('Webhook signature verification failed:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the event
  switch (event.type) {
    case 'payment_intent.succeeded':
      const paymentIntent = event.data.object;
      console.log('Payment succeeded:', paymentIntent.id);
      // Update booking status in Firestore
      // You can implement this based on your needs
      break;
    case 'payment_intent.payment_failed':
      const failedPayment = event.data.object;
      console.log('Payment failed:', failedPayment.id);
      break;
    default:
      console.log(`Unhandled event type ${event.type}`);
  }

  res.json({ received: true });
}

// Route definitions
app.post('/groq-generate', handleGroqGenerate);
app.post('/generate', handleGroqGenerate);
app.post('/createPaymentIntent', handleCreatePaymentIntent);
app.post('/saveBooking', handleSaveBooking);
app.post('/stripe-webhook', handleStripeWebhook);

// Only for local testing
if (require.main === module) {
  const port = process.env.PORT || 3000;
  app.listen(port, () => console.log(`Server running at http://localhost:${port}`));
}

module.exports = app; // For Firebase deploy later
