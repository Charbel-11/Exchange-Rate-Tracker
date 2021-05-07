package exchange.api.helperClasses;

import com.google.gson.annotations.SerializedName;

public class StatTableObj {
    @SerializedName("statName")
    String statName ="";

    @SerializedName("usdToLbp")
    Float usdToLbp;

    @SerializedName("lbpToUsd")
    Float lbpToUsd;

    public StatTableObj(String name, Float utol, Float ltou) {
        this.statName = name;
        this.usdToLbp = utol;
        this.lbpToUsd = ltou;
    }

    public Float getUsdToLbp() {
        return usdToLbp;
    }

    public Float getLbpToUsd() {
        return lbpToUsd;
    }

    public String getStatName() {
        return statName;
    }
}
