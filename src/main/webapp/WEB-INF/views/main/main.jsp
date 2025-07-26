<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

${userTabs}
<br>
<br>
<br>
<a onclick="fnUserDeptPop('user-area')" style="cursor:pointer">[Search User Test]</a>
<br></br>
<br></br>
<div id="user-area"></div>


<script>
$(document).ready(function(){
    // $('#header').addClass('open');
});

//User & Dept 조회 팝업
function fnUserDeptPop(targetId){

    var messageCallback = function (res) {

        window.removeEventListener('message', messageCallback)
        var users = res.data.users
        var depts = res.data.depts

        console.log(users, depts)

        $('#'+targetId).text(JSON.stringify(users))
    }

    window.open(
        // '/common/popup/user-dept-search.html?filterDeptCodes='+'00000001,00007851'+'&mode=USER',
        '/common/popup/user-dept-search.html?filterDeptCodes=&mode=USER',
        'user-dept-search',
        'toolbar=no,scrollbars=yes,resizable=yes,width=740,height=900')

    window.addEventListener('message', messageCallback, false)
}
</script>