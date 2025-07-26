<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- find customer -->
<script type="text/javascript">
	$(function(){
		commonTab( '.findMember-area', '.fm-head .tab-iboxtype', '.fm-cont .tab-cont', 0, 'click' );//탭메뉴

		$('.scrollY').each(function(){
			$(this).mCustomScrollbar({scrollbarPosition:"outside"});
			$(this).mCustomScrollbar('update');
		})

		$('.mCSB_scrollTools .mCSB_draggerRail').css('height', '0px');

		var findMemberOrg = {};
		var deptMemberArrOrg = [];
		var popupInit = true;
		
		var FIND_MEMBER = {
			COMMON : {
				click : {
					updateMyFavorite : function(__uuid , __detailId , __event ) {
						console.log(__uuid , __detailId  , __event );
						// on / off class 변경
						FIND_MEMBER.COMMON.changeFavoriteClass(__event);
						
						if($(__event).hasClass('on')) {
							HTGF.Api.post('${pageContext.request.contextPath}/api/favorite', {menuId: 'FIND_MEMBER', folderCodeId: 'MEMBER', fvUrl: '/FIND_MEMBER', detailId: __detailId }).then(function(resData) {
								$('li[data-id='+__uuid+']').find('.favo3').show();
								FIND_MEMBER.COMMON.setFavoriteForFindMemberOrg(__uuid, 'Y');
							});
						} else {
							HTGF.Api.delete("${pageContext.request.contextPath}/api/FIND_MEMBER/" + __detailId).then(function(resData) {
								var tabIconsIdx = $("#findMemberTabIcons > li.on").index();
								
								if (tabIconsIdx == 0 || tabIconsIdx == -1) {
									$('#memberList li[data-id='+__uuid+']').find('.favo3').hide();
								} else if(tabIconsIdx == 2) {
									$('#favoriteMemberList li[data-id='+__uuid+']').remove();
								}
								FIND_MEMBER.COMMON.setFavoriteForFindMemberOrg(__uuid, 'N');
							});
						}
						
					}
				},
				changeFavoriteClass : function(e) {
					$(e).hasClass("on")? $(e).addClass("off").removeClass("on") : $(e).addClass("on").removeClass("off");
				},
				reDrawMemberList : function() {
					// 현재 활성화 되어있는 탭은 몇번째 인지 체크 후 호출 0 : 멤버 리스트
					if($("#findMemberTabIcons > li.on").index() == 0) {
						// 검색어가 있는지 판단
						if ($("#findMemberSearchInput").val() == "") {
							FIND_MEMBER.TEAM.click.initFindMember();
						} else {
							FIND_MEMBER.TEAM.click.searchFindMember();
						}
					} else {
						FIND_MEMBER.FAVORITES.click.getFavoritMember();
					}
				},
				setFavoriteForFindMemberOrg : function(__uuid, isFavorite) {
					var findMember = findMemberOrg.list.find(function (memberItem) {
						return memberItem.UUID === __uuid;
					});
					
					if(findMember) {
						findMember.FAVORITE_YN = isFavorite;
					}
					
					var recentViewedMember;
					if(findMemberOrg.recentlyViewedMembers){
						recentViewedMember = findMemberOrg.recentlyViewedMembers.find(function(memberItem) {
							return memberItem.UUID === __uuid;
						});
					}
					
					if(recentViewedMember){
						recentViewedMember.FAVORITE_YN = isFavorite;
					}
				}
			},

			TEAM : {
				click : {
					initFindMember: function() {
						popupInit = true;
						console.log('initFindMember');
						$('.tab-cont.member-listtype').eq(0).find('.title').text('${USER_SESSION.deptNameEn}');
						$('.tab-cont.member-listtype').eq(0).find('.btn-clear-search').hide();
						$('#findMemberSearchInput').unbind('keyup').keyup(function(e){
							var key = e.which;
							if(key == 13) {
								FIND_MEMBER.TEAM.click.searchFindMember();
							}
						});
						FIND_MEMBER.TEAM.search({'pageSize': 100, 'pageNo': 1});
					},
					searchFindMember: function() {
						// Organization Tree Tab - 매치되는 조직명을 하일라이트 한다
						if($("#findMemberSearchInput").val() == '') {
							alert('Input search keyword!');
						} else {
							$('.tab-cont.member-listtype').eq(0).find('.btn-clear-search').show();
							$('.tab-cont.member-listtype').eq(0).css('display', 'block');
							$('.tab-cont.member-listtype').eq(0).find('.title').text('Search Results');
							$('#findMemberTabIcons').find('li').removeClass('on');
							$('#findMemberTabIcons').find('li').eq(0).addClass('on');
							
							var findMemberSearchWord = $("#findMemberSearchInput").val();
							
							if ($("#findMember > div > div.pop-cont > div > div.colbox-2.fm-head > ul > li.on").index() == 1) {
								$("#orgTree .btn-team").css('color', '#959393');
								$("#orgTree .btn-team:contains('" + findMemberSearchWord + "')").css('color', 'red').show();
							} else if ($("#findMember > div > div.pop-cont > div > div.colbox-2.fm-head > ul > li.on").index() == 2) {
								FIND_MEMBER.FAVORITES.search({
									'pageSize': 100,
									'pageNo': 1,
									'searchWord': findMemberSearchWord
								});
							} else {
								FIND_MEMBER.TEAM.search({
									'pageSize': 100,
									'pageNo': 1,
									'searchWord': findMemberSearchWord
								});
							}
						}
					},
					searchClear : function() {
						$('#findMemberSearchInput').val('');
						$('#findMemberSearchInput').closest('.searchbox-bbtype').removeClass('open');
					}
				},
				search : function(__searchParam) {
					HTGF.Api.get('${pageContext.request.contextPath}/api/FIND_MEMBER', __searchParam).then(function (resData) {
						//console.log('TEAM.search', resData)
						findMemberOrg.list = resData.list;
						FIND_MEMBER.TEAM.drawFindMemberList(findMemberOrg.list);
					});
				},
				drawFindMemberList : function(memberArr) {
					var $member_list = $('#memberList').empty();
					
					$.each(memberArr, function(idx, memberItem) {
						memberItem.cnttCode = '${LOCALE_CODES}';
						$member_list.append($('#member-ul-li-tmpl').render(memberItem));
					});
					// 퍼블 공통 팝업 오출 함수
					popupLayer('#findMember');
					
					setTimeout(function() {
						$('#memberList').find("a").first().trigger("click");
					}, 1000);
						
				},
				getMemberDetail : function(empNo , __targetID , __event) {
					$('.listM .link').removeClass("active");
					$(__event).addClass("active");
					
					var memberDetail = findMemberOrg.list.find(function(memberItem) {
						return memberItem.EMPLOYEE_NO === empNo;
					});
					
					var $find_member_user_detail = $('#findMemberUserDetailDiv').empty();
					memberDetail.cnttCode = '${LOCALE_CODES}';
					$find_member_user_detail.append($('#find-member-user-detail-tmpl').render(memberDetail));
					globalUserConfig.MEMBER_AUTO_SAVE = 'Y';//임시
					if(!popupInit && globalUserConfig.MEMBER_AUTO_SAVE == 'Y') {
						console.log('MEMBER_AUTO_SAVE')
						HTGF.Api.post('${pageContext.request.contextPath}/api/FIND_MEMBER/recently/'+__targetID);
					}
					popupInit = false;
				}
				
			},

			FAVORITES : {
				click : {
					getFavoritMember : function() {
						popupInit = true;
						FIND_MEMBER.FAVORITES.search({'pageSize': 200, 'pageNo': 1});
					}
				},
				search : function(__searchParam) {
					HTGF.Api.get('${pageContext.request.contextPath}/api/FIND_MEMBER/favorite/list', __searchParam).then(function (resData) {
						console.log('FAVORITES.search',resData)
						findMemberOrg.list = resData.list;
						FIND_MEMBER.FAVORITES.drawFavoriteMemberList(findMemberOrg.list);
					});
				},
				drawFavoriteMemberList : function(memberArr) {
					var $favorite_member_list = $('#favoriteMemberList').empty();
					
					$.each(memberArr, function(idx, memberItem) {
						$favorite_member_list.append($('#member-ul-li-tmpl').render(memberItem));
					});
					setTimeout(function() {
						$('#favoriteMemberList').find("a").first().trigger("click");
					}, 1000);
				}
			},

			RECENTLY : {
				init : function() {
					$('#findMemberSearchInput').focus(function(e){
						$('#findMemberSearchInput').closest('.searchbox-bbtype').addClass('open');
						FIND_MEMBER.RECENTLY.showRecentlyViewedMember($('#findMemberSearchInput'));
					});
				},
				recentViewedMember : function(userId) {
					var memberDetail = findMemberOrg.recentlyViewedMembers.find(function (memberItem) {
						return memberItem.USER_ID === userId;
					});
					console.log('recentViewedMember', memberDetail)
					var selectedRecentView = $('#selectedRecentView').empty();
					
					selectedRecentView.append($('#recently-member-ul-li-tmpl').render(memberDetail));
					
					$('.tab-cont.member-listtype').css('display', 'none');
					$('#findMemberTabIcons').find('li').removeClass('on');
					$('#findMemberTabList').find('.member-listtype:last').css('display', 'block');
					
					setTimeout(function () {
						$('#selectedRecentView').find("a").first().trigger("click");
					}, 1000);
				},
				removeRecentViewedMember : function(_el, targetId) {
					var uri = '/api/FIND_MEMBER/recently';
					if(targetId) {
						uri = uri + '/' + targetId;
					}
					
					HTGF.Api.delete('${pageContext.request.contextPath}'+ uri).then(function (result) {
						FIND_MEMBER.RECENTLY.showRecentlyViewedMember($('#findMemberSearchInput'));
					});
				},
				autoSave : function(_el) {
					var memberAutoSaveValue = ($(_el).hasClass('on') == true) ? 'N' : 'Y';
					HTGF.Api.post('${pageContext.request.contextPath}/api/MAIN/save-userConfig', {
						"memberAutoSave": memberAutoSaveValue
					}).then(function (result) {
						globalUserConfig.memberAutoSave = memberAutoSaveValue;
						FIND_MEMBER.RECENTLY.switchBtnAutoSave($(_el));
					});
				},
				switchBtnAutoSave : function($el) {
					if (globalUserConfig.memberAutoSave == 'Y') {
						$el.removeClass('off');
						$el.addClass('on');
					} else {
						$el.removeClass('on');
						$el.addClass('off');
					}
				},
				showRecentlyViewedMember : function(_el) {
					var $btnRecentViewedMemberAutoSave = $('#btnRecentViewedMemberAutoSave');
					if (globalUserConfig.memberAutoSave == 'Y') {
						$btnRecentViewedMemberAutoSave.removeClass('off');
						$btnRecentViewedMemberAutoSave.addClass('on');
					} else {
						$btnRecentViewedMemberAutoSave.removeClass('on');
						$btnRecentViewedMemberAutoSave.addClass('off');
					}
					
					HTGF.Api.get('${pageContext.request.contextPath}/api/FIND_MEMBER/recently').then(function(result) {
						console.log('showRecentlyViewedMember', result)
						findMemberOrg.recentlyViewedMembers = result;
						if(result){
							$(_el).closest('.searchbox-bbtype').find('.m-listbox').empty().append($('#recently-viewed-li-tmpl').render(result));
						}else{
							$(_el).closest('.searchbox-bbtype').find('.m-listbox').empty();
						}
					});
				},
				getMemberDetail : function(userId , __targetID , __event) {
					$("#memberList,#favoriteMemberList").find(".favophoto").odd().removeClass("selected");
					$(__event).find(".favophoto").addClass("selected");
					
					var memberDetail = findMemberOrg.recentlyViewedMembers.find(function (memberItem) {
						return memberItem.USER_ID === userId;
					});
					
					var $find_member_user_detail = $('#findMemberUserDetailDiv').empty();
					
					$find_member_user_detail.append($('#find-member-user-detail-tmpl').render(memberDetail));
					
					if(globalUserConfig.memberAutoSave == 'Y') {
						if(memberDetail) {
							HTGF.Api.post('${pageContext.request.contextPath}/api/FIND_MEMBER/recently/'+targetId);
						}
					}
				}
			}
		}

		var deptUserList = [];
		var ORG_TREE = {
			click : {
				tab : function() {
					$('#findMemberOrganizationLoader').show();
					// 조직 Tree , 유저 목록 가져오기
					Promise.all([
							HTGF.Api.get('${pageContext.request.contextPath}/api/user/all-dept-list'),
							//HTGF.Api.get('/api/user/all-user-list')
						]).then(function (values) {
							var deptList = values[0];
							// var userList = values[1];
							// deptUserList = userList;
							ORG_TREE.render(ORG_TREE.buildTree( deptList ));
					});
				}, 
				getMember : function(deptCd) {
					var deptUserMember = deptUserList.filter( function( el ){
						return el.DEPT_CODE == deptCd;
					});
					
					if(deptUserMember.length == 0) {
						HTGF.Api.get('${pageContext.request.contextPath}/api/FIND_MEMBER/userList/'+deptCd).then(function(resData){
							if (resData.list && resData.list.length > 0){
								deptUserMember = resData.list;
								deptUserList = deptUserList.concat(deptUserMember);
								
								ORG_TREE.drawDeptMember( deptUserMember , deptCd);
								$("#"+deptCd).children("ul").show();
							}
						});
					} else {
						// 하위가 없으면 로직 추가 해야함
						if($("#"+deptCd).children("ul").length > 0 ){
							
							if($("#"+deptCd).children("ul").css("display") == "none") {
								$("#"+deptCd).children("ul").show();
								ORG_TREE.drawDeptMember( deptUserMember , deptCd); // deptUserList.filter(el => el.deptCode ==deptCd)
							} else {
								// hide children of department And list of member
								$("#"+deptCd).children("ul").hide();
								$("#"+deptCd).find("li:first>div").remove();
							}
							
						} else {
							
							if($("#"+deptCd).find("li:first>div").length >0 ){
								$("#"+deptCd).find("li:first>div").remove();
							} else {
								ORG_TREE.drawDeptMember( deptUserMember , deptCd);
							}
							
						}
						
					}
				}
			},
			render : function(orgArray) {
				var $org_tree = $('#orgTree').empty();
				// tree open
				//$org_tree.append( $('#org-treeOpen-tmpl').render());
				
				$.each(orgArray , function(idx,orgItem){
					orgItem.cnttCode = '${LOCALE_CODES}';
					if(orgItem.level == 0) {
						$org_tree.append( $('#org-treeOpen-tmpl').render(orgItem));
					} else {
						var $org_parent = $('#'+orgItem.parentCode);
						// 상위 하위 일때 구분 하여 템플릿 사용 분기 처리 해줄것
						$org_parent.append($('#org-tree-teambox-tmpl').render(orgItem));
					}
				});
				$('#findMemberOrganizationLoader').hide();
			},
			drawDeptMember : function(memberArray , deptCd) {
				$('#'+deptCd).find("li:first").append('<div class="tree-userbox"></div>').css("display","block");
				
				$.each(memberArray , function(idx,memberItem){
					$('#'+deptCd).find(".tree-userbox").append($('#org-tree-userbox-tmpl').render(memberItem));
				});
			},
			getMemberDetail : function(userUuid) {
				// 상세정보 서버 통신하여 가져오기
				HTGF.Api.get('${pageContext.request.contextPath}/api/FIND_MEMBER/'+userUuid).then( function(resData) {
					var $find_member_user_detail = $('#findMemberUserDetailDiv').empty();
					$find_member_user_detail.append( $('#find-member-user-detail-tmpl').render(resData.detail) );
				});
			},
			buildTree : function (data) {
				var depts = data.filter(function (v) {
					if( v.deptCodePath.indexOf('00000001') > -1 || v.deptCodePath.indexOf('00007851') > -1) {
						v.level =(v.deptCodePath.split('≫').length)?v.deptCodePath.split('≫').length-1 :0; 
						return v;
					}
				});
				depts.sort(function(a, b) { // 내림차순
					return a.level < b.level ? -1 : a.level > b.level ? 1 : 0;
				});
				return depts;
			}
		}

		window.FIND_MEMBER = FIND_MEMBER;
		window.ORG_TREE = ORG_TREE;
		FIND_MEMBER.RECENTLY.init();
	});
