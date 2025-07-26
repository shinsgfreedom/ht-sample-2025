<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="@environment.getProperty('fc-config.sso.ssid')" var="ssid" />
<%
	/************************************************************
	 *	ReturnURL 설정
	 *  gentProc.jsp 에서 인증완료후 "returnURL" 파라미터에 설정된 URL로 리다이렉트
	 ************************************************************/	
	String returnURL = request.getParameter("returnURL") == null ? "" : request.getParameter("returnURL");
	if (!returnURL.trim().equals("")) session.setAttribute("returnURL", returnURL);
	//	System.out.println("parameter returnURL : (" + returnURL + ") / " + "session retutnURL : " + "(" + session.getAttribute("returnURL") +")");

	
	/************************************************************
	 *	Web-Agent 환경 설정
	 ************************************************************/	
	//String AUTH_URL = "hqsso1.hankooktire.com";				// ISign+ SSO URL
	// SSO 도메인벼경작업 20190615 전보규
	String AUTH_URL = "hqsso1.hankooktech.com";				// ISign+ SSO URL
	session.setAttribute("AUTHORIZATION_URL", "https://" + AUTH_URL + "/");
	session.setAttribute("AUTHORIZATION_SSL_URL", "https://" + AUTH_URL + "/");
	String ssid = (String)pageContext.getAttribute("ssid") ;
	session.setAttribute("SSID", ssid);				// 업무 고유 시스템 번호
	session.setAttribute("REQUEST_DATA", "ID");		// 인증DB Column명
	
	/**
	  * penta라는 context path가 존재한다면 path + "origin value"로 입력한다.
	  * ex) String path = "/penta";
	  * session.setAttribute("SERVICE_BUSINESS_PAGE", path + "/sso/business.jsp");
	  */
	String path = "";

	session.setAttribute("SERVICE_BUSINESS_PAGE", path + "/sso/business.jsp");	//ISign+ SSO 인증을 하기위해 불려야할 페이지
	session.setAttribute("SERVICE_LOGIN_PAGE", path + "/ssoLoginPage.html");		//ISign+ SSO 로그인을 하기위해 불려야할 페이지
	session.setAttribute("SERVICE_LOGOUT_PAGE", path + "/sso/logout.jsp");		//ISign+ SSO 로그아웃을 하기위해 불려야할 페이지
	session.setAttribute("SERVICE_ROLE_PAGE", path + "/sso/agentProc.jsp");		//ISign+ SSO 인증에는 성공했으나 권한이 없을 때 보여지는 페이지
	session.setAttribute("EXISTING_LOGIN_PAGE", path + "/ssoLoginPage.html");			//ISign+ SSO 네트워크 실패 시 기존 업무로 로그인 페이지
	
	
	String method = request.getParameter("method") == null ? "" : request.getParameter("method");
	String reTry = request.getParameter("reTry") == null ? "" : request.getParameter("reTry");
	String isToken = request.getParameter("isToken") == null ? "" : request.getParameter("isToken");
	String secureToken = request.getParameter("secureToken") == null ? "" : request.getParameter("secureToken");
	String secureSessionId = request.getParameter("secureSessionId") == null ? "" : request.getParameter("secureSessionId");
	
	String SERVICE_LOGIN_PAGE = session.getAttribute("SERVICE_LOGIN_PAGE") == null ? "" : session.getAttribute("SERVICE_LOGIN_PAGE").toString();
	
	//XSS 방어코드
	method = method.replaceAll("<", "&lt;");
	method = method.replaceAll(">", "&gt;");
	
	reTry = reTry.replaceAll("<", "&lt;");
	reTry = reTry.replaceAll(">", "&gt;");
	
	isToken = isToken.replaceAll("<", "&lt;");
	isToken = isToken.replaceAll(">", "&gt;");
	
	secureToken = secureToken.replaceAll("<", "&lt;");
	secureToken = secureToken.replaceAll(">", "&gt;");
	
	secureSessionId = secureSessionId.replaceAll("<", "&lt;");
	secureSessionId = secureSessionId.replaceAll(">", "&gt;");
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script src="/webjars/jquery/3.5.1/jquery.min.js"></script>
		<script src="/assets/scripts/common.js"></script>
	</head>

<body>
	<form name="sendForm" method="post">
		<input type="hidden" name="isToken" value="<%=isToken%>" />
		<input type="hidden" name="secureToken" value="<%=secureToken%>" />
		<input type="hidden" name="secureSessionId" value="<%=secureSessionId%>" />
	</form>

	<iframe id="frame-temp" style="display:none;width:0px; height: 0px;"></iframe>
	
	<script>

		$(function () {
			var path =  '/views/OEProectStatus/OEProectStatus';

			// Tableau 시스템 토큰처리영역
			HTGF.Api.get('${pageContext.request.contextPath}/api/MONITER_EX/getTableauTicketTemp', {}).then( function(resData) {
				var url = 'https://bi.hankooktech.com/trusted/'
					+ resData.ticket
					+ path;
				$('#frame-temp').attr('src', url);
				
				var method = "<%=method%>";
				var isToken = "<%=isToken%>";
				var reTry = "<%=reTry%>";
				//인증 되지 않는 사용자일 경우 로그인 페이지로 send
				var sendUrl = "<%=SERVICE_LOGIN_PAGE%>";
				var sendForm = document.sendForm;		    
			    console.log("method:" + method );
			    console.log("reTry:" + reTry );
			    console.log("isToken:" + isToken );
				// 인증서버에서 전달하는 유일한 method는 checkToken이다. 해당 method는 /root/isignplus/send/sendSecureToken.jsp에서 전달한다.
				if (method == "checkToken") {
					// reTry는 인증서버의 모든 코드에서 실패가 동작되면 Y, 정상동작되면 N를 전달한다.
					if(reTry == "N"){
						// isToken은 로그인 시도시 로그인 성공이나 로그인 된 상태일 때 Y, 로그인 실패 또는 로그인 된 상태가 아닐 때 N를 전달한다.
						if(isToken == "Y"){
							// 인증서버에 secureToken를 검증하기 위한 페이지로 send
							sendUrl = "<%=path%>" + "/sso/checkauth.jsp";//로그인 성공
						}
					}
				} else {
					// 파라미터가 존재하지 않는다면 인증서버에 Web-Agent의 정보를 요청하기 위한 페이지로 send
					sendUrl = "<%=path%>" + "/sso/checkserver.jsp";//인증서버 정보 요청
				}
				sendForm.action = sendUrl;
				sendForm.submit();
				
			});
		});
		
	</script>

</body>
</html>