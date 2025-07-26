$(function(){
	commonInit();
	windowPopIs(); //window팝업인경우 대응
	valClearKeyup();//(input keyup시 clear 보이게, clear클릭시 val 삭제 및 focus)
	
	$('body').append('<div class="tooltip-wrap" ttname="Tooltip"><div class="textbox"></div></div>');//tooltip 생성
	tooltipSet();//tooltip 실행

	$(window).on('resize', function(){
		$('.popup-wrap:not(.windowtype)').each(function(){
			if($(this).css('display') == 'block') {
				myResizeId = $(this).attr('id');
				popupLayer('#'+myResizeId);
			}
		});
		tooltipSet();//tooltip 재실행
	});
	// $(".datepicker").datepicker();
	// $(".calForm input").datepicker();

	setFocusIVSelect();
	customSelect.init();
});

function commonInit() {
	// GNB Click
	$('#header .btnGnb').on('click', function() {
		$('#header').addClass('open');
		tooltipAllHide();
	});
	$('#header .btnGnbClose').on('click', function() {
		$('#header').removeClass('open');
		tooltipAllHide();
	});

	//GNB Hover
	$('#header #gnb').on('mouseenter', function() {
		$('#header').addClass('open');
		tooltipAllHide();
	});
	$('#header').on('mouseleave', function() {
		$('#header').removeClass('open');
		tooltipAllHide();
	});

	//GNB Search
	$('#header .btnSearch').on('click', function() {
		$(this).toggleClass('on');
		$('#header .searchbox').toggleClass('open');
		if ( $('#header .searchbox').hasClass('on') ) {
			$('.tooltip-wrap').each(function() {
				if ($(this).hasClass('hide')) {
					$(this).removeClass('hide');
				}
			});
		} else {
			$('.tooltip-wrap').each(function() {
				if ($(this).css('display') === 'block') {
					$(this).addClass('hide');
				} else {
					$(this).removeClass('hide');
				}
			});
		}
	});

	// LNB
	setLnb();

	//top 생성
	$('body').append('<a href="#" class="btn-topmove btnTOPMove"><span>TOP</span></a>');
	$('.btnTOPMove').on('click', function () {
		$('html, body').animate({scrollTop: 0}, 200);
		return false;
	});

	//다국어 (로그인포함 언어선택관련 동일)
	$('.lang-selList').each(function(){
		var langListbox = $(this);
		var langBtn = langListbox.find('.lang-sel .lang');
		langBtn.on('click', function(){
			langListbox.addClass('open');
			langListbox.find('.lang-list').css({'max-height':'352px'});
			return false;
		});
	});

	//셀렉트타입의 div형식
	if ( $('.selectbox').length > 0 ) {
		$('.selectbox').each(function(){
			var $selectbox = $(this);
			var $selecLabel = $(this).find('.select-label');
			//var $selectDiv = $(this).find('.select-div');
			$selecLabel.on('click', function(){
				if ( $selectbox.hasClass('open') ) {
					$selectbox.removeClass('open');
				} else {
					$selectbox.addClass('open');
				}
				return false;//20201215 추가
			});
		});
	}

	$(window).on('scroll', function () {
		if ($(this).scrollTop() > 100) {
			$('.btnTOPMove').addClass('show');
		} else {
			$('.btnTOPMove').removeClass('show');
		}
	});

	$(document).click(function(e){ // 화면 클릭시 open클래스를 가진 태그 닫음.
		// if ($(e.target).hasClass('btn-del')) return;
		commonRemove('#header .searchbox', e);
		commonRemove('#wrap-login .lang-selList', e);//로그인 언어선택 닫기 추가
		commonRemove('.inForm-box', e);
		commonRemove('.selectbox',e);//20201204 select기능의 div형식 닫기
		commonRemove('.focusIV-box',e);//20201116 추가
		commonRemove('.btnMorbox',e);//20230207 추가
	});

	//quick link
	shSlideUpDown ( '#quickLeft', '.btn-sh1', '.quicklink-list' );
	shSlideUpDown ( '#quickRight', '.btn-sh1', '.quickmenu-list' );

	//top 이동
	$('#quickRight .btnTop').on('click', function () {
		$('html, body').animate({scrollTop: 0}, 200);
		return false;
	});
	

	//상단 검색
	var $topSearchbox = $('#header .searchbox');
	var $topSearchInput = $topSearchbox.find('.inputbox .input');
	$topSearchInput.focus(function(){
		$topSearchbox.addClass('open');
	});
	$topSearchbox.focusout(function(){
		setTimeout(function() {
			$topSearchbox.removeClass('open');
		}, 300);
	});


    //lnb show/hide
    $('.cont-lc-area .lc-leftbox .btnLC').on('click', function(){
        if ( $('.cont-lc-area').hasClass('leftHide') ) {
            $('.cont-lc-area').removeClass('leftHide');
            $(this).text('open');
        } else {
            $('.cont-lc-area').addClass('leftHide');
            $(this).text('close');
        }
    });

    $('.cont-lc-area .lc-leftbox .btnLCFix').on('click', function(){
        $('.cont-lc-area').addClass('leftHideFix');
    });

    //lnb toggle show/hide
    $('.lnb-list .toggle').off('click', activeLnb).on('click', activeLnb);

}

