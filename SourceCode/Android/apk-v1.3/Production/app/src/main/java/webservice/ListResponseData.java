package webservice;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class ListResponseData<T> {

    @SerializedName("content")
    @Expose
    private List<T> content = null;
    @SerializedName("totalPages")
    @Expose
    private int totalPages;
    @SerializedName("number")
    @Expose
    private int number;
    @SerializedName("first")
    @Expose
    private boolean first;
    @SerializedName("last")
    @Expose
    private boolean last;
    @SerializedName("totalRecords")
    @Expose
    private int totalRecords;

    public List<T> getContent() {
        return content;
    }

    public void setContent(List<T> content) {
        this.content = content;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public boolean isFirst() {
        return first;
    }

    public void setFirst(boolean first) {
        this.first = first;
    }

    public boolean isLast() {
        return last;
    }

    public void setLast(boolean last) {
        this.last = last;
    }

    public int getTotalRecords() {
        return totalRecords;
    }

    public void setTotalRecords(int totalRecords) {
        this.totalRecords = totalRecords;
    }

}