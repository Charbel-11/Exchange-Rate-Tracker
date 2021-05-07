import statistics
import datetime
from flask import request, jsonify, abort, Blueprint
from models.User import User
from models.Transaction import Transaction, TransactionSchema
from models.UserTransaction import UserTransactions

app_features = Blueprint('app_features', __name__)


#Returns the exchange rate from the Transaction Table
@app_features.route('/exchangeRate/<number>', methods = ['GET'])
def exchangeRate(number):
    """ Returns the exchange rates during a specific range of days. 
    ---
    parameters:
      - name: number
        in: path
        type : string
        example: 7
        required: true
        description : The range of days the function needs to work on. 7 means the last week ...
    responses:
      200:
        description: The exchange rate during the last "number" days. It returns both usd_to_lbp and lbp_to_usd rates. 

      400:
        description : The input is invalid. Make sure you have passed a number in the path.
    """
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
@app_features.route('/stats/<number>', methods = ['GET'])
def get_stats(number):
    """ Returns a bunch of stats for the transactions registered for a specific range of days. 
    ---
    parameters:
      - name: number
        in: path
        type : string
        example: 7
        required: true
        description : The range of days the function needs to work on. 7 means the last week ...
    responses:
      200:
        description: Returns stats as Maximum, Median, Stdev, Mode, and Variance

      400:
        description : The input is invalid. Make sure you have passed a number in the path.
    """
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

    stats["max_usd_to_lbp"] = max(usd_numbers)
    stats["max_lbp_to_usd"] = max(lbp_numbers)
    stats["median_usd_to_lbp"] = statistics.median(usd_numbers)
    stats["median_lbp_to_usd"] = statistics.median(lbp_numbers)
    stats["stdev_usd_to_lbp"] = statistics.stdev(usd_numbers)
    stats["stdev_lbp_to_usd"] = statistics.stdev(lbp_numbers)
    stats["mode_usd_to_lbp"] = statistics.mode(usd_numbers)
    stats["mode_lbp_to_usd"] = statistics.mode(lbp_numbers)
    stats["variance_usd_to_lbp"] = statistics.variance(usd_numbers)
    stats["variance_lbp_to_usd"] = statistics.variance(lbp_numbers)


    return jsonify(stats)

# Returns the average usd_to_lbp per rate for a range of days requested by the user
@app_features.route('/graph/usd_to_lbp/<number>', methods = ['GET'])
def sortedGraph(number):
    """ Returns the average USD -> LBP exchange rate for each day during a specific range specified by the user 
    ---
    parameters:
      - name: number
        in: path
        type : string
        example: 7
        required: true
        description : The range of days the function needs to work on. 7 means the last week ...
    responses:
      200:
        description: A json containing the average USD -> LBP rate per day

      400:
        description : The input is invalid. Make sure you have passed a number in the path.
    """
    START_DATE = datetime.datetime.now() - datetime.timedelta(days = int(number))
    END_DATE = datetime.datetime.now()
    usd_to_lbp = Transaction.query.filter(Transaction.added_date.between(START_DATE, END_DATE),Transaction.usd_to_lbp == True).all()

    dates = {}

    for transaction in usd_to_lbp:
        if transaction.added_date.strftime("%d %b %Y") not in dates:
            dates[transaction.added_date.strftime("%d %b %Y")] = [0,0.0]
        dates[transaction.added_date.strftime("%d %b %Y")][0] += 1
        dates[transaction.added_date.strftime("%d %b %Y")][1] += (transaction.lbp_amount / transaction.usd_amount)

    res = []
    for i in range(int(number)-1,-1,-1):
        date = (datetime.datetime.now() - datetime.timedelta(days = i)).strftime("%d %b %Y")
        if date not in dates:
            res.append({'date' : date, 'rate' : -1})
        else :
            res.append({'date' : date, 'rate' : dates[date][1]/dates[date][0]})

    return jsonify(res)

# Returns the average lbp_to_usd per rate for a range of days requested by the user
@app_features.route('/graph/lbp_to_usd/<number>', methods = ['GET'])
def sortedGraph2(number):
    """ Returns the average LBP -> USD exchange rate for each day during a specific range specified by the user 
    ---
    parameters:
      - name: number
        in: path
        type : string
        example: 7
        required: true
        description : The range of days the function needs to work on. 7 means the last week ...
    responses:
      200:
        description: A json containing the average LBP -> USD rate per day

      400:
        description : The input is invalid. Make sure you have passed a number in the path.
    """
    START_DATE = datetime.datetime.now() - datetime.timedelta(days = int(number))
    END_DATE = datetime.datetime.now()
    lbp_to_usd = Transaction.query.filter(Transaction.added_date.between(START_DATE, END_DATE),Transaction.usd_to_lbp == False).all()

    dates = {}

    for transaction in lbp_to_usd:
        if transaction.added_date.strftime("%d %b %Y") not in dates:
            dates[transaction.added_date.strftime("%d %b %Y")] = [0,0.0]
        dates[transaction.added_date.strftime("%d %b %Y")][0] += 1
        dates[transaction.added_date.strftime("%d %b %Y")][1] += (transaction.lbp_amount / transaction.usd_amount)

    res = []
    for i in range(int(number)-1,-1,-1):
        date = (datetime.datetime.now() - datetime.timedelta(days = i)).strftime("%d %b %Y")
        if date not in dates:
            res.append({'date' : date, 'rate' : -1})
        else :
            res.append({'date' : date, 'rate' : dates[date][1]/dates[date][0]})

    return jsonify(res)