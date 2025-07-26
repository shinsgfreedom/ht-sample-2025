$(function() {
    tabCommon.init();
	moveMyPage();
});

let tabCommon = {
    tabRenderer: null
    , sortNumber: 1
    , targetTabEl: '#historyTab'
    , targetTabContEl: '#tbContArea'
    , init() {
        const _this = this
        _this.tabRenderer = new SHEP_TAB.TabRenderer({
            //targetEl: '.main-wrap', // 그릴 대상이 되는 DOM Selector
            targetTabEl: _this.targetTabEl,
            targetTabContEl: _this.targetTabContEl,
            maxTabCount: 8, // 최대 탭 출력 개수, 8개가 넘어가면 stack 처럼 가장 처음에 들어온 탭이 제거됩니다.
            selectedTabId: 'BUSINESS_TRIP_LIST', // 초기화시 선택된 탭 id
            tabs: [
                // 보통 첫번째 아이템은 dashboard 나 가장 처음에 보여질 페이지로 구성합니다.
                {
                    id: 'BUSINESS_TRIP_LIST', // tab 식별자, 보통 HTGF.UTILS.uuid()을 사용하시면 좋습니다.
                    sortNumber: 0, // 정렬 순서, 이 정보는 내부적으로 관리됩니다.
                    titleI18nId: '#국내_출장_리스트', // 탭 title i18n 코드
                    url: '/BUSINESS_TRIP_LIST/index.html?option=tab', // 탭 Content URL
                    zoomUrl: '/BUSINESS_TRIP_LIST/index.html?option=full', // 새창으로열때 탭 Content URL
                    bgColor: '#fff', // 탭 선택시 배경색
                    externalYn: 'N', // 외부URL여부, 외부URL인경우 iframe으로 그려집니다.
                    fixedYn: 'Y', // 고정 여부, Y면 드래그,제거버튼이 보이지 않습니다.
                    pinnedYn: 'N' // PIN 여부, Y면 위치 이동이 불가능함
                }
            ]
        });
    }
    /*reload : 'Y' 일시 해당 탭이 열려있으면 닫고 reload*/
    , selectTab(obj, reload) {
        console.log(obj.url)
        let tabData = {
            id: obj.menuKey, // tab 식별자, Core Menu 데이터를 기본으로 이용한다면 menuKey를 id로 잡으면 좋습니다.
            sortNumber: this.sortNumber++, // 정렬 순서, 이 정보는 내부적으로 관리됩니다.
            titleI18nId: obj.i18nCode, // 탭 title i18n 코드
            url: obj.url, // 탭 Content URL
            zoomUrl: obj.url.replace('tab','full'), // 새창으로열때 탭 Content URL, 별도의 url 매핑과 tiles 레이아웃을 준비해주세요
            bgColor: '#fff', // 탭 선택시 배경색
            externalYn: 'N', // 외부URL여부, 외부URL인경우 iframe으로 그려집니다.
            fixedYn: 'N', // 고정 여부, Y면 드래그,제거버튼이 보이지 않습니다.
            pinnedYn: 'N' // PIN 여부, Y면 위치 이동이 불가능함
        }
        if(reload === 'Y') this.tabRenderer.addOrReloadTab(tabData);
        else this.tabRenderer.addAndSelectTab(tabData);
    }
    , reloadTab() {
        let activeTabId=$(this.getActiveTabTitle()).data("tabId");
        $(this.targetTabEl).find("li[data-tab-id='" + activeTabId + "']").find("[ref=refresh]").trigger('click');
    }
    , getActiveTab() {
        let activeTabId=$(this.getActiveTabTitle()).data("tabId");
        let activeTabCont = $(".fc-tab-content-item[data-tab-id='"+activeTabId+"']");
        return activeTabCont;
    }
    , getActiveTabTitle() {
        let activeTab=$(this.targetTabEl).find(".selected");
        return activeTab;
    }
    /*tab별 요소 selector*/
    , findItem(itemStr, tabId) {
        let tabObj = tabId ? $(".fc-tab-content-item[data-tab-id='"+tabId+"']") : this.getActiveTab();
        return tabObj.find(itemStr);
    }
    , focusTab(tabId){
        this.currTabClose();
        $("#tbTabArea").find("li[data-tab-id='" + tabId + "']").trigger('click');
    }
    , currTabClose() {
        let tabId=$(this.getActiveTabTitle()).data("tabId");

        let idx = this.tabRenderer.tabs.findIndex(function (o) {
            return o.id === tabId
        });
        this.tabRenderer.tabs.splice(idx, 1);
        //this.targetEl.find('ul [data-tab-id=' + v.id + ']').remove()
        //this.targetEl.find('.fc-tab-content [data-tab-id=' + v.id + ']').remove()
        this.tabRenderer.targetTabEl.find('[data-tab-id=' + tabId + ']').remove();
        this.tabRenderer.targetTabContEl.find('[data-tab-id=' + tabId + ']').remove();

        //캐시삭제 추가 by sjjeon
        delete this.tabRenderer.uiCache[tabId];

        this.tabRenderer.saveTab()
    }
}

