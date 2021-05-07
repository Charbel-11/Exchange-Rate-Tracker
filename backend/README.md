# Backend

## About
This is EECE 430L project's backend. Coded by Hussein Jaber with the help of the instructor Mohammad Chehab and my teammates Charbel Chucri,
Maria Mattar, and Omar Khodr

## Technlogies
The technologies used are
* Flask : A micro-framework for Python. It allows you to build websites and web apps quite rapidly and easily.
* MySQL : A relational database management system based on SQL – Structured Query Language. The application is used for a wide range of purposes, including data warehousing, e-commerce, and logging applications.

## Setup
Follow the steps below to setup your backend:
1. Clone the repo:
    1. Create a new folder anywhere in your PC.
    2. Open Command Prompt and change the path to the new folder created.
    3. Using the Command Prompt, write : git clone https://github.com/OmarKhodr/exchange-rate
2. Make sure you have Flask installed. Check this link to know more : https://phoenixnap.com/kb/install-flask
3. By now, you'll find the folder cloned into your new folder. Using Command Prompt, write cd/exchange-rate/backend
4. To install the dependencies needed to run the application, run "pip install -r requirements.txt" using Command Prompt. Note that this step is done only once
5. To run the flask application, write:
    1. set FLASK_APP=server.py
    2. flask run
6.The flask application will be running on localhost:5000 by now

## Database Models
The database has 3 models:
* User
    * Attributes :
        * Id : Primary Key
        * user_name
        * password
* Transaction
    * Attributes :
        * Id : Primary Key
        * user_id : Foreign Key to User(id)
        * usd_amount
        * lbp_amount
        * usd_to_lbp
* UserTransaction
    * Attributes :
        * transaction_id : Primary Key and Foreign Key to Transaction(id)
        * user1_name : Foreign Key to User(user_name)
        * user2_name : Foreign Key to User(user_name)

## Documentation
For API documentation, Swagger UI was used. Swagger UI allows anyone — be it your development team or your end consumers — to visualize and interact with the API’s resources without having any of the implementation logic in place. It’s automatically generated from your OpenAPI (formerly known as Swagger) Specification, with the visual documentation making it easy for back end implementation and client side consumption.

To check the documentation :
1. Make sure you have flasgger installed. If not, just write "pip install flasgger" using CP.
2. Run your flask application as mentioned in the Setup section above.
3. Using any browser, go to http://localhost:5000/apidocs/

You should see something like this :

![alt text](https://github.com/OmarKhodr/exchange-rate/blob/main/backend/Documentation.PNG?raw=true)
