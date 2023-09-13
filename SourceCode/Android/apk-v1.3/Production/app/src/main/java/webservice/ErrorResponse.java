package webservice;

import com.google.gson.annotations.SerializedName;

public class ErrorResponse {

    @SerializedName("code")
    private int code;

    private String status;

    private String message;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

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
}
