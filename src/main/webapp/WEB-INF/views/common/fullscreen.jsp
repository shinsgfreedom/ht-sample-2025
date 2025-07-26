<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<%@include file="/WEB-INF/layouts/main/styles.jsp"%>
<%--<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/style.css">--%>
<style type="text/css">
	body, html {min-width: 100%;}
	body{ -ms-overflow-style: none; }
	::-webkit-scrollbar { display: none; }
	#layer1 {
		overflow-x: hidden;
		overflow-y: auto; // 스크롤 있는 경우에만 표시
	}
</style>
<%@include file="/WEB-INF/core/views/common/common_include.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/5.14.0/css/all.min.css">
<jsp:include page="/WEB-INF/core/views/common/3rdparty/ag-grid.jsp" />
<script src="${pageContext.request.contextPath}/assets/scripts/ag-grid.wrapper.js"></script>
<%@include file="/WEB-INF/layouts/main/scripts.jsp"%>
<%@include file="/WEB-INF/layouts/default/scripts.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/common-dev.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/xlsx.full.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/assets/libs/micromodal.min.js"></script>
<script type="text/javascript">
$(function () {
	$(window).off('resize');
});
</script>
</head>
<body style="width:100%;height:100%;">
<div class="popup-wrap windowtype" id="layer1" style="width:100%;height:100%;">
	<div class="popup w1200">
		<div class="pop-head" id="popHeadTitle"></div>
		<div class="pop-cont" id="cont_${param.tabId}">
		</div>
		<a href="javascript:void(0);" class="close" onclick="FULL_SCREEN.closePopup();return false;" title="Close">close</a>
<c:if test="${empty param.btnOpt || param.btnOpt eq null}">
		<a href="javascript:void(0);" class="refresh" onclick="FULL_SCREEN.refreshPage();return false;" title="Refresh">refresh</a>
		<a href="javascript:void(0);" class="retab" onclick="FULL_SCREEN.reRoutePage();return false;" title="Retab">retab</a>
		<a href="javascript:void(0);" class="maximize" id="btnFullscreenToggle" onclick="FULL_SCREEN.goFullScreen(document.getElementById('layer1'));return false;" title="Maximize">fullscreen</a>
</c:if>
	</div>
</div>
<script>
var __MENU_ID = '${param.tabId}';

$(function() {
	var FULL_LOADING = {
		msg : ''
		, open : function(pType){
			if ( !pType || pType == "L") {
				this.msg = "Loading ...";
			} 
			else if ( pType == "C") {
				this.msg = "Load Completed. Click here!!";
			} else {
				this.msg = pType;
			}
			
			$('#FULL_LOADING').find('p').html(this.msg);
			$('#FULL_LOADING').show();
		}
		, close : function(){
			$('#FULL_LOADING').hide();
		}
	};
	
	var FULL_SCREEN = {
		init : function() {
			FULL_LOADING.open('L');
			this.initNavi();
			this.initData();
		}
		, initNavi : function() {
			var menuInfo = MenuRenderer.getRawData().filter(function(m){
				return m.menuId == __MENU_ID;
			});
			var popTitle = '';
			this.fullscreenUrl = '';
			if(menuInfo === undefined || menuInfo == null || menuInfo.length == 0) {
				popTitle = __MENU_ID;
				this.fullscreenUrl = '';
			} else {
				popTitle = menuInfo[0].text;
				this.fullscreenUrl = menuInfo[0].url;
			}
			$("#popHeadTitle").append(popTitle);
		}
		, initData : function() {
			if(this.fullscreenUrl == '') {
				alert('url dose not exist.');
				this.reRoutePage();
			}
			var tabUrl = this.fullscreenUrl.indexOf('?') > 0 ? this.fullscreenUrl + '&' : this.fullscreenUrl + '?';
			$.ajax({
				type: 'GET',
				url: '${pageContext.request.contextPath}' + tabUrl + 'option=tab&tab=1',
				dataType: 'html',
				beforeSend: function() {
					//FULL_LOADING.open('L');
				},
				success: function(content) {
					$('#cont_${param.tabId}').append(content);
					$('.page-top').remove();
					//$('#btnFullscreenToggle').trigger('click');
				},
				complete: function() {
					//FULL_LOADING.open('C');
					FULL_LOADING.close();
				}
			});
		}
		, reRoutePage : function() {
			if(opener.reRoutePage) {
				opener.reRoutePage(__MENU_ID);
				self.close();
			}
		}
		, refreshPage : function() {
			if(this.fullscreenUrl == '') {
				alert('url dose not exist.');
				this.reRoutePage();
			}
			var tabUrl = this.fullscreenUrl.indexOf('?') > 0 ? this.fullscreenUrl + '&' : this.fullscreenUrl + '?';
			$.ajax({
				type: 'GET',
				url: '${pageContext.request.contextPath}' + tabUrl + 'option=tab&tab=1',
				dataType: 'html',
				beforeSend: function() {
					//FULL_LOADING.open('L');
				},
				success: function(content) {
					$('#cont_${param.tabId}').empty().append(content);
					$('.page-top').remove();
					//$('#btnFullscreenToggle').trigger('click');
				},
				complete: function() {
					//FULL_LOADING.open('C');
					FULL_LOADING.close();
				}
			});
		}
		, closePopup : function() {
			window.close();
		}
		, goFullScreen : function(elem) {
			console.log('goFullScreen')
			FULL_LOADING.close();
			if ((document.fullScreenElement !== undefined && document.fullScreenElement === null) 
					|| (document.msFullscreenElement !== undefined && document.msFullscreenElement === null) 
					|| (document.mozFullScreen !== undefined && !document.mozFullScreen) 
					|| (document.webkitIsFullScreen !== undefined && !document.webkitIsFullScreen)) 
			{
				$('.maximize').addClass('on');
				$('.maximize').attr('title','Minimize');
				if (elem.requestFullScreen) {
					elem.requestFullScreen();
				} else if (elem.mozRequestFullScreen) {
					elem.mozRequestFullScreen();
				} else if (elem.webkitRequestFullScreen) {
					elem.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
				} else if (elem.msRequestFullscreen) {
					elem.msRequestFullscreen();
				}
			} else {
				$('.maximize').removeClass('on');
				$('.maximize').attr('title','Maximize');
				if (document.cancelFullScreen) {
					document.cancelFullScreen();
				} else if (document.mozCancelFullScreen) {
					document.mozCancelFullScreen();
				} else if (document.webkitCancelFullScreen) {
					document.webkitCancelFullScreen();
				} else if (document.msExitFullscreen) {
					document.msExitFullscreen();
				}
			}
		}
	}

	FULL_SCREEN.init();
	window.FULL_SCREEN = FULL_SCREEN;
});
//$(document).ready(function() {
//	$('#btnFullscreenToggle').trigger('click');
//});
</script>
<!-- LOADING -->
<div id="FULL_LOADING" class="LOADING" style="display:none;" onclick="FULL_SCREEN.goFullScreen(document.body);">
	<div class="inner">
		<span><img src="${pageContext.request.contextPath}/common/images/loading.gif" alt="" /></span>
		<p></p>
	</div>
</div>
<!--// LOADING -->
</body>
</html>