# iOS Platform

## How to Run
- Xcode 12 or later
- iOS 14.0 or later

The application has no dependencies or package frameworks (i.e. Cocoapods, Carthage) incorporated.

The backend component also needs to be running locally since it currently isn't deployed, refer to the corresponding README for running instructions.

## Functional Documentation

### Main View
The main view is separated into four main sections:
1. The navigation bar at the top contains buttons to navigate to the authentication views (login or signup depending on the app's current authentication state) and to navigate to the transaction addition view.
2. The USD/LBP exchange rates averaged over the last three days.
3. The button leading to the exchange rate calculator.
4. The statistics section contains a graph as well as a button that navigates to the detailed statistics view.

### Authentication
The app supports performing transactions anonymously or through an account which can be created and logged into through the app by assigning to each user a unique username.

### Adding a Transaction
Adding a transaction is done by specifying the USD and LBP amounts, the direction of the transaction as well as if it is directed to a specific user (this option is only available when the user is logged in).

### Exchange Rate Calculator
The calculator allows the user to convert a specific amount of a given currency (LBP or USD) to the other at the exchange rate shown on the main view (USD/LBP exchange rates averaged over the last three days).

### Statistics
The statistics section displays a graph that plots the daily average exchange USD/LBP rates over variable ranges (30, 60 or 90 days) as well as detailed statistics which display the max, average and standard devitation of both exchange rates from the last 30 days as well as a table that lists all past transactions and who they were exchanged with in case they were exchanged between users. The table can only be filtered to only show transactions done between users.
