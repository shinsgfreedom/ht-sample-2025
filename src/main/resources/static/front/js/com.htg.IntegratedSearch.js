var __INTEGRATED_SEARCH_LIST_ITEM_TEMPLATE = [
	'<li>',
	'	<a href="javascript:void(0)" class="link inte-list-keyword" onclick="querySearchWord(event,\'{{:label}}\')"><span class="txt1">{{:label}}</span><span class="txt2">{{:date}}</span></a><a href="javascript:void(0)" class="btn-del" onclick="deleteSearchWord(\'{{:label}}\')">Delete</a>',
	'</li>'
];

com.htg.IntegratedSearch = (function() {
	function IntegratedSearch(jQuery, autocompleteDataset) {
		var self = this;
		var $ = jQuery;

		var searchSwitchOnOff = true;
		var autocompleteDataset = autocompleteDataset || [];
		
		var $autocompleteInstance;
		var $searchWordInput = $("#integrated_search_input");
		var $autocompleteSwitch = $('#btn_integrated_search_onoff');
		var $autocompleteContainer = $('.searchbox .resultbox .list');
		var $integratedSearchGo = $('#integrated_search_go');
		
		this.contextPath = CONTEXT_ROOT;
		
		this.init = function(option) {
			option = option || {};
			
			/* autocomplete enable/disable */
			if (!option.autocomplete) {
				this.switchToggle(true);
			}
			/* autocomplete-dataset */
			if (option.autocompleteDataset && Array.isArray(option.autocompleteDataset)) {
				_postInit(option.autocompleteDataset);
			} else {
				this.querySearchWord()
					.then(function(result) {
						autocompleteDataset = result.message || [];
						_postInit(autocompleteDataset);
					});
			}
			
			function _postInit(_autocompleteDataset) {
				autocompleteDataset = _autocompleteDataset.map(function(o) {
					return {'label': o.SEARCH_WORD, 'date': o.CREATE_DATE}
				});
				
				self.initAutocomplete();
				console.info('[IntegratedSearch] #_postInit completed - autocompleteDataset:', autocompleteDataset);
			}
		};
		
		this.querySearchWord =function() {
			return HTGF.Api.get(self.contextPath + '/api/search/integrated' ).then( function(result) {
			});
		};
		
		this.redraw = function(autocompleteDataset) {
			$autocompleteInstance._renderMenu($('<ul></ul>'), autocompleteDataset);
		};
		
		this.initAutocomplete = function() {
			
			$searchWordInput.autocomplete({
				minLength: 0,
				source: autocompleteDataset,
				create: function(event, ui) {
					console.log('[IntegratedSearch] #initAutocomplete - @@create:', ui);
					console.info('[IntegratedSearch] #initAutocomplete - autocompleteDataset:', autocompleteDataset);
					$autocompleteContainer.append($.templates(__INTEGRATED_SEARCH_LIST_ITEM_TEMPLATE.join('')).render(autocompleteDataset));
					
					// assign autocomplete instance
					$autocompleteInstance = $searchWordInput.autocomplete("instance");
					console.log('$autocompleteInstance',$autocompleteInstance)

					$autocompleteInstance._renderMenu = function(ul, items) {
						console.log('[IntegratedSearch] $autocompleteInstance._renderMenu ->', items);
						
						var self = this;
						$autocompleteContainer.empty();
						$.each(items, function(index, item) {
							self._renderItemData(ul, item);
						});
					}
					
					$autocompleteInstance._renderItem = function( ul, item ) {
						return $($.templates(__INTEGRATED_SEARCH_LIST_ITEM_TEMPLATE.join('')).render(item)).appendTo($autocompleteContainer);
					};
				},
				response: function(event, ui) {
					console.log('[IntegratedSearch] #initAutocomplete - @@reponse:',ui);
					if (ui.content.length === 0) {
						$autocompleteContainer.empty();
					}
				}
			});
		};
		
		this.deleteSearchWord = function(searchWord) {
			var targetWord;
			
			for (var index in autocompleteDataset) {
				targetWord = autocompleteDataset[index].label;
				console.log('[IntegratedSearch] #deleteSearchWord - item:', targetWord);
				
				if (searchWord === targetWord) {
					autocompleteDataset.splice(index, 1);
					console.log('[IntegratedSearch]  #deleteSearchWord - autocompleteDataset:', autocompleteDataset);
					self.redraw(autocompleteDataset)
					break;
				}
			}
			return HTGF.Api.delete(self.contextPath + '/api/search/integrated/'+searchWord).then( function(result) {
			
				autocompleteDataset = result.message || [];
				autocompleteDataset = autocompleteDataset.map(function(o) {
					return {'label': o.SEARCH_WORD, 'date': o.CREATE_DATE}
				});
 				
				$searchWordInput.val('').blur()
 				self.redraw(autocompleteDataset);
 				
 				return autocompleteDataset;
			});
		};
		
		this.searchWord = function(searchWord) {
			if (!searchWord) {
				return new Promise(function(resolve){ resolve('NOT_WORK'); });
			};
			
			/* add recent search word to dataset */
			var filtered = autocompleteDataset.filter(function(data) {
				return (data.label || '').toLowerCase() === searchWord.toLowerCase();
			});
			
			/* save recent serach word */
			if (searchSwitchOnOff && filtered.length === 0) {
				return HTGF.Api.post(self.contextPath + '/api/search/integrated' , searchWord ).then( function(result) {
				
					autocompleteDataset = result.message || [];
					autocompleteDataset = autocompleteDataset.map(function(o) {
						return {'label': o.SEARCH_WORD, 'date': o.CREATE_DATE}
					});
					
					self.redraw(autocompleteDataset);
					
					return autocompleteDataset;
				});
			} else {
				return new Promise(function(resolve) {
					resolve('NOT_WORK');
				});
			}
		};
		
		/* invoke Elastic API */
		this.invokeElasticApi = function(searchWord) {
			console.info('[IntegratedSearch] #invokeElasticApi - searchWord:', searchWord);
			return new Promise(function(resolve) {
				resolve(searchWord)
			});
		};
		
		this.switchToggle = function(init) {
			searchSwitchOnOff = !searchSwitchOnOff;
			
			if (searchSwitchOnOff) {
				$autocompleteSwitch.removeClass('off').addClass('on');
			} else {
				$autocompleteSwitch.removeClass('on').addClass('off');
			}
			
			$autocompleteContainer.css('display', searchSwitchOnOff ? 'block' : 'none');
			
			if (!init) {
				this.updateAutocompleteStatus();
			}
		};
		
		this.updateAutocompleteStatus = function(status) {
			var status = searchSwitchOnOff ? 'Y' : 'N';
			
			HTGF.Api.post(self.contextPath + self.contextPath + '/api/MAIN/save-userConfig' , {'autocomplete': status} ).then( function(result) {
			});
		};
		
		this.setAutocompleteData = function( dataSet ) {
			autocompleteDataset = dataSet || [];
			globalUserConfig.searchWords = autocompleteDataset; 
			self.redraw(autocompleteDataset);
		}
		
	}
	
	return IntegratedSearch;
})();