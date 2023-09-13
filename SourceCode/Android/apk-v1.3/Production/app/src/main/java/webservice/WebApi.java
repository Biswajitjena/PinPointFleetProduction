package webservice;


import com.pinpointfleet.mvp.LoginResponse;
import com.pinpointfleet.mvp.UserData;

import java.util.ArrayList;
import java.util.List;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;

public interface WebApi {

    String BASE_IP_STATIC = "http://209.145.61.7:8080";


    @GET("/PinPointFleet/opengts?reqType=auth")
    Call<LoginResponse> callLogin(@Query("userID") String userID,
                                  @Query("password") String password);


}
