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
</head>
<body>
<div id="wrap">
	<tiles:insertAttribute name="header"/>

	<div id="historyTab">
	   	<ul class="fc-tab-main" >
		   <li class="main-tab" onclick="routeMain();">
			   <span class="fc-tab-left-control" onclick="routeMain('Y');">
				   <i class="home"></i>
			   </span>
			   <span class="title">HOME</span>
		   </li>
	   	</ul>
	   	<ul class="fc-tab" id="tbTabArea">
<%--			<li class="selected"><!--selected : 활성화시 추가-->--%>
<%--				<span class="fc-tab-left-control">--%>
<%--					<i class="fas fa-thumbtack fa-rotate-180" ref="pin"></i>--%>
<%--				</span>--%>
<%--				<span class="title">기본 active Tab</span>--%>
<%--				<span class="fc-tab-right-control">--%>
<%--					<i class="fas fa-expand" ref="expand"></i>--%>
<%--					<i class="fas fa-times" ref="close"></i>--%>
<%--				</span>--%>
<%--			</li>--%>
		</ul>
	</div>

	<!-- contents -->
	<div id="contents">

		<div class="content">
			<div class="cont-lc-area">
				<!-- 컨텐츠 영역 -->
				<div class="lc-rightbox" id="tbContArea">
<%--				<tiles:insertAttribute name="body"/>--%>
				</div>
				<!-- //컨텐츠 영역 -->
			</div>
		</div>
	</div>
	<!-- //contents -->

	<tiles:insertAttribute name="footer"/>
</div>
<!-- 팝업 영역 -->
<!-- popup collection -->
<script type="text/template" id="systemPopTemplete"><!-- message,confirm -->
	{{if popupType && popupType.length}}
		{{if popupType=='alert'}}
			<div class="popup system">
				<div class="pop-cont">
					<div class="system-txt ta-c"><p class="txt">{{:message}}</p></div>
				</div>
				<div class="pop-foot ta-c">
					<a href="javascript:void(0);" onclick="{{:action}}" class="btn-ix"><span class="ico-check3"></span><span class="ix-txt color1">OK</span></a>
				</div>
			</div>
		{{/if}}
		{{if popupType=='confirm'}}
			<div class="popup system">
				<div class="pop-cont">
					<div class="system-txt ta-c"><p class="txt">{{:message}}</p></div>
				</div>
				<div class="pop-foot ta-c">
					<a href="javascript:void(0)" class="btn-ix" onclick="SYSTEM_POPUP.destroy();"><span class="ix-txt">Cancel</span></a>
					<a href="javascript:void(0)" class="btn-ix" onclick="{{:action}}"><span class="ico-check3"></span><span class="ix-txt color1">Complete</span></a>
				</div>
			</div>
		{{/if}}
	{{/if}}
</script>
<div class="popup-wrap" id="systemPop"></div><!-- system popup -->

<script type="text/javascript">
$(function () {
	var SYSTEM_POPUP = {
		config: {
			id : 'systemPop',
			templete : 'systemPopTemplete'
		}
		, popupType: {
			alert: 'alert',
			confirm: 'confirm'
		}
		, showAlert : function(message, nextAction) {
			var defaultAction = "SYSTEM_POPUP.destroy();";
			if (nextAction == undefined || nextAction == null) {
				nextAction = "";
			}
			var obj = {
				popupType: this.popupType.alert
				, message: message
				, action: defaultAction+nextAction
			}
			this.render(obj);
		}
		, showConfirm : function(message, nextAction) {
			var defaultAction = "SYSTEM_POPUP.destroy();";
			if (nextAction == undefined || nextAction == null) {
				nextAction = "";
			}
			var obj = {
				popupType: this.popupType.confirm
				, message: message
				, action: defaultAction+nextAction
			}
			this.render(obj);
		}
		, render: function(obj) {
			$('#'+this.config.id).empty().append($('#'+this.config.templete).render(obj));
			popupLayer('#'+this.config.id);
		}
		, destroy: function() {
			$('#'+this.config.id).fadeOut(400).empty();
		}
	}
	window.SYSTEM_POPUP = SYSTEM_POPUP;
});
</script>

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

<tiles:insertAttribute name="scripts"/>
<%--<script type="text/javascript" src="${pageContext.request.contextPath}/front/js/com.htg.IntegratedSearch.js?${rand}"></script>--%>
</body>
</html>
