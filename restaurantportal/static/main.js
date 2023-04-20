
let uid = null;
let value = 0;

const firebaseConfig = {
  apiKey: "AIzaSyAzrBi9zuKrJDnZowoR9s9jJPqZX2egXUA",
  authDomain: "lastbite-907b1.firebaseapp.com",
  projectId: "lastbite-907b1",
  storageBucket: "lastbite-907b1.appspot.com",
  messagingSenderId: "342058562429",
  appId: "1:342058562429:web:f2fef939342130176f1214",
  measurementId: "G-9Z27YN7XJX"
};
firebase.initializeApp(firebaseConfig);

async function fetchRestaurantOrders(uid) {
  const response = await fetch(`/data?uid=${uid}`);
  const data = await response.json();
  return data;
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
            let value = ordersLeft;
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