</script>
<script id="recently-member-ul-li-tmpl" type="text/template">
<li class="listM has-delbtn" data-id="{{:UUID}}">
	<a href="javascript:void(0)" class="link" onclick="FIND_MEMBER.RECENTLY.getMemberDetail('{{:EMPLOYEE_NO}}', '{{:UUID}}', this);return false;">
		<div class="nameteam">
			<div class="namebox"><strong class="txt1">{{:NAME}}</strong><span class="txt2">( {{:NAME_EN}} )</span></div>
			<div class="teambox">{{:RANK_NAME}}<br>{{:DEPT_NAME}}</div>
		</div>
		<div class="favophoto">
			<span class="photo" style="background-image: url(${pageContext.request.contextPath}/front/images/img-noPhoto2.png);"></span>
			<span class="favo3 userId" {{if FAVORITE_YN=="Y"}} style="display:block;"{{else}} style="display:none;" {{/if}}></span>
		</div>
	</a>
</li>
</script>
<script id="member-ul-li-tmpl" type="text/template">
<li class="listM" data-id="{{:UUID}}">
	<a href="javascript:void(0)" class="link" onclick="FIND_MEMBER.TEAM.getMemberDetail('{{:EMPLOYEE_NO}}', '{{:UUID}}', this);return false;">
		<div class="nameteam">
		{{if cnttCode == USE_LANG}}
			<div class="namebox"><strong class="txt1">{{:NAME}}</strong><span class="txt2">( {{:NAME_EN}} )</span></div>
			<div class="teambox">{{:DEPT_NAME}}<br>{{:POSITION_NAME}}</div>
		{{else}}
			<div class="namebox"><strong class="txt1">{{:NAME_EN}}</strong><span class="txt2">( {{:NAME}} )</span></div>
			<div class="teambox">{{:DEPT_NAME_EN}}<br>{{:POSITION_NAME_EN}}</div>
		{{/if}}
		</div>
		<div class="favophoto">
			<span class="photo" style="background-image: url(${pageContext.request.contextPath}/front/images/img-noPhoto2.png);"></span>
			<span class="favo3 userId" {{if FAVORITE_YN=="Y"}} style="display:block;"{{else}} style="display:none;" {{/if}}></span>
		</div>
	</a>
