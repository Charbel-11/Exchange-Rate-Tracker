# Frontend - Web

### About
This is EECE 430L project's frontend Web. Coded by Charbel Chucri with the help of the instructor Mohammad Chehab and my teammates Hussein Jaber, Maria Mattar, and Omar Khodr.

### Technologies
React JS was used for web development.

### Setup

#### Step 1 : Setup and Run the Backend
Refer to the README file available in the [backend directory](https://github.com/OmarKhodr/exchange-rate/tree/main/backend)

#### Step 2 : Install Packages
The node_modules directory is not a part of a cloned repository and should be downloaded using the npm install command to download all the direct and transitive dependencies mentioned in the package.json file:
1. Using the Command Prompt, go to the project directory: cd exchange-rate
2. Using the Command Prompt, Enter : cd frontend-web
3. Using the Command Prompt, Enter : npm install

#### Step 3 : Run the Frontend
1. Using the Command Prompt, Enter : npm start

### Project Structure

* *App.js* is the entry point of the program. It contains the authentication code as well as the initilization of the following components: UserCredentialsDialog, ExchangeRates, Statistics, Transactions and Conversion.
Tabs were used to navigate between 3 main pages: STATISTICS (containing ExchangeRates + Statistics), TRANSACTIONS (containing Transactions) and CONVERSIONS (containing ExchangeRates + Conversion).
* *UserCredentialsDialog.js* is the dialog component used for logging in and signing up.
* *ExchangeRates.js* is responsible to display the exchange rates of the last N days, where N can be specified by the user.
* *Statistics.js* fetches statistics and graph data, and displays them using a table and a plot respectively, with the option to choose to use data from the last 30, 60 or 90 days.
* *Transactions.js* allows to add new transactions (between users if needed) and fetches the transactions of a specific user, displaying them in a table. Either all transactions or transactions between users can be displayed.
* *Conversion.js* allows conversion from one currency to another.
