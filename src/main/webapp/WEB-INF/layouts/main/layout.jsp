<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="rand" value="<%=System.nanoTime()%>" />
<%
	response.setHeader("Cache-Control", "no-cache, no-store"); 
	response.setHeader("Pragma", "no-cache"); 
	response.setDateHeader("Expires", -1); 
%>
<html lang="${lang}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>SHEP</title>
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
	<link rel="icon" href="/favicon.ico" type="image/x-icon">
	<tiles:insertAttribute name="styles"/>
	<%@include file="/WEB-INF/core/views/common/common_include.jsp"%>
	<%--<jsp:include page="/WEB-INF/views/common/ag-grid.jsp"/>--%>
	<%--<jsp:include page="/WEB-INF/views/common/ag-grid-utils.jsp" />--%>

	<!-- tab lib -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/core/fc-tab.css?v=${FC_CURRENT_VERSION}">
	<script type="text/template" id="tab-item-tpl">
		<li>
			<!--span class="fc-tab-left-control">
				<i class="fas fa-thumbtack" ref="pin"></i>
				<i class="fas fa-bars" style=" margin: 0.2em; cursor: grab" ref="drag-bar"></i>
			</span-->
			<span class="title"></span>
			<span class="fc-tab-right-control">
				<i class="fas fa-redo-alt" ref="refresh"></i>
				<i class="fas fa-times" ref="close"></i>
			</span>
		</li>
	</script>
</head>
<body>
<div id="wrap">
	<tiles:insertAttribute name="header"/>

	<div id="historyTab">
<%--		<li class="main-tab" onclick="routeMain();" id="MAIN">--%>
<%--		   <span class="fc-tab-left-control" onclick="routeMain('Y');">--%>
<%--			   <i class="home"></i>--%>
<%--		   </span>--%>
<%--		   <span class="title">HOME</span>--%>
<%--	    </li>--%>
		<div id="mainTabs" class="inner abs-area maintype w2ui-reset w2ui-tabs" name="mainTabs">
			<ul id="tbTabArea" class="fc-tab">
			</ul>
			<%--ul class="fc-tab" id="tbTabArea">
				<li class="selected"><!--selected : 활성화시 추가-->
					<span class="fc-tab-left-control">
						<i class="fas fa-thumbtack fa-rotate-180" ref="pin"></i>
					</span>
					<span class="title">기본 active Tab</span>
					<span class="fc-tab-right-control">
						<i class="fas fa-expand" ref="expand"></i>
						<i class="fas fa-times" ref="close"></i>
					</span>
				</li>
			</ul--%>
		</div>
	</div>

	<!-- contents -->
	<div id="contents">
		<div class="content">
			<div class="cont-lc-area">
				<!-- 컨텐츠 영역 -->
				<div class="lc-rightbox" id="tbContArea">


				</div>
				<!-- //컨텐츠 영역 -->
			</div>
		</div>
	</div>
	<!-- //contents -->

	<tiles:insertAttribute name="footer"/>
</div>

<!-- 팝업 영역 -->
<%@include file="/WEB-INF/layouts/default/systemPopup.jsp"%>

<tiles:insertAttribute name="scripts"/>
<%--<script type="text/javascript" src="${pageContext.request.contextPath}/front/js/com.htg.IntegratedSearch.js?${rand}"></script>--%>
</body>
</html>
