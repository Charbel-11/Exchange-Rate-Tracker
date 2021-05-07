package exchange.api.models;
import com.google.gson.annotations.SerializedName;

public class ExchangeRates {
    @SerializedName("usd_to_lbp")
    public Float usdToLbp;

    @SerializedName("lbp_to_usd")
    public Float lbpToUsd;
}