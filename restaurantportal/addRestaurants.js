const admin = require("firebase-admin");
const geofire = require("geofire-common");

// Initialize Firebase Admin SDK with your service account key
const serviceAccount = require("./serviceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const firestore = admin.firestore();
const restaurantsRef = firestore.collection("restaurants");

async function addRestaurantsWithGeoFire() {
  const batch = firestore.batch();
  const querySnapshot = await restaurantsRef.get();

  querySnapshot.forEach((restaurant) => {
    console.log(restaurant.data().name);
    if (restaurant.data().name == "Papa Johns") {
      
    
    const docRef = restaurantsRef.doc(restaurant.id);
    const location = [restaurant.data().location.latitude, restaurant.data().location.longitude];
    const geohash = geofire.geohashForLocation([42.000, -42.000]);

    // Add GeoFire data
    const updatedData = {
      ...restaurant.data(),
      geohash: geohash,
      lat: 42.000,
      lng: -42.100
    };

    batch.update(docRef, updatedData);
  }
  else {
    console.log("skipping restaurant: " + restaurant.name);
  }
  });

  await batch.commit();
  console.log("Restaurants updated successfully with GeoFire data.");
}

// Run the script and handle errors
addRestaurantsWithGeoFire()
  .then(() => {
    console.log("Script completed successfully.");
    process.exit(0);
  })
  .catch((error) => {
    console.error("An error occurred:", error);
    process.exit(1);
  });
