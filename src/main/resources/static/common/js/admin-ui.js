
$(function(){
	adminInit();
});

function adminInit() {
	$('html').addClass('adminHtml');

	contH();

	$(window).on('resize', function(){
		contH();
	});
}

/*content 최소높이값*/
function contH() {
	$('#contents').css({'min-height':'auto'});
	var windowH = $(window).outerHeight();
	//var headerH = $('#header').outerHeight();
	var footerH = $('#footer').outerHeight();
	//$('#contents').css({'min-height':Number(windowH-(headerH+footerH))+'px'});
	$('#contents').css({'min-height':Number(windowH-footerH)+'px'});
}