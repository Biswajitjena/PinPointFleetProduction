package com.pinpointfleet.mvp;

import java.util.List;

public interface LoginInteractor {

    void loginSuccess(LoginResponse model);

    void loginFailure(String message);

    void login2Success(List<UserData> model);

    void login2Failure(String message);

}
