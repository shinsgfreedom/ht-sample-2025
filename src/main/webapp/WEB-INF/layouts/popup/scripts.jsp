<%@ page contentType="text/html;charset=UTF-8" %>

<%@include file="/WEB-INF/layouts/default/scripts.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/common-dev.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/assets/libs/micromodal.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/commonUtile.js"></script>
<script>
	var MY_BOOKMARK = {
		Api:{}
	};
	MY_BOOKMARK.Api.BookmarkRender = (function (params) {
		function ContentBookmark(params) {
			this.params = params;
			this.params.fvUrl = window.location.pathname;
			this.params.myFavoriteUid = '';
			this.params.bookmarkDesc = '';
			//console.log('this.params', this.params)
		}
		ContentBookmark.prototype.render = function () {
			var __this = this;
			this.isBookmarked = false;
			this.$bookmarkContainer = $('.pop-head:first');
			var tempHtml = this.$bookmarkContainer.html();
			this.$bookmarkContainer.html(tempHtml+ '<a href="javascript:void(0);" class="btn-favoChk3">favo</a>');
			this.$bookmarkContainer.find('.btn-favoChk3').click(function() {
				ContentBookmark.prototype.save(__this);
			});
			ContentBookmark.prototype.search(__this);
		}
		ContentBookmark.prototype.search = function ( pThis ) {
			var __this = pThis;
			try {
				HTGF.Api.get('${pageContext.request.contextPath}/api/favorite/getMyContentsBookmarkStatus', __this.params).then( function(resData) {
					console.log('search-resData', resData, typeof(resData), resData.MY_FAVORITE_UID)
					if(typeof(resData) == 'object' && typeof(resData.MY_FAVORITE_UID) != 'undefined') {
						__this.params.myFavoriteUid = resData.MY_FAVORITE_UID;
						__this.isBookmarked = true;
						__this.$bookmarkContainer.find('.btn-favoChk3').addClass('on');
					}
					console.log()
				});
			} catch (e) {
				console.error(e);
			} finally {
				//console.log('ContentBookmark.prototype.search finally');
			}
		}
		ContentBookmark.prototype.save = function ( pThis ) {
			var __this = pThis;
			if(__this.params.myFavoriteUid == '') {
				var bookmarkDesc = prompt('Input bookmark name first.', __this.params.bookmarkDescDefault);
				if(bookmarkDesc === null) return;
				__this.params.bookmarkDesc = bookmarkDesc;
				
				var vParams = {};
				Object.assign(vParams, __this.params);
				console.log('save', vParams);
				HTGF.Api.post('${pageContext.request.contextPath}/api/favorite/saveMyContentsBookmark', vParams).then( function(resData) {
					console.log('save-resData', resData)
					__this.params.myFavoriteUid = resData.code;
					__this.isBookmarked = true;
					afterSave();
				});
			} else {
				HTGF.Api.delete("${pageContext.request.contextPath}/api/favorite/" + __this.params.myFavoriteUid).then(function(resData) {
					__this.params.myFavoriteUid = '';
					__this.isBookmarked = false;
					afterSave();
				});
			}
			
			function afterSave() {
				console.log('afterSave', __this.params);
				if(__this.isBookmarked) {
					__this.$bookmarkContainer.find('.btn-favoChk3').addClass('on');
				} else {
					__this.$bookmarkContainer.find('.btn-favoChk3').removeClass('on');
				}
			}
		}
		ContentBookmark.prototype.setBookmarkDesc = function ( PDesc ) {
			this.params.bookmarkDesc = PDesc;
			this.params.bookmarkDescDefault = PDesc;
		}
		return ContentBookmark;
	})();
</script>