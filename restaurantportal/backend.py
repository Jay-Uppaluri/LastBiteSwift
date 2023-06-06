from contextlib import _RedirectStream
from datetime import datetime, timedelta
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import auth
import pytz


import json
from flask import Flask, render_template, Response, request, redirect, url_for, session, make_response
from flask import jsonify
import base64
import secrets
import requests
from dotenv import load_dotenv
import os

load_dotenv()

SQUARE_SANDBOX_CLIENT_ID = os.getenv("SQUARE_SANDBOX_CLIENT_ID")
SQUARE_SANDBOX_ACCESS_TOKEN = os.getenv("SQUARE_SANDBOX_ACCESS_TOKEN")

SQUARE_OAUTH_REDIRECT_URI = "http://127.0.0.1:5000/oauth_callback"
SQUARE_AUTHORIZE_URL = "https://connect.squareupsandbox.com/oauth2/authorize"
SQUARE_TOKEN_URL = "https://connect.squareupsandbox.com/oauth2/token"


app = Flask(__name__)
app.secret_key = "test secret key 2123*"
cred = credentials.Certificate(
    './serviceAccountKey.json')
firebase_admin.initialize_app(cred)


@app.route('/a')
def index():
    return render_template('index.html', firebase_config={
        'apiKey': os.getenv('FIREBASE_API_KEY'),
        'authDomain': os.getenv('FIREBASE_AUTH_DOMAIN'),
        'projectId': os.getenv('FIREBASE_PROJECT_ID'),
        'storageBucket': os.getenv('FIREBASE_STORAGE_BUCKET'),
        'messagingSenderId': os.getenv('FIREBASE_MESSAGING_SENDER_ID'),
        'appId': os.getenv('FIREBASE_APP_ID'),
        'measurementId': os.getenv('FIREBASE_MEASUREMENT_ID')
    })


def get_firestore_database():
    return firestore.client()


def get_orders(database):
    current_time = datetime.now()
    #two_weeks_ago = current_time - timedelta(days=14)
    #return database.collection("orders").where("timestamp", ">=", two_weeks_ago).get()
    return database.collection("orders").get()


@app.route('/data')
def get_data():
    userId = request.args.get('uid')
    database = get_firestore_database()
    user_doc = database.collection('users').document(userId).get()
    restaurant_id = user_doc.get("restaurantId")
    restaurant_doc = database.collection('restaurants').document(restaurant_id).get()

    if not restaurant_doc.exists:
        return jsonify({"error": "Restaurant not found"}), 404

    # Filter orders by restaurant ID before passing to the function
    orders = database.collection('orders').where("restaurantId", "==", restaurant_id).get()
    restaurant_amounts = get_running_total_for_restaurant(orders, database, restaurant_id)

    if restaurant_amounts is None:
        return jsonify({"error": "Invalid restaurant ID"}), 404

    restaurant_data = {
        "name": restaurant_doc.get("name"),
        "data": restaurant_amounts.get("data", []),
        "totalAmount": restaurant_amounts.get("amount", 0)
    }

    return jsonify([restaurant_data])


""" @app.route('/authorize/<restaurant_id>')
def authorize(restaurant_id):
    csrf_token = secrets.token_hex(16)
    session['csrf_token'] = csrf_token

    state_data = {
        "restaurantId": restaurant_id,
        "csrf_token": csrf_token,
    }
    state = base64.urlsafe_b64encode(json.dumps(state_data).encode()).decode()

    url_params = {
        'client_id': SQUARE_SANDBOX_CLIENT_ID,
        'response_type': 'code',
        'state': state,
        'scope': 'MERCHANT_PROFILE_READ PAYMENTS_READ',
        'redirect_uri': SQUARE_OAUTH_REDIRECT_URI
    }
    auth_url = requests.Request('GET', SQUARE_AUTHORIZE_URL, params=url_params).prepare().url

    return redirect(auth_url) """

@app.route('/get_csrf_token', methods=['GET'])
def get_csrf_token():
    auth.verify_id_token(session['firebase_token'])
    csrf_token = request.cookies.get("csrf_token")
    if csrf_token:
        return jsonify({"csrf_token": csrf_token}), 200
    return jsonify({"message": "Failed to get CSRF token"}), 400


