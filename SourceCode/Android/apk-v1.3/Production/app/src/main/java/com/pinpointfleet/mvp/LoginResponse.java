package com.pinpointfleet.mvp;

import com.google.gson.annotations.SerializedName;

public class LoginResponse {

    @SerializedName("success")
    private String success;

    public String getSuccess() {
        return success;
    }

    public void setSuccess(String success) {
        this.success = success;
    }
}
