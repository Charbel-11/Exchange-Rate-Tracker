from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask import request
from flask_cors import CORS
from flask import jsonify
from flask_marshmallow import Marshmallow
from flask import abort
import json
from flask_bcrypt import Bcrypt
import datetime
import jwt

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:Arsenal.123@localhost:3306/exchange'
# app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:lobster@localhost:3306/exchange'
SECRET_KEY = "b'|\xe7\xbfU3`\xc4\xec\xa7\xa9zf:}\xb5\xc7\xb9\x139^3@Dv'"
ma = Marshmallow(app)
CORS(app)
db = SQLAlchemy(app)
bcrypt = Bcrypt()


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_name = db.Column(db.String(30), unique=True)
    hashed_password = db.Column(db.String(128))

    def __init__(self, user_name, password):
        super(User, self).__init__(user_name=user_name)
        self.hashed_password = bcrypt.generate_password_hash(password)

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

class UserTransactions(db.Model):
    transaction_id = db.Column(db.Integer, db.ForeignKey('transaction.id'), primary_key=True)
    user1_name = db.Column(db.String(30), db.ForeignKey('user.user_name'))
    user2_name = db.Column(db.String(30), db.ForeignKey('user.user_name'))