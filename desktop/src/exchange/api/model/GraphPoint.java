package exchange.api.model;

import com.google.gson.annotations.SerializedName;

public class GraphPoint {
    @SerializedName("date")
    public String date;

    @SerializedName("rate")
    public Float rate;
}
