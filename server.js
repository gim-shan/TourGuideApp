// Simple Stripe Payment Server
// Deploy to Railway, Render, or Heroku (free tiers)
// npm install express stripe cors dotenv

require('dotenv').config();
require('dotenv').config({ path: './functions/.env' });
const express = require('express');
const cors = require('cors');

//removed secret
const stripeSecretKey = process.env.STRIPE_SECRET_KEY;
if (!stripeSecretKey) {
  console.error('ERROR: STRIPE_SECRET_KEY environment variable is not set!');
  console.error('Please set it in Railway Dashboard → Variables');
  process.exit(1);
}
const stripe = require('stripe')(stripeSecretKey);

const app = express();
app.use(cors());
app.use(express.json());

// Create Payment Intent
app.post('/create-payment-intent', async (req, res) => {
  try {
    const { amount, currency = 'usd' } = req.body;

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: currency,
      automatic_payment_methods: { enabled: true },
    });

    res.json({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
