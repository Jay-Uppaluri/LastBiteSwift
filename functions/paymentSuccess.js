const stripe = require('stripe')('sk_test_51Mm5YMJa42zn3jCLGFx3TVg1OsHS5QYnxZXXM3BksjK6muoefYGzLUHwujpZmT2SSAwx5CIlfXK6kWBhZ0rV9DLL000ufSmDld');
const { logPaymentInfo, logOrdersInfo, getPointOfSaleInfo, getRestaurantAccessToken, refreshAccessToken, updateRestaurantAccessToken } = require('./helper');
const { Client } = require('square');

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
    console.log("starting payment intent succeeded event");
    const paymentIntent = event.data.object;
    const userId = paymentIntent.metadata.userId;
    const restaurantId = paymentIntent.metadata.restaurantId;

    const accessTokenInfo = await getRestaurantAccessToken(restaurantId);


// Check if the access token has expired
    if (Date.now() >= accessTokenInfo.expiresAt.toMillis()) {
      // Request a new access token using the refresh token
      const newAccessTokenInfo = await refreshAccessToken(restaurantId, accessTokenInfo.refreshToken);
      // Update the access token and its expiration time in the database
      await updateRestaurantAccessToken(restaurantId, newAccessTokenInfo.access_token, newAccessTokenInfo.expires_at);
      // Update the accessTokenInfo object with new data
      accessTokenInfo = {
        accessToken: newAccessTokenInfo.access_token,
        expiresAt: newAccessTokenInfo.expires_at,
      };
    }
    // Use the updated access token
    const client = new Client({
      environment: 'sandbox', // Or 'production' when not testing
      accessToken: accessTokenInfo.accessToken,
    });


    // Log the payment information to your Firestore database
    await logPaymentInfo(paymentIntent);

    const pointOfSaleInfo = await getPointOfSaleInfo(restaurantId);

    if (pointOfSaleInfo.system == 'square') {
    // Create the order on Square
      try {
        const response = await client.ordersApi.createOrder({
          order: {
            locationId: pointOfSaleInfo.locationId,
            referenceId: 'my-order-001',
            lineItems: [
              {
                name: paymentIntent.metadata.orderType,
                quantity: '1',
                basePriceMoney: {
                  amount: paymentIntent.amount - 50,
                  currency: 'USD'
                }
              },
            ],
            taxes: [
              {
                uid: 'state-sales-tax',
                name: 'State Sales Tax',
                percentage: '9',
                scope: 'ORDER'
              }
            ],
          },
          metadata: {
            restaurantId: restaurantId,
          },
          idempotencyKey: paymentIntent.id,
        });
      
        console.log(response.result);
        console.log(`Order created on Square: ${response.result.order.id}`);
        await logOrdersInfo(userId, restaurantId, paymentIntent.id, "OPEN", response.result.order.id, paymentIntent.amount);

      } catch(error) {
        // here we refund the customer 
        console.log(error);
        //await logOrdersInfo(userId, restaurantId, paymentIntent.id, "failed", response.result.order.id)
      }
    }




    console.log(`Payment intent succeeded: ${paymentIntent.id}`);
  }

  res.status(200).send();
};
