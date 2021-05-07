package exchange.transactions;
import exchange.Authentication;
import exchange.api.ExchangeService;
import exchange.api.models.Transaction;
import javafx.fxml.Initializable;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;


public class Transactions implements Initializable {
    public TableColumn<Transaction, Float> lbpAmount;
    public TableColumn<Transaction, Float> usdAmount;
    public TableColumn<Transaction, String> transactionDate;
    public TableView tableView;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        lbpAmount.setCellValueFactory(new PropertyValueFactory<Transaction, Float>("lbpAmount"));
        usdAmount.setCellValueFactory(new PropertyValueFactory<Transaction, Float>("usdAmount"));
        transactionDate.setCellValueFactory(new PropertyValueFactory<Transaction, String>("addedDate"));

        String userToken = Authentication.getInstance().getToken();
        String authHeader = userToken != null ? "Bearer " + userToken : null;

        ExchangeService.exchangeApi().getTransactions(authHeader).enqueue(new Callback<List<Transaction>>() {
                    @Override
                    public void onResponse(Call<List<Transaction>> call, Response<List<Transaction>> response) {
                        tableView.getItems().setAll(response.body());
                    }
                    @Override
                    public void onFailure(Call<List<Transaction>> call, Throwable throwable) {
                    }
                });
        //TODO: Add option to filter table

    }
}