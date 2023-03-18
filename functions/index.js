const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const paymentSheet = require('./paymentSheet');
const paymentSuccess = require('./paymentSuccess');

exports.paymentSheet = functions.https.onRequest(paymentSheet);
exports.paymentSuccess = functions.https.onRequest(paymentSuccess);