@app.route('/oauth_callback')
def oauth_callback():
    authorization_code = request.args.get('code')
    print(request)
    print(authorization_code)
    encoded_state = request.args.get('state')
    state = json.loads(base64.urlsafe_b64decode(encoded_state.encode()))

    restaurant_id = state['restaurantId']
    csrf_token = state['csrf_token']

    # Debug: Print the CSRF tokens
    print(f"Provided CSRF token: {csrf_token}")

    # Get the user ID from the Firebase Authentication
    user = auth.verify_id_token(session['firebase_token'])
    user_id = user['uid']

    # Retrieve the stored CSRF token from the secure, HttpOnly cookie
    stored_csrf_token = request.cookies.get('csrf_token')

    # Debug: Print the stored CSRF token
    print(f"Stored CSRF token: {stored_csrf_token}")

    if csrf_token != stored_csrf_token:
        return "Invalid CSRF token", 403

    # Exchange the authorization_code for an access token
    token_url = 'https://connect.squareupsandbox.com/oauth2/token'  # Replace with the provider's token endpoint
    payload = {
        'grant_type': 'authorization_code',
        'code': authorization_code,
        'client_id': 'sandbox-sq0idb--6fEGNSRA_VfU91OGguc_Q',
        'client_secret': 'sandbox-sq0csb--QLxExckfqwKcmx1sAheDPuESwROWdwBd9qxzU4TIZw',
        'redirect_uri': 'http://127.0.0.1:5000/oauth_callback',
    }

    response = requests.post(token_url, data=payload)
    if response.status_code != 200:
        return "Failed to obtain access token", 400

    token_data = response.json()
    print(token_data)
    access_token = token_data.get('access_token')
    expires_at = token_data.get('expires_at')
    refresh_token = token_data.get('refresh_token')

    # Update the restaurant's access token in Firestore
    try:
        restaurant_ref = get_firestore_database().collection("restaurants").document(restaurant_id)
        restaurant_doc = restaurant_ref.get()

        if restaurant_doc.exists:

            ##expires_at = datetime.fromisoformat(expires_at[:-1]).timestamp()
            expires_at_datetime = datetime.strptime(expires_at, "%Y-%m-%dT%H:%M:%SZ")
            expires_at_timestamp = expires_at_datetime.replace(tzinfo=pytz.UTC)

            # Update access token info
            restaurant_ref.update({
                "accessTokenInfo": {
                    "accessToken": access_token,
                    "expiresAt": expires_at_timestamp,
                    "refreshToken": refresh_token
                }
            })
        else:
            return "Restaurant not found", 404
    except Exception as e:
        print(str(e))
        return "An error has occurred. Please try again", 500

    # ... (rest of the code for OAuth flow)

    return "OAuth flow completed successfully"


def get_running_total_for_restaurant(orders, database, restaurant_id):
    restaurant_amounts = {}

    restaurant = get_restaurant(database, restaurant_id)
    if restaurant is None:
        return None

    restaurant_name = restaurant.get("name", None)

    for order in orders:
        order_dict = order.to_dict()
        amount = order_dict["amount"]
        timestamp = order_dict["timestamp"]
        if restaurant_name:
            if restaurant_name in restaurant_amounts:
                restaurant_amounts[restaurant_name]["data"].append({"x": timestamp.timestamp(), "y": amount})
                restaurant_amounts[restaurant_name]["amount"] += amount
            else:
                restaurant_amounts[restaurant_name] = {"data": [{"x": timestamp.timestamp(), "y": amount}], "amount": amount}

    # Sort the data points by timestamp and compute the cumulative total
    for restaurant_name, data in restaurant_amounts.items():
        data["data"].sort(key=lambda point: point["x"])
        cumulative_total = 0
        for point in data["data"]:
            cumulative_total += point["y"]
            point["y"] = cumulative_total

    return restaurant_amounts.get(restaurant_name, None)


def get_restaurant(database, restaurant_id):
    restaurant_ref = database.collection("restaurants").document(restaurant_id)
    restaurant_doc = restaurant_ref.get()
    return restaurant_doc.to_dict() if restaurant_doc.exists else None




@app.route('/abc')
def render_login():
    return render_template('login.html', firebase_config={
        'apiKey': os.getenv('FIREBASE_API_KEY'),
        'authDomain': os.getenv('FIREBASE_AUTH_DOMAIN'),
        'projectId': os.getenv('FIREBASE_PROJECT_ID'),
        'storageBucket': os.getenv('FIREBASE_STORAGE_BUCKET'),
        'messagingSenderId': os.getenv('FIREBASE_MESSAGING_SENDER_ID'),
        'appId': os.getenv('FIREBASE_APP_ID'),
        'measurementId': os.getenv('FIREBASE_MEASUREMENT_ID')
    })


@app.route('/')
def login():
    return render_template('signup.html')


