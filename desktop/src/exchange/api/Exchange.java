package exchange.api;

import exchange.api.models.*;
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

    @POST("/userTransaction/{username}")
    Call<Object> addUserTransaction(@Body Transaction transaction, @Header("Authorization") String authorization,
                                @Path("username")String username);


    @GET("/userTransactions")
    Call<List<Transaction>> getUserTransactions(@Header("Authorization") String authorization);

    @GET("/users")
    Call<List<User>> getUsers(@Header("Authorization") String authorization);

    @GET("/stats/{numberOfDays}")
    Call<Stats> getStats(@Path("numberOfDays")Integer number);

    @GET("/graph/usd_to_lbp/{numberOfDays}")
    Call<List<GraphPoint>> getUsdToLbpGraph(@Path("numberOfDays")Integer number);

    @GET("/graph/lbp_to_usd/{numberOfDays}")
    Call<List<GraphPoint>> getLbpToUsdGraph(@Path("numberOfDays")Integer number);

}