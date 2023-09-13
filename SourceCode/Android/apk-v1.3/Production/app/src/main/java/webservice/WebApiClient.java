package webservice;


import java.io.IOException;
import java.util.concurrent.TimeUnit;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;


public class WebApiClient {

    static WebApiClient webClient;

    public static WebApiClient getInstance() {
        if (webClient == null) {
            webClient = new WebApiClient();
        }
        return webClient;
    }

    //for debug build
    HttpLoggingInterceptor logging = new HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY);

    Interceptor interceptor = new Interceptor() {
        @Override
        public Response intercept(Chain chain) throws IOException {

            Request newRequest = chain.request().newBuilder()
                    .addHeader("Content-Type", "application/json")
                    .build();
            return chain.proceed(newRequest);
        }
    };


    public WebApi getApiClient(String baseUrl) {

        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(baseUrl)
                .client(getHttpClient())
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        WebApi service = retrofit.create(WebApi.class);
        return service;
    }

    public WebApi getDynamicApiClient() {

        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(WebApi.BASE_IP_STATIC)
                .client(getHttpClient())
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        WebApi service = retrofit.create(WebApi.class);
        return service;
    }

/*
    public WebApi getLoginApiClient() {
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(WebApi.BASE_URL)
                .client(getHttpClient())
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        WebApi service = retrofit.create(WebApi.class);
        return service;
    }
*/



    private OkHttpClient getHttpClient() {

        HttpLoggingInterceptor logging = new HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY);

        Interceptor interceptor = new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {

                Request newRequest = chain.request().newBuilder()
//                        .addHeader("languageId", MyApplication.LANGUAGE_ID)
                        .build();

                return chain.proceed(newRequest);
            }
        };

        OkHttpClient client = new OkHttpClient.Builder()
                .addInterceptor(logging)
                .addInterceptor(interceptor)
                .connectTimeout(180, TimeUnit.SECONDS)
                .readTimeout(180, TimeUnit.SECONDS)
                .build();

        return client;
    }


}
