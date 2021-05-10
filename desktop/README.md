# Frontend - Desktop

## About
This is EECE 430L project's Desktop Frontend. Developped by Maria Mattar with the help of the instructor Mohammad Chehab and my teammates Charbel Chucri, Hussein Jaber, and Omar Khodr

## Technologies and Libraries
* The project was built using IntelliJ IDEA 
* JavaFx SDK 11.0.2 
* Retrofit 2.9.0
* Java jdk-15.0.2
* ControlsFx 8.40.11 

## Setup

### Step 1 : Backend Setup
Please refer to the corresponding backend README.md file.

### Step 2 : Libraries
- Please refer to the documentation found here in order to add the above libraries to the Project Structure `https://www.jetbrains.com/help/idea/javafx.html#add-javafx-lib`

- ControlsFx 8.40.11 was used as an additional library. It was used in the Add Transaction section, for the autocompletion feature in the "Send to User" TextField.
  * Download it here: `https://javalibs.com/artifact/org.controlsfx/controlsfx`
  * The documentation can be found here: `https://controlsfx.github.io/` 
  * Add the library to the Project Structure.
  * Add to your VM the following  `--add-exports javafx.base/com.sun.javafx.event=ALL-UNNAMED`

### Step 3 : Run the project

## Project Structure
![image](https://user-images.githubusercontent.com/62443809/117622485-562fd080-b17b-11eb-9070-1fac228c00e9.png)

* _Parent.java_ server as the controller for the navigation component _parent.fxml_, it will react to events initiated by navigation buttons and switch to the corresponding page. Meaning that it will load the corresponding fxml-defined components accordingly.
* _Authentication.java_ is the component that takes care of userToken related functionalities, such as saving them upon user authentication or deleting them upon user logout.
* _exchange.api package_ communicates directly with the backend via the _ExchangeService_ which makes use of the _Exchange_ interface to define the calls. The _Exchange_ Interface uses the models found in the _exchange.models package_ to shape the responses returned from the API call.
* _exchange.login_ and _exchange.register packages_ correspond to the login and register fxml-defined components. As their names suggest, they allow a new user to register to the platform, and an existing user to log into his account. Both of these components implement the _PageCompleter_ interface which will redirect the user to the "Currency Exchange" page (rates.fxml component) upon authentication.
* _exchange.rates package_ contains the rates.fxml component and the Rates.java controller. It allows the user to view the average Exchange Currency Rate for the past specified number of days. It also gives him the possibility to convert, using the calculator, between LBP and USD currencies.

  ![image](https://user-images.githubusercontent.com/62443809/117626910-4bc40580-b180-11eb-8e61-0815e8edfc3e.png)

* _exchange.statistics package_ contains the statistics.fxml component and its controller, Statistics.java. It allows the user to view statistics (max, average, stdv,mode prediction) and average rates per day, and displays them using a table and a plot respectively, with the option to choose to use data from the last 30, 60 or 90 days.

  ![image](https://user-images.githubusercontent.com/62443809/117627123-82018500-b180-11eb-92d3-299546f389d6.png)

* _exchange.transactions package_ contains the transactions.fxml component and its controller, Transactions.java. It allows the user to add new a transaction (and send it to another user if needed). It fetches the transactions of the authenticated user, displaying them in a table. The user is also able to filter the table to view only the transactions sent to someone else.

  ![image](https://user-images.githubusercontent.com/62443809/117627490-e45a8580-b180-11eb-8332-357604cacd9f.png)
