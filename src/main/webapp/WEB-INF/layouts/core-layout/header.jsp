<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="header">
    <div class="logobox">
        <div class="inner">
            <a href="#"><span class="logo-hk">Hankook</span></a>
            <div class="right">
                <div class="in-top">
                    <select class="select" name="global-locale-select" style="width: 140px">
                        <c:forEach var="item" items="${LOCALE_CODES}">
                            <option value="${item.value}" ${item.value == lang ? 'selected' : ''}>${item.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <!--a href="${pageContext.request.contextPath}" class="link">HOME</a>
                <span class="bar"></span>
                <a href="${pageContext.request.contextPath}/swagger-ui.html" class="link" target="_blank">swagger</a>
                <span class="bar"></span-->
                <a href="${pageContext.request.contextPath}/logout.html" class="link">LOGOUT</a>
            </div>
        </div>

    </div>
    <div id="gnb">
        <ul class="gnb1Depth"></ul>
        <div class="gnbbg"></div>
    </div>
</div>
<script>
    $(function() {
        var menuTemplage = '{{if menuId == "MANAGER" || parentId == "e8428f3294a24aa09b75956fdfdb5105"}}'
        menuTemplage += '<li class="{{:selected ? \'active\' : \'\'}}"><a href="{{:url ? url : \'javascript:void(0);\'}}">{{:text}}</a> {{if items.length > 0}}<ul class="gnb2Depth"></ul>{{/if}}</li>'
        menuTemplage += '{{/if}}';
        MenuRenderer.setMenuTemplate(menuTemplage)
        MenuRenderer.render({targetEl:$('#gnb > ul')})
        $('#gnb > ul').addClass('gnb1Depth');
        $('#gnb > ul').append('<li></li>');

        // 로케일 변경
        $('[name=global-locale-select]').change(function(e) {
            const selectedVal = $(e.currentTarget).val()
            HTGF.Api.get('/api/auth?lang=' + selectedVal).then(function() {
                location.reload()
            })
        })
    })
</script>