function activeLnb() {
    if ($(this).hasClass('on')) {
        $(this).removeClass('on').parent('li').removeClass('on');
    } else {
        $(this).addClass('on').parent('li').addClass('on');
    }
    
    contH();
    return false;
}

function commonRemove(trg, e) {
	var $trg = $(trg);

	// 개발에서 요소를 지운 후에 이 코드를 타서 생기는 버그 때문에 추가
	/*if ($(e.target).closest('.btn-del').length && $trg.hasClass('focusIV-box')) {
		return;
	}*/

	if ($trg.hasClass("open")) {
		if (!$trg.has(e.target).length) {
			/*if ($trg.hasClass('btn-group')) {
				removeTooltip();
			}*/

			$trg.removeClass("open");
		}
	}
}

// 단독 slide
function shSlideUpDown2 ( shWrap, shBtn, shTarget ) {
	var $shWarp = $(shWrap);

	$shWarp.each(function(){
		var $shThisBtn = $(this).find(shBtn);
		 $shThisBtn.off('click').on('click', function(){
			var $shTraget = $(this).closest(shWrap).find(shTarget);

			$('.open').removeClass('open');
			if ( $(this).hasClass('on') ) {
				$(this).removeClass('on').addClass('off');
				$shTraget.slideUp(300);
			} else {
				$(this).removeClass('off').addClass('on');
				$shTraget.slideDown(300);
			}
			return false;
		});
	});
}

// 탭_open
function commonTab( tabWrap, tab, tabDiv, openIdx, onStats ){ // onStats : click, hover
	if( !openIdx ){
		openIdx = 0;
	}

	triggerTab( tabWrap, tab, tabDiv, openIdx, onStats );

	$(document).on(onStats, tabWrap + ' ' + tab + ' .tag', function(){
		var nIdx = $(tabWrap + ' ' + tab + ' .tag ').index(this);
		triggerTab( tabWrap, tab, tabDiv, nIdx, onStats );
		//return false;
		if ( onStats == 'click' ) {
			return false;
		}
	});
}

// 탭_trigger
function triggerTab( tabWrap, tab, tabDiv, nIdx, onStats ){
	var $tabWrap = $(tabWrap);
	var $tabLi = $tabWrap.find(tab + ' .tag');
	var $tabCont = $tabWrap.find(tabDiv);

	$tabCont.hide();
	
	if ( onStats == 'click' ) {
		$tabCont.eq(nIdx).show();
	} else {
		$tabCont.eq(nIdx).show();
	}

	$tabLi.parent().removeClass('on');
	$tabLi.eq(nIdx).parent().addClass('on');
}

