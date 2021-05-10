package exchange.rates;

import exchange.api.ExchangeService;
import exchange.api.models.ExchangeRates;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import java.net.URL;
import java.util.ResourceBundle;


public class Rates implements Initializable {
    public Label buyUsdRateLabel;
    public Label sellUsdRateLabel;

    public TextField numberOfDays;

    //calculator
    public TextField calculatorInput;
    public Label calculatorOutputLabel;
    public ChoiceBox conversionType;

    /**
     * Fetches Exchange Rates from the backend and sets the values of buyUsdRateLabel and sellUsdRateLabel
     * API Call Parameters:
     *      - numDays: the number of days included in the Exchange Rate
     **/
    private void fetchRates() {
        Integer numDays = 3;
        if(numberOfDays.getText() != ""){
            numDays = Integer.parseInt(numberOfDays.getText());
        }
        ExchangeService.exchangeApi().getExchangeRates(numDays).enqueue(new Callback<ExchangeRates>() {
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

    /**
     * Responds to the "Get Rates" Button onClick event
     * Calls fetchRates()
     **/
    public void fetchRatesActionEvent(ActionEvent actionEvent){
        fetchRates();
    }

    /**
     * Responds to the "Convert" Button onClick event
     * Converts the input to the complementary currency based on the rates fetched by "fetchRates()"
     * Parameters:
     *      - Float: calculatorInput
     *      - String: conversionType (USD or LBP)
     **/
    public void calculateExchange(ActionEvent actionEvent){
        Float calcInput = Float.parseFloat(calculatorInput.getText());
        Boolean isUsd = conversionType.getValue().equals("USD");

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
        conversionType.setValue("USD");
        fetchRates();
    }
}
