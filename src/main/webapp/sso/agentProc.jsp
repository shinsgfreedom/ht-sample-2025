<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.Enumeration" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
	<body>

<%
	// SUCCESS_CODE => 1(인증 성공), 2(인증 실패), 3(권한)
	String SUCCESS_CODE = session.getAttribute("SUCCESS_CODE")==null ? "" : session.getAttribute("SUCCESS_CODE").toString();
	String SERVICE_LOGIN_PAGE = session.getAttribute("SERVICE_LOGIN_PAGE")==null ? "" : session.getAttribute("SERVICE_LOGIN_PAGE").toString();
	String SERVICE_LOGOUT_PAGE = session.getAttribute("SERVICE_LOGOUT_PAGE")==null ? "" : session.getAttribute("SERVICE_LOGOUT_PAGE").toString();
	String AUTHORIZATION_SSL_URL = session.getAttribute("AUTHORIZATION_SSL_URL")==null ? "" : session.getAttribute("AUTHORIZATION_SSL_URL").toString();
	String SSID = session.getAttribute("SSID")==null ? "" : session.getAttribute("SSID").toString();
 	String returnURL = session.getAttribute("returnURL")==null ? "" : session.getAttribute("returnURL").toString();


	String checkServer = session.getAttribute("checkServer")==null ? "" : session.getAttribute("checkServer").toString();
//	String user_id = session.getAttribute("ID")==null ? "" : session.getAttribute("ID").toString();


	if (checkServer.isEmpty()) {
		session.setAttribute("checkServer", "Y");
	}

	//System.out.println("## 페이지 분기시작 1 ## "+ returnUrl);
	//System.out.println("## 페이지 분기시작 2 ## "+ SUCCESS_CODE);
	if (SUCCESS_CODE.equals("1")) {
		if (!returnURL.equals("")) {
			session.setAttribute("returnURL", returnURL);
			response.sendRedirect("/ssoprocess.html");
			return;
		}
	// 인증에 성공하고 권한이 있을 때 agentProc.jsp로 들어왔을 때 메시지가 출력된다.
 	response.sendRedirect("/ssoprocess.html");
%>
	<input value="<%=returnURL%>"/>
	<input value="<%=SUCCESS_CODE%>"/>
	<!-- 내부에 작성된 내용을 삭제하고 인증 완료 후 작업으로 변경하세요. -->
	<h1>인증성공</h1>
	<input type="button" onclick="showAndroidToast()" style="cursor:hand" value="로그아웃" />
	<input type="button" onclick="javascript:location.href='<%=AUTHORIZATION_SSL_URL%>LoginServlet?method=changePwForm&ssid=<%=SSID %>'" style="cursor:hand" value="비밀번호변경" />
	<input type="button" onclick="javascript:location.href='<%=AUTHORIZATION_SSL_URL%>LoginServlet?method=OTPRegisterForm&ssid=<%=SSID %>'" style="cursor:hand" value="OTP등록" />
	<!-- 내부에 작성된 내용을 삭제하고 인증 완료 후 작업으로 변경하세요. -->
	<script type="text/javascript">
		function showAndroidToast() {
			//setCookie('isignplus', 'isignplustest', 1);
			location.href='<%=SERVICE_LOGOUT_PAGE%>'
			Android.hybridLogout();
		}
	</script>
<%
	} else if(SUCCESS_CODE.equals("3")) {
	// 인증이 성공하고 권한이 없는 상태에서 agentProc.jsp로 들어왔을 때 메시지가 출력된다.
%>
	<h1><%=session.getAttribute("errMsg") == null ? "" : session.getAttribute("errMsg").toString()%></h1>
<%
	}else{
	// 인증되지 않은 상태에서 agentProc.jsp로 들어왔을 때 로그인 버튼이 보여진다.
%>
	<input type="button" onclick="javascript:location.href='login.jsp'" style="cursor:hand" value="로그인" />
<%
	}
%>

	</body>
</html>
