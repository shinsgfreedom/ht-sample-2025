<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="${pageContext.request.contextPath}/assets/libs/bluebird.min.js"></script>
<script src="${pageContext.request.contextPath}/webjars/core-js-bundle/3.6.1/minified.js"></script>
<script src="${pageContext.request.contextPath}/webjars/babel__polyfill/7.10.4/dist/polyfill.min.js"></script>
<script src="${pageContext.request.contextPath}/webjars/jquery/3.5.1/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/webjars/moment/2.27.0/moment.js"></script>

<script src="${pageContext.request.contextPath}/assets/libs/jsview/jsviews.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/libs/jsrender/jsrender.min.js"></script>

<script src="${pageContext.request.contextPath}/fc-core-static/sys-resources.js"></script>
<script>
    (function () {
        window.I18 = function (i18nCode, data) {
            var i18nJson = window.__FC_LOCALES, lang = '${lang}', i18nText = i18nJson[i18nCode]
            if (!i18nText) return i18nCode + '_' + lang;

            return compile(i18nText, data);
            function compile(tpl, data) {
                var compiledStr = tpl,
                    regex = /\{\@=(.+?)\@\}/gim,
                    t0;

                while ((t0 = regex.exec(compiledStr)) != null) {
                    var existVal = data ? Object.keys(data).includes(t0[1]) : false;
                    var targetText = existVal ? data[t0[1]] : '[:' + t0[1] + ']';
                    compiledStr = compiledStr.replace(new RegExp(t0[0], 'gi'), targetText);
                }
                return compiledStr;
            }
        };

        window.CODE = function (code) {
            var codeJson = window.__FC_CODES[code];
            if (codeJson && codeJson.i18nCode) codeJson.i18n = window.I18(codeJson.i18nCode);
            return codeJson;
        };

        window.MenuRenderer = (function() {
            var menu = ${MENU_JSON}
            var mapChildren = function (parentId) {
                return menu.filter(function (o) {
                    return o.parentId === parentId
                }).map(function (v) {
                    return Object.assign(v, {items: mapChildren(v.id)})
                })
            }
            var rootNodes = menu.filter(function(v) { return !v.parentId})
            var root = rootNodes.map(function (v) {
                return Object.assign(v, {items: mapChildren(v.id)})
            })
            var menuTemplate = '<li class="{{:selected ? \'active\' : \'\'}}"><a href="{{:url}}">{{:text}}</a> {{if items.length > 0}}<ul></ul>{{/if}}</li>'
            function generateMenuDOM(el, cb) {
                renderMenu(el, root)
                function renderMenu(el, items) {
                    var menuRowTpl = $.templates(menuTemplate)
                    items.forEach(function(v) {
                        var li = $(menuRowTpl.render(v))
                        if (v.items.length > 0) renderMenu(li.find('ul'), v.items)
                        el.append(li)
                        cb && cb(v, li)
                    })
                }
                return el
            }
            function render(opts) {
                if (!opts) throw 'targetEl required'
                opts.targetEl.empty().append(generateMenuDOM(opts.targetEl, opts.cb || function() {}))
            }

            var mapParent = function (pId, result) {
                var parent = menu.find(function (o) {
                    return o.id === pId;
                });
                return parent ? mapParent(parent.parentId, result.concat([parent])) : result;
            }
            return {
                render: render,
                setRawData: function(m) {
                    menu = m
                },
                getRawData: function() {
                    return menu
                },
                getData: function() {
                    return root
                },
                setMenuTemplate:function(tpl) {
                    menuTemplate = tpl
                },
                getMenuTemplate: function() {
                    return menuTemplate
                },
                getHierarchy: function (menuId) {
                    var vId = menu.find(function (o) {
                        return o.menuId === menuId;
                    });
                    if (vId) vId = vId.id;
                    return mapParent(vId, []).reverse();
                }
            }
        })()

        // jsRender Helper 함수 등록
        $.views.helpers({
            codeI18n: function (code) {
                var o = CODE(code)
                if (!o) return code

                return I18(o.i18nCode)
            },
            dateFormat: function (v, format) {
                return moment(v).format(format)
            }
        })
    })()
</script>

<style>
    <c:set var="unAuthElementStyle" value="[data-fc-auth]"/>

    <c:if test="${USER_SESSION.menuAuth.readable eq true}">
    <c:set var="unAuthElementStyle" value="${unAuthElementStyle}:not([data-fc-auth*='r'])"/>
    </c:if>
    <c:if test="${USER_SESSION.menuAuth.writable eq true}">
    <c:set var="unAuthElementStyle" value="${unAuthElementStyle}:not([data-fc-auth*='w'])"/>
    </c:if>
    <c:if test="${USER_SESSION.menuAuth.modifiable eq true}">
    <c:set var="unAuthElementStyle" value="${unAuthElementStyle}:not([data-fc-auth*='m'])"/>
    </c:if>
    <c:if test="${USER_SESSION.menuAuth.deletable eq true}">
    <c:set var="unAuthElementStyle" value="${unAuthElementStyle}:not([data-fc-auth*='d'])"/>
    </c:if>

    ${unAuthElementStyle} {
        display: none;
    }
</style>
<script src="${pageContext.request.contextPath}/assets/scripts/common.js"></script>