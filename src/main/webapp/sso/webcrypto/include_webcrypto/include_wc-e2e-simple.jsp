<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // 버전 정보. webcrypto의 버전과 맞춰서 넣음
  String version = "3.0.1.4";

  // webcrypto 파일들의 root 경로
  String baseURL = "/sso/webcrypto";
%>
    <!-- js 로딩 순서 바꾸면 안됨 -->
    <script type="text/javascript" src="<%=baseURL%>/js/forge/forge.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/jsbn.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/util.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/sha1.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/sha256.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/sha512.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/asn1.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/cipher.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/cipherModes.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/seed.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/aes.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/prng.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/random.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/rsa.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/pkcs1.js?v=<%=version%>" charset="UTF-8"></script>

    <script type="text/javascript" src="<%=baseURL%>/js/webcrypto/common/webcrypto.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/webcrypto/common/webcrypto_msg.js?v=<%=version%>" charset="UTF-8"></script>

    <script type="text/javascript" src="<%=baseURL%>/js/webcrypto/e2e/webcrypto_e2e.js?v=<%=version%>" charset="UTF-8"></script>
