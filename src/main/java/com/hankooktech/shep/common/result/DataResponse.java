package com.hankooktech.shep.common.result;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor
public class DataResponse {
    private int status;
    private Object data;

    @AllArgsConstructor
    @Getter
    public static enum Status {
        SUCCESS(200, "S001", "Success"),
        INVALID_INPUT_VALUE(400, "E001", "Invalid Input Value");

        int status;
        String code;
        String message;
    }
}


