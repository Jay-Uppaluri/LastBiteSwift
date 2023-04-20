from contextlib import _RedirectStream
from datetime import datetime, timedelta
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import auth
import json
from flask import Flask, render_template, Response, request, redirect, url_for

app = Flask(__name__)
cred = credentials.Certificate('C:\\Users\\srina\\Desktop\\lastbite_python\\serviceAccountKey.json')
firebase_admin.initialize_app(cred)


@app.route('/a')
def index():
    return render_template('index.html')

def get_firestore_database():
    return firestore.client()

def get_orders(database):
    current_time = datetime.now()
    two_weeks_ago = current_time - timedelta(days=14)
    
    return database.collection("orders").where("timestamp", ">=", two_weeks_ago).get()

def get_restaurant(database, restaurant_id):
    restaurant_ref = database.collection("restaurants").document(restaurant_id)
    restaurant_doc = restaurant_ref.get()

    return restaurant_doc.to_dict() if restaurant_doc.exists else None

def group_orders_by_restaurant(orders, database):
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

    return restaurant_amounts

@app.route('/data')
def get_data():
    database = get_firestore_database()
    orders = get_orders(database)
    restaurant_amounts = group_orders_by_restaurant(orders, database)
    restaurant_data = []
    for restaurant_name, data in restaurant_amounts.items():
        restaurant_data.append({
            "name": restaurant_name,
            "data": data["data"],
            "totalAmount": data["amount"]
        })
    response = Response(json.dumps(restaurant_data), content_type='application/json;charset=utf-8')
    return response

@app.route('/abc')
def render_login():
    return render_template('login.html')

@app.route('/')
def login():
    return render_template('signup.html')



@app.route('/11')
def render_signUp():
    return render_template('index.html')

@app.route('/signup', methods=['POST'])
def signup():
    # Get the form data from the request
    email = request.form['email']
    password = request.form['password']
    restaurant_id = request.form['restaurantId']
    
    # Create a Firestore client
    db = firestore.client()
    
    # Create a new user document in the "users" collection
    user_data = {
        'email': email,
        'password': password,
        'restaurantId': restaurant_id,
        'createdAt': datetime.now()
    }
    #db.collection('users').add(user_data)
    #Create a new user in Firebase Authentication
    auth = firebase_admin.auth
    user = auth.create_user(email=email, password=password)
    db.collection('users').document(user.uid).set(user_data)
    # Add custom claims to the user indicating their restaurant ID
    #auth.set_custom_user_claims(user.uid, {'restaurant_id': restaurant_id})
    
    # Redirect the user to a success page
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run()
