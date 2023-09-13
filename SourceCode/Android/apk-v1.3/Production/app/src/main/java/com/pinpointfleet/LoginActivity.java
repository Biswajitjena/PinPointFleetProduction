package com.pinpointfleet;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

import com.fleetanalytics.pinpointmobile.R;
import com.pinpointfleet.mvp.LoginPresenter;
import com.pinpointfleet.mvp.LoginResponse;
import com.pinpointfleet.mvp.LoginView;
import com.pinpointfleet.mvp.UserData;

import org.json.JSONObject;

import java.util.Arrays;
import java.util.List;

import json_parsing.LoginJSON;
import slider.SliderHomeActivity;

public class LoginActivity extends Activity implements LoginView {

    Button btnLogin;
    EditText etUser, etPass;
    Context context = this;

    // First start activity--------------------
    private int count;
    private SharedPreferences setSP;
    LoginPresenter presenter;
    String imeiNumber;
    public String url = "https://portal.fleetanalytics.net:8443";
//    public String url = "http://209.145.61.7:8080";
    // Local - http://192.168.111.92:8080
    // Live - http://199.87.53.154:8080

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        // First start activity--------------------
        setSP = this.getSharedPreferences("MyApp", 0);
        count = setSP.getInt("count", 0);
        selectContentView();
        // ------------------
        presenter = new LoginPresenter(this, this);

        try {
            imeiNumber = Settings.Secure.getString(getContentResolver(), Settings.Secure.ANDROID_ID);
        } catch (Exception e) {
            e.printStackTrace();
        }

        init();
        btnLogin.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {

                if (Utils.getConnectivityStatus(context) != 0) {
                    String sUser = etUser.getText().toString();
                    String sPass = etPass.getText().toString();
                    if (!sUser.equals("") && !sPass.equals("")) {
                        //TODO

                        new DownloadFileAsync().execute(sUser, sPass);


                    } else {
                        ToastOnUI(getResources().getString(
                                R.string.enter_abv_data_first));
                    }
                } else {
                    ToastOnUI(getResources().getString(
                            R.string.no_internet_connection));
                }

            }
        });
    }

    public void init() {

        btnLogin = (Button) findViewById(R.id.btnLogin);
        etUser = (EditText) findViewById(R.id.etUser);
        etPass = (EditText) findViewById(R.id.etPass);

        SharedPreferences saveUrl = getSharedPreferences("saveURL", 0);
        SharedPreferences.Editor e = saveUrl.edit();
        e.putString("url", url);
        e.apply();
    }

    private void selectContentView() {
        // TODO Auto-generated method stub
        if (count == 1) {
            setCount(1);
            Intent i = new Intent(this, SliderHomeActivity.class);
            // i.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
            i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            startActivity(i);
            this.finish();
        } else {
            setContentView(R.layout.activity_login);
        }
    }

    private void setCount(int count) {
        SharedPreferences.Editor e = setSP.edit();
        e.putInt("count", count);
        e.apply();
    }

    ProgressDialog progDailog;

    @Override
    public void loginSuccess(LoginResponse model) {
        Intent i = new Intent(LoginActivity.this,
                SliderHomeActivity.class);
        i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(i);
        finish();

    }

    @Override
    public void loginFailure(String message) {
        ToastOnUI(getResources().getString(R.string.error));

    }

    @Override
    public void login2Success(List<UserData> model) {
        Intent i = new Intent(LoginActivity.this,
                SliderHomeActivity.class);
        i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(i);
        finish();
    }

    @Override
    public void login2Failure(String message) {
        ToastOnUI(getResources().getString(R.string.error));

    }

    class DownloadFileAsync extends AsyncTask<String, Void, Void> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            lockScreenOrientation();
            progDailog = new Utils().showDialog(context, getResources()
                    .getString(R.string.authenticating));
        }

        @Override
        protected Void doInBackground(String... aur) {
            Log.v("LOGIN RESPONSE-", Arrays.toString(aur));


            try {
                String user = aur[0];
                String pass = aur[1];
                String s = new LoginJSON().LoginMethod(context, user,
                        pass);

                Log.v("LOGIN RESPONSE: ", ":" + s);
                JSONObject jObject = new JSONObject(s);
                String success = jObject.getString("success");

                String userrole = "";
                if (success.equalsIgnoreCase("True")) {
                    if (s.contains("userole")) {
                        userrole = jObject.getString("userole");
                    }
                    String account_id = jObject.getString("account_id");
                    String time_zone = jObject.getString("account_tmz");
                    String userID = jObject.getString("userId");
//					String loginId = "";
//					if(jObject.has("userId")){
//						loginId = jObject.getString("userId");	
//					}

                    saveLoginCredential(url, userID, account_id, userrole, time_zone);
                    setCount(1);
                    Intent i = new Intent(LoginActivity.this,
                            SliderHomeActivity.class);
                    i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    startActivity(i);
                    LoginActivity.this.finish();


                } else {
                    ToastOnUI(success);
                }
            } catch (Exception e) {
                e.printStackTrace();
                Log.v("LOGIN RESPONSE1: ", ":" + e.getMessage());
                ToastOnUI(getResources().getString(R.string.error));
                if (progDailog != null) {
                    progDailog.dismiss();
                }
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void unused) {
            progDailog.dismiss();
            // unlockScreenOrientation();
        }
    }

    public void saveLoginCredential(String ip_port, String userID,
                                    String account_id, String user_role, String timeZone) {
        SharedPreferences saveUrl = getSharedPreferences("saveURL", 0);
        SharedPreferences.Editor e = saveUrl.edit();
        e.putString("url", ip_port);
        e.putString("accountID", account_id);
        e.putString("userID", userID);
        e.putString("user_role", user_role);
        e.putString("time_zone", timeZone);
        //e.putString("loginId", LoginId);
        e.apply();
    }

    private void lockScreenOrientation() {
        int currentOrientation = getResources().getConfiguration().orientation;
        if (currentOrientation == Configuration.ORIENTATION_PORTRAIT) {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        } else {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        }
    }

    /*
     * private void unlockScreenOrientation() {
     * setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR); }
     */

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (progDailog != null) {
            progDailog.dismiss();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (progDailog != null) {
            progDailog.dismiss();
        }
    }

    protected void ToastOnUI(final String text) {
        runOnUiThread(() -> new Utils().showToast(LoginActivity.this, text));
    }
}