@app.route('/11')
def render_signUp():
    return render_template('index.html', firebase_config={
        'apiKey': os.getenv('FIREBASE_API_KEY'),
        'authDomain': os.getenv('FIREBASE_AUTH_DOMAIN'),
        'projectId': os.getenv('FIREBASE_PROJECT_ID'),
        'storageBucket': os.getenv('FIREBASE_STORAGE_BUCKET'),
        'messagingSenderId': os.getenv('FIREBASE_MESSAGING_SENDER_ID'),
        'appId': os.getenv('FIREBASE_APP_ID'),
        'measurementId': os.getenv('FIREBASE_MEASUREMENT_ID')
    })

@app.route('/signup', methods=['POST'])
def signup():
    # Get the form data from the request
    email = request.form['email']
    password = request.form['password']
    restaurant_id = request.form['restaurantId']

    # Generate the CSRF token
    csrf_token = secrets.token_hex(16)

    # Create a Firestore client
    db = firestore.client()

    # Create a new user document in the "users" collection
    user_data = {
        'email': email,
        'password': password,
        'restaurantId': restaurant_id,
        'csrfToken': csrf_token,
        'createdAt': datetime.now()
    }
    # Create a new user in Firebase Authentication
    auth = firebase_admin.auth
    user = auth.create_user(email=email, password=password)
    db.collection('users').document(user.uid).set(user_data)

    # Set the firebase_token in the session
    firebase_token = auth.create_custom_token(user.uid)
    session['firebase_token'] = firebase_token

    # Redirect the user to a success page
    return redirect(url_for('index'))


def restaurant_to_dict(restaurant):
    restaurant_dict = restaurant.to_dict()

    if "location" in restaurant_dict:
        restaurant_dict["location"] = {
            "latitude": restaurant_dict["location"].latitude,
            "longitude": restaurant_dict["location"].longitude
        }

    return restaurant_dict

#Put request to update orders left
# Function to update ordersLeft attribute of a restaurant
@app.route("/restaurants/<restaurant_id>", methods=["PUT"])
def update_orders_left(restaurant_id):
    firestore_db = get_firestore_database()
    restaurant_ref = firestore_db.collection("restaurants").document(str(restaurant_id))
    restaurant = restaurant_ref.get()

    if not restaurant.exists:
        return jsonify({"error": "Restaurant not found"}), 404

    try:
        data = request.get_json()
        orders_left = int(data["ordersLeft"])
        if(orders_left < 0) or (orders_left > 20):
       
            return jsonify({"error": "Cannot process this many orders"}), 400
 
    except (ValueError, KeyError, TypeError):
        return jsonify({"error": "Invalid data provided"}), 400

    restaurant_ref.update({"ordersLeft": orders_left})

    updated_restaurant = restaurant_to_dict(restaurant_ref.get())
    return jsonify({"success": True, "restaurant": updated_restaurant}), 200

def generate_csrf_token():
    return secrets.token_hex(16)

@app.route('/set_session', methods=['POST'])
def set_session():
    firebase_token = request.form['firebase_token']
    if firebase_token:
        session['firebase_token'] = firebase_token

        # Generate a CSRF token and store it server-side
        csrf_token = generate_csrf_token()
        
        # Store the CSRF token in a secure, HttpOnly cookie
        response = make_response(json.dumps({"message": "Session set successfully"}))
        response.set_cookie('csrf_token', csrf_token, secure=True, httponly=True)

        return response, 200
    return jsonify({"message": "Failed to set session"}), 400

""" def group_orders_by_restaurant(orders, database):
    restaurant_amounts = {}
    for order in orders:
        order_dict = order.to_dict()
        restaurant_id = order_dict["restaurantId"]
        amount = order_dict["amount"]
        timestamp = order_dict["timestamp"]
        restaurant = get_restaurant(database, restaurant_id)
        if restaurant:
            restaurant_name = restaurant["name"]
            if restaurant_name in restaurant_amounts:
                restaurant_amounts[restaurant_name]["data"].append({"x": timestamp.timestamp(), "y": amount})
                restaurant_amounts[restaurant_name]["amount"] += amount
            else:
                restaurant_amounts[restaurant_name] = {"data": [{"x": timestamp.timestamp(), "y": amount}], "amount": amount}

    # Sort the data points by timestamp and compute the cumulative total
    for restaurant_name, data in restaurant_amounts.items():
        data["data"].sort(key=lambda point: point["x"])
        cumulative_total = 0
        for point in data["data"]:
            cumulative_total += point["y"]
            point["y"] = cumulative_total

    return restaurant_amounts """

""" def get_restaurant(database, restaurant_id):
    restaurant_ref = database.collection("restaurants").document(restaurant_id)
    restaurant_doc = restaurant_ref.get()

    return restaurant_doc.to_dict() if restaurant_doc.exists else None """




if __name__ == '__main__':
    app.run()
