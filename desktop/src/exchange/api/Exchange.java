package exchange.api;

import exchange.api.model.ExchangeRates;
import exchange.api.model.Token;
import exchange.api.model.Transaction;
import exchange.api.model.User;
import retrofit2.Call;
import retrofit2.http.*;

import java.util.List;

public interface Exchange {
    @POST("/user")
    Call<User> addUser(@Body User user);

    @POST("/authentication")
    Call<Token> authenticate(@Body User user);

    @GET("/exchangeRate/{numberOfDays}")
    Call<ExchangeRates> getExchangeRates(@Path("numberOfDays")Integer number);

    @POST("/transaction")
    Call<Object> addTransaction(@Body Transaction transaction, @Header("Authorization") String authorization);

    @GET("/transaction")
    Call<List<Transaction>> getTransactions(@Header("Authorization") String authorization);

//    @GET("/stats")
//    Call<>
}