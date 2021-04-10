package exchange.rates;

import exchange.Authentication;
import exchange.api.ExchangeService;
import exchange.api.model.ExchangeRates;
import exchange.api.model.Transaction;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleGroup;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import java.net.URL;
import java.util.ResourceBundle;
import java.util.concurrent.CompletableFuture;


public class Rates implements Initializable {
    public Label buyUsdRateLabel;
    public Label sellUsdRateLabel;
    public TextField lbpTextField;
    public TextField usdTextField;
    public ToggleGroup transactionType;

    //calculator
    public TextField calculatorInput;
    public Label calculatorOutputLabel;
    public ToggleGroup conversionType;

    private void fetchRates() {
        ExchangeService.exchangeApi().getExchangeRates().enqueue(new Callback<ExchangeRates>() {
             @Override
             public void onResponse(Call<ExchangeRates> call,
                                    Response<ExchangeRates> response) {
                 ExchangeRates exchangeRates = response.body();
                 Platform.runLater(() -> {
                     buyUsdRateLabel.setText(exchangeRates.lbpToUsd.toString());
                     sellUsdRateLabel.setText(exchangeRates.usdToLbp.toString());
                 });
             }
             @Override
             public void onFailure(Call<ExchangeRates> call, Throwable throwable) {

             }
        });
    }

    public void addTransaction(ActionEvent actionEvent) {
        Transaction transaction = new Transaction(
                Float.parseFloat(usdTextField.getText()),
                Float.parseFloat(lbpTextField.getText()),
                ((RadioButton) transactionType.getSelectedToggle()).getText().equals("Sell USD")
        );
        String userToken = Authentication.getInstance().getToken();
        String authHeader = userToken != null ? "Bearer " + userToken : null;

        ExchangeService.exchangeApi().addTransaction(transaction, authHeader).enqueue(new Callback<Object>() {
              @Override
              public void onResponse(Call<Object> call, Response<Object> response) {
                  fetchRates();
                  Platform.runLater(() -> {
                      usdTextField.setText("");
                      lbpTextField.setText("");
                  });
              }
              @Override
              public void onFailure(Call<Object> call, Throwable throwable) {
              }
        });
    }

    public void calculateExchange(ActionEvent actionEvent){
        Float calcInput = Float.parseFloat(calculatorInput.getText());
        Boolean isUsd = ((RadioButton) conversionType.getSelectedToggle()).getText().equals("USD");

        String calculatorOutput = calcInput.toString() + (isUsd ? " USD " : " LBP ") + "is equivalent to ";

        if(isUsd){
            calcInput *= Float.parseFloat(sellUsdRateLabel.getText());
        }else{
            calcInput *= Float.parseFloat(buyUsdRateLabel.getText());
        }

        calculatorOutput += calcInput.toString() + (isUsd ? " LBP " : " USD ");

        calculatorOutputLabel.setText(calculatorOutput);
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        fetchRates();
    }
}
