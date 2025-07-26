(function (W) {
	let SHEP_TAB = {}

	SHEP_TAB.TabRenderer = (function () {
		function assertThrow(expr, msg) {
			if (expr) throw msg
		}

		function swapArray(arr, sourceIdx, targetIdx) {
			if (sourceIdx === targetIdx || sourceIdx < 0 || targetIdx < 0) return
			let temp = arr[targetIdx]
			arr[targetIdx] = arr[sourceIdx]
			arr[sourceIdx] = temp
		}

		let TabRenderer = function (opts) {
			//    this.targetEl = $(opts.targetEl)
			this.targetTabEl = $(opts.targetTabEl)
			this.targetTabContEl = $(opts.targetTabContEl)

			assertThrow(!this.targetTabEl.length, 'Not found TargetEl [' + opts.targetTabEl + '] please check your DOM')
			assertThrow(!this.targetTabContEl.length, 'Not found TargetEl [' + opts.targetTabContEl + '] please check your DOM')

			this.tabs = opts.tabs || []
			this.maxTabCount = opts.maxTabCount || 8
			this.uiCache = {}
			this.selectedTabId = opts.selectedTabId || null
			let self = this
			HTGF.Api.get('/api/user/my-tabs/list').then(function (tabs) {
				if (tabs.length === 0) {
					if (self.tabs.length > 0) {
						let selectedTabId = opts.selectedTabId || null
						let selectedTab = selectedTabId ? self.tabs.find(function (v) {
							return v.id === selectedTabId
						}) : self.tabs[0]
						self.selectTab(selectedTab)
					}
				} else {
					self.tabs = tabs.sort(function (a,b) {
						if(a.sortNumber < b.sortNumber) return -1;
						if(a.sortNumber > b.sortNumber) return 1;
						if(a.sortNumber === b.sortNumber) return 0;
					})

					self.selectTab(self.tabs[0])
				}
			})
		}, fn = TabRenderer.prototype
		fn.zoompop = null
		fn.getSelectedTab = function () {
			if (!this.selectedId) return null
			let selectedId = this.selectedId
			return this.tabs.find(function (v) {
				return v.id === selectedId
			})
		}
		fn.loadTab = function () {
			let self = this
			HTGF.Api.get('/api/user/my-tabs/list').then(function (tabs) {
				self.tabs = tabs.sort(function (v) {
					return v.sortNumber
				})
				if (tabs.length > 0) self.selectTab(self.tabs[0])
			})
				.catch(HTGF.Api.commonErrorCb)
			return this
		}
		fn.saveTab = function () {
			HTGF.Api.post('/api/user/my-tabs/save', this.tabs).catch(HTGF.Api.commonErrorCb)
		}
		/**
		 * Tab 선택
		 * @param v
		 */
		fn.selectTab = function (v) {
			this.selectedTabId = v.id
			this.render()
			this.loadPage(v)
		}
		/**
		 * 새 창으로 tab 을 열고 tab 제거
		 * @param v
		 */
		fn.zoomTab = function (v) {
			HTGF.Popup(v.zoomUrl || url, {width: screen.width, height: screen.height}, function () {
				console.log('closed', v)
			}.bind(this));

			//기존 메인페이지의 탭제거 by sjjeon
			this.removeTab(v);
		}

		fn.addAndSelectTab = function (v) {
			if (this.tabs.length + 1 > this.maxTabCount) this.tabs.shift()
			let notExists = !this.tabs.some(function (t) {
				return t.id === v.id
			})
			if (notExists) this.tabs.push(v)
			this.tabs.forEach(function (v, i) {
				v.sortNumber = i
			})
			this.selectTab(v)
			this.saveTab()
		}
		fn.addOrReloadTab = function (v) {
			if (this.tabs.length + 1 > this.maxTabCount) this.tabs.shift()
			let notExists = !this.tabs.some(function (t) {
				return t.id === v.id
			})

			if(!notExists) this.removeTab(v)

			this.tabs.push(v)
			this.tabs.forEach(function (v, i) {
				v.sortNumber = i
			})
			this.selectTab(v)
			this.saveTab()
		}
		fn.removeTab = function (v) {
			let idx = this.tabs.findIndex(function (o) {
				return o.id === v.id
			})
			this.tabs.splice(idx, 1)
			//this.targetEl.find('ul [data-tab-id=' + v.id + ']').remove()
			//this.targetEl.find('.fc-tab-content [data-tab-id=' + v.id + ']').remove()
			this.targetTabEl.find('[data-tab-id=' + v.id + ']').remove()
			this.targetTabContEl.find('[data-tab-id=' + v.id + ']').remove()

			let selectedId = this.selectedTabId
			let notHasSelectedTab = !this.tabs.some(function (v) {
				return v.id === selectedId
			})
			if (notHasSelectedTab) {
				let lastTab = this.tabs[this.tabs.length - 1]
				if (lastTab) this.selectTab(lastTab)
			}

			//캐시삭제 추가 by sjjeon
			delete this.uiCache[v.id];

			this.saveTab()
		}
		fn.loadPage = function (v, forceUpdate) {
			let self = this, html = this.uiCache[v.id]
			if (!forceUpdate && html) return toggle()


			//let body = this.targetEl.find('.fc-tab-content')
			let body = this.targetTabContEl;
			HTGF.Backdrop.show()
			HTGF.Api.loadTemplate(v.url).then(function (d) {
				renderContent(d)
			})
				.catch(function (e) {
					console.error('html load error', e)
					renderContent('')
				})
				.finally(function () {
					HTGF.Backdrop.hide()
				})

			function renderContent(content) {
				//let contentEl = body.find('.fc-tab-content-item');
				//contentEl이 n개일때 새로고임후 다른탭이 모두 change되는 문제 수정modify by sjjeon
				let contentEl = body.find(".fc-tab-content-item[data-tab-id='" + v.id + "']");

				if (body.has('[data-tab-id=' + v.id + ']').length === 0) {
					contentEl = $('<div class="fc-tab-content-item">').attr('data-tab-id', v.id)
					body.append(contentEl)
				}
				//if (v.externalYn === 'Y') contentEl.empty().append('<iframe style="width:100%; height:1000px" src="' + v.url + '"/>')
				//else contentEl.empty().html(content)

				if (v.externalYn === 'Y') {
					contentEl.empty().append('<iframe id="ifr_' + v.id + '" data-id="' + v.id + '" scrolling="no" style="overflow-x:hidden; overflow-y:hidden; overflow:hidden; width:100%; min-height:500px;" src="' + v.url + '"/>')
				} else {
					contentEl.empty().html(content);
				}

				self.uiCache[v.id] = contentEl
				toggle()
			}

			function toggle() {
				//self.targetEl.find('.fc-tab-content-item').hide()
				//self.targetEl.find('.fc-tab-content-item[data-tab-id=' + v.id + ']').show()

				self.targetTabContEl.find('.fc-tab-content-item').hide()
				self.targetTabContEl.find('.fc-tab-content-item[data-tab-id=' + v.id + ']').show();
			}
		}
		fn.render = function () {
			//if (!this.targetEl.has('ul.fc-tab')) {
			//    this.targetEl.append($('<ul>').attr('class', 'fc-tab'))
			//        .append($('<div>').attr('class', 'fc-tab-content'))
			//}
			//let ul = this.targetEl.find('ul.fc-tab').empty()
			let ul = this.targetTabEl.empty()
			let self = this
			this.tabs.forEach(function (v, i) {
				let el = $($('#tab-item-tpl').html())
					.attr('data-tab-id', v.id)
				el.find('.title').text(I18(v.titleI18nId))

				//공통 ui에 맞춤
				if (self.selectedTabId === v.id) el.css({'background-color': v.bgColor}).attr('class', 'selected')

				if (v.pinnedYn === 'N') {
					el.find('[ref=pin]').addClass('fa-rotate-180')
					el.find('[ref=drag-bar]').show()
				} else {
					el.find('[ref=pin]').removeClass('fa-rotate-180')
					el.find('[ref=drag-bar]').hide()
				}

				if (v.fixedYn === 'Y') {
					el.find('.fc-tab-left-control').hide()
					el.find('[ref=close').hide()
					el.find('[ref=expand]').hide()
				} else {
					el.find('.fc-tab-left-control').show()
					el.find('[ref=close').show()
					el.find('[ref=expand]').show()
				}

				el.find('[ref=drag-bar]').mousedown(function (e) {
					let offset = el.position()
					let dx = e.pageX - offset.left
					let currentIdx = Number(i), DRAG_THRESHOLD = el.outerWidth() + 10
					el.css({opacity: 0})
					let placeholder = $('<li><div /><span class="title">' + I18(v.titleI18nId) + '</span><div /></li>')
						.attr('class', 'moving')
						.css({left: offset.left + 'px'})
					ul.append(placeholder)

					$('body').css('user-select', 'none')
					$(window).mousemove(function (e) {
						let px = e.pageX - dx
						// if (px < 10) return
						placeholder.css({left: px + 'px', 'z-index': 3})
						let idx = Math.ceil(placeholder.position().left / DRAG_THRESHOLD)

						let targetTab = self.tabs[idx - 1]

						// fixed tab 이면 이동 자체가 안되도록
						if (!targetTab || targetTab.pinnedYn === 'Y') return
						ul.children().eq(idx).before(el)
						swapArray(self.tabs, currentIdx, idx - 1)
						//console.log('changed', currentIdx, idx - 1, self.tabs[currentIdx].titleI18nId, targetTab && targetTab.titleI18nId, self.tabs.length)
						currentIdx = idx - 1
					})
					$(window).mouseup(function () {
						$(window).off('mousemove mouseup')
						$('body').css('user-select', '')
						el.css({opacity: 1})
						placeholder.remove()
						self.tabs.forEach(function (v, i) {
							v.sortNumber = i
						})
						self.saveTab()
					})
				})
				el.click(function () {
					self.selectTab(v)
				})
				el.find('[ref=pin]').click(function (e) {
					e.stopPropagation()
					v.pinnedYn = v.pinnedYn === 'Y' ? 'N' : 'Y'
					$(this).removeClass('fa-rotate-180')
					if (v.pinnedYn === 'N') $(this).addClass('fa-rotate-180')

					let fixedTabs = self.tabs.filter(function (v) {
						return v.pinnedYn === 'Y' || v.fixedYn === 'Y'
					})
					let normalTabs = self.tabs.filter(function (v) {
						return v.pinnedYn === 'N' && v.fixedYn === 'N'
					})
					self.tabs = fixedTabs.concat(normalTabs)
					self.render()
					self.saveTab()
				})
				el.find('[ref=close]').click(function (e) {
					e.stopPropagation()
					self.removeTab(v)
				})
				el.find('[ref=expand]').click(function (e) {
					e.stopPropagation()
					self.zoomTab(v)
				})
				el.find('[ref=refresh]').click(function (e) {
					e.stopPropagation()
					self.selectTab(v)
					self.selectedId = v.id
					self.render()
					self.loadPage(v, true)
				})
				ul.append(el)
			})
			return this
		}
		return TabRenderer
	})()

	W.SHEP_TAB = SHEP_TAB;
	return SHEP_TAB
})(window);