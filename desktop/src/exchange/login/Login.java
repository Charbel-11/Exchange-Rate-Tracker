package exchange.login;

import exchange.Authentication;
import exchange.OnPageCompleteListener;
import exchange.PageCompleter;
import exchange.api.ExchangeService;
import exchange.api.models.Token;
import exchange.api.models.User;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class Login implements PageCompleter {
    private OnPageCompleteListener onPageCompleteListener;

    public TextField usernameTextField;
    public PasswordField passwordTextField;

    public void login(ActionEvent actionEvent) {
        User user = new User(usernameTextField.getText(),
                passwordTextField.getText());

        ExchangeService.exchangeApi().authenticate(user).enqueue(new Callback<Token>() {
             @Override
             public void onResponse(Call<Token> call, Response<Token> response) {
                 Authentication.getInstance().saveToken(response.body().getToken());
                 Platform.runLater(() -> {
                     onPageCompleteListener.onPageCompleted();
                 });
             }
             @Override
             public void onFailure(Call<Token> call, Throwable throwable) {
             }
         });
    }

    @Override
    public void setOnPageCompleteListener(OnPageCompleteListener onPageCompleteListener) {
        this.onPageCompleteListener = onPageCompleteListener;
    }
}