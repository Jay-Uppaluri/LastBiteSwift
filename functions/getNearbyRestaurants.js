const admin = require("firebase-admin");
const geofire = require("geofire-common");

const firestore = admin.firestore();

exports.getNearbyRestaurants = async (req, res) => {
      // Verify ID token
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    res.status(401).send("Unauthorized: Missing or invalid ID token.");
    return;
  }

  const idToken = authHeader.split("Bearer ")[1];
  try {
    await admin.auth().verifyIdToken(idToken);

  } catch (error) {
    console.error("Error verifying ID token:", error);
    res.status(401).send("Unauthorized: Invalid ID token.");
    return;
  }
  const userLat = req.body.latitude;
  const userLon = req.body.longitude;
  const radius = req.body.radius;

  if (!userLat || !userLon || !radius) {
    res.status(400).send("Latitude, longitude, and radius are required.");
    return;
  }

  const center = [userLat, userLon];

// Each item in 'bounds' represents a startAt/endAt pair. We have to issue
// a separate query for each pair. There can be up to 9 pairs of bounds
// depending on overlap, but in most cases there are 4.
const bounds = geofire.geohashQueryBounds(center, radius);
const promises = [];
for (const b of bounds) {
  const q = firestore.collection('restaurants')
    .orderBy('geohash')
    .startAt(b[0])
    .endAt(b[1]);

  promises.push(q.get());
}

// Collect all the query results together into a single list
Promise.all(promises).then((snapshots) => {
  const matchingDocs = [];

  for (const snap of snapshots) {
    for (const doc of snap.docs) {
      const lat = doc.get('lat');
      const lng = doc.get('lng');

      // We have to filter out a few false positives due to GeoHash
      // accuracy, but most will match
      const distanceInKm = geofire.distanceBetween([lat, lng], center);
      const distanceInM = distanceInKm * 1000;
      if (distanceInM <= radius) {
        matchingDocs.push(doc);
      }
    }
  }

  return matchingDocs;
}).then((matchingDocs) => {
  // Process the matching documents and return as JSON
  const restaurants = matchingDocs.map(doc => {
    return {
      ...doc.data(),
      id: doc.id
    };
});

console.log(restaurants);
res.status(200).json(restaurants);
}).catch((error) => {
  console.error("Error fetching nearby restaurants:", error);
  res.status(500).send("Error fetching nearby restaurants.");
});
};