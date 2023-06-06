const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { stripe } = require('./stripeInit');

admin.initializeApp();

const paymentSheet = require('./paymentSheet');
const paymentSuccess = require('./paymentSuccess');
const squareWebhookListener = require('./squareWebhook');
const getNearbyRestaurants = require('./getNearbyRestaurants');

exports.paymentSheet = functions.https.onRequest(paymentSheet);
exports.paymentSuccess = functions.https.onRequest(paymentSuccess);
exports.squareWebhookListener = functions.https.onRequest(squareWebhookListener);
exports.getNearbyRestaurants = functions.https.onRequest(getNearbyRestaurants.getNearbyRestaurants);
