<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="header">
	<div class="inner">
		<div class="left">
			<a href="javascript:;" class="btn-gnb btnGnb"><span>GNB Open</span></a>
			<h1 class="logo"><a href="javascript:;" onclick="routeMain('MAIN');" class="btn-logo">SHEP</a></h1>
		</div>
		<div class="right">
			<c:if test="${USER_SESSION.customAuth.ADMIN_MAIN eq 'true'}">
				<a href="javascript:;" class="btn-util util4" onclick="window.open('/admin/menu.html','PopupWin', 'width=1300, height=700'); return false;">
					<span>Setting</span>
				</a>
			</c:if>
			<%--			<a href="javascript:;" class="btn-util util3" onclick="moveMyPage; return false;">--%>
			<%--				<span>My Page</span>--%>
			<%--			</a>--%>
			<%--			<a href="javascript:void(0)" class="link" onclick="return false;" title="${USER_SESSION.name}(${USER_SESSION.employeeNo}) / ${USER_SESSION.deptName}">--%>
			<%--			</a>--%>
			<a href="/logout.html" class="btn-logout">
				<span>Logout</span>
			</a>
		</div>
	</div>

	<!--gnb-box-->
	<div class="gnbBox">
		<div class="inner" id="gnb-area">
			<a href="javascript:void(0)" class="btn-gnbClose btnGnbClose"><span>GNB Close</span></a>
			<ul class="depth1-ul" id="gnb">

			</ul>
		</div>
	</div>
	<!--//gnb-box-->
</div>

<script>
	$(document).ready(function() {

		var winH = $(window).height();
		var winW = $(window).width();

		window.FRONT_MENU_RENDERER = (function () {
			var menu = ${MENU_JSON};

			var mapChildren = function (parentId, depth) {
				return menu.filter(function (o) {
					return o.parentId === parentId;
				}).map(function (v) {
					return Object.assign(v, {items: mapChildren(v.id, depth + 1), depth: depth + 1});
				});
			};

			var rootNodes = menu.filter(function (v) {
				return !v.parentId;
			});

			var root = rootNodes.map(function (v) {
				return Object.assign(v, {items: mapChildren(v.id, 0), depth: 0});
			});

			console.log('>>>> root ', root);

			// 1depth 메뉴와 2depth 메뉴를 위한 별도의 템플릿 정의
			var menuTemplate = '{{if menuId != "MANAGER"}}<li class="depth1-li">'
					+ '<a href="javascript:;" class="depth1-link link"'
					+ '{{if items.length == 0}}'
					+ '	{{if externalUrlYn != true}} onclick="routePage({id: \'{{:menuId}}\', text: \'{{:text}}\', link: \'{{:url}}\'}); return false;" {{/if}}'
					+ '	{{if externalUrlYn == true}} onclick="window.open(\'{{:externalUrl}}\', \'{{:text}}\', \'width='+winW+',height='+winH+'\'); return false;"{{/if}}'
					+ '{{/if}}'
					+ '>'
					+ '<span class="txt">{{:text}}</span>'
					+ '</a>'
					+ '{{if items.length > 0}}<ul class="depth2-ul"></ul>{{/if}}'
					+ '</li>{{/if}}';

			var subMenuTemplate = '<li class="depth2-li{{if items.length > 0}} has-depth{{/if}}">'
					+ '<a href="javascript:;" class="depth2-link" onclick="routePage({id: \'{{:menuId}}\', text: \'{{:text}}\', link: \'{{:url}}\'}); return false;">'
					+ '{{:text}}'
					+ '</a>'
					+ '</li>';

			function generateMenuDOM(el, cb) {
				renderDepth1Menu(el, root);

				function renderDepth1Menu(el, items) {
					//console.log('>> renderDepth1Menu', items);
					var menuRowTpl = $.templates(menuTemplate);
					items.forEach(function (v) {
						var li = $(menuRowTpl.render(v));
						el.append(li);

						if (v.items && v.items.length > 0) {
							var subMenuContainer = li.find('.depth2-ul');
							renderDepth2Menu(subMenuContainer, v.items);
						}

						cb && cb(v, li);
					});
				}

				function renderDepth2Menu(el, items) {
					//console.log('>> renderDepth2Menu', items);
					var subMenuRowTpl = $.templates(subMenuTemplate);
					items.forEach(function (v) {
						var li = $(subMenuRowTpl.render(v));
						el.append(li);

						if (v.items && v.items.length > 0) {
							var subMenuContainer = li.find('.depth3-ul');
							renderDepth3Menu(subMenuContainer, v.items);
						}

						cb && cb(v, li);
					});
				}

				return el;
			}

			function render(opts) {
				if (!opts) throw 'targetEl required';
				opts.targetEl.empty().append(generateMenuDOM(opts.targetEl, opts.cb || function () {}));
			}

			var mapParent = function (pId, result) {
				var parent = menu.find(function (o) {
					return o.id === pId;
				});
				return parent ? mapParent(parent.parentId, result.concat([parent])) : result;
			};

			return {
				render: render,
				setRawData: function (m) {
					menu = m;
				},
				getRawData: function () {
					return menu;
				},
				getData: function () {
					return root;
				},
				setMenuTemplate: function (tpl) {
					menuTemplate = tpl;
				},
				getMenuTemplate: function () {
					return menuTemplate;
				},
				getHierarchy: function (menuId) {
					var vId = menu.find(function (o) {
						return o.menuId === menuId;
					});
					if (vId) vId = vId.id;
					return mapParent(vId, []).reverse();
				}
			};
		})();

	});

	function moveMyPage() {
		<c:if test="${!empty param.tabName}">
		function moveActionPage(pMenuId, pReqId) {
			var menuData = MenuRenderer.getRawData().filter(function(item){ return (item.id === pMenuId || item.menuId === pMenuId) });
			//console.log('menuData', menuData)
			var moveUrl = menuData[0].url;
			moveUrl = moveUrl.indexOf('?') > 0 ? moveUrl + '&' : moveUrl + '?';
			routePage({id: menuData[0].menuId, text: menuData[0].text, link: moveUrl+'todoId='+pReqId+'&docNo='+pReqId});
		}
		moveActionPage('${param.tabName}', '${param.todoId}');
		</c:if>
	}

	$(function() {
		FRONT_MENU_RENDERER.render({targetEl:$('#gnb-area > .depth1-ul')});
	});
</script>