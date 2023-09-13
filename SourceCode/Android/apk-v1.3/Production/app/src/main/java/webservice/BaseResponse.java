package webservice;

import com.google.gson.annotations.SerializedName;

public class BaseResponse<T> {

    @SerializedName("status")
    private String status;
    @SerializedName("message")
    private String message;
    @SerializedName("http_status_code")
    private int code;
    @SerializedName("data")
    private T data;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
