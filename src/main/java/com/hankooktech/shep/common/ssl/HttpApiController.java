package com.hankooktech.shep.common.ssl;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcNoAuth;
import com.hankooktech.fc.biz_common.excel.ExcelReader;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * Excel File API REST Controller (User API)
 * fc-config.file-config.file-root-path 속성이 존재할때만 구동됨
 */
@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/api/http")
public class HttpApiController {
	
	private final ExcelReader excelReader;
	
	@FcNoAuth
	@GetMapping("/convert")
	public void upload(@UserSession UserSessionDTO session, HttpServletResponse rsp, @RequestParam Map<String,String> allParams) throws Exception {
		String returnUrl = allParams.get("returnUrl");
		
		for( Map.Entry<String, String> entry : allParams.entrySet() ){
			if(!"returnUrl".equals(entry.getKey())) {
				returnUrl += "&" + entry.getKey() + "=" + entry.getValue();
			}			
		}		
		System.out.println("returnUrl:" + returnUrl);
		
		URL url = new URL(returnUrl);
    	URLConnection con = url.openConnection();
    	InputStream in = con.getInputStream();
    	String encoding = con.getContentEncoding();
    	encoding = encoding == null ? "UTF-8" : encoding;
    	String body = IOUtils.toString(in, encoding);
    	
    	String replactStr = "<script[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>";
        Pattern pattern = Pattern.compile(replactStr); //img 태그 src 추출 정규표현식
        Matcher matcher = pattern.matcher(body);     
   
        while(matcher.find()){
        	String src = matcher.group(1);             
            body = body.replaceAll(src, "/api/http/getproxy.html?path="+URLEncoder.encode("http://tdesign.hankooktech.com/"+src, StandardCharsets.UTF_8));
        }
        
    	rsp.setContentType("text/html;charset=utf-8");
    	rsp.setCharacterEncoding("UTF-8");
    	rsp.getWriter().println(body);
    	rsp.getWriter().flush();
	}
	
	@FcNoAuth
    @RequestMapping("/getproxy.html")
    public void getproxy(HttpServletRequest req, HttpServletResponse rsp, @RequestParam("path") String path) throws IOException {
    	URL url = new URL(path);
    	URLConnection con = url.openConnection();
    	InputStream in = con.getInputStream();
    	String encoding = con.getContentEncoding();
    	encoding = encoding == null ? "UTF-8" : encoding;
    	String body = IOUtils.toString(in, encoding);
    	
    	rsp.setContentType("text/html;charset=utf-8");
    	rsp.setCharacterEncoding("UTF-8");
    	rsp.getWriter().println(body);
    	rsp.getWriter().flush();
    }
}
