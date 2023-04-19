const { getFirestore } = require('firebase-admin/firestore');

const db = getFirestore();
const admin = require('firebase-admin');

// BACKEND, hosted on firebase functions (serverless)
async function getCustomerIdFromDb(userId) {
  try {
    const userRef = db.collection("users").doc(userId);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      console.log("User not found");
      return null;
    }

    const userData = userDoc.data();
    return userData.customerId;
  } catch (error) {
    console.error("Error fetching customer ID from Firestore:", error);
    return null;
  }
}

async function storeRestaurantAccessToken(restaurantId, accessToken, merchantId) {
  await db.collection('restaurants').doc(restaurantId).update({
    accessToken: accessToken,
    merchantId: merchantId
  });

  console.log(`Access token stored for restaurant: ${restaurantId}`);
}

async function getRestaurantIdByMerchantId(merchantId) {
  const querySnapshot = await db.collection('restaurants').where('merchantId', '==', merchantId).get();

  if (querySnapshot.empty) {
    throw new Error(`No restaurant found for merchant ID: ${merchantId}`);
  }

  return querySnapshot.docs[0].id;
}


async function getRestaurantAccessToken(restaurantId) {
  const docRef = db.collection('restaurants').doc(restaurantId);
  const doc = await docRef.get();

  if (!doc.exists) {
    throw new Error(`No restaurant found for ID: ${restaurantId}`);
  }

  return doc.data().accessToken;
}

async function getPointOfSaleInfo(restaurantId) {
  const docRef = db.collection('restaurants').doc(restaurantId);
  const doc = await docRef.get();

  if (!doc.exists) {
    throw new Error(`No restaurant found for ID: ${restaurantId}`);
  }

  return doc.data().pointOfSaleInfo;
}


async function addCustomerIdToUserDocument(userId, customerId) {
  try {
    const userRef = db.collection("users").doc(userId);

    // Update the user document with the provided customerId
    await userRef.update({ customerId: customerId });

    console.log(`Customer ID ${customerId} added to user document for user ID ${userId}`);
  } catch (error) {
    console.error("Error adding customer ID to Firestore:", error);
  }
}

async function logPaymentInfo(paymentIntent) {
  try {
    const paymentRef = db.collection('paymentIntents').doc(paymentIntent.id);
    await paymentRef.set({
      amount: paymentIntent.amount,
      currency: paymentIntent.currency,
      customer: paymentIntent.customer,
      paymentMethod: paymentIntent.payment_method,
      created: paymentIntent.created,
      status: paymentIntent.status
    });
    console.log(`Payment information logged for payment intent ${paymentIntent.id}`);
  } catch (error) {
    console.error("Error logging payment information to Firestore:", error);
  }
}

async function logOrdersInfo(userId, restaurantId, paymentIntentId, status, orderId, amount) {
  const ordersRef = db.collection("orders");

  const newOrder = {
    userId: userId,
    restaurantId: restaurantId,
    timestamp: admin.firestore.Timestamp.now(),
    status: status,
    paymentIntentId: paymentIntentId,
    amount: amount,
  };

  await ordersRef.doc(orderId).set(newOrder);
  console.log(`Order logged with ID: ${orderId}`);
}


module.exports = {
  getCustomerIdFromDb,
  addCustomerIdToUserDocument,
  logPaymentInfo,
  logOrdersInfo,
  getPointOfSaleInfo,
  storeRestaurantAccessToken,
  getRestaurantAccessToken,
  getRestaurantIdByMerchantId
};