function popupLayer(id){
	$('.popup-wrap').each(function(){
	 	if($(this).css('display') == 'flex') {
	 		$(this).css('z-index','10');
	 	} else {
	 		$(this).css('z-index','');
	 	}
	 });

	var $popWrap = $(id);
	var $pop = $(id).find('.popup');
	
	if ($popWrap.hasClass('windowtype')) {
	} else if ($popWrap.hasClass('popup-FR-wrap')) {
		$popWrap.addClass('popOpen').css({'z-index':'15'});
	} else if ($popWrap.hasClass('popup-FL-wrap')) {
		$popWrap.addClass('popOpen').css({'z-index':'15'});
	} else {
		$popWrap.css({'display':'flex','z-index':'15'});
	}

	var popHeadHeight = $pop.find('.pop-head').outerHeight();
	var popFootHeight = $pop.find('.pop-foot').outerHeight();
	
	if ($pop.find('.pop-head').length < 1) { popHeadHeight = 0; $pop.addClass('no-head');}
	if ($pop.find('.pop-foot').length < 1) { popFootHeight = 0; $pop.addClass('no-foot');}

	if ($popWrap.hasClass('popup-FR-wrap')) { 
	} else if ($popWrap.hasClass('popup-FL-wrap')) {
	} else if ($popWrap.hasClass('map')) {
	} else {
		setPosLayer($popWrap)
	}
}

var popFlag = false;

function setPosLayer(pop) {
	var $popWrap = pop;
	var $pop = $popWrap.find('.popup');
	var $popCont = $pop.find('.pop-cont');

	var borwWidth = $(window).width();
	var borwHeight = $(window).height();
	var popWidth = $pop.outerWidth();
	var popHeight = $pop.outerHeight();

	var headHeight = $('.pop-head').outerHeight() ? $('.pop-head').outerHeight() : 0;
	var footHeight = $('.pop-foot').outerHeight() ? $('.pop-foot').outerHeight() : 0;

	/*$popCont.css({
		'max-height': borwHeight - (headHeight + footHeight + 120) + 'px',
	});*/

	// if (!popFlag) {
	// 	$popCont.mCustomScrollbar({scrollbarPosition:"outside"});

	// 	popFlag = true;
	// } else {
	// 	$popCont.mCustomScrollbar('destroy');
	// 	$popCont.mCustomScrollbar({scrollbarPosition:"outside"});
	// }
	
	//var popHeight = $pop.outerHeight();
	//$pop.css({'margin-top':(-(popHeight/2))+'px'});
}

/*window type 팝업*/
function windowPopIs() {
	if ( $('.popup-wrap.windowtype').length > 0 ) {
		$('html').addClass('windowPopupHtml');
		if ( $('.pop-foot').length > 0 ) {
			$('.popup-wrap.windowtype').removeClass('no-footbtn');
		} else {
			$('.popup-wrap.windowtype').addClass('no-footbtn');
		}
		if ( $('.pop-head').length > 0 ) {
			$('.popup-wrap.windowtype').removeClass('no-head');
		} else {
			$('.popup-wrap.windowtype').addClass('no-head');
		}
	}
}

function setLnb() {
	var $leftBox = $('.cont-lc-area .lc-leftbox');
	$leftBox.addClass('collapse');//초기값 : 닫기

	$leftBox.find('.btn-lc').off('click').on('click', function() {
		if (!$leftBox.hasClass('collapse')) {
			$leftBox.addClass('collapse');
		} else {
			$leftBox.removeClass('collapse');
		}
	});
}

function valClearKeyup () {
	if ( $("[class*='inForm-'] .input").val() == "" ) {//val값이 없는경우
		$("[class*='inForm-'] .clear").hide();
	}

	$(document).on("focusin", "[class*='inForm-'] .input", function(){//focus in/out val값에 따라
		if ( !$(this).val() == "" ) {
			var myClosestHeight = $(this).closest("[class*='inForm-']").outerHeight(true);
			$(this).each(function(){
				$(this).closest("[class*='inForm-']").addClass('open').find('.inFormIn-inView').css({'top':myClosestHeight+'px'});
			});
		}
	}).on("click", "[class*='inFormIn-'] .link", function(){
		$(this).closest("[class*='inForm-']").removeClass('open');
	});

	$(document).on("keyup", "[class*='inForm-'] .input", function(){//input keyup
		var myClosestHeight = $(this).closest("[class*='inForm-']").outerHeight(true);
		if ( $(this).val() == "" ) {
			$(this).next('.clear').hide();
			$(this).closest("[class*='inForm-']").removeClass('open');
		} else {
			$(this).next('.clear').show();
			$(this).closest("[class*='inForm-']").addClass('open').find('.inFormIn-inView').css({'top':myClosestHeight+'px'});
		}
	});
	$(document).on("click", "[class*='inForm-'] .clear:not([onclick])", function(){
		$(this).prev('.input').val('').focus();
		$(this).hide();
		$(this).closest("[class*='inForm-']").removeClass('open');
		return false;
	});
	$(document).on("focus", "*:not([class*='ag-theme']) [class*='inForm-'] > *:not([class*='btn'])", function(){
		$(this).closest("[class*='inForm-']").addClass('focus');
	}).on("focusout", "*:not([class*='ag-theme']) [class*='inForm-'] > *:not([class*='btn'])", function(){
		$(this).closest("[class*='inForm-']").removeClass('focus');
	});
}

