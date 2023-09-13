package com.pinpointfleet.mvp;

import com.google.gson.annotations.SerializedName;

public class UserData {

    @SerializedName("UserId")
    private String UserId;

    @SerializedName("UserName")
    private String UserName;

    @SerializedName("intAutoId")
    private String intAutoId;

    @SerializedName("Password")
    private String Password;

    @SerializedName("IP")
    private String IP;

    @SerializedName("Company")
    private String Company;

    @SerializedName("LocationId")
    private int LocationId;

    @SerializedName("LocationName")
    private String LocationName;

    public String getUserId() {
        return UserId;
    }

    public void setUserId(String userId) {
        UserId = userId;
    }

    public String getUserName() {
        return UserName;
    }

    public void setUserName(String userName) {
        UserName = userName;
    }

    public String getIntAutoId() {
        return intAutoId;
    }

    public void setIntAutoId(String intAutoId) {
        this.intAutoId = intAutoId;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String password) {
        Password = password;
    }

    public String getIP() {
        return IP;
    }

    public void setIP(String IP) {
        this.IP = IP;
    }

    public String getCompany() {
        return Company;
    }

    public void setCompany(String company) {
        Company = company;
    }

    public int getLocationId() {
        return LocationId;
    }

    public void setLocationId(int locationId) {
        LocationId = locationId;
    }

    public String getLocationName() {
        return LocationName;
    }

    public void setLocationName(String locationName) {
        LocationName = locationName;
    }

    public String getUserRoleOrTeam() {
        return UserRoleOrTeam;
    }

    public void setUserRoleOrTeam(String userRoleOrTeam) {
        UserRoleOrTeam = userRoleOrTeam;
    }

    public String getAppName() {
        return AppName;
    }

    public void setAppName(String appName) {
        AppName = appName;
    }

    public int getIsUserActive() {
        return isUserActive;
    }

    public void setIsUserActive(int isUserActive) {
        this.isUserActive = isUserActive;
    }

    @SerializedName("UserRoleOrTeam")
    private String UserRoleOrTeam;

    @SerializedName("AppName")
    private String AppName;

    @SerializedName("isUserActive")
    private int isUserActive;

}
