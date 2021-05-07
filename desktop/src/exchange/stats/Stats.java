package exchange.stats;

import exchange.api.ExchangeService;
import exchange.api.model.Stat;
import exchange.api.model.StatTableObj;
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

public class Stats implements Initializable {
    public TableColumn<StatTableObj, String> stats;
    public TableColumn<StatTableObj, Float> lbpToUsd;
    public TableColumn<StatTableObj, Float> usdToLbp;
    public TableView tableView;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        stats.setCellValueFactory(new PropertyValueFactory<StatTableObj, String>("statName"));
        lbpToUsd.setCellValueFactory(new PropertyValueFactory<StatTableObj, Float>("lbpToUsd"));
        usdToLbp.setCellValueFactory(new PropertyValueFactory<StatTableObj, Float>("usdToLbp"));

        // TODO: fix number of days
        Integer numDays = 30; //Integer.parseInt(numberOfDays.getText());
        ExchangeService.exchangeApi().getStats(numDays).enqueue(new Callback<Stat>() {
            @Override
            public void onResponse(Call<Stat> call, Response<Stat> response) {
                List<StatTableObj> statTableObjList = response.body().toStatTableObj();
                tableView.getItems().setAll(statTableObjList);
            }

            @Override
            public void onFailure(Call<Stat> call, Throwable throwable) {

            }

        });


    }
}
