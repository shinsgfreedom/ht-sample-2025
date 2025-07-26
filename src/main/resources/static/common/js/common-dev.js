/*
$.fn.createUploader = function(config, category, callback){
	category = typeof category !== 'undefined' ? category : '';
	var status = false;
	var m1 = 1048576; //1MByte
	
	if(!this[0]) {console.log("객체를 찾을수 없음"); return;}
	if(this[0].tagName.toLowerCase() != "div") {console.log("DIV 객체가 아님"); return;}

	var default_config = {
		upload_url : "/component-sample/upload",
		download_url : "/component-sample/download",
		mode : "list",
		autosend : false,
		toolbar : true,
		totalsize : true,
		customScroll : true,
		drm : false,
		language : "en",
		locale : {
			en : {
				add : "Add",
				browse : "Browse files",
				cancel : "Cancel",
				clear : "Clear",
				clearAll : "Clear all",
				download : "Download",
				dragAndDrop : "Drag & drop",
				filesOrFoldersHere : "files or folders here",
				or : "or",
				upload : "Upload",
				byte: "B",
				kilobyte: "KB",
				megabyte: "MB",
				gigabyte: "GB"
			},
			ko : {
				add : "Add",
				browse : "파일 선택",
				cancel : "Cancel",
				clear : "Clear",
				clearAll : "Clear all",
				download : "Download",
				dragAndDrop : "Drag & drop",
				filesOrFoldersHere : "files or folders here",
				or : "or",
				upload : "Upload",
				byte: "B",
				kilobyte: "KB",
				megabyte: "MB",
				gigabyte: "GB"
			}
		}
	};

	if(config){
		default_config = config;
	}

	var mode = default_config.mode?default_config.mode:"list";
	var toolbar = default_config.toolbar?default_config.toolbar:true;
	var autosend = default_config.autosend?default_config.autosend:false;
	var customScroll = default_config.customScroll?default_config.customScroll:false;
	var drm = default_config.drm?default_config.drm:false;
	
	var vault = new dhx.Vault(this[0].id, {
		mode : mode,
		toolbar: toolbar,
		customScroll: customScroll,
		uploader : {
			target : default_config.upload_url,
			downloadURL : "/component-sample/download/",//default_config.download_url,
			autosend: autosend,
			params: {
				category: category,
				drm: drm
			},
			//singleRequest:true
		}
	});

	vault.toolbar.data.update("add", {icon : "far fa-plus-square"});
	vault.toolbar.data.update("upload", {icon : "far fa-save"});
	vault.toolbar.data.update("remove-all", {icon : "far fa-trash-alt"});
	
	if(default_config.totalsize){
		vault.toolbar.data.add({type : "text", id : "size"}, 3);
		//vault.toolbar.show("size");
	}
	
	if(default_config.locale){
		if(default_config.language){
			if(default_config.locale[default_config.language]){
				dhx.i18n.setLocale("vault", default_config.locale[default_config.language]);
			}else{
				if(default_config.locale.en){
					dhx.i18n.setLocale("vault", default_config.locale.en);
				}
			}
		}else{
			if(default_config.locale.en){
				dhx.i18n.setLocale("vault", default_config.locale.en);
			}
		}
	}

	vault.events.on("change", function() {
		var tot = vault.data.reduce(function(total, f) {
			return total + f.size;
		}, 0);

		vault.toolbar.data.update("size", {value : Math.round(tot/m1*100)/100 + " MB"});
	});
	var rtn;
	var delete_list = [];
	var load_data;

	vault.events.on("BeforeAdd", function(item) {
		if(default_config.allowedSize){
			if(item.file.size > default_config.allowedSize){
				dhx.message({
					text: item.file.name + "Too Large, canceled",
					css: "dhx-error",
					expire: 4000
				});
				return false;
			}
		}
		
		if(default_config.fileLimit){
			if (vault.data.getLength() >= default_config.fileLimit) {
				dhx.message({
					text: "Current Limit - " + default_config.fileLimit + ", file " + item.file.name + " canceled",
					css: "dhx-error",
					expire: 4000
				});
				return false;
			}
		}
		
		if(default_config.totalAllowedSize){
			var tot = vault.data.reduce(function(total, f) {
				return total + f.size;
			}, 0);
			
			if(tot > default_config.totalAllowedSize){
				dhx.message({
					text: item.file.name + "Too Large, canceled",
					css: "dhx-error",
					expire: 4000
				});
				return false;
			}
		}
	});
	
	vault.events.on("beforeRemove", function(file) {
		if(file.status == "uploaded"){
			delete_list.push(file);
		}
	});

	vault.events.on("removeAll", function() {
		delete_list = load_data?load_data:[];
	});
	
	vault.events.on("uploadComplete", function(files) {
		rtn = {
			status : status,
			upload_list : files,
			delete_list : delete_list
		};
		callback(rtn);
	});

	vault.events.on("uploadFail", function(files) {
		status = false;
	});

	vault.paint();

	var result = {
		"vault":vault,
		"load":function(item){
			load_data = JSON.parse(JSON.stringify(item));
			vault.data.parse(item);
		},
		"send":function(){
			var queues = vault.data.findAll({by:"status", match:"queue"});

			if(queues.length > 0){
				status = true;
				vault.uploader.send();
			}else{
				rtn = {
					status : true,
					upload_list : [],
					delete_list : delete_list
				};
				callback(rtn);
			} 
		}
	};

	return result;
}
*/
function I18nLabel(pI18nCode) {
	document.write(I18(pI18nCode));
}