//tooltip
function tooltipSet() {
	var windowW = $(window).width(), windowH = $(window).height();
	$('[tooltipname]').each(function(){
		var $myBtn = $(this), myTitle = $myBtn.attr('tooltipname'), btnH = $myBtn.outerHeight(), btnW = $myBtn.outerWidth();
		var btnTop = $myBtn.offset().top, btnLeft = $myBtn.offset().left;
		$myBtn.mouseover(function(){
			//$('body').append('<div class="tooltip-wrap" ttname="'+myTitle+'Tooltip"><div class="textbox">'+myTitle+'</div></div>');
			$('.tooltip-wrap').attr({'ttname':myTitle+'Tooltip'}).find('.textbox').text(myTitle);
			$('[ttname="'+myTitle+'Tooltip"]').css({'postion':'fixed','display':'block'});
			var myTooltipW = $('[ttname="'+myTitle+'Tooltip"]').outerWidth();   
			if ( (btnLeft + myTooltipW) >= windowW ) {   
				$('[ttname="'+myTitle+'Tooltip"]').css({'left':Number(btnLeft - (myTooltipW-btnW))+'px'});
			} else {
				$('[ttname="'+myTitle+'Tooltip"]').css({'left':btnLeft+'px'});
			}
			if ( (btnTop + btnH) >= windowH ) {
				$('[ttname="'+myTitle+'Tooltip"]').css({'top':Number(btnTop-btnH)+'px'});
			} else {
				$('[ttname="'+myTitle+'Tooltip"]').css({'top':Number(btnTop+btnH)+'px'});
			}
		}).mouseout(function(){
			$('[ttname="'+myTitle+'Tooltip"]').hide();
		});
	});
}

//tooltip
function tooltipShow(btnName, viewName, alignName, verticalName) {
	//alignName : left/right/center/left end/right end(alignName값이 전달되지 않았을 경우 left, right 위치를 자동으로 계산)
	//verticalName : top/middle/bottom
	var windowW = $(window).width(), windowH = $(window).height(), btnH = $(btnName).outerHeight(), btnW = $(btnName).outerWidth();
	var btnNameTop = $(btnName)[0].getBoundingClientRect().top, btnNameLeft = $(btnName)[0].getBoundingClientRect().left;
	var $ttname = $('[ttname="'+viewName+'"]');
	var alignArr = alignName ? alignName.split(' ') : '';

	$ttname.show();

	var viewNameW = $ttname.outerWidth();
	var viewNameH = $ttname.outerHeight();

	var myLeft = 0;
	var myTop = 0;

	//좌우
	if (alignArr[0] === "center") {
		$ttname.css({'left':((btnNameLeft+(btnW/2))-(viewNameW/2))+'px'}).addClass('arrowC');
	} else if (alignArr[0] === "right" || (btnNameLeft >= (windowW/2) && alignArr[0] !== "left")) {
		if (alignArr[1] === "end") {
			myLeft = btnNameLeft-viewNameW-4;
		} else {
			myLeft = (btnNameLeft+btnW)-viewNameW;
		}
		$ttname.addClass('arrowR');
	} else {	
		if (alignArr[1] === "end") {
			myLeft = btnNameLeft+btnW+4;
		} else {
			myLeft = btnNameLeft;
		}
		$ttname.addClass('arrowL');
	}
	$ttname.css({'left':myLeft+'px'}).addClass('arrowL');

	//상하
	if (verticalName === "middle") {
		myTop = btnNameTop+(btnH/2)-(viewNameH/2);
	} else if (verticalName === "top") {
		myTop = btnNameTop-viewNameH;
	} else {
		if (btnH < 25) {
			myTop = btnNameTop+(btnH+5);
		} else {
			myTop = btnNameTop+btnH;
		}
	}

	$ttname.css({'top':myTop+'px'});

	return false;
}