</li>
</script>
<script id="find-member-user-detail-tmpl" type="text/template">
<!-- user 정보 -->
<div class="member-infotype" style="display: block;">
	<div class="member-head">
		<span class="photo" style="background-image: url(${pageContext.request.contextPath}/front/images/img-noPhoto2.png);"></span>
	{{if cnttCode == USE_LANG}}
		<div class="namebox"><strong class="txt1">{{:NAME}}</strong><span class="txt2">( {{:NAME_EN}} )</span></div>
		<div class="teambox">{{:DEPT_NAME}} / {{:POSITION_NAME}}</div>
	{{else}}
		<div class="namebox"><strong class="txt1">{{:NAME_EN}}</strong><span class="txt2">( {{:NAME}} )</span></div>
		<div class="teambox">{{:DEPT_NAME_EN}} / {{:POSITION_NAME_EN}}</div>
	{{/if}}
		<div class="btnbox">
			<div class="btn ico">
				<a href="javascript:void(0)" class="btn-email">email</a>
			</div>
			<div class="btn ico">
				<a href="javascript:void(0)" class="btn-favoChk2 {{if FAVORITE_YN=="Y"}}on{{else}}off{{/if}}" onclick="FIND_MEMBER.COMMON.click.updateMyFavorite('{{:UUID}}', '{{:DETAIL_ID}}', this);return false;">Favorites</a><!-- 즐겨찾기 추가된 상태 : on -->
			</div>
		</div>
	</div>
	
	<div class="member-cont">
		<div class="border2-box info-team">
			{{:DEPT_NAME_PATH}}
			<!--<span>Hankook Technology Group Co., Ltd</span><span>CEO</span><span>COO</span><span>Digital Strategy Department(CDO&CIO)</span><span>Deputy Managing Director of IT Strategy</span><span>Global IT Planning Team</span>-->
		</div>
	</div>
