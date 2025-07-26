
$(function(){
	commonInit();
});
function commonInit() {

	/*gnb open test
	now = 1;
	gnbOpen();*/

	var gnb = $("#gnb");

	gnb.on('mouseenter', function(){
		setTimeout(gnbOpen, 100);
		now = 1;
		var gnbH = gnb.find('.gnb1Depth').outerHeight();
		gnb.css({'height':gnbH+'px'});
		console.log(gnbH)
	}).on('mouseleave', function(){
		setTimeout(gnbOpen, 200);
		now = 0;
		var gnbMinH = gnb.find('.gnb1Depth > li > a').outerHeight();
		gnb.css({'height':gnbMinH+'px'}).find('li').removeClass('hover');
	});

	gnb.find('li a').focus(function(){
		setTimeout(gnbOpen, 100);
		now = 1;
		var gnbH = gnb.find('.gnb1Depth').outerHeight();
		gnb.css({'height':gnbH+'px'});
	}).blur(function(){
		setTimeout(gnbOpen, 200);
		now = 0;
		var gnbMinH = gnb.find('.gnb1Depth > li > a').outerHeight();
		gnb.css({'height':gnbMinH+'px'});
	});

	gnb.find('li > a').on('mouseenter', function(){
		$(this).parent().addClass('hover').siblings().removeClass('hover');
	});

	//2depth이하
	gnb.find('.gnb2Depth').each(function(i){
		$(this).find('a').on('mouseenter', function(){
			$(this).parent().addClass('hover');
			$(this).parents('li').addClass('hover').siblings().removeClass('hover');
		});
	});

	//top 이동
	$('body').append('<a href="#" class="btn-topmove btnTOPMove">Go To Top</a>');
	$('.btnTOPMove').on('click', function () {
		$('html, body').animate({scrollTop: 0}, 200);
		return false;
	});

	//날짜
	$.datepicker.setDefaults({//datepicker 공통설정
		dateFormat: 'yy-mm-dd'
	});
	if ( $('.datepicker').length > 0 ) {
		$(".datepicker").each(function(){
			$(this).datepicker({});
		});
	}

	if ( $('.monthpicker').length > 0 ) {
		$(".monthpicker").each(function(){
			$(this).monthpicker({pattern: 'yyyy-mm'});
		});
	}
	
	//textarea 대체 textarea-div
	if ( $('.textareabox').length > 0 ) {
		$('.textareabox').each(function(){
			var textareabox = $(this);
			var textarea = textareabox.find('.textarea-div');
			textarea.on('focusin', function(){
				textareabox.addClass('active');
			}).on('focusout', function(){
				textareabox.removeClass('active');
			});
			if ( textarea.attr('contenteditable') === "false" ) {//contenteditable 속성이 false 일때(입력불가능)
				textareabox.addClass('disabled');
			}
			
			textareabox.find(".scrollY").each(function(){
				$(this).mCustomScrollbar();
			});
		});
	}

	$(window).on('resize', function(){

		$('.popup-wrap').each(function(){
			if( $(this).is(':visible') ) {
				var pop = $(this).find('.popup');
				pop.css({'height':'auto'});
				pop.find('.popcont-box').css({'height':'auto'});
				var borwHeight = $(window).height();
				var popHeight = pop.outerHeight();
				var popHeadHeight = pop.find('.pop-head').outerHeight();
				var popFootBtnHeight = pop.find('.popbtn-box').outerHeight();
				if ( pop.hasClass('no-footbtn') ) { popFootBtnHeight = 0; }
				var borPerHeight = Math.ceil(borwHeight*6/100);
				var popMaxHeight = Number((borwHeight-borPerHeight));
				var popWidth = pop.outerWidth();
				var popWidthHalf = popWidth/2;
				var minusHeight = 70 + popFootBtnHeight;//116;
				if ( pop.hasClass('admin-popup') ) { minusHeight = 30 + popFootBtnHeight; }
				if ( pop.hasClass('system') ) {
					//console.log('system');
				}
				if ( !$(this).hasClass('windowtype') ) {
					if ( popHeight >= popMaxHeight ) {
						if ( borwHeight < 400 ) {
							pop.removeAttr('style').addClass('position-r');
							//pop.find('.popcont-box').removeAttr('style');
							pop.find('.popcont-box').css({'height':'auto'});
						} else {
							pop.removeClass('position-r').css({'margin-top':(-(popMaxHeight/2))+'px','height':popMaxHeight+'px'});
							pop.find('.popcont-box').css({'height':((popMaxHeight-popHeadHeight)-minusHeight)+'px'}).mCustomScrollbar({});
							//pop.find('.popcont-box').css({'height':((popMaxHeight-popHeadHeight)-minusHeight)+'px'});
						}
					} else {
						pop.removeClass('position-r').css({'margin-top':(-(popHeight/2))+'px'});
						pop.find('.popcont-box').css({'height':((popHeight-popHeadHeight)-minusHeight)+'px'}).mCustomScrollbar({});
						//pop.find('.popcont-box').css({'height':((popHeight-popHeadHeight)-minusHeight)+'px'});
					}

					if ( $(this).hasClass('has-inpopup') ) {
						if ( $(this).hasClass('has-catePop') ) {

						}
					} else {
						pop.css({'margin-left':(-popWidthHalf)+'px'});
					}
				}
			}
		});
	});

	$(window).on('scroll', function () {
		if ($(this).scrollTop() > 100) {
			$('.btnTOPMove').addClass('show');//.fadeIn(500);
		} else {
			$('.btnTOPMove').removeClass('show');//.fadeOut('slow');
		}
	});

}

