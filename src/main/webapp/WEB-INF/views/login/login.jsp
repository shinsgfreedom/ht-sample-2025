<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String checkServer = session.getAttribute("checkServer") == null ? "" : session.getAttribute("checkServer").toString();
%>
<!doctype html>
<html lang="${lang}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="subject" content="login page">
    <title>SHEP Login</title>
    <%@include file="/WEB-INF/core/views/common/common_include.jsp"%>
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
    <link rel="icon" href="/favicon.ico" type="image/x-icon">

	<!-- front 기본 css -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/common_f/css/style.css" type="text/css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/front/css/front.css" type="text/css">

	<!-- 화면용 jquery 버전 : 공통에서 제공중이니 개발시 삭제 -->
	<script src="${pageContext.request.contextPath}/webjars/jquery/3.5.1/jquery.min.js"></script>

	<!-- 기본 js -->
	<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/common-ui.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/front/js/front-ui.js"></script>

	<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/jquery.cookie.js"></script>
	<script src="${pageContext.request.contextPath}/assets/scripts/common.js"></script>

    <jsp:include page="/WEB-INF/core/views/common/3rdparty/select2.jsp" />
    <style>
        /** select2 - common style span class 겹치는 문제 해결 */
        span.selection {
            display: block;
        }
    </style>
    <jsp:include page="/sso/isign_sso_login_include.jsp"/>
</head>

<body>
<!-- wrap -->
<div id="wrap-login">
	<div class="login-inner">

		<!-- container -->
		<div class="header">
			<span class="logo">
				<img src="${pageContext.request.contextPath}/common_f/images/login/login-top-logo.png" alt="Hankook" />
				<img src="${pageContext.request.contextPath}/common_f/images/login/logo.png" alt="SHE" />
			</span>
		</div>
		<div id="container">
			<div class="inner-contain">
				<div class="visual">
					<img src="${pageContext.request.contextPath}/common_f/images/login/edge-left.png" class="left"/>
					<img src="${pageContext.request.contextPath}/common_f/images/login/edge-right.png" class="right" />
					<div class="bg-area">
						<!-- 배경 이미지 영역 -->
					</div>
				</div>
				<div class="login-wrap">
					<form class="login-area form-signin" name="loginform" method="post" action="">
					<div class="info-bx">

						<div class="textbox mgb20">
							<p class="txt1">Welcome to</p>
							<p class="txt2">
								<strong>SHEP</strong>
							</p>
							<p class="txt1 mgt10">
								<span>Safety Health Enviroment Portal</span>
							</p>
						</div>

						<input type="text" class="input" placeholder="User ID" id="id" name="id"/>

						<input type="password" class="input" placeholder="Password" id="pw" name="pw"/>

						<div class="chkFindbox flrbox">
							<label class="rc-box fl">
								<input type="checkbox" id="rememberId" name="rememberId">
								<label for="rememberId">Remember ID</label>
							</label>
							<a class="fr link" href="#">Change Password</a>
						</div>
						<button type="button" class="btn-login" title="login" id="submit-btn">LOGIN</button>

						<c:if test="${requestScope['ACTIVE_PROFILES'].contains('local') || requestScope['ACTIVE_PROFILES'].contains('dev')}">
							<div>
								<br>
								<h6>자동 로그인</h6>
								<select name="user-autocomplete" class="select2-hidden-accessible" style="margin-top: 3em; width: 100%"></select>
							</div>
						</c:if>
						<label style="color:gray;margin-top: 16px;font-size: 12px;">Optimized only for Chrome and Edge browsers.</label>
					</div>
					</form>
				</div>
			</div>
		</div>
		<!--// container -->

		<div class="footer">
			<p class="copyright">Copyright ⓒ Hankook Tire &amp; Technology Co.,Ltd. All Rights Reserved.</p>
		</div>

	</div>
</div>
<!--// wrap -->
<!-- 팝업 영역 -->
<!-- popup collection -->
<script type="text/template" id="systemPopTemplete"><!-- message,confirm -->
	{{if popupType && popupType.length}}
		{{if popupType=='alert'}}
			<div class="popup system">
				<div class="pop-cont">
					<div class="system-txt ta-c"><p class="txt">{{:message}}</p></div>
				</div>
				<div class="pop-foot ta-c" style="padding-bottom: 20px;">
					<a href="javascript:void(0);" onclick="{{:action}}" class="btn-ix"><span class="ico-check3"></span><span class="ix-txt color1">OK</span></a>
				</div>
			</div>
		{{/if}}
		{{if popupType=='confirm'}}
			<div class="popup system">
				<div class="pop-cont">
					<div class="system-txt ta-c"><p class="txt">{{:message}}</p></div>
				</div>
				<div class="pop-foot ta-c" style="padding-bottom: 20px;">
					<a href="javascript:void(0)" class="btn-ix" onclick="LOG_IN.SYSTEM_POPUP.destroy();"><span class="ix-txt">Cancel</span></a>
					<a href="javascript:void(0)" class="btn-ix" onclick="{{:action}}"><span class="ico-check3"></span><span class="ix-txt color1">Complete</span></a>
				</div>
			</div>
		{{/if}}
	{{/if}}