</div>
<!-- //user 정보 -->
</script>
<script type="text/template" id="recently-viewed-li-tmpl">
<li class="listM has-delbtn"><!-- 검색결과에는 has-delbtn이 추가 -->
	<a href="javascript:void(0)" class="link" onclick="FIND_MEMBER.RECENTLY.recentViewedMember('{{:EMPLOYEE_NO}}')"><!-- 선택한 user : active -->
		<div class="nameteam">
			<div class="namebox"><strong class="txt1">{{:NAME}}</strong><span class="txt2">( {{:NAME_EN}} )</span></div>
			<div class="teambox">{{:RANK_NAME}}<br>{{:DEPT_NAME}}</div>
		</div>
		<div class="favophoto">
			<span class="photo" style="background-image: url(${pageContext.request.contextPath}/front/images/img-noPhoto2.png);"></span>
			<!-- @개발팀 즐겨찾기했을때 태그자체 보임, 아닐경우 태그 자체 삭제 -->
			<!-- <span class="favo3"></span> -->
		</div>
	</a>
	<a href="javascript:void(0)" class="btn-del9 delbtn" onclick="FIND_MEMBER.RECENTLY.removeRecentViewedMember(this, '{{:UUID}}')">Delete</a><!-- 검색결과에는 삭제버튼 추가 -->
