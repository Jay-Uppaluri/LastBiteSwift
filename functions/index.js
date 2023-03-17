const functions = require('firebase-functions');
const stripe = require('stripe')('sk_test_51Mm5YMJa42zn3jCLGFx3TVg1OsHS5QYnxZXXM3BksjK6muoefYGzLUHwujpZmT2SSAwx5CIlfXK6kWBhZ0rV9DLL000ufSmDld');


const { initializeApp, applicationDefault, cert } = require('firebase-admin/app');
const { getFirestore, Timestamp, FieldValue } = require('firebase-admin/firestore');

const admin = require('firebase-admin');
admin.initializeApp();
const db = getFirestore();


exports.paymentSheet = functions.https.onRequest(async (req, res) => {
  const customer = await stripe.customers.create();
  const ephemeralKey = await stripe.ephemeralKeys.create(
    {customer: customer.id},
    {apiVersion: '2022-11-15'}
  );
  const data = req.body;
  const amount = data.amount
  const validAmounts = [499, 599, 699];
  if (!validAmounts.includes(amount)) {
    Response.status(400).send("Invalid payment amount");
    return;
  }
  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount,
    currency: 'usd',
    customer: customer.id,
    automatic_payment_methods: {
      enabled: true,
    },
  });

  res.json({
    paymentIntent: paymentIntent.client_secret,
    ephemeralKey: ephemeralKey.secret,
    customer: customer.id,
    publishableKey: 'pk_test_51Mm5YMJa42zn3jCLDGyMInDAgUBxKBCNjFLeqCdpSi2QTwZwKFahXKbvd23gHy18En2nS3eqCfthgRPNEZwxZy4V00chCbTmqB'
  });
});

exports.paymentSuccess = functions.https.onRequest(async (req, res) => {
  // Verify the signature of the Stripe webhook event
  const sig = req.headers['stripe-signature'];
  let event;

  try {
    event = stripe.webhooks.constructEvent(req.rawBody, sig, "whsec_c9fwm3kaAwLthkptFLqPL8Xj2TFzm3a5");
  } catch (err) {
    console.log(`Webhook error: ${err.message}`);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the payment_intent.succeeded event
  if (event.type === 'payment_intent.succeeded') {
    const paymentIntent = event.data.object;

    // Log the payment information to your Firestore database
    const paymentRef = admin.firestore().collection('Payments').doc(paymentIntent.id);
    await paymentRef.set({
      amount: paymentIntent.amount,
      currency: paymentIntent.currency,
      customer: paymentIntent.customer,
      paymentMethod: paymentIntent.payment_method,
      created: paymentIntent.created,
      status: paymentIntent.status
    });

    console.log(`Payment intent succeeded: ${paymentIntent.id}`);
  }

  res.status(200).send();
});
