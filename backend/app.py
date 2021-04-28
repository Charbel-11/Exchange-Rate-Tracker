from flask import Flask 
from flask_sqlalchemy import SQLAlchemy
from flask import request
from flask import Response
from flask import jsonify
from flask_marshmallow import Marshmallow
from flask_bcrypt import Bcrypt
from flask_cors import CORS , cross_origin
import jwt
import datetime
import requests
import json
import statistics





#### Setup ####
app = Flask(__name__)
ma = Marshmallow(app)
bcrypt = Bcrypt(app)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:Arsenal.123@localhost:3306/exchange'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:lobster@localhost:3306/exchange'
CORS(app)

db = SQLAlchemy(app)

SECRET_KEY = "b'|\xe7\xbfU3`\xc4\xec\xa7\xa9zf:}\xb5\xc7\xb9\x139^3@Dv'"








#### Helper Functions ####    
def create_token(user_id):
    payload = {
        'exp': datetime.datetime.utcnow() + datetime.timedelta(days=4),
        'iat': datetime.datetime.utcnow(),
        'sub': user_id
    }
    return jwt.encode(
        payload,
        SECRET_KEY,
        algorithm='HS256'
    )

def extract_auth_token(authenticated_request):
    auth_header = authenticated_request.headers.get('Authorization')
    if auth_header and auth_header!="Bearer":
        return auth_header.split(" ")[1]
    else:
        return None

def decode_token(token):
    payload = jwt.decode(token, SECRET_KEY, 'HS256')
    return payload['sub']







#### API CALLS ####



## User ##

#Add a new user to the Users Table
@app.route('/user', methods = ['POST'])
def add_user():
    user_name = request.json.get('user_name')
    password = request.json.get('password')
    if user_name and password:
        new_User = User(
            user_name = user_name,
            password = password
        )
        db.session.add(new_User)
        db.session.commit()
        return jsonify(user_schema.dump(new_User))
    return Response("{ 'Message' : 'Invalid Input :(' }", status=400, mimetype='application/json')


#Get the user_names of all users in the database
@app.route('/users', methods = ['GET'])
def get_users():
    users = User.query.with_entities(User.user_name, User.id)
    return jsonify(users_schema.dump(users))


#Authenticate a User
@app.route('/authentication', methods = ['POST'])
def authenticate_user():
    user_name = request.json.get('user_name')
    password = request.json.get('password')
    if user_name and password:
        user = User.query.filter_by(user_name = user_name).first()
        if(user is None):
            return Response("{ 'Message' : 'Invalid Username :(' }", status=403, mimetype='application/json')
        same_password = bcrypt.check_password_hash(user.hashed_password,password)
        if(same_password is False):
            return Response("{ 'Message' : 'Invalid Password :(' }", status=403, mimetype='application/json')
        
        # User is indeed valid, return a jwt token
        Token = create_token(user.id)
        return jsonify (
            token = Token   
        )


## USER DONE ##



## Transaction ##


#Add a transaction to our Transaction Table
@app.route('/transaction', methods = ['POST'])
def add_transaction():
    usd_amount = request.json.get('usd_amount')
    lbp_amount = request.json.get('lbp_amount')
    usd_to_lbp = request.json.get('usd_to_lbp')
    user_id = None

    token = extract_auth_token(request)
    if(token):
        try : 
            user_id = decode_token(token)
        except :
            return Response("{ 'Message' : 'Invalid Token :(' }", status=403, mimetype='application/json')
        
    if usd_amount and lbp_amount and usd_to_lbp is not None:
        new_Transaction = Transaction(
            usd_amount = usd_amount,
            lbp_amount = lbp_amount,
            usd_to_lbp = usd_to_lbp,
            user_id = user_id,
        )
        db.session.add(new_Transaction)
        db.session.commit()
        return jsonify(transaction_schema.dump(new_Transaction))
    return Response("{ 'Message' : 'Invalid Input :(' }", status=400, mimetype='application/json')