function tooltipAllHide() {
	$('.tooltip-wrap').each(function(){
		$(this).hide();
	})
}


function setFocusIVSelect() {
	$('.focusIV-box').each(function(){
		var $focusIVBox = $(this);
		var $focusIVInput =	$focusIVBox.find('.focusIV-input');
		var $focusIVView = $focusIVBox.find('.focusIV-view');

		if ($focusIVInput.val().length > 0) {
			$(this).find('.btn').hide();
			$(this).find('.has-clear .clear').css({
				'display': 'inline-block',
				'right': '4px',
			});
		}

		$focusIVInput.on('click', function(){
			$('.focusIV-box').removeClass('open');
			$focusIVBox.addClass('open');
		});

		$focusIVInput.on('change', function(){
			if ($focusIVInput.val().length > 0) {
				if ($(this).closest('.insearch-box').length > 0) {
					$focusIVBox.find('.btn').hide();
				}
				
				$focusIVBox.find('.has-clear .clear').css({
					'display': 'inline-block',
					'right': '4px',
				});
			}
		});
	});
}



// 유기적 slide
function shSlideUpDown ( shWrap, shBtn, shTarget, shNowOpen ) {//20210127 (shNowOpen : 클릭한 곳만 열리는 타입)
	var $shWarp = $(shWrap);
	$shWarp.each(function(){
		var $shBtn = $shWarp.find(shBtn), $shTarget = $shWarp.find(shTarget);
		var $shThisBtn = $(this).find(shBtn), $shThisTarget = $(this).find(shTarget);
		 $shThisBtn.on('click', function(){
			// $('.open').removeClass('open');
			if ( $shThisBtn.hasClass('on') ) {
				$shThisBtn.removeClass('on').addClass('off');
				$shThisTarget.slideUp();
			} else {
				if ( shNowOpen = 'shNowOpen' ) {
					$shBtn.removeClass('on').addClass('off');
					$shTarget.slideUp();
				}
				$shThisBtn.removeClass('off').addClass('on');
				$shThisTarget.slideDown();
			}
			return false;
		});
	});
}

const tabBoxJS = function(num){
	const _target = $(document).find(".tabBoxJS");
	_target.each(function(){
		const _btn = $(this).find(".cont-tabBtn .item");
		const _con = $(this).find(".cont-tabCon");
		_btn.removeClass("on").eq(num-1).addClass("on");
		_con.removeClass("on").eq(num-1).addClass("on");
	});
}

