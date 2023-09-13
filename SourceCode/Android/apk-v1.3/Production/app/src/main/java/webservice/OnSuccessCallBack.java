package webservice;

public interface OnSuccessCallBack<T> {

    void success(BaseResponse<T> response);
}
