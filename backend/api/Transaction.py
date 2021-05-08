from flask import request, jsonify, abort, Blueprint, Response
from app import db, bcrypt
from models.User import User
from models.UserTransaction import UserTransactions
from models.Transaction import Transaction, TransactionSchema
from api.helper import create_token, extract_auth_token, decode_token
import datetime


transaction_schema = TransactionSchema()

transactions_schema = TransactionSchema(many = True)

app_transaction = Blueprint('app_transaction', __name__)

#Add a transaction to our Transaction Table
@app_transaction.route('/transaction', methods = ['POST'])
def add_transaction():
    """ Adds a new transaction. 
    ---
    parameters:
      - name: usd_amount
        in: body
        type : number
        example: 10
        required: true
      - name: lbp_amount
        in: body
        type : number
        example: 130000
        required: true
      - name : usd_to_lbp
        in : body
        type : boolean
        example : 1
        required : true
        description : True if the transaction is USD to LBP. False otherwise.
      - name : token
        in : header
        type : string
        required : false
        description : A token should be passed if the user is signed in. Not passed otherwise.  
    responses:
      200:
        description: The transaction added as a json.

      400:
        description : The input is invalid. Make sure you have passed the needed body.
    """

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
    """ Returns all transactions registered by the signed in user.
    ---
    parameters:
      - name: token
        in: header
        type : string
        required: true
        description : The token returned by the backend whenever a certain user signs in. The token is a hashed string of the user's id
    responses:
      200:
        description: A json of all transactions registered

    """

    token = extract_auth_token(request)
    if(token):
      try:     
          user_id = decode_token(token)
          user_name = User.query.filter_by(id = user_id).first().user_name
          sold_transactions = UserTransactions.query.filter_by(user2_name = user_name).all()
          user_transactions = []
          for transaction in sold_transactions:
                cur_transaction = Transaction.query.filter_by(id = transaction.transaction_id).first()
                user_transactions.append(cur_transaction)
          transactions = Transaction.query.filter_by(user_id = user_id).all()

          res = []
          for transaction in transactions:
                res.append(transaction_schema.dump(transaction))
          for transaction in user_transactions:
                res.append(transaction_schema.dump(transaction))
          return jsonify(res)
      except : 
          return Response("{ 'Message' : 'Invalid Input :(' }", status=400, mimetype='application/json')
  
    