const slideListSelectJS = {
	init : function(_this){
        const _target = $(".slideListSelectJS."+_this);
        if(!_target.hasClass("js")){
            // const _this = $(this);
            const _total = _target.find(".slide-con .item").length;
			const _page = _target.find(".control-page");
			let _pageNum = '';
			for(let i=0;i<_total;i++){
				_pageNum += "<button type=\"button\" class=\"num\" onclick=\"slideListSelectJS.quick('"+_this+"',"+(i+1)+")\">"+(i+1)+"</button>";
			}
			_page.html(_pageNum);
            _target.find(".control-box p").html("<strong>1</strong> / "+_total);
            _target.find(".slide-con > ul").width(_total*100+"%");
            _target.find(".slide-con .item").eq(0).addClass("on");
            _target.find(".control-page .num").eq(0).addClass("on");
            const _btn = _target.find(".control-btn button");
            // slideListSelectJS.ck(_target);
            _btn.on("click",function(){
                slideListSelectJS.mov(_target,$(this).attr("class").split("-")[1]);
            });
        }
        _target.addClass("js");
	},
    mov : function(_this,_mov){
        const _item = _this.find(".slide-con .item");
        const _active = _this.find(".slide-con .item.on");
        const _ul = _this.find(".slide-con > ul");
        const _total = _this.find(".slide-con .item").length;
        const _indexNum = _active.index();
		const _page = _this.find(".control-page .num");
        const _list = _this.find(".list-box .list");
        _item.removeClass("on");
		_page.removeClass("on");
		_list.find(".item").removeClass("on");
		let _prev = 0;
		let _next = 0;
		if(_indexNum == 0){
			_prev = _total-1;
        }else{
			_prev = _indexNum-1;
		}
		if(_indexNum == _total-1){
            _next = 0;
        }else{
			_next = _indexNum+1;
		}
        
        if(_mov == "prev"){
            _ul.animate({"left":(_prev*100)*-1+"%"},500);
            _item.eq(_prev).addClass("on");
			_page.eq(_prev).addClass("on");
			_list.eq(_prev).find(".item").addClass("on");
        }else if(_mov == "next"){
            _ul.animate({"left":(_next*100)*-1+"%"},500);
            _item.eq(_next).addClass("on");
			_page.eq(_next).addClass("on");
			_list.eq(_next).find(".item").addClass("on");
        }
        // slideListSelectJS.ck(_this);
    },
    ck : function(_this){
        const _item = _this.find(".slide-con .item.on");
        const _btnL = _this.find(".control-btn .btn-prev");
        const _btnR = _this.find(".control-btn .btn-next");
        const _indexNum = _item.index();
        const _total = _this.find(".slide-con .item").length;
        const _thisNum = _this.find(".control-box p strong");
        const _btn = _this.find(".control-btn button");
        _thisNum.html(_indexNum+1);
        _btn.prop("disabled",false);
        if(0 == _total-1){
            _btn.prop("disabled",true);
        }else if(_indexNum == 0){
            _btnL.prop("disabled",true);
        }else if(_indexNum == _total-1){
            _btnR.prop("disabled",true);
        }
    },
	quick : function(_this, num){
		// event.preventDefault();
		const _target = $(".slideListSelectJS."+_this);
        const _ul = _target.find(".slide-con > ul");
        const _item = _target.find(".slide-con .item");
		const _page = _target.find(".control-page .num");
        const _list = _target.find(".list-box .list");
		_ul.animate({"left":(((num-1))*100)*-1+"%"},500);
        _item.removeClass("on").eq(num-1).addClass("on");
		_page.removeClass("on").eq(num-1).addClass("on");
		_list.find(".item").removeClass("on");
		_list.eq(num-1).find(".item").addClass("on");
	}
}

const imgFit = function(_target,_type){
    _target.each(function(){
        const _box = $(this);
        const _img = $(this).find("img");
        // _img.removeClass("fitW").removeClass("fitH").removeClass("fitN");
		const _isW = _img.hasClass("fitW");
		const _isH = _img.hasClass("fitH");
		const _isN = _img.hasClass("fitN");
		// console.log(">>> _isW : ",_isW);
		// console.log(">>> _isH : ",_isH);
		// console.log(">>> _isN : ",_isN);
		if(_img.length > 0 && !_isW && !_isH && !_isN){
			const _boxW = _box.width();
			const _boxH = _box.height();
			const _naturalImgW = _img[0].naturalWidth;
			const _naturalImgH = _img[0].naturalHeight;
			const _imgH = _img.height();
			// console.log(">>> _img : ",_img);
			// console.log(">>> _boxW : ",_boxW);
			// console.log(">>> _boxH : ",_boxH);
			// console.log(">>> _naturalImgW : ",_naturalImgW);
			// console.log(">>> _naturalImgH : ",_naturalImgH);
			// console.log(">>> _imgH : ",_imgH);
			if(_imgH == 0){

			}else if(_boxW > _naturalImgW && _boxH > _naturalImgH){
				_img.addClass("fitN");
			}else if(_boxH <= _imgH){
				_type == "in" ? _img.addClass("fitH") : _img.addClass("fitW");
			}else if(_boxH > _imgH){
				_type == "in" ? _img.addClass("fitW") : _img.addClass("fitH");
			}
		}
    });
}
			
function openPopup() {
	$('.inner-popup.sales-group').addClass('open');
}

function closePopup(popEl) {
	$(popEl).closest('.inner-popup.sales-group').removeClass('open');
}
			
function openPopup2() {
	$('.inner-popup.business-card').addClass('open');
}

function closePopup2(popEl) {
	$(popEl).closest('.inner-popup.business-card').removeClass('open');
}

