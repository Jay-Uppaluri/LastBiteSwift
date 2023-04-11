const stripe = require('stripe')('sk_test_51Mm5YMJa42zn3jCLGFx3TVg1OsHS5QYnxZXXM3BksjK6muoefYGzLUHwujpZmT2SSAwx5CIlfXK6kWBhZ0rV9DLL000ufSmDld');
const { getCustomerIdFromDb, addCustomerIdToUserDocument } = require('./helper');
const validAmounts = [499, 599, 699];

module.exports = async (req, res) => {
  const userId = req.body.userId;
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
      restaurantId: restaurantId
    },
  });

  await addCustomerIdToUserDocument(userId, customer.id);
  
  res.json({
    paymentIntent: paymentIntent.client_secret,
    ephemeralKey: ephemeralKey.secret,
    customer: customer.id,
    publishableKey: 'pk_test_51Mm5YMJa42zn3jCLDGyMInDAgUBxKBCNjFLeqCdpSi2QTwZwKFahXKbvd23gHy18En2nS3eqCfthgRPNEZwxZy4V00chCbTmqB'
  });
};
