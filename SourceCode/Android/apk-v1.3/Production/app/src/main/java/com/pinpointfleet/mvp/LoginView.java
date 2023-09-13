package com.pinpointfleet.mvp;



import java.util.List;

public interface LoginView {

    void loginSuccess(LoginResponse model);
    void loginFailure(String message);

    void login2Success(List<UserData> model);

    void login2Failure(String message);

}
