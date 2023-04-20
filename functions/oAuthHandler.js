const stripe = require('stripe')('sk_test_51Mm5YMJa42zn3jCLGFx3TVg1OsHS5QYnxZXXM3BksjK6muoefYGzLUHwujpZmT2SSAwx5CIlfXK6kWBhZ0rV9DLL000ufSmDld');
const {storeRestaurantAccessToken } = require('./helper');
const admin = require('firebase-admin');
const { identity } = require('firebase-functions/v2');
require('dotenv').config();

// Initialize firebase-admin
if (!admin.apps.length) {
  admin.initializeApp();
}


module.exports = async (req, res) => {
    const authorizationCode = req.query.code;
    const state = req.query.state;
    const restaurantId = req.query.restaurantId;

      // Verify the state parameter to protect against CSRF attacks
      // ...

    try {
        // Exchange the authorizationCode for an access_token
        const response = await axios.post('https://connect.squareupsandbox.com/oauth2/token', {
          client_id: process.env.SQUARE_SANDBOX_CLIENT_ID,
          client_secret: process.env.SQUARE_SANDBOX_ACCESS_TOKEN,
          code: authorizationCode,
          grant_type: 'authorization_code'
        });
        const expiresAt = response.data.expires_at;
        const refreshToken = response.data.refresh_token;
        const accessToken = response.data.access_token;
        const merchantId = response.data.merchant_id;
        // Store the access_token securely in your database
        await storeRestaurantAccessToken(restaurantId, accessToken, merchantId, refreshToken, expiresAt);
    
        res.send('OAuth flow completed');
    } catch (error) {
        console.error('Error exchanging authorization code:', error.message);
        res.status(500).send('Error during OAuth flow');
    }
};
