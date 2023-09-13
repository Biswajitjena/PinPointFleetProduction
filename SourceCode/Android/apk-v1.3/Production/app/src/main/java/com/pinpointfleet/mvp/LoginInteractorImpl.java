package com.pinpointfleet.mvp;



import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import webservice.WebApiClient;

public class LoginInteractorImpl {


    public void callLogin(String username, String password,LoginInteractor interactor) {

        WebApiClient.getInstance().getDynamicApiClient().callLogin(username, password).enqueue(new Callback<LoginResponse>() {
            @Override
            public void onResponse(Call<LoginResponse> call, Response<LoginResponse> response) {
                if (response.code() == 200) {
                    interactor.loginSuccess(response.body());

                }
            }

            @Override
            public void onFailure(Call<LoginResponse> call, Throwable t) {
                interactor.loginFailure(t.getLocalizedMessage());

            }
        });

    }

/*
    public void callLogin(String username, String password, String deviceId,LoginInteractor interactor) {

        WebApiClient.getInstance().getDynamicApiClient().callLogin(username, password,
                "TransferApp", deviceId).enqueue(new Callback<List<UserData>>() {
            @Override
            public void onResponse(Call<List<UserData>> call, Response<List<UserData>> response) {
                if (response.code() == 200) {
                    interactor.login2Success(response.body());

                }
            }

            @Override
            public void onFailure(Call<List<UserData>> call, Throwable t) {
                interactor.login2Failure(t.getLocalizedMessage());

            }
        });

    }
*/


}
