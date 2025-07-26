<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="${lang}" class="windowPopupHtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>SHEP</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<tiles:insertAttribute name="styles"/>
<tiles:insertAttribute name="scripts"/>
<style type="text/css">
	body, html {min-width: 100%;}
</style>
</head>
<body>
<div class="popup-wrap windowtype" id="layer1">
	<tiles:insertAttribute name="body"/>
</div>
</body>
</html>
