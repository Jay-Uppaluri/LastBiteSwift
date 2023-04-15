const admin = require('firebase-admin');
const { Client } = require('square');

// Initialize Firebase app and Firestore
const db = admin.firestore();


const accessToken = 'EAAAEAT_ae3DaTY2Bg6gyWLDoHA8M2FqiWRJ3NycF8Ona7iqQI1FOV2Ke_GhEqI5';

// Initialize Square API client
const client = new Client({
  environment: 'sandbox', // Or 'production' when not testing
  accessToken: accessToken,
});

const squareWebhookListener = async (req, res) => {
    // You should validate the webhook signature here
    // Check the Square API documentation for more information

    if (req.body.type === 'order.updated') {
      const orderId = req.body.data.id;
  
      try {
        // Retrieve the order from Square
        const { result } = await client.ordersApi.retrieveOrder(orderId);
        const order = result.order;
  
        // Check for fulfillments and get the status of the first fulfillment
        if (order.fulfillments && order.fulfillments.length > 0) {
          const orderStatus = order.fulfillments[0].state;
  
          // Update the order status in Firestore
          await db.collection('orders').doc(orderId).update({ status: orderStatus });
          console.log(`Order status updated in Firestore: ${orderId}`);
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
  
