
let uid = null;
let value = 0;


const firebaseConfig = window._appConfig.firebaseConfig;
firebase.initializeApp(firebaseConfig);

async function fetchRestaurantOrders(uid) {
  const response = await fetch(`/data?uid=${uid}`);
  const data = await response.json();
  return data;
}

document.addEventListener("DOMContentLoaded", () => {
  // ...
  const connectWithSquareButton = document.getElementById("connect-with-square");
  if (connectWithSquareButton) {
    connectWithSquareButton.addEventListener("click", connectWithSquare);
  }
  // ...
});

async function fetchCSRFToken() {
  try {
      const response = await fetch('/get_csrf_token');
      if (response.ok) {
          const data = await response.json();
          return data.csrf_token;
      } else {
          console.error("Failed to fetch CSRF token");
          return null;
      }
  } catch (error) {
      console.error("Error fetching CSRF token:", error);
      return null;
  }
}


async function connectWithSquare() {
  const userId = firebase.auth().currentUser.uid;
  const firestore = firebase.firestore();

  try {
      const userDoc = await firestore.collection("users").doc(userId).get();
      const restaurantId = userDoc.data().restaurantId;
      
      // Fetch the CSRF token
      const csrfToken = await fetchCSRFToken();
      if (!csrfToken) {
          console.error("Failed to get CSRF token");
          return;
      }
      
      // Encode the state parameter
      const stateData = {
          "restaurantId": restaurantId,
          "csrf_token": csrfToken
      };
      const state = btoa(JSON.stringify(stateData));
      
      // Construct the Square authorization URL
      const urlParams = new URLSearchParams({
          client_id: "sandbox-sq0idb--6fEGNSRA_VfU91OGguc_Q",
          response_type: "code",
          state: state,
          scope: "MERCHANT_PROFILE_READ PAYMENTS_READ ORDERS_READ ORDERS_WRITE",
          redirect_uri: "http://127.0.0.1:5000/oauth_callback"
      });

      const authUrl = `https://connect.squareupsandbox.com/oauth2/authorize?${urlParams.toString()}`;

      // Redirect the user to the Square authorization URL
      window.location.href = authUrl;
  } catch (error) {
      console.error("Error fetching restaurant ID or CSRF token:", error);
  }
}




function createChart(data) {
  const ctx = document.getElementById('chart').getContext('2d');
  const datasets = [];
  for (const restaurant of data) {
    datasets.push({
      label: restaurant.name,
      data: restaurant.data ? restaurant.data.map((point) => ({
        x: new Date(point.x * 1000),
        y: point.y,
      })) : [],
      backgroundColor: 'rgba(75, 192, 192, 0.2)',
      borderColor: 'rgba(75, 192, 192, 1)',
      borderWidth: 1,
      pointBackgroundColor: 'black',
      fill: false,
    });
  }
  new Chart(ctx, {
    type: 'line',
    data: {
      datasets,
    },
    options: {
      scales: {
        x: {
          type: 'time',
          time: {
            unit: 'day',
            tooltipFormat: 'MMM dd, yyyy',
            displayFormats: {
              day: 'MMM dd',
            },
          },
          title: {
            display: true,
            text: 'Date',
          },
        },
        y: {
          title: {
            display: true,
            text: 'Cumulative Amount',
          },
        },
      },
    },
  });
}



firebase.auth().onAuthStateChanged(function (user) {
  if (user) {
    console.log("Current user:", user.email);
    uid = user.uid;
  } else {
    console.log("No user logged in");
  }
});


function submitValue() {
  const firestore = firebase.firestore();
  const ordersLeft = ordersLeftValue.innerHTML;

  const userId = firebase.auth().currentUser.uid;

  firestore.collection("users").doc(userId).get().then((doc) => {
    if (doc.exists) {
      const restaurantId = doc.data().restaurantId;
      console.log(restaurantId);
      // Submit the value here
      fetch(`/restaurants/${restaurantId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          ordersLeft: ordersLeft
        })
      })
        .then(response => response.json())
        .then(data => {
          console.log(data);
          alert("Value submitted: " + ordersLeft);
        });

    } else {
      console.log("No such document!");
    }
  }).catch((error) => {
    console.log("Error getting document:", error);
  });
}


let ordersLeftValue;

document.addEventListener('DOMContentLoaded', () => {
  ordersLeftValue = document.getElementById('orders_left_value');
});

function decrease() {
  value--;
  console.log(value);
  if (ordersLeftValue) {
    updateValue();
  }
}

function increase() {
  value++;
  console.log(value);
  if (ordersLeftValue) {
    updateValue();
  }
}

function updateValue() {
  ordersLeftValue.innerHTML = value;
}

firebase.auth().onAuthStateChanged(function (user) {
  if (user) {
    console.log("Current user:", user.email);
    const firestore = firebase.firestore();
    const userId = user.uid;
    firestore.collection("users").doc(userId).get().then((doc) => {
      if (doc.exists) {
        const restaurantId = doc.data().restaurantId;
        firestore.collection("restaurants").doc(restaurantId).get().then((doc) => {
          if (doc.exists) {
            const ordersLeft = doc.data().ordersLeft;
            value = ordersLeft;
            document.getElementById("orders_left_value").innerText = ordersLeft;
          } else {
            console.log("No such restaurant document!");
          }
        }).catch((error) => {
          console.log("Error getting restaurant document:", error);
        });
      } else {
        console.log("No such user document!");
      }
    }).catch((error) => {
      console.log("Error getting user document:", error);
    });
  } else {
    console.log("No user logged in");
  }
});



async function main() {
  setTimeout(1000);
  if (uid) {
    console.log(uid);
    const data = await fetchRestaurantOrders(uid);
    const canvas = document.createElement('canvas');
    if (data.length > 0) {
      // Set the total amount text
      document.getElementById("total-amount").innerText = `Total Amount: $${data[0].totalAmount.toFixed(2)}`;
    }

    canvas.id = 'chart';
    document.getElementById('canvas-container').appendChild(canvas);
    
    createChart(data);
  } else {
    // No user is signed in.
    // Redirect to login page or show a message
  }
}

setTimeout(main, 1000);