</script>
<div class="popup-wrap" id="systemPop"></div><!-- system popup -->
<script>
	$(function () {
		
		var LOG_IN = {
			init : function() {
				this.loadIdCookie();
				this.initEvent();
			}
		
			, doLogin : function() {
				var checkServer = "<%=checkServer%>";
				if (checkServer === "" || $('#id').val() === 'admin') {
					var __this = this;
					this.setIdCookie();
					var data = $('.form-signin').serializeJson();
					data.password = data.pw;
					HTGF.Backdrop.show()
					HTGF.Api.post('/api/auth/login', data).then(function(){ 
						location.href = '/MAIN/main.html';
					}).catch(function (resData){
						//console.log(resData)
						if (resData.status === 403){
							__this.SYSTEM_POPUP.showAlert('Invalid User ID or password');
						}else{
							__this.SYSTEM_POPUP.showAlert(resData.response.message);
						}
					}).finally(function() { HTGF.Backdrop.hide() });
				} else {
					idpwLogin();
				}
				
			} 
		
			, initEvent : function() {
				var __this = this;
				$('#submit-btn').on('click', function() {
					__this.doLogin();
		        });
				
				var $target = null;
				$("#id").on('keyup', function(e) {
					if (e.keyCode === 13) {
						$target = $('#pw');
						$target.focus().select();
					}
				});
				
				$("#pw").on('keyup', function(e) {
					if (e.keyCode === 13) {
						__this.doLogin();
					}
				});
				
				$('#rememberId').on('click', function() {
					__this.setIdCookie();
		        });
			}
			
			, REMEMBER_ID_KEY : 'REMEMBER_ID_KEY'
			, loadIdCookie : function () {
				var rememberId = $.cookie( this.REMEMBER_ID_KEY );
				if(typeof rememberId != 'undefined' && rememberId != '') {
					$('#id').val(rememberId);
					$("#rememberId").prop("checked", true);	
				}
			}
			,  setIdCookie : function () {
				if($("#rememberId").is(":checked") == true) {
					$.cookie(this.REMEMBER_ID_KEY, $('#id').val(), { expires: 7 });
				} else {
					$.removeCookie(this.REMEMBER_ID_KEY);
				}
			}
			, SYSTEM_POPUP : {
				config: {
					id : 'systemPop',
					templete : 'systemPopTemplete'
				}
				, popupType: {
					alert: 'alert',
					confirm: 'confirm'
				}
				, showAlert : function(message, nextAction) {
					var defaultAction = "LOG_IN.SYSTEM_POPUP.destroy();";
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
					var defaultAction = "LOG_IN.SYSTEM_POPUP.destroy();";
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
		}
		
		LOG_IN.init();
		window.LOG_IN = LOG_IN;
    });
    
    <c:if test="${requestScope['ACTIVE_PROFILES'].contains('local') || requestScope['ACTIVE_PROFILES'].contains('dev')}">
    	$(function () {
            var redirectUrl = '${param.redirectUrl}' || '/MAIN/main.html'
            // 테스트용 계정 세팅
            $('#id').val('admin');
            $('#pw').val('qwer1234');
            
            $('[name=user-autocomplete]').select2({
                placeholder: 'Insert User Name',
                width: 'style', ajax: {
                    url: '/api/dev-utils/auto-complete/user',
                    data: function (params) {
                        return {q: params.term}
                    },
                    processResults: function (d) {
                        return {
                            results: d.map(function (v) {
                                return {id: v.uuid, text: v.name + '(' + v.deptName + ')', name: v.name, deptName: v.deptName, empNo: v.empNo}
                            })
                        }
                    }
                }
            }).on('select2:select', function(e) {
                $(this).val(null).trigger('change')
                var d = e.params.data
                HTGF.Backdrop.show();
                HTGF.Api.get('/api/dev-utils/auto-login/' + d.id).then(function() {
                    location.href = redirectUrl;
                })
                .catch(HTGF.Api.commonErrorCb)
                .finally(function() {
                    HTGF.Backdrop.hide();
                })
            });
        });
    </c:if>
</script>
</body>
</html>
