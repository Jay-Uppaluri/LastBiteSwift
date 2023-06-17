const admin = require("firebase-admin");
const geofire = require("geofire-common");

// Initialize Firebase Admin SDK with your service account key
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const firestore = admin.firestore();
const restaurantsRef = firestore.collection("restaurants");

// Set of random restaurant names
const randomRestaurantNames = ["Lobster House", "Spaghetti Factory", "Taco Palace"];

async function addRestaurantsWithGeoFire() {
  const batch = firestore.batch();
  const querySnapshot = await restaurantsRef.get();

  querySnapshot.forEach((restaurant) => {
    console.log(restaurant.data().name);
  
    if (restaurant.data().name === "Papa Johns") {
      const data = restaurant.data();
      const seattleLocation = [47.6062, -122.3321];
      const seattleGeohash = geofire.geohashForLocation(seattleLocation);
  
      // Update "Papa Johns" restaurant location
      const updatedData = {
        ...data,
        geohash: seattleGeohash,
        lat: seattleLocation[0],
        lng: seattleLocation[1]
      };
      batch.update(restaurant.ref, updatedData);
  
      // Create new restaurants
      randomRestaurantNames.forEach((name, index) => {
        const newRestaurantRef = restaurantsRef.doc();
        const newData = {
          ...data,
          name: name,
          address: "123 Seattle Way, Seattle, WA, 98101",
          geohash: seattleGeohash,
          location: { latitude: seattleLocation[0], longitude: seattleLocation[1] },
          lat: seattleLocation[0],
          lng: seattleLocation[1],
        };
  
        batch.set(newRestaurantRef, newData);
      });
    } else {
      console.log("Skipping restaurant: " + restaurant.name);
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