function overrideTabRendererMethods() {
    TabRenderer.selectTab = function (v) {
        if(v.id !== 'home'){
            $('.fc-tab-main .main-tab').css({'background-color': 'white'});
            $('.fc-tab-main .main-tab .title').css({'color': '#f39a5c'});
        }

        if(this.selectedTabId === 'init'){
            this.selectedTabId = 'home';
            routeMain();
        } else {
            this.selectedTabId = v.id;
            this.render();
            this.loadPage(v, v.forceRefresh === 'Y');
        }
    };

    TabRenderer.removeTab = function (v) {
        let idx = this.tabs.findIndex(function (o) { return o.id === v.id });
        this.tabs.splice(idx, 1);
        delete this.uiCache[v.id];
        this.targetEl.find('ul [data-tab-id=' + v.id + ']').remove();
        this.targetEl.find('.fc-tab-content [data-tab-id=' + v.id + ']').remove();

        let selectedId = this.selectedTabId;
        let notHasSelectedTab = !this.tabs.some(function (v) { return v.id === selectedId });
        if (notHasSelectedTab) {
            let lastTab = this.tabs[this.tabs.length - 1];
            if (lastTab) this.selectTab(lastTab);
        }
        this.saveTab();

        if(this.tabs.length == 0){
            routeMain();
        }
    };
}

function fallbackTabRenderer() {
    window.TabRenderer = new HTGF.TabRenderer({
        targetEl: '#historyTab',
        maxTabCount: 10,
        selectedTabId: 'init',
        tabs: []
    });
    overrideTabRendererMethods();
    routeMain();
}

function routePage( pMenu ) {
    console.log('routePage >> pMenu >> ', pMenu);
    closeGnb();
    //TabRenderer.clickSiteMenu(pMenu);

    var menuItem = FRONT_MENU_RENDERER.getRawData().find(function(tab) {
        return tab.menuId !== 'M2_INTEGRATED_SEARCH' && tab.menuId == pMenu.id;
    });

    console.log('routePage >> menuItem >> ', menuItem);

    if(menuItem) {
        var menuUrl = menuItem.externalUrlYn && menuItem.externalUrlYn == true ? menuItem.externalUrl : pMenu.link;

        TabRenderer.addAndSelectTab({
            id: menuItem.id, // tab 식별자, 보통 HTGF.UTILS.uuid()을 사용하시면 좋습니다.
            sortNumber: 0, // 정렬 순서, 이 정보는 내부적으로 관리됩니다.
            titleI18nId: menuItem.i18nCode,
            url: menuUrl.indexOf('?') > 0 ? menuUrl + '&option=tab' : menuUrl + '?option=tab', // 탭 Content URL
            bgColor: getMenuBackgroundColor(menuItem.url), // 탭 선택시 배경색
            externalYn: menuItem.externalUrlYn && menuItem.externalUrlYn == true ? 'Y' : 'N', // 외부URL여부, 외부URL인경우 iframe으로 그려집니다.
            fixedYn: 'N', // 고정 여부, Y면 드래그,제거버튼이 보이지 않습니다.
            pinnedYn: 'N', // PIN 여부, Y면 위치 이동이 불가능함
            forceRefresh: 'Y'
        });
        // TabRenderer.saveTab();

        console.log('#### save ?!?! ')
    } else {
        alert('Fail to open Menu.');
    }
}

function getMenuBackgroundColor(url){
    var colorParamName = 'contSearch=';
    return url.indexOf(colorParamName) > -1? url.substr(url.indexOf(colorParamName)+colorParamName.length, 6) : 'f5bf1e';    
}


function routeMain( forceRefresh ) {
	$('.fc-tab-main .main-tab').css({'background-color': '#f39a5c'});
	$('.fc-tab-main .main-tab .title').css({'color': 'white'});

	TabRenderer.selectTab({ id: 'home', text: 'Home' , tooltip : 'Home', url: '/MAIN/refresh.html?option=tab',forceRefresh: forceRefresh ? 'Y' : 'N' });
}

function refreshMain( pMenuId ) {
	closeGnb();
	TabRenderer.clickRefreshMain({ id: 'home', text: 'Home' , tooltip : 'Home' });
}

function closeGnb() {
	var $gnbBtn = $('#btnGnb'), $gnb = $("#gnb");
	$gnbBtn.removeClass('on').addClass('off');
	$gnb.removeClass('open');
	// closeTopMenu();
}

function closeTopMenu() {
	if(globalUserConfig.topLayerDisplay == 'N') {
		$('#main_top_layer').hide();
		$('.quick-area').css('top', '5px');
		$('#btnTopLayer').removeClass('off');
		$('#main_tab_alarm_count').removeClass('off');
		
		var $gnbBtn = $('#btnGnb'), $gnb = $("#gnb");
		if($gnb.hasClass('open')) {
			$gnb.removeClass('open');
		}
		if ( $gnbBtn.hasClass('on') ) {
			$gnbBtn.removeClass('on').addClass('off');
		}
	}
}