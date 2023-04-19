const admin = require('firebase-admin');
const { Client } = require('square');
const { getRestaurantIdByMerchantId, getRestaurantAccessToken } = require('./helper');

// Initialize Firebase app and Firestore
const db = admin.firestore();





const getOrderStatus = (order) => {
    let canceledOrFailedCount = 0;
    let preparedCount = 0;
  
    for (const fulfillment of order.fulfillments) {
      if (fulfillment.state === 'CANCELLED' || fulfillment.state === 'FAILED') {
        canceledOrFailedCount++;
      } else if (fulfillment.state === 'PREPARED') {
        preparedCount++;
      }
    }
  
    if (canceledOrFailedCount === order.fulfillments.length) {
      return 'FAILED';
    } else if (canceledOrFailedCount > 0 && preparedCount === order.fulfillments.length - canceledOrFailedCount) {
      return 'PARTIAL';
    } else {
      const allPrepared = order.fulfillments.every(fulfillment => fulfillment.state === 'PREPARED');
      return allPrepared ? 'READY' : order.fulfillments[0].state;
    }
  };
  
  
  const updateOrderStatusInFirestore = async (orderId, status) => {
    await db.collection('orders').doc(orderId).update({ status });
    console.log(`Order status updated in Firestore: ${orderId}`);
  };
  
  const squareWebhookListener = async (req, res) => {

    const merchantId = req.body.merchant_id;

    const restaurantId = await getRestaurantIdByMerchantId(merchantId);

    const accessToken = await getRestaurantAccessToken(restaurantId);

    const client = new Client({
      environment: 'sandbox', // Or 'production' when not testing
      accessToken: accessToken,
    });
    // TODO: validate webhook signature
  
    if (req.body.type === 'order.updated') {
      const orderId = req.body.data.id;
  
      try {
        // Retrieve the order from Square
        const { result } = await client.ordersApi.retrieveOrder(orderId);
        const order = result.order;
  
        // Check for fulfillments and update the order status
        if (order.fulfillments && order.fulfillments.length > 0) {
          let orderStatus = getOrderStatus(order);
  
          if (order.state === 'COMPLETED') {
            orderStatus = 'COMPLETED';
          }
  
          // Update the order status in Firestore
          await updateOrderStatusInFirestore(orderId, orderStatus);
        } else {
          console.log(`No fulfillments found for order: ${orderId}`);
        }
      } catch (error) {
        console.error(`Error updating order status in Firestore: ${error.message}`);
      }
    }
  
    res.status(200).send();
  };
  
  
  module.exports = squareWebhookListener;
  
