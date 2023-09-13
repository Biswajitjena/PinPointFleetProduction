package com.pinpointfleet.mvp;

import android.content.Context;


import java.util.List;

public class LoginPresenter implements LoginInteractor {
    LoginView loginView;
    LoginInteractorImpl interactor;
    Context mContext;

    public LoginPresenter(LoginView loginView, Context mContext) {
        this.loginView = loginView;
        interactor = new LoginInteractorImpl();
        this.mContext = mContext;
    }


    public void callLogin(String username, String password) {

        interactor.callLogin(username, password, this);
    }

  /*  public void callLogin(String username, String password, String deviceID) {

        interactor.callLogin(username, password, deviceID,this);
    }
*/

    @Override
    public void loginSuccess(LoginResponse list) {
        loginView.loginSuccess(list);
    }

    @Override
    public void loginFailure(String message) {
        loginView.loginFailure(message);
    }

    @Override
    public void login2Success(List<UserData> model) {
        loginView.login2Success(model);
    }

    @Override
    public void login2Failure(String message) {
        loginView.login2Failure(message);
    }
}
