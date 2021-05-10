package exchange.statistics;

import exchange.api.ExchangeService;
import exchange.api.helperClasses.StatTableObj;
import exchange.api.models.GraphPoint;
import exchange.api.models.Stats;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.chart.CategoryAxis;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
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

    public ChoiceBox numberOfDaysStats;
    public ChoiceBox numberOfDaysGraph;

    public TableColumn<StatTableObj, String> stats;
    public TableColumn<StatTableObj, Float> lbpToUsd;
    public TableColumn<StatTableObj, Float> usdToLbp;
    public TableView tableView;

    /**
     * Action Event that responds to the "numberOfDaysGraph" ChoiceBox onAction Event
     * - Fetches the Graph Points (date, rate) corresponding to the daily exchange rate for selling and buying USD rates for the past "numberOfDaysGraph" Days
     * - Creates new series for both selling and buying USD Rates, and adds those series to the "graph" LineChart
     * API Call Parameters:
     *      - String: numberOfDaysGraph.value
     *              - Example: "Past dd Days"
     **/
    public void fetchGraphs(ActionEvent actionEvent) {
        graph.getData().removeAll();
        graph.getData().clear();
        String numDaysStr = (String) numberOfDaysGraph.getValue();
        Integer numDays = Integer.parseInt(numDaysStr.substring(5, 7));

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
    }

    /**
     * Responds to the "numberOfDaysStats" ChoiceBox onAction Event
     * - Fetches the Statistics corresponding to the daily exchange rate for selling and buying USD rates for the past "numberOfDaysStats" Days
     * - Using the StatTableObj helper class, the response.body() Stat object is converted to an intermediate format for the TableView
     * API Call Parameters:
     *      - String: numberOfDaysStats.value
     *              - Example: "Past dd Days"
     **/
    public void fetchStats(ActionEvent actionEvent) {
        String numDaysStr = (String) numberOfDaysStats.getValue();
        Integer numDays = Integer.parseInt(numDaysStr.substring(5, 7));

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


    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        stats.setCellValueFactory(new PropertyValueFactory<StatTableObj, String>("statName"));
        lbpToUsd.setCellValueFactory(new PropertyValueFactory<StatTableObj, Float>("lbpToUsd"));
        usdToLbp.setCellValueFactory(new PropertyValueFactory<StatTableObj, Float>("usdToLbp"));

        xAxis.setLabel("Date");
        yAxis.setLabel("Rate");

        numberOfDaysStats.setValue("Last 30 Days");
//        numberOfDaysGraph.setValue("Last 30 Days");
    }

}