/*gnb */
function gnbOpen(){
	var gnbH = $('#gnb .gnb1Depth').outerHeight();
	var minuH = 64;
	if( now == 1 ){
		$('#gnb').addClass('open');
	} else {
		gnbH = 0;
		$('#gnb').removeClass('open');
	}
}

// 탭_open
function commonTab( tabWrap, tab, tabDiv, openIdx, onStats ){//onStats : click, hover

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
		setTimeout(function(){
			$tabCont.eq(nIdx).show();
		}, 0);
	} else {
		$tabCont.eq(nIdx).show();
	}

	$tabLi.parent().removeClass('on');
	$tabLi.eq(nIdx).parent().addClass('on');
}

/*popup*/
function popupLayer(id){
	$('.popup-wrap').each(function(){
	 	if( $(this).css('display') == 'block' ) {
	 		$(this).css('z-index','10');
	 	} else {
	 		$(this).css('z-index','');
	 	}
	 })
	$(id).css({'display':'block','z-index':'11'});

	var pop = $(id).find('.popup');
	pop.css({'height':'auto'});
	pop.find('.popcont-box').css({'height':'auto'});
	var borwHeight = $(window).height();
	var popHeight = pop.outerHeight();
	var popHeadHeight = pop.find('.pop-head').outerHeight();
	var popFootBtnHeight = pop.find('.popbtn-box').outerHeight();
	if ( pop.hasClass('no-footbtn') ) { popFootBtnHeight = 0; }
	var borPerHeight = Math.ceil(borwHeight*6/100);
	var popMaxHeight = Number((borwHeight-borPerHeight));
	var popWidth = pop.outerWidth();
	var popWidthHalf = popWidth/2;
	var minusHeight = 70 + popFootBtnHeight;//116;
	if ( pop.hasClass('admin-popup') ) { minusHeight = 20 + popFootBtnHeight; }
	if ( pop.hasClass('system') ) {
		//console.log('system');
	}
	if ( !$(id).hasClass('windowtype') ) {
		if ( popHeight >= popMaxHeight ) {
			if ( borwHeight < 400 ) {
				pop.removeAttr('style').addClass('position-r');
				//pop.find('.popcont-box').removeAttr('style');
				pop.find('.popcont-box').css({'height':'auto'});
			} else {
				pop.removeClass('position-r').css({'margin-top':(-(popMaxHeight/2))+'px','height':popMaxHeight+'px'});
				pop.find('.popcont-box').css({'height':((popMaxHeight-popHeadHeight)-minusHeight)+'px'}).mCustomScrollbar({scrollbarPosition:"outside"});
				//pop.find('.popcont-box').css({'height':((popMaxHeight-popHeadHeight)-minusHeight)+'px'});
			}
		} else {
			pop.removeClass('position-r').css({'margin-top':(-(popHeight/2))+'px'});
			pop.find('.popcont-box').css({'height':((popHeight-popHeadHeight)-minusHeight)+'px'}).mCustomScrollbar({scrollbarPosition:"outside"});
			//pop.find('.popcont-box').css({'height':((popHeight-popHeadHeight)-minusHeight)+'px'});
		}

		if ( $(id).hasClass('has-inpopup') ) {
			if ( $(id).hasClass('has-catePop') ) {

			}
		} else {
			pop.css({'margin-left':(-popWidthHalf)+'px'});
		}
	}
}

/*link more*/
function linkMore(obj) {
	var myTxt = $(obj).parents('.link').find('.txt');
	if ( $(obj).parents('.link').hasClass('allView') ) {
		$(obj).text('more').parents('.link').removeClass('allView');
		myTxt.removeClass('overLink');
	} else {
		$(obj).text('less').parents('.link').addClass('allView');
		var myTxtH = myTxt.height();
		if ( myTxtH > 41 ) { myTxt.addClass('overLink'); }	
	}
	return false;
}