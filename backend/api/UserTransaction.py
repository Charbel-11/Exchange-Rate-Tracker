from flask import request, jsonify, abort, Blueprint
from app import db, bcrypt
from models.User import User
from models.Transaction import Transaction, TransactionSchema
from models.UserTransaction import UserTransactions
from api.helper import create_token, extract_auth_token, decode_token
import datetime


transaction_schema = TransactionSchema()

transactions_schema = TransactionSchema(many = True)

app_user_transaction = Blueprint('app_user_transaction', __name__)


#Post a transaction between two users.
@app_user_transaction.route('/userTransaction/<username>', methods = ['POST'])
def add_user_transaction(username):
    """ Adds a new User-Transaction. 
    ---
    parameters:
      - name : username
        in : path
        type : string
        required : true
        example : MariaMattar20
        description : The username of the user you've done the transcation with
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
        description: The User-Transaction added as a json.

      400:
        description : The input is invalid. Make sure you have passed the needed body.
    """


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
@app_user_transaction.route('/userTransactions', methods = ['GET'])
def get_User_Transactions():
    """ Returns all User-Transactions registered by the signed in user.
    ---
    parameters:
      - name: token
        in: header
        type : string
        required: true
        description : The token returned by the backend whenever a certain user signs in. The token is a hashed string of the user's id
    responses:
      200:
        description: A json of all User-Transactions registered by the signed in user.
      400:
        description : The token passed is invalid.

    """
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
