from flask import request, jsonify, abort, Blueprint, Response
from app import db, bcrypt
from models.User import User
from models.Transaction import Transaction, TransactionSchema
from api.helper import create_token, extract_auth_token, decode_token
import datetime


transaction_schema = TransactionSchema()

transactions_schema = TransactionSchema(many = True)

app_transaction = Blueprint('app_transaction', __name__)

#Add a transaction to our Transaction Table
@app_transaction.route('/transaction', methods = ['POST'])
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

#Get all transactions for a certain user
@app_transaction.route('/transaction', methods = ['GET'])
def getTransactions():
    token = extract_auth_token(request)
    if(token):
        try:
            user_id = decode_token(token)
            transactions = Transaction.query.filter_by(user_id = user_id).all()
            return jsonify(transactions_schema.dump(transactions))
        except :
            return Response("{ 'Message' : 'Invalid Token :(' }", status=400, mimetype='application/json')

