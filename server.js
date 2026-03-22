// Simple Stripe Payment Server
// Deploy to Railway, Render, or Heroku (free tiers)
// npm install express stripe cors dotenv

const path = require('path');
// Try to load .env from multiple possible locations
require('dotenv').config({ path: path.resolve(__dirname, '.env') });
require('dotenv').config({ path: path.resolve(__dirname, 'functions/.env') });
const express = require('express');
const cors = require('cors');

// Check and log Stripe key status
const stripeSecretKey = process.env.STRIPE_SECRET_KEY;
if (!stripeSecretKey) {
  console.error('ERROR: STRIPE_SECRET_KEY environment variable is not set!');
  console.error('Please set it in Railway Dashboard → Variables');
  console.error('Current env vars:', Object.keys(process.env));
  process.exit(1);
} else {
  console.log('✓ STRIPE_SECRET_KEY loaded successfully');
  console.log('  Key starts with:', stripeSecretKey.substring(0, 15) + '...');
}
const stripe = require('stripe')(stripeSecretKey);

const app = express();
app.use(cors());
app.use(express.json());

// Create Payment Intent
app.post('/create-payment-intent', async (req, res) => {
  try {
    const { amount, currency = 'usd' } = req.body;
    
    console.log(`Payment request: amount=${amount}, currency=${currency}`);

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: currency,
      automatic_payment_methods: { enabled: true },
    });

    console.log(`PaymentIntent created: ${paymentIntent.id}`);
    res.json({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    console.error('Stripe error:', error.message);
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