#Post a transaction between two users.
@app.route('/userTransaction/<username>', methods = ['POST'])
def add_user_transaction(username):
    usd_amount = request.json.get('usd_amount')
    lbp_amount = request.json.get('lbp_amount')
    usd_to_lbp = request.json.get('usd_to_lbp')

    token = extract_auth_token(request)
    if(token):
        try :
            user1_id = decode_token(token)

            user1_name = User.query.filter_by(id = user1_id).all()[0].user_name

            #Just to make sure that the username passed is valid. If not, it will throw an exception
            user2 = User.query.filter_by(user_name = username)

            if usd_amount and lbp_amount and usd_to_lbp is not None:
                new_Transaction = Transaction(
                    usd_amount = usd_amount,
                    lbp_amount = lbp_amount,
                    usd_to_lbp = usd_to_lbp,
                    user_id = user1_id,
                )
                db.session.add(new_Transaction)
                db.session.commit()
                
                new_User_Transaction = UserTransactions(
                    user1_name = user1_name,
                    user2_name = username,
                    transaction_id = new_Transaction.id
                )

                db.session.add(new_User_Transaction)
                db.session.commit()

                return jsonify(transaction_schema.dump(new_Transaction))

        except :
            return Response("{ 'Message' : 'Invalid Input :(' }", status=400, mimetype='application/json')
    
    return Response("{ 'Message' : 'You're not signed in! }", status=400, mimetype='application/json')

#Get all UserTransactions for a certain user
@app.route('/userTransactions', methods = ['GET'])
def get_User_Transactions():
    token = extract_auth_token(request)
    if(token):
        try : 
            user1_id = decode_token(token)

            username = User.query.filter_by(id = user1_id).all()[0].user_name

            #If he was the buyer or the seller
            allUserTransactions = []

            user_transactions1 = UserTransactions.query.filter_by(user1_name = username).all()
            user_transactions2 = UserTransactions.query.filter_by(user2_name = username).all()

            for user_transaction in user_transactions1:
                transaction = Transaction.query.filter_by(id = user_transaction.transaction_id).first()
                current = [user_transaction.user2_name,transaction.usd_amount,transaction.lbp_amount,transaction.usd_to_lbp,transaction.added_date.strftime("%d %b %Y ")]
                allUserTransactions.append(current)
            
            for user_transaction in user_transactions2:
                transaction = Transaction.query.filter_by(id = user_transaction.transaction_id).first()
                current = [user_transaction.user1_name,transaction.usd_amount,transaction.lbp_amount,transaction.usd_to_lbp,transaction.added_date.strftime("%d %b %Y ")]
                allUserTransactions.append(current)

            return jsonify(allUserTransactions)
        
        except : 
            return Response("{ 'Message' : 'Invalid Input :(' }", status=400, mimetype='application/json')

    return Response("{ 'Message' : 'You're not signed in! }", status=400, mimetype='application/json')

# Example Output : For user Hussein, these are his User Transactions returned :
# [
#   ["MariaMattar20",1.0,11500.0,true,"11 Apr 2021 "],
#   ["CharbelChucri20",1.0,11500.0,true,"11 Apr 2021 "],
#   ["OmarKhodr20",1.0,11500.0,true,"11 Apr 2021 "],
#   ["OmarKhodr20",1.0,10500.0,false,"11 Apr 2021 "]
# ]


#Get all transactions for a certain user
@app.route('/transaction', methods = ['GET'])
def getTransactions():
    token = extract_auth_token(request)
    if(token):
        try:
            user_id = decode_token(token)
            transactions = Transaction.query.filter_by(user_id = user_id).all()
            return jsonify(transactions_schema.dump(transactions))
        except :
            return Response("{ 'Message' : 'Invalid Token :(' }", status=400, mimetype='application/json')



## Features ##

#Returns the exchange rate from the Transaction Table
@app.route('/exchangeRate/<number>', methods = ['GET'])
def exchangeRate(number):
    START_DATE = datetime.datetime.now() - datetime.timedelta(days = int(number))
    END_DATE = datetime.datetime.now()
    usd_to_lbp = Transaction.query.filter(Transaction.added_date.between(START_DATE, END_DATE),Transaction.usd_to_lbp == True).all()
    lbp_to_usd = Transaction.query.filter(Transaction.added_date.between(START_DATE, END_DATE),Transaction.usd_to_lbp == False).all()
    
    sum1 = 0.0
    len1 = 0
    for transaction in usd_to_lbp:
        len1 = len1 + 1
        difference = transaction.lbp_amount / transaction.usd_amount
        sum1 = sum1 + difference
    
    sum2 = 0.0
    len2 = 0
    for transaction in lbp_to_usd:
        len2 = len2 + 1
        difference = transaction.lbp_amount / transaction.usd_amount
        sum2 = sum2 + difference

    avg1 = -1
    avg2 = -1

    if(len1 != 0):
        avg1 = sum1 / len1
    if(len2 != 0):
        avg2 = sum2 / len2

    return jsonify(
        usd_to_lbp = avg1,
        lbp_to_usd = avg2
    )