</li>
</script>

<script type="text/template" id="org-treeOpen-tmpl">
<li class="tree-box treeOpen" id="{{:code}}">
	<p class="tree-shbox">
		<a href="javascript:void(0)" class="btn-arrowTree" onclick="ORG_TREE.click.getMember('{{:code}}');return false;">show/hide</a>
		<a href="javascript:void(0)" class="btn-team">{{if cnttCode == workCountryCode}} {{:deptNameNative}} {{else}} {{:deptNameEn}} {{/if}}</a>
	</p>
</li>
</script>
<script type="text/template" id="org-tree-teambox-tmpl">
<ul class="tree-teambox tree-dep{{:level}}" id="{{:code}}">
	<li class="tree-box treeOpen">
		<p class="tree-shbox">
			<a href="javascript:void(0)" class="btn-arrowTree" onclick="ORG_TREE.click.getMember('{{:code}}');return false;">show/hide</a>
			<a href="javascript:void(0)" class="btn-team"> {{:name}}</a>
		</p>
	</li>
</ul>
</script>
<script type="text/template" id="org-tree-userbox-tmpl">
<a href="javascript:void(0)" class="btn-user" onclick="ORG_TREE.getMemberDetail('{{:UUID}}',this);return false;">{{:DEPT_NAME}} {{:NAME}}</a>
</script>
<div class="popup-wrap" id="findMember">
	<div class="popup w1020">
		<div class="pop-head">
			find Member
		</div>
		<div class="pop-cont">
			<div class="findMember-area border-cAfter memberbox" style="height: 655px;">

				<div class="colbox-2 fm-head">
					<ul class="tab-iboxtype col" id="findMemberTabIcons">
						<li><a href="javascript:void(0)" class="tag ibox" onclick="FIND_MEMBER.TEAM.click.initFindMember();return false;"><div class="ico-fm1">Team</div></a></li>
						<li><a href="javascript:void(0)" class="tag ibox" onclick="ORG_TREE.click.tab();return false;"><div class="ico-fm2">Organization</div></a></li>
						<li><a href="javascript:void(0)" class="tag ibox" onclick="FIND_MEMBER.FAVORITES.click.getFavoritMember();return false;"><div class="ico-fm3">Favorites</div></a></li>
					</ul>
					<div class="searchbox-bbtype col">
						<div class="insearch-box type1">
							<input type="text" class="input" id="findMemberSearchInput" placeholder="Please search for member name or team name">
							<a href="javascript:void(0)" class="btn-clear btn clear" onclick="FIND_MEMBER.TEAM.click.searchClear();return false;">clear</a>
							<a href="javascript:void(0)" class="btn-search btn" onclick="FIND_MEMBER.TEAM.click.searchFindMember();return false;">search</a>
						</div>

						<div class="member-listtype">
							<div class="ml-head icon-title"><span class="title clock-title">Recent Searches</span></div>
							<div class="ml-cont scrollY" style="height: 412px;">
								<ul class="m-listbox">
								</ul>
							</div>
							<div class="ml-foot ta-r">
								<div class="inbox onoffbox type2">
									<div class="txt1">Auto Save</div>
									<a href="javascript:void(0)" class="btn-onoff on" id="btnRecentViewedMemberAutoSave" onclick="FIND_MEMBER.RECENTLY.autoSave(this);return false;"><!-- on/off -->
										<span class="txt2 txt-on">ON</span><span class="txt2 txt-off">OFF</span><!-- 부모값 on/off에 따라 css에서 숨김보임처리함 -->
									</a>
								</div>
								<div class="inbox">
									<a href="javascript:void(0)" class="link-txt" onclick="FIND_MEMBER.RECENTLY.removeRecentViewedMember(this);return false;">Detail All</a>
								</div>
							</div>
						</div>
						<!-- //20210202 검색결과 목록 위치 이동 -->
					</div>
				</div>

				<!-- 탭내용(왼쪽) + user정보, 목록 및 검색결과(오른쪽) -->
				<div class="colbox-2 fm-cont border-t666">

					<!-- 탭내용(왼쪽) -->
					<div class="col" id="findMemberTabList">

						<!-- Team 목록 -->
						<div class="tab-cont member-listtype">
							<div class="ml-head inbar-title">
								<span class="title"></span>
								<a href="javascript:void(0)" class="btn-del8 btn-clear-search" style="display: none" onclick="FIND_MEMBER.TEAM.click.initFindMember(); return false;">close</a><!--20210304 닫기버튼 추가 -->
							</div>
							<div class="ml-cont scrollY" style="height: 535px;">
								<ul class="m-listbox" id="memberList">
								</ul>
							</div>
						</div>
						<!-- //Team 목록 -->

						<!-- Organization 목록 -->
						<div class="tab-cont member-listtype position-r">
							<div class="loadingbar" id="findMemberOrganizationLoader" style="display: none;">
								<div class="loadingbarbox">
									<div class="loadingbar-in">
										<img src="${pageContext.request.contextPath}/common_f/images/common/loading.gif">
										<p>Loading....</p>
									</div>
								</div>
							</div>
							
							<div class="ml-head inbar-title"><span class="title">Organization</span></div>
							<div class="ml-cont scrollY" style="height: 535px;">
								<div class="treeTeam-area">
									<!--
									ul.tree-teambox.tree-dep0
										ul.tree-teambox.tree-dep1
											ul.tree-teambox.tree-dep2
											ul.tree-teambox.tree-dep2
												ul.tree-teambox.tree-dep3
													ul.tree-teambox.tree-dep4
													ul.tree-teambox.tree-dep4
														ul.tree-teambox.tree-dep5
														....이런식...
									-->
									<ul class="tree-teambox tree-dep0" id="orgTree">
									</ul>
								</div>
							</div>
						</div>
						<!-- //Organization 목록 -->

						<!-- Favorites 목록 -->
						<div class="tab-cont member-listtype">
							<div class="ml-cont scrollY" style="height: 595px;">
								<ul class="m-listbox" id="favoriteMemberList">
								</ul>
							</div>
						</div>
						<!-- //Favorites 목록 -->

						<div class="tab-cont member-listtype">
							<div class="ml-cont scrollY" style="height: 595px;">
								<ul class="m-listbox" id="selectedRecentView">
								</ul>
							</div>
						</div>

					</div>
					<!-- //탭내용(왼쪽) -->
					
					<!-- user정보, 목록 및 검색결과(오른쪽) -->
					<div class="col" id="findMemberUserDetailDiv">
					</div>
					<!-- //user정보, 목록 및 검색결과(오른쪽) -->

				</div>

			</div>
		</div>
		<a href="javascript:void(0)" class="close" onclick="$('#findMember').fadeOut(400);return false;">close</a>
	</div>
</div>
<!-- //find customer -->