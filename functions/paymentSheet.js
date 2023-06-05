const functions = require('firebase-functions');
const stripeSecretKey = functions.config().stripe.secret;
const stripe = require('stripe')(stripeSecretKey);
const { getCustomerIdFromDb, addCustomerIdToUserDocument } = require('./helper');
const validAmounts = [499, 599, 699];
const admin = require('firebase-admin');
const stripePublishableKey = functions.config().stripe.publishable;


// Initialize firebase-admin
if (!admin.apps.length) {
  admin.initializeApp();
}

module.exports = async (req, res) => {
  const authHeader = req.headers.authorization;
  const idToken = authHeader.split('Bearer ')[1];

  try {
      // Verify and decode the ID token
      const decodedToken = await admin.auth().verifyIdToken(idToken);
      const userId = decodedToken.uid;
      const customerId = await getCustomerIdFromDb(userId);
      let customer;
      if (customerId != undefined && customerId != null) {
        customer = await stripe.customers.retrieve(customerId);
      } else {
        customer = await stripe.customers.create();
      }
      const ephemeralKey = await stripe.ephemeralKeys.create(
        {customer: customer.id},
        {apiVersion: '2022-11-15'}
      );
      const data = req.body;
      const amount = data.amount;
      const restaurantId = data.restaurantId;
      if (!validAmounts.includes(amount)) {
        Response.status(400).send("Invalid payment amount");
        return;
      }
      const paymentIntent = await stripe.paymentIntents.create({
        amount: amount,
        currency: 'usd',
        customer: customer.id,
        setup_future_usage: 'off_session',
        automatic_payment_methods: {
          enabled: true,
        },
        metadata: {
          userId: userId,
          restaurantId: restaurantId,
          orderType: data.orderType
        },
      });
    
      await addCustomerIdToUserDocument(userId, customer.id);
      
      res.json({
        paymentIntent: paymentIntent.client_secret,
        ephemeralKey: ephemeralKey.secret,
        customer: customer.id,
        publishableKey: stripePublishableKey

      });
  } catch (error) {
    console.log('Error: ', error);
    return res.status(401).send('Unauthorized');
  }
};
