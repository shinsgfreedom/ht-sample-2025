<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="${lang}" class="adminHtml">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <jsp:include page="/WEB-INF/core/views/common/common_include.jsp"/>
    <!-- 퍼블쪽 의존성 -->
    <%@include file="/WEB-INF/layouts/default/scripts.jsp"%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/common/js/admin-ui.js"></script><!-- admin일때만 추가(공통일때 삭제) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/admin.css" type="text/css"><!-- admin일때만 추가(공통일때 삭제) -->
    <!-- 퍼블쪽 의존성 끝 -->
</head>
<body>
<div id="wrap">
    <tiles:insertAttribute name="header"/>
    <div id="contents">
        <div class="visual"></div>
        <div class="content">
            <tiles:insertAttribute name="body"/>
        </div>
    </div>
    <tiles:insertAttribute name="footer"/>
</div>
</body>
</html>
