package exchange.transactions;

import exchange.Authentication;
import exchange.api.ExchangeService;
import exchange.api.models.Transaction;
import exchange.api.models.User;
import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import org.controlsfx.control.textfield.TextFields;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;


public class Transactions implements Initializable {
    public TableColumn<Transaction, Float> lbpAmount;
    public TableColumn<Transaction, Float> usdAmount;
    public TableColumn<Transaction, String> transactionDate;
    public TableColumn<Transaction, String> transactionTypeCol;
    public TableColumn<Transaction, String> otherUserCol;
    public TableView tableView;


    public TextField lbpTextField;
    public TextField usdTextField;
    public TextField otherUser;
    public ChoiceBox transactionType;


    public Button userTransactionsButton;
    public Button allTransactionsButton;

    /**
     * - Fetches a list of Transactions associated with the authenticated user
     * - After Fetching the Transactions, they are displayed to the TableView and userTransactionsButton is now visible
     * - If the user is not authenticated or does not have any registered transaction,
     *      a placeholder message is displayed accordingly to the tableView
     *  API Call Parameters:
     *      - String: authHeader
     **/
    public void fetchTransactions(){
        otherUserCol.setVisible(false);
        lbpAmount.setPrefWidth(100);
        usdAmount.setPrefWidth(100);

        String userToken = Authentication.getInstance().getToken();
        String authHeader = userToken != null ? "Bearer " + userToken : null;

        if(authHeader == null){
            tableView.setPlaceholder(new Label("Please Login or Register to view your transactions"));
        }else{
            tableView.setPlaceholder(new Label("You do not have any Transactions yet"));
        }

        ExchangeService.exchangeApi().getTransactions(authHeader).enqueue(new Callback<List<Transaction>>() {
            @Override
            public void onResponse(Call<List<Transaction>> call, Response<List<Transaction>> response) {
                userTransactionsButton.setVisible(true);
                allTransactionsButton.setVisible(false);
                if(response.body() != null){
                    tableView.getItems().setAll(response.body());
                }
            }
            @Override
            public void onFailure(Call<List<Transaction>> call, Throwable throwable) {
            }
        });
    }

    /**
     * - Fetches a list of Transactions associated with the authenticated user and sent to another user
     * - After Fetching the Transactions, they are displayed to the TableView and allTransactionsButton is now visible
     * - If the user is not authenticated or does not have any registered transaction,
     *      a placeholder message is displayed accordingly to the tableView
     *  API Call Parameters:
     *      - String: authHeader
     **/
    public void fetchUserTransactions(ActionEvent actionEvent) {
        otherUserCol.setVisible(true);
        lbpAmount.setPrefWidth(80);
        usdAmount.setPrefWidth(80);
        transactionDate.setPrefWidth(120);

        String userToken = Authentication.getInstance().getToken();
        String authHeader = userToken != null ? "Bearer " + userToken : null;

        if(authHeader == null){
            tableView.setPlaceholder(new Label("Please Login or Register to view your transactions"));
        }else{
            tableView.setPlaceholder(new Label("You do not have any Transactions yet"));
        }

        ExchangeService.exchangeApi().getUserTransactions(authHeader).enqueue(new Callback<List<Transaction>>() {
            @Override
            public void onResponse(Call<List<Transaction>> call, Response<List<Transaction>> response) {
                userTransactionsButton.setVisible(false);
                allTransactionsButton.setVisible(true);
                if(response.body() != null){
                    tableView.getItems().setAll(response.body());
                }
            }
            @Override
            public void onFailure(Call<List<Transaction>> call, Throwable throwable) {
            }
        });
    }


    /**
     * - Adds a new Transaction
     * - if the user is authenticated, the added transaction will be associated to him
     * - Being authenticated also permits him to send the transaction to another user
     *  API Call Parameters:
     *      - Transaction: transaction
     **/
    public void addTransaction(ActionEvent actionEvent) {
        Transaction transaction = new Transaction(
                otherUser.getText(),
                Float.parseFloat(usdTextField.getText()),
                Float.parseFloat(lbpTextField.getText()),
                transactionType.getValue().equals("Sell USD")
        );

        String userToken = Authentication.getInstance().getToken();
        String authHeader = userToken != null ? "Bearer " + userToken : null;

        if(otherUser.getText() == "Send to User" && otherUser.getText() == ""){
            transaction.setOtherUser("-");
            ExchangeService.exchangeApi().addTransaction(transaction, authHeader).enqueue(new Callback<>() {
                @Override
                public void onResponse(Call<Object> call, Response<Object> response) {
                    fetchTransactions();
                }

                @Override
                public void onFailure(Call<Object> call, Throwable throwable) {
                }
            });
        }else{
            ExchangeService.exchangeApi().addUserTransaction(transaction, authHeader, otherUser.getText()).enqueue(new Callback<Object>() {
                @Override
                public void onResponse(Call<Object> call, Response<Object> response) {
                    fetchTransactions();
                }
                @Override
                public void onFailure(Call<Object> call, Throwable throwable) {
                }
            });
        }

    }

    /**
     * - Fetches usernames of all users in the database and populates the "otherUser" TextField
     *      Autocomplete feature using the controlsfx.control.textfield package.
     *      This facilitates the search for users when sending a Transaction
     *  API Call Parameters:
     *      - String: authHeader
     **/
    public void fetchUsernames(){
        String userToken = Authentication.getInstance().getToken();
        String authHeader = userToken != null ? "Bearer " + userToken : null;

        ExchangeService.exchangeApi().getUsers(authHeader).enqueue(new Callback<List<User>>() {
            @Override
            public void onResponse(Call<List<User>> call, Response<List<User>> response) {

                if(response.body() != null){
                    List<String> users = new ArrayList<>();
                    for(User user : response.body()){
                        users.add(user.getUsername());
                    }
                    TextFields.bindAutoCompletion(otherUser, users);
                }else{
                    otherUser.setPromptText("Login to send Transactions to users");
                }
            }
            @Override
            public void onFailure(Call<List<User>> call, Throwable throwable) {
            }
        });
    }


    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        lbpAmount.setCellValueFactory(new PropertyValueFactory<Transaction, Float>("lbpAmount"));
        usdAmount.setCellValueFactory(new PropertyValueFactory<Transaction, Float>("usdAmount"));
        transactionDate.setCellValueFactory(new PropertyValueFactory<Transaction, String>("addedDate"));
        transactionTypeCol.setCellValueFactory(new PropertyValueFactory<Transaction, String>("type"));
        otherUserCol.setCellValueFactory(new PropertyValueFactory<Transaction, String>("otherUser"));

        fetchTransactions();
        fetchUsernames();
    }
}