package com.hankooktech.shep;

import javax.servlet.RequestDispatcher;
//import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller 
public class CustomErrorController implements ErrorController { 
	private final String VIEW_PATH = "/errors/";
	@RequestMapping(value = "/error") 
	public String handleError(HttpServletRequest request) {
		String goPage = null;
		Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE); 
		log.debug("status" + status);
		log.debug("error content" + request);

		if ( status != null ){ 
			int statusCode = Integer.valueOf(status.toString());
			
			if ( statusCode == HttpStatus.NOT_FOUND.value() ){ 
				goPage = "404";
			}
			else
			if ( statusCode == HttpStatus.FORBIDDEN.value() ){ 
				goPage = "403";
			}
			else {
				goPage = "error";
			}
		} 

		return VIEW_PATH + goPage; 
	}
	
	@Override public String getErrorPath() { 
		return null; 
	} 
}
