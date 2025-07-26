
"use strict";
var GLOBAL_CONF = {
    USERKEY : 0
}

var COMMONJS = {

    enterSearch:function(_keyName){

        $("#"+_keyName).keypress(function(e){

            if(e.keyCode == 13){
                $(".search").click();
            }
        })


    }

    /***************************************************************
     * ucwareMessenger API
     *
     *@param 팀장이름(SendName)
     *@param 부서정보(RecvID)
     *@param 팀장ID(SendID)
     * @param 알림제목(Subject)
     * COMMONJS.ucwareMessenger(RecvID,SendName,SendID,Subject);
     ****************************************************************/
    , ucwareMessenger:function(RecvID,SendName,SendID,Subject){

        //alert("ucwareMessenger alert Api call");

        var $form = $('<form></form>');
        $form.attr('action', 'http://202.31.8.193:12556');
        $form.attr('method', 'post');
        $form.attr('target', 'ifrsubmit');
        $form.appendTo('body');

        var winName='ifrsubmit'
            ,inputCMD = $('<input type="hidden" value="ALERT" name="CMD">')
            ,inputAction = $('<input type="hidden" value="ALERT" name="Action">')
            ,inputSendName = $('<input type="hidden" value="'+SendName+'" name="SendName">')
            ,inputRecvID = $('<input type="hidden" value="'+RecvID+'" name="RecvID">')
            ,inputSystemName = $('<input type="hidden" value="HOPE" name="SystemName">')
            ,inputSendID = $('<input type="hidden" value="'+SendID+'" name="SendID">')
            ,inputSubject = $('<input type="hidden" value="'+Subject+'" name="Subject">')
            ,inputContents = $('<input type="hidden" value="'+Subject+"건이 최종 확인되었습니다."+'" name="Contents">')
            ,inputSubject_Encode = $('<input type="hidden" value="KSC5601" name="Subject_Encode">')
            ,inputContents_Encode = $('<input type="hidden" value="KSC5601" name="Contents_Encode">')
            ,inputSystemName_Encode = $('<input type="hidden" value="KSC5601" name="SystemName_Encode">')
            ,inputSendName_Encode = $('<input type="hidden" value="KSC5601" name="SendName_Encode">')
            ,inputURL = $('<input type="hidden" value="http://arena.hankooktire.com" name="URL">')
            ,inputOption = $('<input type="hidden" value="UM=POST" name="Option">');

        /*알림 읽기표시, 알림 삭제를 위한 알림 키 값.*/
        /*<참고>
            생략 시 임의의 키 값으로 시스템에서
            자동으로 생성됨
            임의의 키 값 생성시에는 읽기,삭제
            기능을 사용할 수 없음.--%>*/
        $form.append(inputCMD).append(inputAction).append(inputSendName).append(inputRecvID).append(inputSystemName).append(inputSendID)
            .append(inputSubject).append(inputContents).append(inputSubject_Encode).append(inputContents_Encode).append(inputSystemName_Encode)
            .append(inputSendName_Encode).append(inputURL).append(inputOption);

        //$form.submit();


        // $form.submit(function(event){
        //     // 자동 submit을 시키는 것을 막는다.
        //     event.preventDefault();
        //     // /** * 입력 필드 validattion check 로직 */
        //     // /** * ajax로 다른 페이지를 처리 후에 결과가 성공일 때 전송 처리를 한다. */
        //     // 전송 여부 boolean 값
        //     // 초기값은 false로 셋팅을 한다.
        //     var isSubmit = false;
        //
        //     console.log("isSubmit:",isSubmit);
        //     $.ajax({ url:'http://202.31.8.193:12556', type:'post', data:$('#ucmasg').serialize(), dataType:'json',
        //         // 다른 페이지를 처리 후에 결과가 성공일 때
        //         // 비동기식으로 처리를 함
        //         async: false
        //         , success:function(data) {
        //             var message = data.message;
        //             // 결과값이 성공이면 전송 여부는 true
        //
        //             console.log("message:",message);
        //             if ( message == 'Success' ) {
        //                 isSubmit = true;
        //             } else {
        //                 // 결과값이 실패이면 전송 여부는 false
        //                 // 앞서 초기값을 false로 해 놓았지만 한번 더 선언을 한다.
        //                 isSubmit = false;
        //             }
        //         },
        //         error:function(request, status, error) {
        //             // 오류가 발생했을 때 호출된다.
        //             console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        //             // ajax 처리가 결과가 에러이면 전송 여부는 false
        //             // 앞서 초기값을 false로 해 놓았지만 한번 더 선언을 한다.
        //             isSubmit = false; }
        //         , beforeSend:function() {
        //             // 로딩바를 보여준다.
        //         }, complete:function() {
        //             // 로딩바를 해제한다.
        //         } });
        //     if ( isSubmit )
        //         this.submit();
        // })


        $form.submit(function(e){
            //e.preventDefault()
            alert("ucware.net submit");
            $.post().done(function(data){
                console.log("---->",data);
            })
            return false;
        });



    }
    /***************************************************************
     * localstorage remove
     *
     * 전달받은 key name으로 해당 localstorage data를 삭제
     *
     * @param String key	 : 저장 key
     * COMMONJS.removeStorage(key);
     ****************************************************************/
    ,removeStorage : function(name) {
        try {
            localStorage.removeItem(name);
            localStorage.removeItem(name + '_expiresIn');
            //localStorage.clear();
        } catch(e) {
            console.log('removeStorage: Error removing key ['+ key + '] from localStorage: ' + JSON.stringify(e) );
            return false;
        }
        return true;
    },
    /***************************************************************
     * localstorage dept remove
     *
     * 전달받은 dept key name으로 해당 localstorage data를 삭제
     *
     * name-01,-01_expiresIn , name-04,-04_expiresIn
     * @param String key	 : 저장 key
     * EX:
     * COMMONJS.removeStorage(key);
     ****************************************************************/
    removeDefStorage:function(){

        var subValue='-01';
        var name ='';
        for (var key in localStorage){

            var iValue = key.indexOf(subValue);

            if(iValue > 0){
                var strArray=key.split('-');
                name = strArray[0];
            }
        }

        localStorage.removeItem(name+'-01');
        localStorage.removeItem(name +'-01'+'_expiresIn');
        localStorage.removeItem(name+'-02');
        localStorage.removeItem(name +'-02'+'_expiresIn');
        localStorage.removeItem(name+'-03');
        localStorage.removeItem(name +'-03'+'_expiresIn');
        localStorage.removeItem(name+'-04');
        localStorage.removeItem(name +'-04'+'_expiresIn');
    },
    /***************************************************************
     * GET localstorage
     *
     * 전달받은 key name 으로 해당 localstorage 값 얻거나 삭제
     *
     * name-01,-01_expiresIn , name-04,-04_expiresIn
     * @param String key	 : 저장 key
     * @param String key	 : 저장 key
     * EX:
     * COMMONJS.getStorage(GLOBAL_CONF.USERKEY+'-01',GLOBAL_CONF.USERKEY);
     * COMMONJS.getStorage(GLOBAL_CONF.USERKEY+'-02',GLOBAL_CONF.USERKEY);
     * COMMONJS.getStorage(GLOBAL_CONF.USERKEY+'-03',GLOBAL_CONF.USERKEY);
     * COMMONJS.getStorage(GLOBAL_CONF.USERKEY+'-04',GLOBAL_CONF.USERKEY);
     ****************************************************************/
    getStorage : function(key,uniqkey) {

        if(uniqkey != 0){

            var now = Date.now();  //epoch time, lets deal only with integer
            // set expiration for storage
            var expiresIn = localStorage.getItem(key+'_expiresIn');


            if (expiresIn===undefined || expiresIn===null) { expiresIn = 0; }

            if(expiresIn == 0){
                COMMONJS.removeDefStorage();
            }

            if (expiresIn < now) {// Expired
                COMMONJS.removeStorage(key);
                return null;
            } else {
                try {
                    var value = localStorage.getItem(key);
                    return value;
                } catch(e) {
                    console.log('getStorage: Error reading key ['+ key + '] from localStorage: ' + JSON.stringify(e) );
                    return null;
                }
            }

        }

    },
    /***************************************************************
     * SET localstorage
     *
     * 전달받은 key로 해당 value localstorage 저장
     *

     * @param String key	 : 저장 key
     * @param String value	 : 저장될값
     * @param String expires : 저장기간
     * EX:
     COMMONJS.setStorage(GLOBAL_CONF.USERKEY+'-01',value,86400*30);//로컬 스토리지 유효기간 30일
     ****************************************************************/
    setStorage: function (key, value, expires) {

        if (expires===undefined || expires===null) {
            expires = (24*60*60);  // default: seconds for 1 day
        } else {
            expires = Math.abs(expires); //make sure it's positive
        }

        var now = Date.now();  //millisecs since epoch time, lets deal only with integer
        var schedule = now + expires*1000;
        try {
            localStorage.setItem(key, value);
            localStorage.setItem(key + '_expiresIn', schedule);
        } catch(e) {
            console.log('setStorage: Error setting key ['+ key + '] in localStorage: ' + JSON.stringify(e) );
            return false;
        }
        return true;

    }
    , numberFormat : function( pValue, fixed ){
        if(fixed) {
            return Number(pValue).toFixed(fixed).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        } else {
            return Number(pValue).toFixed().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
    }

    , nvl : function(pStr) {
        return this.nvl2(pStr, '');
    }

    , nvl2 : function(pStr, pDefault) {
        var vResult = '';
        if (pStr == undefined || pStr == null || pStr === '') {
            if (pDefault == undefined || pDefault == null) {
                vResult = '';
            } else {
                vResult = pDefault;
            }
        } else {
            vResult = pStr;
        }
        return vResult;
    }
    , isEmpty : function(value){
        if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){
            return true
        }else{
            return false
        }
    }
    ,isNotEmpty : function(value){
        if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){
            return false
        }else{
            return true
        }
    }
    ,groupBy : function(xs, key) {
        let _this = this;
        return xs.reduce(function(rv, x) {
            if ( _this.isNotEmpty(x[key]) ){
                (rv[x[key]] = rv[x[key]] || []).push(x);
            }
            return rv;
        }, {});
    }
};






