package com.hankooktech.shep.common.result;

import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Result<T> {
	private T message;
	private ErrorCode code;
	
	@JsonProperty("event_time")
	private String eventTime;
	
	public Result() {
		this.code = ErrorCode.Ok;
		var formatter = new SimpleDateFormat("yyyy.MM.dd hh:mm:ss");
		this.eventTime = formatter.format(GregorianCalendar.getInstance().getTime());
	}
	
	public Result(T message) {
		this();
		this.message = message;
	}

	public Result(T message, ErrorCode code) {
		this();
		this.message = message;
		this.code = code;
	}
}
