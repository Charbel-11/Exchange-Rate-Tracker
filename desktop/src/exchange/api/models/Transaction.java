package exchange.api.models;
import com.google.gson.annotations.SerializedName;


public class Transaction {

    @SerializedName("usd_amount")
    Float usdAmount;

    @SerializedName("lbp_amount")
    Float lbpAmount;

    @SerializedName("usd_to_lbp")
    Boolean usdToLbp;

    @SerializedName("id")
    Integer id;

    @SerializedName("added_date")
    String addedDate;

    @SerializedName("user_name")
    String otherUser;

    public Transaction(String username, Float usdAmount, Float lbpAmount, Boolean usdToLbp) {
        this.otherUser = username;
        this.usdAmount = usdAmount;
        this.lbpAmount = lbpAmount;
        this.usdToLbp = usdToLbp;
    }

    public Float getUsdAmount() {
        return usdAmount;
    }

    public Float getLbpAmount() {
        return lbpAmount;
    }

    public String getAddedDate() {
        if(addedDate.charAt(2) == ' '){
            return addedDate;
        }
        String formattedDate =  new String(addedDate.substring(9, 10) + " - " +
                                                    addedDate.substring(5, 7) + " - " +
                                                    addedDate.substring(0, 4));
        return formattedDate;
    }

    public String getType() {
        if(usdToLbp == true){
            return "Sell USD";
        }
        return "Buy USD";
    }

    public String getOtherUser(){
        return otherUser;
    }

    public void setOtherUser(String username){
        this.otherUser = username;
    }


}