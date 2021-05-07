package exchange.graph;

import exchange.api.ExchangeService;
import exchange.api.model.GraphPoint;
import javafx.application.Platform;
import javafx.fxml.Initializable;
import javafx.scene.chart.CategoryAxis;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.input.SwipeEvent;
import javafx.scene.input.ZoomEvent;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

public class Graph implements Initializable {
    public LineChart<String, Float> graph;
    public CategoryAxis xAxis;
    public NumberAxis yAxis;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        xAxis.setLabel("Date");
        yAxis.setLabel("Rate");

        //TODO: fix number of days
        Integer numDays = 30; //Integer.parseInt(numberOfDays.getText());

        //USD to LBP Rates
        ExchangeService.exchangeApi().getUsdToLbpGraph(numDays).enqueue(new Callback<List<GraphPoint>>() {
            @Override
            public void onResponse(Call<List<GraphPoint>> call, Response<List<GraphPoint>> response) {
                Platform.runLater(() -> {
                    XYChart.Series series = new XYChart.Series<String, Float>();
                    for(GraphPoint point : response.body()){
                        series.getData().add(new XYChart.Data(point.date, point.rate));
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
                        series.getData().add(new XYChart.Data(point.date, point.rate));
                    }
                    series.setName("LBP to USD rates");
                    graph.getData().add(series);
                });
            }
            @Override
            public void onFailure(Call<List<GraphPoint>> call, Throwable throwable) { }
        });

    }

    //TODO: support those if you have time
    public void onSwipeRightHandler(SwipeEvent swipeEvent) {

    }

    public void onZoomHandler(ZoomEvent zoomEvent) {
    }
}