#Returns a bunch of stats for the exchange rate for a range of days
@app.route('/stats/<number>', methods = ['GET'])
def get_stats(number):
    START_DATE = datetime.datetime.now() - datetime.timedelta(days = int(number))
    END_DATE = datetime.datetime.now()
    usd_to_lbp = Transaction.query.filter(Transaction.added_date.between(START_DATE, END_DATE),Transaction.usd_to_lbp == True).all()
    lbp_to_usd = Transaction.query.filter(Transaction.added_date.between(START_DATE, END_DATE),Transaction.usd_to_lbp == False).all()

    usd_numbers = []
    for transaction in usd_to_lbp:
        usd_numbers.append(transaction.lbp_amount / transaction.usd_amount)
    
    lbp_numbers =[]
    for transaction in lbp_to_usd:
        lbp_numbers.append(transaction.lbp_amount / transaction.usd_amount)

    # Dictionary to store the stats calculated
    stats = {}

    stats["max-usd_to_lbp"] = max(usd_numbers)
    stats["max-lbp-to-usd"] = max(lbp_numbers)
    stats["median-usd_to_lbp"] = statistics.median(usd_numbers)
    stats["median-lbp_to_usd"] = statistics.median(lbp_numbers)
    stats["stdev-usd_to_lbp"] = statistics.stdev(usd_numbers)
    stats["stdev-lbp_to_usd"] = statistics.stdev(lbp_numbers)
    stats["mode-usd_to_lbp"] = statistics.mode(usd_numbers)
    stats["mode-lbp_to_usd"] = statistics.mode(lbp_numbers)
    stats["variance-usd_to_lbp"] = statistics.variance(usd_numbers)
    stats["variance-lbp_to_usd"] = statistics.variance(lbp_numbers)


    return jsonify(stats)

# Returns the average usd_to_lbp per rate for a range of days requested by the user
@app.route('/graph/usd_to_lbp/<number>', methods = ['GET'])
def sortedGraph(number):
    usd_to_lbp_graph = []
    for i in range(int(number)):
        req = requests.get('http://localhost:5000/exchangeRate/' + str(i)).json()
        current = {"date" : (datetime.datetime.now() - datetime.timedelta(days = i)).strftime("%d %b %Y ")  , "rate" : req['usd_to_lbp']}
        usd_to_lbp_graph.append(current)
    return jsonify(usd_to_lbp_graph)

# Returns the average lbp_to_usd per rate for a range of days requested by the user
@app.route('/graph/lbp_to_usd/<number>', methods = ['GET'])
def sortedGraph2(number):
    lbp_to_usd_graph = []
    for i in range(int(number)):
        req = requests.get('http://localhost:5000/exchangeRate/' + str(i)).json()
        current = {"date" : (datetime.datetime.now() - datetime.timedelta(days = i)).strftime("%d %b %Y ")  , "rate" : req['lbp_to_usd']}
        lbp_to_usd_graph.append(current)
    return jsonify(lbp_to_usd_graph)
















#### Models ####
class Transaction(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    usd_amount = db.Column(db.Float)
    lbp_amount = db.Column(db.Float)
    usd_to_lbp = db.Column(db.Boolean)
    added_date = db.Column(db.DateTime)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)

    def __init__(self, usd_amount, lbp_amount, usd_to_lbp, user_id):
        super(Transaction, self).__init__(
            usd_amount=usd_amount,
            lbp_amount=lbp_amount, 
            usd_to_lbp=usd_to_lbp,
            user_id=user_id,
            added_date=datetime.datetime.now()
        )

class TransactionSchema(ma.Schema):
    class Meta:
        fields = ("id", "usd_amount", "lbp_amount", "usd_to_lbp", "added_date", "user_id")
        model = Transaction

transaction_schema = TransactionSchema()

transactions_schema = TransactionSchema(many = True)


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_name = db.Column(db.String(30), unique=True)
    hashed_password = db.Column(db.String(128))

    def __init__(self, user_name, password):
        super(User, self).__init__(user_name=user_name)
        self.hashed_password = bcrypt.generate_password_hash(password)

class UserSchema(ma.Schema):
    class Meta:
        fields = ("id", "user_name")
        model = User

user_schema = UserSchema()

users_schema = UserSchema(many = True)

# A table that shows transactions between users.
class UserTransactions(db.Model):
    transaction_id = db.Column(db.Integer, db.ForeignKey('transaction.id'), primary_key=True)
    user1_name = db.Column(db.String(30), db.ForeignKey('user.user_name'))
    user2_name = db.Column(db.String(30), db.ForeignKey('user.user_name'))


