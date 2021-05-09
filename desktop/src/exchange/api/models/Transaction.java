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

    private String convertToMonth(String month){
        if(month.equals("01")) return "Jan";
        else if(month.equals("02")) return "Feb";
        else if(month.equals("03")) return "Mar";
        else if(month.equals("04")) return "Apr";
        else if(month.equals("05")) return "May";
        else if(month.equals("06")) return "Jun";
        else if(month.equals("07")) return "Jul";
        else if(month.equals("08")) return "Aug";
        else if(month.equals("09")) return "Sep";
        else if(month.equals("10")) return "Oct";
        else if(month.equals("11")) return "Nov";
        return "Dec";
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
        String formattedDate =  new String(addedDate.substring(8, 10) + " - " +
                                                    convertToMonth(addedDate.substring(5, 7)) + " - " +
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