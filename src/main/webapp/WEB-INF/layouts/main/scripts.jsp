<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="rand" value="<%=System.nanoTime()%>" />

<!--사용자용 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/common_f/js/common-ui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/jquery.mCustomScrollbar.concat.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/assets/scripts/ag-grid.wrapper.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/front/js/front-ui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/front/js/com.htg.TabRenderer.js?${rand}"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/front/js/com.htg.layout.js?${rand}"></script>
<script>
	var CONTEXT_ROOT = '${pageContext.request.contextPath}';
	var FROALA_EDITOR_KEY = "8JF3bG3A5C3A2B2C1yQNDMIJd1IQNSEa2EUAf1XVFQa1EaD4D3B2C2A18A14A7C9D4C3==";
	var globalUserConfig = JSON.parse(JSON.stringify(${globalUserConfig.toJsonString()}));

	var agent = navigator.userAgent.toLowerCase();
	String.prototype.hashCode = function() {
		var hash = 0;
		if (this.length == 0) {
			return hash;
		}
		for (var i = 0; i < this.length; i++) {
			var char = this.charCodeAt(i);
			hash = ((hash<<5)-hash)+char;
			hash = hash & hash; // Convert to 32bit integer
		}
		return hash;
	}

	/* default js library package */
	var com = {
		htg : {}
	};

	com.htg.common = {
			VariableManager: {},
			MenuUtil: {
				getMenu: function(_menuId) {
					var menu = MenuRenderer.getRawData().filter(function(_m) {
						if (_m.menuId === _menuId) {
							return JSON.parse(JSON.stringify(_m));
						}
					});
					return menu && menu.length > 0 && menu[0];
					//return (menu && menu.length > 0 && menu[0]) || {menuId: 'PAGE_404'};
				}
			},
			GlobalUserConfig: {
				synchronize: function(_userPortletGroups) {
					$.each(_userPortletGroups, function(_, _pg) {
						$.each(_pg.widgets, function(_, _p) {
							$.each(MenuRenderer.getRawData(), function(_, _m) {
								if (_m.menuId === _p.id) {
									_p.link = _m.url;
									return false;
								}
							});
						});
					});

					globalUserConfig.userPortletGroups = _userPortletGroups;
					console.info('[GlobalUserConfig] MenuRenderer.getRawData() =====>', MenuRenderer.getRawData());
					console.info('[GlobalUserConfig] globalUserConfig.userPortletGroups, =====>', globalUserConfig.userPortletGroups);
				}
			},
			TabNavigator: {
				route: function (option) {
					var self = this;
					var _option, _successHandler;

					if (option && typeof option === 'object') {

						if (!option.menuId) {
							console.error('[TabNavigator] #route - option must have menuId property!!');
							return;
						}
						if (option.success || !option.successHandler) {
							console.error('[TabNavigator - %s] #route - option must have successHandler function, NOT success!!', option.menuId);
							return;
						}

						_successHandler = option.successHandler;

						_option = JSON.parse(JSON.stringify(option));
						delete _option.menuId;
						delete _option.successHandler;

						if (!option.error) {
							_option.error = function(response) {
								console.error('[TabNavigator - %s] #route - response:', option.menuId, response);
							};
						}

						_option.success = function(html) {
								self.verifySession(html)
									.then(function(html) {
										_successHandler(html);
									});
						};
					} else {
						console.error('[TabNavigator - %s] #route - option is requred', option.menuId);
						return;
					}

					$.ajax(_option);
				} ,
				verifySession: function(html) {
					return new Promise(function(resolve, reject) {
						if (html.indexOf('<meta name="subject" content="login page">') > -1) {
							reject();
							top.document.location.replace(CONTEXT_ROOT + '/');
						} else {
							resolve(html);
						}
					});
				}
			}
	};
</script>