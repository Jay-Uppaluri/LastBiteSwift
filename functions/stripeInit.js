const functions = require('firebase-functions');
const stripeSecretKey = functions.config().stripe.secret;
const stripe = require('stripe')(stripeSecretKey);
const stripePublishableKey = functions.config().stripe.publishable;

module.exports = { stripe, stripePublishableKey };