var customSelect = {
	init: function() {
		this.ele = {
			selectWrap: $('.custom-select'),
		};

		this.setElements();
		this.bindEvents();
	},
	setElements: function() {
		this.selector = {
			selectWrap: '.custom-select',
			selectList: '.select-list',
			selectScroll: '.scroll-area',
			selectItem: '.selected-item',
			selectedVal: '.selected-val',
			list: '.list',
			activeCls: 'active',
			openCls: 'open',
		};

		this.ele.selectList = this.ele.selectWrap.find(this.selector.selectList);
		this.ele.selectScroll = this.ele.selectList.find(this.selector.selectScroll);
		this.ele.selectListItem = this.ele.selectWrap.find(this.selector.list);
		this.ele.selectedItem = this.ele.selectWrap.find(this.selector.selectItem);
	},
	bindEvents: function() {
		var my = this;

		this.ele.selectedItem.on('click', function() {
			my.toggleSelect($(this));
		});

		this.ele.selectListItem.on('click', function() {
			my.activeItem($(this));
		});
	},
	toggleSelect: function(mySelect) {
		var $select = mySelect.closest(this.selector.selectWrap);

		if (!$select.hasClass(this.selector.openCls)) {
			this.openSelect($select);
		} else {
			this.closeSelect($select);
		}
	},
	openSelect: function(mySelect) {
		var my = this;
		this.closeAllSelect();

		mySelect.addClass(this.selector.openCls);
		mySelect.find(this.selector.selectList).css({
			'z-index': '13',
		}).slideDown(100, function() {
			mySelect.find(my.selector.selectScroll).mCustomScrollbar();
		});
	},
	closeSelect: function(mySelect) {
		var my = this;

		mySelect.removeClass(this.selector.openCls);
		mySelect.find(this.selector.selectList).css({
			'z-index': '',
		}).slideUp(100);
		mySelect.find(this.selector.selectScroll).mCustomScrollbar("destroy");
	},
	closeAllSelect: function() {
		var my = this;

		this.ele.selectWrap.removeClass(this.selector.openCls);
		this.ele.selectList.css({
			'z-index': '',
		}).slideUp(100);
		this.ele.selectScroll.mCustomScrollbar("destroy");
	},
	activeItem: function(myItem) {
		var selectTxt = myItem.text();
		var $mySelect = myItem.closest(this.selector.selectWrap);

		$mySelect.find(this.selector.list).removeClass(this.selector.activeCls);

		myItem.addClass(this.selector.activeCls);
		$mySelect.find(this.selector.selectedVal).text(selectTxt);

		this.closeSelect($mySelect);
	}
};

const printArea = function(areaID,orientation){
	var printContent = document.getElementById(areaID).innerHTML;
    var originalContent = document.body.innerHTML;
    document.body.innerHTML = "<style>@page { size:"+orientation+"} .pdf-box{ width: 100%; zoom: 0.6;}</style>"+printContent;
    window.print();
    document.body.innerHTML = originalContent;
}


var SCREEN_SCALE_SAVE = {
	data : {
		key : 'SCALE_21232F297A57A5A743894A0E4A801FC3',
		scale : 1
	},
	init : function() {
		var scaleData = localStorage.getItem(this.data.key);
		//console.log('scaleData', scaleData)
		if(scaleData == null || scaleData == '') {
			this.data.scale = 1;
		} else {
			this.data.scale = scaleData * 1;
			this.zoom();
		}
	},
	scaleIn : function(event) {
		event.stopPropagation();
		this.data.scale *= 1.05;
		this.zoom();
	},
	scaleOut : function(event) {
		event.stopPropagation();
		this.data.scale /= 1.05;
		this.zoom();
	},
	scaleDefault : function(event) {
		event.stopPropagation();
		this.data.scale = 1;
		this.zoom();
	},
	zoom : function() {
		var body = document.body;
		body.style.zoom = this.data.scale;
		body.style.mozTransform = 'scale('+this.data.scale+')';
		body.style.oTransform = 'scale('+this.data.scale+')';
		localStorage.removeItem(this.data.key);
		localStorage.setItem(this.data.key, this.data.scale, 86400*90);
	}
}
SCREEN_SCALE_SAVE.init();
window.SCREEN_SCALE_SAVE = SCREEN_SCALE_SAVE;