<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	response.setHeader("Cache-Control", "no-cache, no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", -1);
%>
<html lang="${lang}" class="windowPopupHtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SHEP</title>
<%@include file="/WEB-INF/core/views/common/common_include.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/5.14.0/css/all.min.css">
<jsp:include page="/WEB-INF/core/views/common/3rdparty/ag-grid.jsp" />
<script src="${pageContext.request.contextPath}/assets/scripts/ag-grid.wrapper.js"></script>
<tiles:insertAttribute name="styles"/>
<tiles:insertAttribute name="scripts"/>
<style type="text/css">
	body, html {min-width: 100%;}
</style>
</head>
<body>
<!-- 로딩바(전체화면:#wrap밖, body바로 다음에 사용) -->
<div id="LOADING" class="loadingbar" style="display: none;">
	<div class="loadingbarbox">
		<div class="loadingbar-in">
			<img src="${pageContext.request.contextPath}/front/images/common/loading.gif">
			<p>Loading....</p>
		</div>
	</div>
</div>
<!-- //로딩바(전체화면) -->
<div class="popup-wrap windowtype" id="layer1">
	<tiles:insertAttribute name="body"/>
</div>
<%--<!-- LOADING -->
<div id="LOADING" class="LOADING" style="display:none;">
	<div class="inner">
		<span><img src="${pageContext.request.contextPath}/common/images/loading.gif" alt="" /></span>
		<p></p>
	</div>
</div>
<!--// LOADING -->--%>
</body>

<div class="popup-wrap" id="infoPopupInPopup">
    <div class="popup w500">
        <div class="pop-head bbtype">
            안내
        </div>
        <div class="pop-cont" id="contInfoPopupInPopup">
            팝업내용
        </div>
        <a href="#" class="close" onclick="$('#contInfoPopupInPopup').html('');$('#infoPopupInPopup').fadeOut(400);return false;">close</a>
    </div>
</div>

<div class="popup-wrap" id="alertPopupInPopup">
    <div class="popup w500">
        <div class="pop-head bbtype">
            경고
        </div>
        <div class="pop-cont" id="contAlertPopupInPopup">
            팝업내용
        </div>
        <a href="#" class="close" onclick="$('#contAlertPopupInPopup').html('');$('#alertPopupInPopup').fadeOut(400);return false;">close</a>
    </div>
</div>
</html>
