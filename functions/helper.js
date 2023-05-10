const { getFirestore } = require('firebase-admin/firestore');

const db = getFirestore();
const admin = require('firebase-admin');
const axios = require('axios');

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

async function storeRestaurantAccessToken(restaurantId, accessToken, merchantId, refreshToken, expiresAt) {
  await db.collection('restaurants').doc(restaurantId).update({
    'accessTokenInfo.accessToken': accessToken,
    'accessTokenInfo.refreshToken': refreshToken,
    'accessTokenInfo.expiresAt': expiresAt,
    merchantId: merchantId,
  });

  console.log(`Access token stored for restaurant: ${restaurantId}`);
}

async function updateRestaurantsOrdersLeft(restaurantId) {
  const restaurantRef = db.collection('restaurants').doc(restaurantId);

  await db.runTransaction(async (transaction) => {
    const restaurantDoc = await transaction.get(restaurantRef);

    if (!restaurantDoc.exists) {
      throw new Error('Restaurant not found');
    }

    const ordersLeft = restaurantDoc.data().ordersLeft;

    if (ordersLeft <= 0) {
      throw new Error('No orders left');
    }

    transaction.update(restaurantRef, {
      'ordersLeft': ordersLeft - 1
    });
  });
}

async function getRestaurantIdByMerchantId(merchantId) {
  const querySnapshot = await db.collection('restaurants').where('merchantId', '==', merchantId).get();

  if (querySnapshot.empty) {
    throw new Error(`No restaurant found for merchant ID: ${merchantId}`);
  }

  return querySnapshot.docs[0].id;
}


async function refreshAccessToken(restaurantId, refreshToken) {
  try {
    const response = await axios.post('https://connect.squareupsandbox.com/oauth2/token', {
      client_id: process.env.SQUARE_SANDBOX_CLIENT_ID,
      client_secret: process.env.SQUARE_SANDBOX_ACCESS_TOKEN,
      refresh_token: refreshToken,
      grant_type: 'refresh_token',
    });

    return {
      access_token: response.data.access_token,
      expires_at: response.data.expires_at,
    };
  } catch (error) {
    console.error('Error refreshing access token:', error.message);
    throw error;
  }
}

async function generateRandomFourDigitNumber() {
  const min = 1000;
  const max = 9999;
  return Math.floor(Math.random() * (max - min + 1)) + min;
}



async function getRestaurantAccessToken(restaurantId) {
  const docRef = db.collection('restaurants').doc(restaurantId);
  const doc = await docRef.get();

  if (!doc.exists) {
    throw new Error(`No restaurant found for ID: ${restaurantId}`);
  }

  return doc.data().accessTokenInfo;
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

async function logOrdersInfo(userId, restaurantId, paymentIntentId, status, amount, orderNumber, address) {
  const ordersRef = db.collection("orders");

  const newOrder = {
    userId: userId,
    restaurantId: restaurantId,
    timestamp: admin.firestore.Timestamp.now(),
    status: status,
    paymentIntentId: paymentIntentId,
    amount: amount,
    orderNumber: orderNumber,
    address: address
  };

  const newDocRef = ordersRef.doc();
  const orderId = newDocRef.id;
  newOrder.orderId = orderId;

  await newDocRef.set(newOrder);
  console.log(`Order logged with ID: ${orderId}`);
}



async function updateRestaurantAccessToken(restaurantId, newAccessToken, newExpiresAt) {
  await db.collection('restaurants').doc(restaurantId).update({
    'accessTokenInfo.accessToken': newAccessToken,
    'accessTokenInfo.expiresAt': newExpiresAt,
  });

  console.log(`Access token updated for restaurant: ${restaurantId}`);
}

async function getRestaurant(restaurantId) {
  const docRef = db.collection('restaurants').doc(restaurantId);
  const doc = await docRef.get();

  if (!doc.exists) {
    throw new Error(`No restaurant found for ID: ${restaurantId}`);
  }

  return doc.data();
}


module.exports = {
  getCustomerIdFromDb,
  addCustomerIdToUserDocument,
  logPaymentInfo,
  logOrdersInfo,
  getPointOfSaleInfo,
  storeRestaurantAccessToken,
  getRestaurantAccessToken,
  getRestaurantIdByMerchantId,
  refreshAccessToken,
  updateRestaurantAccessToken,
  updateRestaurantsOrdersLeft,
  generateRandomFourDigitNumber,
  getRestaurant
};
