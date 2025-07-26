package com.hankooktech.shep.common.messenger;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.LinkedHashMap;
import java.util.Map;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class MessengerHttpClient {
	private String MESSENGER_API_URL = "http://202.31.8.193:12556";
	private String MESSENGER_API_METHOD = "POST";
	
	public MessengerHttpClient() {
		
	}
	
	public String sendMessage(Map<String, String> params) {
		String result = "";
		HttpURLConnection con = null;
		BufferedReader in = null;
		
		try {
			params.put("CMD", "ALERT");
			params.put("Action", "ALERT");
			params.put("SystemName", "SHEP");
			params.put("SystemName_Encode", "KSC5601");
			params.put("SendName_Encode", "KSC5601");
			params.put("Subject_Encode", "KSC5601");
			params.put("Contents_Encode", "KSC5601");
			params.put("Option", "UM=POST");
			
			StringBuilder postData = new StringBuilder();
			for(Map.Entry<String, String> param : params.entrySet()) {
				if(postData.length() != 0) {
					postData.append('&');
				}
				postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
				postData.append('=');
				postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
			}
			byte[] postDataBytes = postData.toString().getBytes("UTF-8");
			
			URL obj = new URL(MESSENGER_API_URL);
			con = (HttpURLConnection)obj.openConnection();
			con.setRequestMethod(MESSENGER_API_METHOD);
			// 연결 타임아웃 설정 
			con.setConnectTimeout(3000);
			// 읽기 타임아웃 설정 
			con.setReadTimeout(3000);
			con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			con.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
			con.setDoOutput(true);
			con.getOutputStream().write(postDataBytes); // POST 호출
		
			in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			String line;
			while((line = in.readLine()) != null) {
				result += line;
			}
			log.info("result=" + result);
		} catch(Exception e) {
			e.printStackTrace();
			log.error(e.toString());
		} finally {
			if(in != null) {
				try { 
					in.close(); 
				} catch(Exception e) { 
					e.printStackTrace();
					log.error(e.toString());
				}
			}
			
			if(con != null) {
				con.disconnect();	
			}
		}
			
		return result;
	}
	
	public static void main(String[] args) {
		Map<String, String> params = new LinkedHashMap<String, String>();
		params.put("SendName", "최운수");
		params.put("SendID", "21601228");
		params.put("RecvID", "uc200903");
		params.put("Subject", "테스트 메시지");
		params.put("Contents", "테스트 메시지를 발송합니다.");
		params.put("URL", "http://devplms.hankooktech.com");
		
		MessengerHttpClient messengerHttpClient = new MessengerHttpClient();
		messengerHttpClient.sendMessage(params);
	}
}
