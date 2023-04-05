const stripe = require('stripe')('sk_test_51Mm5YMJa42zn3jCLGFx3TVg1OsHS5QYnxZXXM3BksjK6muoefYGzLUHwujpZmT2SSAwx5CIlfXK6kWBhZ0rV9DLL000ufSmDld');
const { logPaymentInfo, logOrdersInfo } = require('./helper');

module.exports = async (req, res) => {
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
    const userId = paymentIntent.metadata.userId;
    const restaurantId = paymentIntent.metadata.restaurantId;
  
    // Log the payment information to your Firestore database
    await logPaymentInfo(paymentIntent);
    await logOrdersInfo(userId, restaurantId, paymentIntent.id, true)

    
  
    console.log(`Payment intent succeeded: ${paymentIntent.id}`);
  }

  res.status(200).send();
};