/************************************ LOADING 추가 시작 ************************************/
var LOADING = {
	msg : ''
	, open : function(pType){
		if ( !pType || pType == "S") {
			this.msg = "Searching ...";
		} 
		else if ( pType == "U") {
			this.msg = "Updating ...";
		}
		else if ( pType == "D") {
			this.msg = "Deleting ...";
		} else {
			this.msg = pType;
		}
		
		$('#LOADING').find('p').html(this.msg);
		$('#LOADING').show();
	}
	, close : function(){
		$('#LOADING').hide();
	}
};
/************************************ LOADING 추가  끝 ************************************/

/************************************ DateToString 추가 시작 ************************************/
Date.prototype.format = function(f) {
	if (!this.valueOf()) return " ";
 
	var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
	var d = this;
	
	return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
		switch ($1) {
			case "yyyy": return d.getFullYear();
			case "yy": return (d.getFullYear() % 1000).zf(2);
			case "MM": return (d.getMonth() + 1).zf(2);
			case "dd": return d.getDate().zf(2);
			case "E": return weekName[d.getDay()];
			case "HH": return d.getHours().zf(2);
			case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
			case "mm": return d.getMinutes().zf(2);
			case "ss": return d.getSeconds().zf(2);
			case "a/p": return d.getHours() < 12 ? "오전" : "오후";
			default: return $1;
		}
	});
};
 
String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};
/************************************ DateToString 추가 끝 ************************************/


let EVENT_BINDER = {
	bind: function (_callObj, _eventRootEl) {
		let $pageRoot = $(_eventRootEl);
		let eventTargetTypes = '';
		eventTargetTypes += '[data-load]';
		eventTargetTypes += ',[data-unload]';
		eventTargetTypes += ',[data-error]';
		eventTargetTypes += ',[data-resize]';
		eventTargetTypes += ',[data-scroll]';
		eventTargetTypes += ',[data-input]';
		eventTargetTypes += ',[data-change]';
		eventTargetTypes += ',[data-submit]';
		// eventTargetTypes += ',[data-reset]';
		// eventTargetTypes += ',[data-cut]';
		// eventTargetTypes += ',[data-copy]';
		// eventTargetTypes += ',[data-paste]';
		eventTargetTypes += ',[data-select]';
		eventTargetTypes += ',[data-focus]';
		eventTargetTypes += ',[data-focusin]';
		eventTargetTypes += ',[data-blur]';
		eventTargetTypes += ',[data-focusout]';
		eventTargetTypes += ',[data-click]';
		eventTargetTypes += ',[data-dbclick]';
		// eventTargetTypes += ',[data-mousedown]';
		// eventTargetTypes += ',[data-mouseup]';
		// eventTargetTypes += ',[data-mousemove]';
		eventTargetTypes += ',[data-mouseover]';
		eventTargetTypes += ',[data-mouseout]';
		eventTargetTypes += ',[data-keydown]';
		eventTargetTypes += ',[data-keyup]';
		eventTargetTypes += ',[data-keypress]';
		eventTargetTypes += ',[data-enterSearch]';

		$pageRoot.find(eventTargetTypes).each(function () {

			for (let key in $(this).data()) {

				if (eventTargetTypes.indexOf('data-' + key) > -1) {

					let paramObj = undefined;

					$(_eventRootEl).unbind(key).on(key, '[data-' + key + ']', function (e) {
						let targetFunc = targetingFunc($(this).data()[key], _callObj);

						if (key === 'change') {
							paramObj = {};
							paramObj.value = $(this).find("option:selected").val();
							paramObj.text = $(this).find("option:selected").text();
						}else if(key === 'keypress'){
							if($(this).data()[key] == 'enterSearch'){

								paramObj = {};
								paramObj.pageUuid = $(this).data('param');

								if(e.keyCode == 13){
									_callObj.search();
								}
								return;
							}
						}

						targetFunc.call(this, e, paramObj);
					});
				}
			}
		});

		function targetingFunc(targetFunctionName, _callObj) {
			console.log(targetFunctionName, _callObj);
			let targetFunctionNames = targetFunctionName.split('.');
			let targetFunc = _callObj;
			for (let index in targetFunctionNames) {
				targetFunc = targetFunc[targetFunctionNames[index]];
			}
			return targetFunc;
		}
	}
};

