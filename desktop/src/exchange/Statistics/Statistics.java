package exchange.Statistics;

import exchange.api.ExchangeService;
import exchange.api.models.GraphPoint;
import exchange.api.models.Stats;
import exchange.api.helperClasses.StatTableObj;
import javafx.application.Platform;
import javafx.fxml.Initializable;
import javafx.scene.chart.CategoryAxis;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.SwipeEvent;
import javafx.scene.input.ZoomEvent;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

public class Statistics implements Initializable {
    public LineChart<String, Float> graph;
    public CategoryAxis xAxis;
    public NumberAxis yAxis;

    public TableColumn<StatTableObj, String> stats;
    public TableColumn<StatTableObj, Float> lbpToUsd;
    public TableColumn<StatTableObj, Float> usdToLbp;
    public TableView tableView;


    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {

        xAxis.setLabel("Date");
        yAxis.setLabel("Rate");

        stats.setCellValueFactory(new PropertyValueFactory<StatTableObj, String>("statName"));
        lbpToUsd.setCellValueFactory(new PropertyValueFactory<StatTableObj, Float>("lbpToUsd"));
        usdToLbp.setCellValueFactory(new PropertyValueFactory<StatTableObj, Float>("usdToLbp"));

        //TODO if time, fix colors

        //TODO: fix number of days
        Integer numDays = 30; //Integer.parseInt(numberOfDays.getText());

        //USD to LBP Rates
        ExchangeService.exchangeApi().getUsdToLbpGraph(numDays).enqueue(new Callback<List<GraphPoint>>() {
            @Override
            public void onResponse(Call<List<GraphPoint>> call, Response<List<GraphPoint>> response) {
                Platform.runLater(() -> {
                    XYChart.Series series = new XYChart.Series<String, Float>();
                    for(GraphPoint point : response.body()){
                        series.getData().add(new XYChart.Data(point.date.replace("2021", ""), point.rate));
                    }
                    series.setName("USD to LBP rates");
                    graph.getData().add(series);
                });
            }
            @Override
            public void onFailure(Call<List<GraphPoint>> call, Throwable throwable) { }
        });

        // LBP to USD Rates
        ExchangeService.exchangeApi().getLbpToUsdGraph(numDays).enqueue(new Callback<List<GraphPoint>>() {
            @Override
            public void onResponse(Call<List<GraphPoint>> call, Response<List<GraphPoint>> response) {
                Platform.runLater(() -> {
                    XYChart.Series series = new XYChart.Series<String, Float>();
                    for(GraphPoint point : response.body()){
                        series.getData().add(new XYChart.Data(point.date.replace("2021", ""), point.rate));
                    }
                    series.setName("LBP to USD rates");
                    graph.getData().add(series);
                });
            }
            @Override
            public void onFailure(Call<List<GraphPoint>> call, Throwable throwable) { }
        });

        // Get the statistics
        ExchangeService.exchangeApi().getStats(numDays).enqueue(new Callback<Stats>() {
            @Override
            public void onResponse(Call<Stats> call, Response<Stats> response) {
                List<StatTableObj> statTableObjList = response.body().toStatTableObj();
                tableView.getItems().setAll(statTableObjList);
            }

            @Override
            public void onFailure(Call<Stats> call, Throwable throwable) { }
        });
    }

    //TODO: support those if you have time
    public void onSwipeRightHandler(SwipeEvent swipeEvent) {

    }

    public void onZoomHandler(ZoomEvent zoomEvent) {
    }
}
