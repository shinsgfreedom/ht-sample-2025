<%@ page contentType="text/html;charset=UTF-8" language="java" %>


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