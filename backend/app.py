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






#### Setup ####
app = Flask(__name__)
ma = Marshmallow(app)
bcrypt = Bcrypt(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:Arsenal.123@localhost:3306/exchange'
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


#Add a new user to the Users Table
@app.route('/addUser', methods = ['POST'])
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
@app.route('/getUsers', methods = ['GET'])
def get_users():
    users = User.query.with_entities(User.user_name, User.id)
    return jsonify(users_schema.dump(users))




#Authenticate a User
@app.route('/authenticate', methods = ['POST'])
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


#Add a transaction to our Transaction Table
@app.route('/addTransaction', methods = ['POST'])
def add_transaction():
    usd = request.json.get('usd')
    lbp = request.json.get('lbp')
    usd_to_lbp = request.json.get('usd_to_lbp')
    user_id = None

    token = extract_auth_token(request)
    if(token):
        try : 
            user_id = decode_token(token)
        except :
            return Response("{ 'Message' : 'Invalid Token :(' }", status=403, mimetype='application/json')
        
    if usd and lbp and usd_to_lbp is not None:
        new_Transaction = Transaction(
            usd = usd,
            lbp = lbp,
            usd_to_lbp = usd_to_lbp,
            user_id = user_id,
        )
        db.session.add(new_Transaction)
        db.session.commit()
        return jsonify(transaction_schema.dump(new_Transaction))
    return Response("{ 'Message' : 'Invalid Input :(' }", status=400, mimetype='application/json')


#Post a transaction between two users.
@app.route('/addUserTransaction/<username>', methods = ['POST'])
def add_user_transaction(username):
    usd = request.json.get('usd')
    lbp = request.json.get('lbp')
    usd_to_lbp = request.json.get('usd_to_lbp')

    token = extract_auth_token(request)
    if(token):
        try :
            user1_id = decode_token(token)

            user1_name = User.query.filter_by(id = user1_id).all()[0].user_name

            #Just to make sure that the username passed is valid. If not, it will throw an exception
            user2 = User.query.filter_by(user_name = username)

            if usd and lbp and usd_to_lbp is not None:
                new_Transaction = Transaction(
                    usd = usd,
                    lbp = lbp,
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
@app.route('/getUserTransactions', methods = ['GET'])
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
                current = [user_transaction.user2_name,transaction.usd,transaction.lbp,transaction.usd_to_lbp,transaction.added_date]
                allUserTransactions.append(current)
            
            for user_transaction in user_transactions2:
                transaction = Transaction.query.filter_by(id = user_transaction.transaction_id).first()
                current = [user_transaction.user1_name,transaction.usd,transaction.lbp,transaction.usd_to_lbp,transaction.added_date]
                allUserTransactions.append(current)

            res = jsonify(allUserTransactions)
            return res
        
        except : 
            return Response("{ 'Message' : 'Invalid Input :(' }", status=400, mimetype='application/json')

    return Response("{ 'Message' : 'You're not signed in! }", status=400, mimetype='application/json')

#Get all transactions for a certain user
@app.route('/getTransactions', methods = ['GET'])
def getTransactions():
    token = extract_auth_token(request)
    if(token):
        try:
            user_id = decode_token(token)
            transactions = Transaction.query.filter_by(user_id = user_id).all()
            return jsonify(transactions_schema.dump(transactions))
        except :
            return Response("{ 'Message' : 'Invalid Token :(' }", status=400, mimetype='application/json')


#Returns the exchange rate from the Transaction Table
@app.route('/exchangeRate', methods = ['GET'])
def exchangeRate():
    START_DATE = datetime.datetime.now() - datetime.timedelta(days = 3)
    END_DATE = datetime.datetime.now()
    usd_to_lbp = Transaction.query.filter(Transaction.added_date.between(START_DATE, END_DATE),Transaction.usd_to_lbp == True).all()
    lbp_to_usd = Transaction.query.filter(Transaction.added_date.between(START_DATE, END_DATE),Transaction.usd_to_lbp == False).all()
    
    sum1 = 0.0
    len1 = 0
    for transaction in usd_to_lbp:
        len1 = len1 + 1
        difference = transaction.lbp / transaction.usd
        sum1 = sum1 + difference
    
    sum2 = 0.0
    len2 = 0
    for transaction in lbp_to_usd:
        len2 = len2 + 1
        difference = transaction.lbp / transaction.usd
        sum2 = sum2 + difference

    avg1 = "Not Available Yet"
    avg2 = "Not Available Yet"
    if(len1 != 0):
        avg1 = sum1 / len1
    if(len2 != 0):
        avg2 = sum2 / len2

    return jsonify(
        usd_to_lbp = avg1,
        lbp_to_usd = avg2
    )


















#### Models ####
class Transaction(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    usd = db.Column(db.Float)
    lbp = db.Column(db.Float)
    usd_to_lbp = db.Column(db.Boolean)
    added_date = db.Column(db.DateTime)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)

    def __init__(self, usd, lbp, usd_to_lbp, user_id):
        super(Transaction, self).__init__(usd=usd,
        lbp=lbp, usd_to_lbp=usd_to_lbp,
        user_id=user_id,
        added_date=datetime.datetime.now())

class TransactionSchema(ma.Schema):
    class Meta:
        fields = ("id", "usd", "lbp", "usd_to_lbp", "added_date", "user_id")
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


