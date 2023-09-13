package webservice;

import android.text.TextUtils;

import com.google.gson.Gson;

import java.io.IOException;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

@SuppressWarnings({"NullableProblems", "ConstantConditions"})
public class RetrofitCallBackHandler<T> implements Callback<BaseResponse<T>> {

    private BaseInteractor interactor;

    private OnSuccessCallBack<T> onSuccessCallBack;

    private boolean showProgress;

    private boolean showErrorMessage;

    public RetrofitCallBackHandler(BaseInteractor interactor, OnSuccessCallBack<T> onSuccessCallBack) {

        this(interactor, onSuccessCallBack, true);
    }

    public RetrofitCallBackHandler(BaseInteractor interactor, OnSuccessCallBack<T> onSuccessCallBack, boolean showProgress) {

        this(interactor, onSuccessCallBack, showProgress, true);
    }

    public RetrofitCallBackHandler(BaseInteractor interactor, OnSuccessCallBack<T> onSuccessCallBack, boolean showProgress, boolean showErrorMessage) {

        this.interactor = interactor;
        this.onSuccessCallBack = onSuccessCallBack;
        this.showProgress = showProgress;
        this.showErrorMessage = showErrorMessage;

//        if (showProgress) interactor.showProgress();
    }

    @Override
    public void onResponse(Call<BaseResponse<T>> call, Response<BaseResponse<T>> response) {

        if (showProgress) hideProgress();

        try {

            if (response.code() == 200) {

                if (response.body().getCode() == 200) {

                    onSuccessCallBack.success(response.body());

                } else {

                    if (showErrorMessage) responseFailure(response.body().getStatus());
                }

            } else {

                Gson gson = new Gson();

                try {

                    ErrorResponse errorResponse = gson.fromJson(response.errorBody().string(), ErrorResponse.class);

                    if (showErrorMessage) {

                        if (!TextUtils.isEmpty(errorResponse.getMessage())) {

                            responseFailure(errorResponse.getMessage());

                        } else {

                            responseFailure(errorResponse.getStatus());
                        }
                    }

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    @Override
    public void onFailure(Call<BaseResponse<T>> call, Throwable t) {

        if (showProgress) hideProgress();

        if (showErrorMessage) responseFailure(t.getMessage());

        t.printStackTrace();
    }


    public void hideProgress() {

//        interactor.hideProgress();
    }

    public void responseFailure(String message) {

        interactor.responseFailure(message);
    }
}