/************************************ EVENT_BINDER (MutationObserver)시작**E11이후부터 적용가능 **********************************/

	/*var OBSERVER = {
		init: function () {
			OBSERVER.observer = new MutationObserver(OBSERVER.callback);
		}
		, defaultConfig: {
			// 옵션 설명
			//  - childList : 대상 노드의 하위 요소가 추가되거나 제거되는 것을 감지합니다.
			//  - attributes : 대상 노드의 속성 변화를 감지합니다.
			//  - characterData : 대상 노드의 데이터 변화를 감지합니다.
			//  - subtree : 대상의 하위의 하위의 요소들까지의 변화를 감지합니다.
			//  - attributeOldValue : 변화 이전의 속성 값을 기록합니다.
			//  - characterDataOldValue : 변화 이전의 데이터 값을 기록합니다.
			//  - attributeFilter : 모든 속성의 변화를 감지할 필요가 없는 경우 속성을 배열로 설정합니다.
			characterData: true,
			attributes: true,
			childList: true,
			subtree: true
		}
		, observe: function (eventObj, targetNode, config) {
			OBSERVER.targetNode = targetNode;
			OBSERVER.eventObj = eventObj;

			let _config = {};
			if (config == undefined) {
				_config = OBSERVER.defaultConfig;
			}
			OBSERVER.observer.observe($(targetNode)[0], _config);
		}
		, callback: function (mutationsList, observer) {

			//console.log('mutationsList', mutationsList);
			for (let idx in mutationsList) {
				if (mutationsList[idx].type === 'childList') {
					observer.disconnect();
					//console.log('The ' + mutationsList[idx].childList + ' childList was modified.');
					EVENT_BINDER.bind(OBSERVER.eventObj, OBSERVER.targetNode);
				} else if (mutationsList[idx].type === 'attributes') {
					//console.log('The ' + mutationsList[idx].attributeName + ' attribute was modified.');
				} else if (mutationsList[idx].type === 'characterData') {
					//console.log('The ' + mutationsList[idx].characterData + ' characterData was modified.');
				} else if (mutationsList[idx].type === 'subtree') {
					//console.log('The ' + mutationsList[idx].attributeName + ' subtree was modified.');
				} else if (mutationsList[idx].type === 'attributeOldValue') {
					//console.log('The ' + mutationsList[idx].attributeName + ' attributeOldValue was modified.');
				} else if (mutationsList[idx].type === 'characterDataOldValue') {
					//console.log('The ' + mutationsList[idx].attributeName + ' characterDataOldValue was modified.');
				} else if (mutationsList[idx].type === 'attributeFilter') {
					//console.log('The ' + mutationsList[idx].attributeName + ' attributeFilter was modified.');
				}else{

				}
			}
		}
	}
	OBSERVER.init();
// 20210219 개발팀 요청으로 추가
	var EVENT_BINDER = {
		bind: function (_callObj, _eventRootEl) {

			let $pageRoot = $(_eventRootEl);
			$pageRoot.find('[data-click], [data-change], [data-focus], [data-focusout], [data-keyup], [data-keydown], [data-focusin], [data-scroll]').each(function () {

				$(this).unbind();
				for ( let key in $(this).data()){

					let paramObj = undefined;

					if (key === 'change'){
						paramObj = {};
						paramObj.value = $(this).find("option:selected").val();
						paramObj.text = $(this).find("option:selected").text();
					}

					$(this).on(key, function (e) {
						let targetFunc = targetingFunc($(this).data()[key], _callObj);
						targetFunc.call(this, e, paramObj);
					});
				}

				OBSERVER.observe(_callObj, _eventRootEl);
			});

			function targetingFunc(targetFunctionName, _callObj) {
				let targetFunctionNames = targetFunctionName.split('.');
				let targetFunc = _callObj;
				for (let index in targetFunctionNames) {
					targetFunc = targetFunc[targetFunctionNames[index]];
				}
				return targetFunc;
			}
		}
	};*/

/************************************ EVENT_BINDER 추가 끝 ************************************/
