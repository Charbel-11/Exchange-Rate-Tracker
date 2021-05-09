package exchange.api.models;

import com.google.gson.annotations.SerializedName;
import exchange.api.helperClasses.StatTableObj;

import java.util.ArrayList;
import java.util.List;

public class Stats {
    @SerializedName("max_usd_to_lbp")
    public Float usd_numbers;

    @SerializedName("max_lbp_to_usd")
    public Float lbp_numbers;

    @SerializedName("median_usd_to_lbp")
    public Float median_usd_to_lbp;

    @SerializedName("median_lbp_to_usd")
    public Float median_lbp_to_usd;

    @SerializedName("stdev_usd_to_lbp")
    public Float std_dev_usd_to_lbp;

    @SerializedName("stdev_lbp_to_usd")
    public Float std_dev_lbp_to_usd;

    @SerializedName("mode_usd_to_lbp")
    public Float mode_usd_to_lbp;

    @SerializedName("mode_lbp_to_usd")
    public Float mode_lbp_to_usd;

    @SerializedName("variance_usd_to_lbp")
    public Float variance_usd_to_lbp;

    @SerializedName("variance_lbp_to_usd")
    public Float variance_lbp_to_usd;

    @SerializedName("predict_usd_to_lbp")
    public Float prediction_usd_to_lbp;

    @SerializedName("predict_lbp_to_usd")
    public Float prediction_lbp_to_usd;

    public List<StatTableObj> toStatTableObj(){
        List<StatTableObj> result = new ArrayList<>();

        StatTableObj maxStat = new StatTableObj("Maximum", usd_numbers, lbp_numbers);
        StatTableObj medianStat = new StatTableObj("Median", median_usd_to_lbp, median_lbp_to_usd);
        StatTableObj stddevStat = new StatTableObj("Standard Deviation", std_dev_usd_to_lbp, std_dev_lbp_to_usd);
        StatTableObj varianceStat = new StatTableObj("Variance", variance_usd_to_lbp, variance_lbp_to_usd);
        StatTableObj modeStat = new StatTableObj("Mode", mode_usd_to_lbp, mode_lbp_to_usd);
        StatTableObj prediction = new StatTableObj("Prediction", prediction_usd_to_lbp, prediction_lbp_to_usd);

        result.add(maxStat);
        result.add(medianStat);
        result.add(stddevStat);
        result.add(varianceStat);
        result.add(modeStat);
        result.add(prediction);

        return result;
    }
}
