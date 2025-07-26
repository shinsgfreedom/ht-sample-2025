<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="${pageContext.request.contextPath}/common/js/commonUtile.js"></script>

<script src="${pageContext.request.contextPath}/webjars/flatpickr/4.6.9/dist/plugins/monthSelect/index.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/flatpickr/4.6.9/dist/plugins/monthSelect/style.css">

<style>
    
    /* ag-grid header align : center */
	.ag-header-cell-label {justify-content: center;}
    /* .ag-header-group-text {font-weight: bolder;} */
    /* .ag-header-group-cell-label {font-weight: bold;} */
    .header-read {
        background-color: #fce4d6 !important;
    }
    .header-read-if {
        background-color: #d3efff !important;
    }
    .header-read-calc {
        background-color: #fff8c2 !important;
    }
    .calc-read {
        background-color: #fff2cc !important;
    }
    .no-editable {
        /* background-color: #000000 !important; */
    }
    .cell-simul1 {
        background-color: #eef79e !important;
    }
    .cell-simul2 {
        background-color: #ffffff !important;
    }
    .cell-span-odd {
        /* background-color: #b3f5fd !important; */
        /* background-color: #f1f1f1 !important; */
        /* background-color: #fcfdfe !important; */
        background-color: #f7f7f7 !important;
    }
    .cell-span-even {
        background-color: #ffffff !important;

    }
	.show-cell {	  
        background-color: #eef79e  !important;
	  /* border-left: 1px solid lightgrey !important;
	  border-right: 1px solid lightgrey !important; */
	  border-bottom: 1px solid lightgrey !important; 
	}

	.diff-cell {	  
        background-color: #aaffaa  !important;
	  /* border-left: 1px solid lightgrey !important;
	  border-right: 1px solid lightgrey !important; */
	  /* border-bottom: 1px solid lightgrey !important;  */
	}
	.mandatory-cell {	  
        background-color: #ffe7e7  !important;
	  /* border-left: 1px solid lightgrey !important;
	  border-right: 1px solid lightgrey !important; */
	  /* border-bottom: 1px solid lightgrey !important;  */
	}
	.matter-issue-cell {	  
        background-color: #ece7ff  !important;
	  /* border-left: 1px solid lightgrey !important;
	  border-right: 1px solid lightgrey !important; */
	  /* border-bottom: 1px solid lightgrey !important;  */
	}
    /*
    .excel-header {
        background-color: #f5f7f7;
    }
    */
</style>
<script>
$(function(){
    const GRID_COMPONENTS = {
        makeCommonGridOptions : function(pPagination, pDomLayout, pPageType) {
            if(pPageType === 'New' || pPageType === 'Edit') {
                return {
                    // suppressContextMenu:false,
                    // suppressClipboardPaste:false,
                    pagination: pPagination,
                    domLayout: (pDomLayout) ? pDomLayout: 'autoHeight',
                    rowSelection: 'multiple',
                    rowModelType: 'clientSide',
                    enableRangeSelection: true,
                    onGridSizeChanged: function (params) {
                        params.api.sizeColumnsToFit()
                    },
                    onRangeSelectionChanged: function (params) {
                        var rangeSelection = params.api.getCellRanges();
                        if (!rangeSelection || rangeSelection.length === 0) {
                            return;
                        }

                        if (params.started && params.finished) {
                            var startRowIndex = rangeSelection[0].startRow.rowIndex;

                            params.api.forEachNodeAfterFilterAndSort(function (node, index) {
                                if (index === startRowIndex) {
                                    node.setSelected(!node.isSelected());
                                }
                            });

                        } else if (!params.started && params.finished) {
                            var startRowIndex = rangeSelection[0].startRow.rowIndex;
                            var endRowIndex = rangeSelection[0].endRow.rowIndex;

                            params.api.forEachNodeAfterFilterAndSort(function (node, index) {
                                if (index >= startRowIndex && index <= endRowIndex) {
                                    node.setSelected(true);
                                }
                            });
                        }
                    }
                    , defaultExportParams: {
                        processCellCallback: function(params) {
                            return GRID_COMPONENTS.getKeyValueCellRenderer(params);
                        }
                    }
                }
            } else {
                return {
                    // suppressContextMenu:fasle,
                    // suppressClipboardPaste:false,
                    pagination: pPagination,
                    domLayout: (pDomLayout) ? pDomLayout: 'autoHeight',
                    rowSelection: 'multiple',
                    rowModelType: 'clientSide',
                    // sideBar: {// pPageType 에 따른 sideBar option 변경.
                    //     toolPanels: ['columns', 'filters'],
                    // },
                    enableRangeSelection: true,
                    onGridSizeChanged: function (params) {
                        params.api.sizeColumnsToFit()
                    },
                    onRangeSelectionChanged: function (params) {
                        var rangeSelection = params.api.getCellRanges();
                        if (!rangeSelection || rangeSelection.length === 0) {
                            return;
                        }

                        if (params.started && params.finished) {
                            var startRowIndex = rangeSelection[0].startRow.rowIndex;

                            params.api.forEachNodeAfterFilterAndSort(function (node, index) {
                                if (index === startRowIndex) {
                                    node.setSelected(!node.isSelected());
                                }
                            });

                        } else if (!params.started && params.finished) {
                            var startRowIndex = rangeSelection[0].startRow.rowIndex;
                            var endRowIndex = rangeSelection[0].endRow.rowIndex;

                            params.api.forEachNodeAfterFilterAndSort(function (node, index) {
                                if (index >= startRowIndex && index <= endRowIndex) {
                                    node.setSelected(true);
                                }
                            });
                        }
                    }
                    , defaultExportParams: {
                        processCellCallback: function(params) {
                            return GRID_COMPONENTS.getKeyValueCellRenderer(params);
                        }
                    }
                }

            }

        },
        makeHdChkColDef : function() {
            return {
                checkboxSelection: true, headerCheckboxSelection: true , headerCheckboxSelectionFilteredOnly: true,
            }
        },
        makeHideColDef : function(pheaderName, pfield) {
            return {
                headerName: pheaderName, field: pfield, filter: false, hide:true
            }
        },
        makeColDef : function(pheaderName, pfield, pminWidth) {
            if(pminWidth > 0) {
                return {
                    headerName: pheaderName, field: pfield, minWidth: pminWidth
                }
            } else {
                return {
                    headerName: pheaderName, field: pfield
                }
            }
        },
        makeCodeCellRendererColDef : function(pheaderName, pfield, pminWidth) {
            return {
                ...this.makeColDef(pheaderName, pfield, pminWidth), cellStyle: {'textAlign': 'center'}, cellRenderer: 'codeCellRenderer',
                filter: 'agSetColumnFilter',
                filterParams: {
                    cellRenderer: 'codeCellRenderer'
                },
            }
        },
        makeNumberColDef : function(pheaderName, pfield, pminWidth, pfixed) {
            return {
                ...this.makeColDef(pheaderName, pfield, pminWidth), cellStyle: {'textAlign': 'right'}, valueFormatter: params => numberFormat(params, pfixed), //cellEditor: CAgGridCellEditor.getNumericCellEditor(),
            }
        },
        makeNoEditNumberColDef : function(pheaderName, pfield, pminWidth, pfixed) {
            return {
                ...this.makeColDef(pheaderName, pfield, pminWidth), cellStyle: {'textAlign': 'right'}, editable: false, valueFormatter: params => numberFormat(params, pfixed), //cellEditor: CAgGridCellEditor.getNumericCellEditor(),
            }
        },
        makePercentColDef : function(pheaderName, pfield, pminWidth, pfixed) {
            return {
                ...this.makeColDef(pheaderName, pfield, pminWidth), cellStyle: {'textAlign': 'right'}, valueFormatter: params => percentFormatter(params, pfixed), //cellEditor: CAgGridCellEditor.getNumericCellEditor(),
            }
        },
        makeNoEditColDef : function(pheaderName, pfield, pminWidth) {
            return {
                ...this.makeColDef(pheaderName, pfield, pminWidth), cellStyle: {'textAlign': 'left'}, editable: false,
            }
        },
        makePinnedNoEditColDef : function(pheaderName, pfield, pminWidth) {
            return {
                ...this.makeNoEditColDef(pheaderName, pfield, pminWidth), cellStyle: {'textAlign': 'left'}, pinned: 'left', 
            }
        },
        makePinnedNoEditColDefRowspan : function(pheaderName, pfield, pminWidth) {
            return {
                ...this.makePinnedNoEditColDef(pheaderName, pfield, pminWidth),
                ...this.makeRowSpan(),
            }
        },
        makeRowSpan : function(params) {
            return {
                rowSpan: this.getRowspan,
                // ...this.makeCellClassRules(),
            }
        },
        makeCellClassRules : function(params) {
            return {
                    cellClassRules: {
                        'cell-span-odd': this.oddRowSpan,
                        'cell-span-even': this.evenRowSpan,
                        // 'diff-cell': this.diffCellStyle,
                    },
                }
        },
        makeCellClassRulesFoamSealant : function(params) {
            if(this.noEditable) {
                return {
                    cellClassRules: {
                        'no-editable': this.noEditable,
                    },
                }
            } else {
                return {
                    cellClassRules: {
                        'cell-span-odd': this.oddRowSpan,
                        'cell-span-even': this.evenRowSpan,
                    },
                }
            }
        },
        getRowspan(params) {
            let cnt = 0;
            let isSame = true;
            let isMakeSpan = true;
            params.api.forEachNode(function(node, index){
                if(index >= params.node.rowIndex) {
                    if(params.data.rfqMasUid === node.data.rfqMasUid 
                        && params.data.year === node.data.year && isSame){
                        cnt++;    
                        isMakeSpan = true;                  	
                    } else {
                        isSame = false;
                        // return;
                    }
                // } else if(index < params.node.rowIndex
                //         && params.data.rfqMasUid === node.data.rfqMasUid
                //         && params.data.rfqSeq === node.data.rfqSeq)  {
                //     isMakeSpan = false;
                // }
                } else {
                    isMakeSpan = false;
                        // return;
                }
            });

            if(isMakeSpan){
                return cnt;
            } else {
                return 1;
            }
        },
        oddRowSpan(params) {
            // console.log('params.data.rfqSeq % 2', (Number(params.data.rfqSeq) % 2))
            if(params.data.rowSpanSeq) {
                return (Number(params.data.rowSpanSeq) % 2) ? false:true;
            } else {
                return (Number(params.data.rfqSeq) % 2) ? false:true;
            }
        },
        evenRowSpan(params) {
            // console.log('params.data.rfqSeq % 2', (Number(params.data.rfqSeq) % 2))
            if(params.data.rowSpanSeq) {
                return (Number(params.data.rowSpanSeq) % 2) ? true:false;
            } else {
                return (Number(params.data.rfqSeq) % 2) ? true:false;
            }
        },
        matterIssueCellStyle(params) {
            // console.log('params', params)
            // console.log('params.value', params.value);
            if(params.data.issueYn === 'Y') {
                return true;
            }
            return false;
        },
        mandatoryCellStyle(params) {
            if(params.data.mandatoryCellStyle) {
                // console.log('mandatoryCellStyle-params', params)
                // console.log('mandatoryCellStyle-params.value', params.value);
                // console.log('mandatoryCellStyle-params.data.mandatoryCellStyle', params.data.mandatoryCellStyle);
                if(params.value == undefined || params.value == '') {
                // console.log('mandatoryCellStyle-return', true)
                    return true;
                }
            } 
            
            return false;
        },
        diffCellStyle(params) {
            // console.log('params', params)
            // console.log('params.value', params.value);
            if(params.colDef.field === 'dept') {
                if(params.data.dept && params.data.dept.code.indexOf('│') > -1) {
                    return true;
                }
            } else {
                if(params.data[params.colDef.field]) {
                    if(params.data[params.colDef.field].toString().indexOf('│') > -1) {
                        return true;
                    }
                }
            }
            return false;
        },
        getDiffValueFixed2(params) {
            let val = GRID_COMPONENTS.getDiffValue(params);
            if(val == undefined || val == '') {
                val = 0;
            } else {
                val = COMMON_SCRIPT.getNumberToFixed2(val);
            }
            return val;
        },
        getDiffValue(params) {
            // if(params.colDef.field == 'imageUid') console.log('params', params)
            // console.log('params.value', params.value);
            let val = params.data[params.colDef.field];
            if(val) {
                if(val.toString().indexOf('│') > -1) {
                    return (val.split('│')[0] != 'null' ? val.split('│')[0] : '');
                }
            }
            return val;
        },
        getDiffValueVal(val) {
            if(val) {
                if(val.toString().indexOf('│') > -1) {
                    return (val.split('│')[0] != 'null' ? val.split('│')[0] : '');
                }
            }
            return val;
        },
        getCodeCellRenderer : function(params){
            // console.log('params', params)
            if(params.value){
                let val = params.value;
                if(params.value.indexOf('│') > -1) {
                    val = params.value.split('│')[0];
                }
                var code = CODE(val.trim());
                if(code) {
                    return code.codeName;            
                    // return code.i18n;            
                } else {
                    return val;
                }
            } else {
                return undefined;
            }				
        },
        isCostFoamSealantEditable(params) {
            // if(params.data.tireConstCode === 'BIZ_DVSN_TIRE_CONSTRUCTION_A'
            //     || params.data.tireConstCode === 'BIZ_DVSN_TIRE_CONSTRUCTION_S') {
            //     return true;
            // } else {
            //     return false;
            // }
            if(params.data.tlCode === 'BIZ_DVSN_T_L_A'
                || params.data.tlCode === 'BIZ_DVSN_T_L_C'
                || params.data.tlCode === 'BIZ_DVSN_T_L_S') {
                return true;
            } else {
                return false;
            }
        },
        noEditable(params) {
            return !this.isCostFoamSealantEditable;
        },
        // getCellClassRules(params) {
        //     console.log('params', params);
        //     return {
        //         'cell-span-odd': GRID_COMPONENTS.oddRowSpan(params),//oddRowSpan,//_this.oddRowSpan,
        //         'cell-span-even': GRID_COMPONENTS.evenRowSpan(params),//_this.evenRowSpan,
        //     }
        // },

        getCustomHeaderGroup : function() {
            function CustomHeaderGroup() {}

            CustomHeaderGroup.prototype.init = function (params) {
                this.params = params;
                this.eGui = document.createElement('div');
                this.eGui.className = 'ag-header-group-cell-label';
                this.eGui.innerHTML =
                    '' +
                    '<div class="customHeaderLabel">' +
                    this.params.displayName +
                    // '</div>' +
                    //// '<div class="customExpandButton"><i class="fa fa-arrow-right"></i></div>';
                    // '<div >' +
                    '    &nbsp;&nbsp;(<i class="far fa-square" style="opacity: 0.5; font-size: 1.5em; background-color: rgb(16, 91, 255);"></i>' +
                    '    <span>Main</span>' +
                    '    <i class="far fa-square" style="opacity: 0.5; font-size: 1.5em; background-color: rgb(85, 247, 0);"></i>' +
                    '    <span>Sub</span>)' +
                    '    <span>${I18["#OEM_TARGET_MARKET"]}</span>' +
                    '</div>';

                // this.onExpandButtonClickedListener = this.expandOrCollapse.bind(this);
                // this.eExpandButton = this.eGui.querySelector('.customExpandButton');
                // this.eExpandButton.addEventListener(
                // 'click',
                // this.onExpandButtonClickedListener
                // );

                // this.onExpandChangedListener = this.syncExpandButtons.bind(this);
                // this.params.columnGroup
                // .getOriginalColumnGroup()
                // .addEventListener('expandedChanged', this.onExpandChangedListener);

                // this.syncExpandButtons();
            };

            CustomHeaderGroup.prototype.getGui = function () {
                return this.eGui;
            };

            // CustomHeaderGroup.prototype.expandOrCollapse = function () {
            //     var currentState = this.params.columnGroup
            //         .getOriginalColumnGroup()
            //         .isExpanded();
            //     this.params.setExpanded(!currentState);
            // };

            // CustomHeaderGroup.prototype.syncExpandButtons = function () {
            //     function collapsed(toDeactivate) {
            //         toDeactivate.className =
            //             toDeactivate.className.split(' ')[0] + ' collapsed';
            //     }

            //     function expanded(toActivate) {
            //         toActivate.className = toActivate.className.split(' ')[0] + ' expanded';
            //     }

            //     if (this.params.columnGroup.getOriginalColumnGroup().isExpanded()) {
            //         expanded(this.eExpandButton);
            //     } else {
            //         collapsed(this.eExpandButton);
            //     }
            // };

            // CustomHeaderGroup.prototype.destroy = function () {
            //     this.eExpandButton.removeEventListener(
            //         'click',
            //         this.onExpandButtonClickedListener
            //     );
            // };

            return CustomHeaderGroup;
        },
        getCustomHeaderGroupExpand : function(doExpand) {
            function CustomHeaderGroup() {}

            CustomHeaderGroup.prototype.init = function (params) {
                this.params = params;
                this.eGui = document.createElement('div');
                this.eGui.className = 'ag-header-group-cell-label';
                this.eGui.innerHTML =
                    '' +
                    '<div class="customHeaderLabel">' +
                    this.params.displayName +
                    '</div>' +
                    '<div class="customExpandButton" style="cursor: pointer;"><i class="fa fa-arrow-right"></i></div>' +
                    '<div class="customExpandButtonDesc" style="display: inline-block;color: cornflowerblue;margin-left: 5px; cursor: pointer;">Expand</div>';

                this.onExpandButtonClickedListener = this.expandOrCollapse.bind(this);
                this.eExpandButton = this.eGui.querySelector('.customExpandButton');
                this.buttonText = this.eGui.querySelector('.customExpandButtonDesc');
                this.eExpandButton.addEventListener('click',this.onExpandButtonClickedListener);
                this.buttonText.addEventListener('click',this.onExpandButtonClickedListener);

                this.onExpandChangedListener = this.syncExpandButtons.bind(this);
                this.params.columnGroup.getOriginalColumnGroup().addEventListener('expandedChanged', this.onExpandChangedListener);

                if(doExpand && !this.params.columnGroup.isExpanded()){
                    this.params.setExpanded(true);
                }

                this.syncExpandButtons();
            };

            CustomHeaderGroup.prototype.getGui = function () {
                return this.eGui;
            };

            CustomHeaderGroup.prototype.expandOrCollapse = function () {
                var currentState = this.params.columnGroup.getOriginalColumnGroup().isExpanded();
                this.params.setExpanded(!currentState);
                this.params.api.sizeColumnsToFit();
            };

            CustomHeaderGroup.prototype.syncExpandButtons = function () {
                function collapsed(toDeactivate) {
                    toDeactivate.className =
                        toDeactivate.className.split(' ')[0] + ' collapsed';
                }

                function expanded(toActivate) {
                    toActivate.className = toActivate.className.split(' ')[0] + ' expanded';
                }

                if (this.params.columnGroup.getOriginalColumnGroup().isExpanded()) {
                    expanded(this.eExpandButton);
                    this.buttonText.textContent = 'Close';
                } else {
                    collapsed(this.eExpandButton);
                    this.buttonText.textContent = 'Expand';
                }
            };

            CustomHeaderGroup.prototype.destroy = function () {
                this.eExpandButton.removeEventListener('click',this.onExpandButtonClickedListener);
            };

            return CustomHeaderGroup;
        },
        getTargetMarketCheckRenderer : function(isEditable){
            function CheckboxRenderer() {}

            CheckboxRenderer.prototype.init = function(params) {
                this.params = params;
                this.eGui = document.createElement('div');                  
                var itag = document.createElement('i');
                itag.classList.add('far');
                itag.classList.add('fa-square');
                itag.style.opacity = '0.5';
                itag.style.fontSize = '1.5em';
                switch(params.value){
                case 'BIZ_DVSN_MARKET_TYPE_M':
                    itag.style.backgroundColor = '#105bff';//opacity:0.8;
                    break;
                case 'BIZ_DVSN_MARKET_TYPE_S':
                    itag.style.backgroundColor = '#55f700';
                    break;                    
                default:
                    itag.style.backgroundColor = '';
                }
                
                if(isEditable){                    
                    this.checkedHandler = this.checkedHandler.bind(this);                    
                    this.eGui.addEventListener('click', this.checkedHandler);
                    params.eGridCell.addEventListener('click', this.checkedHandler);
                } 

                this.eGui.appendChild(itag);
                
                params.eGridCell.addEventListener('dblclick', this.stopdblClickHandler);
            }

            CheckboxRenderer.prototype.stopdblClickHandler = function(e) {
                e.stopImmediatePropagation();
            }

            CheckboxRenderer.prototype.checkedHandler = function(e) {                    
                //var checked = e.target.checked ? 'Y': 'N';
                let _this = this;
                let colId = this.params.column.colId;
                // console.log('colId', colId);
                let newValue = undefined;
                //Main Market 선택 여부 체크
                let targetMarketMain = GRID_COMPONENTS.getTargetMarketMain(this.params);

                if(targetMarketMain) {
                    switch(this.params.data[colId]){
                    case 'BIZ_DVSN_MARKET_TYPE_S':
                        newValue = 'N';
                        break;                    
                    default:
                        newValue = 'BIZ_DVSN_MARKET_TYPE_S';
                    } 
                } else {
                    switch(this.params.data[colId]){
                    case 'BIZ_DVSN_MARKET_TYPE_M': 
                        newValue = 'BIZ_DVSN_MARKET_TYPE_S';                       
                        break;
                    case 'BIZ_DVSN_MARKET_TYPE_S':
                        newValue = 'N';
                        break;                    
                    default:
                        newValue = 'BIZ_DVSN_MARKET_TYPE_M';
                    } 

                }
                /*
                switch(this.params.data[colId]){
                case 'BIZ_DVSN_MARKET_TYPE_M': 
                    newValue = 'BIZ_DVSN_MARKET_TYPE_S';                       
                    break;
                case 'BIZ_DVSN_MARKET_TYPE_S':
                    newValue = 'N';
                    break;                    
                default:
                    newValue = 'BIZ_DVSN_MARKET_TYPE_M';
                } 
                */
                this.params.node.setDataValue(colId, newValue);
                e.stopImmediatePropagation();
            }

            CheckboxRenderer.prototype.getGui = function(params) {
                return this.eGui;
            }

            CheckboxRenderer.prototype.destroy = function(params) {
                this.eGui.removeEventListener('click', this.checkedHandler);
                this.eGui.removeEventListener('dblclick', this.stopdblClickHandler);
            }

            return CheckboxRenderer;
        }, 
        getTargetMarketMain : function(params) {
            let _this = this;
            const markColId = ['markNaCode','markSaCode','markEuCode','markMeCode','markAfriCode'
                            ,'markApCode','markCnCode','markAseaCode','markIndiCode','markKrCode'];
            let targetMarketMain = false;
            markColId.forEach((o) => {                    
                if(params.data[o] == 'BIZ_DVSN_MARKET_TYPE_M')  {
                    targetMarketMain = true;
                }
            })  
            return targetMarketMain;
        },
        getKeyValueCellRenderer : function(params){
            // console.log('getKeyValueCellRenderer params :: ' , params);
            if(!params.value)
                return '';
            if(!CODE(params.value))
                return params.value;
            return CODE(params.value).codeName;
        },
        getValueKeyCellRenderer : function(params) {
            if(params.column.userProvidedColDef.cellRenderer === 'codeCellRenderer'){
                var values = params.column.userProvidedColDef.cellEditorParams.values;
                var code;
                if(values.some(function(value){
                    var codeObj = CODE(value);
                    if(codeObj && (codeObj.property1 === params.value || codeObj.codeName === params.value)){
                        code = codeObj.code;
                        return true;
                    }                            
                })) { 
                    return code;
                } 
            }
            // console.log('params :: ' , params);
            return params.value;
        },
        getCellEditorParamValues(code, canEmpty){
            function codeSort(a, b){
                if(a.codeName > b.codeName) {
                    return 1; 
                }

                if(a.codeName < b.codeName) {
                    return -1; 
                }
                return 0; 
            }
            var list = HTGF.UTILS.getCodes(code).sort(codeSort).map(function(element){
                // console.log('element', element)
                // return element.codeName;// 추가 수정 부분.
                return element.code;
            });
            if(canEmpty){
                list.splice(0,0,'');
            }

            if(code === 'BIZ_DVSN_INCOTERMS') {
                // console.log('BIZ_DVSN_INCOTERMS', list);
                // NONE 코드를 맨 위로 올리기.
                list = [...new Set(['BIZ_DVSN_INCOTERMS_NONE'])];
                // list = [...new Set(['BIZ_DVSN_INCOTERMS_NONE', ...list])];
                // console.log('BIZ_DVSN_INCOTERMS', list)
                
            }
            
            return list;
            // return list.sort();
        },
        getImageCellRenderer : function(isEditable){
            
            function ImageCellRenderer() {}

            ImageCellRenderer.prototype.init = function(params) {
                this.params = params;
                // console.log('init.param', params)
                // console.log('init.params.value', params.value)
                
                this.eGui = document.createElement('div');
                
                //TODO params.value 가 undefined 인 이유는???
                // if(params.value){
                if(params.data.imageUid){
                    let imageUid = GRID_COMPONENTS.getDiffValue(params);
                    // image
                    var imageTag = document.createElement('img');
                    // imageTag.src = '${pageContext.request.contextPath}/api/file/download/'+params.value;
                    // imageTag.src = '${pageContext.request.contextPath}/api/file/download/'+params.data.imageUid;
                    imageTag.src = '${pageContext.request.contextPath}/api/file/download/'+imageUid;
                    imageTag.style.height = 100;
                    this.eGui.appendChild(imageTag);

                    if(isEditable){
                        var deleteTag = document.createElement('i');
                        deleteTag.className = 'fa fa-trash fa-2x';
                        deleteTag.style.position = 'absolute';
                        deleteTag.style.top = 20;
                        deleteTag.style.left = 20;                                                
                        this.eGui.appendChild(deleteTag);
                        deleteTag.addEventListener('click', this.imageDeleteHandler.bind(this));
                    }
                } else {
                    if(isEditable){
                        var spanTag = document.createElement('span');
                        spanTag.innerHTML = 'Click Me to..';
                        this.eGui.appendChild(spanTag);
                    }
                }

                var fileTag = document.createElement('input');
                fileTag.type = 'file';
                fileTag.style.display = 'none';
                this.eGui.appendChild(fileTag);                	

                if(isEditable){
                    params.eGridCell.addEventListener('click', this.clickHandler);
                    fileTag.addEventListener('change', this.changeHandler.bind(this));
                }
                /* 
                
                this.eGui = document.createElement('input');                  
                this.eGui.type = 'checkbox';
                                    
                this.eGui.checked = params.value === 'Y' ? true : false;
                this.checkedHandler = this.checkedHandler.bind(this);                    
                params.eGridCell.addEventListener('click', this.clickHandler); */
            }

            ImageCellRenderer.prototype.imageDeleteHandler = function(e) {                   
                e.stopImmediatePropagation();
                /* var imageViewArea = e.target.closest('div');
                var imgTag = $(imageViewArea).find('img');
                if(imgTag) imgTag.remove();
                $(e.target).remove(); */
// console.log('this.params.column.colId', this.params.column.colId)
            // console.log('this.params.node.data.imageUid', this.params.node.data.imageUid)
                if(this.params.node.data.imageUidDeleted) {

                } else {
                    this.params.node.data.imageUidDeleted = '';
                }
                this.params.node.data.imageUidDeleted += (this.params.node.data.imageUid + ',');
                // console.log('this.params.node.data.imageUidDeleted', this.params.node.data.imageUidDeleted)
                // if(this.params.node.data.rowStatus === 'R') this.params.node.data.rowStatus = 'U';
                // this.params.node.data[this.params.column.colId] = undefined;
                this.params.node.data['imageUid'] = undefined;
                this.params.api.refreshCells({
                    force: true
                });
                this.params.api.resetRowHeights();                                       
            }

            ImageCellRenderer.prototype.changeHandler = function(e) {                    
                e.preventDefault();

                var _this = this;
                
                var uuid = this.params.node.data.pgmInfoUid ? this.params.node.data.pgmInfoUid : HTGF.UTILS.uuid();
                
                var formData = new FormData()
                formData.append('file', e.currentTarget.files[0]);
                formData.append('workId', uuid);
                formData.append('category', 'PMC');
                HTGF.Api.postUpload('/api/file/upload', formData).then(function(data) {
                    // console.log('data', data)
                    // console.log('_this.params', _this.params)
                    // _this.params.node.data[_this.params.column.colId] = data.id;
                    if(_this.params.node.data['rowStatus'] == 'R') {
                        _this.params.node.data['rowStatus'] = 'U';
                    }
                    _this.params.node.data['imageUid'] = data.id;
                    _this.params.api.refreshCells({
                        force: true,
                        columns: [_this.params.column.colId],
                        rowNodes: [_this.params.node]
                    });
                    _this.params.api.resetRowHeights();                    	
                }).catch(function(e){
                    console.log(e);
                    alert("Fail to upload Image.");
                });
            }

            ImageCellRenderer.prototype.clickHandler = function(e) {
                var fileTag = e.currentTarget.querySelector('input');
                if(fileTag){
                    $(fileTag).trigger('click');
                }               	                    
            }

            ImageCellRenderer.prototype.getGui = function(params) {
                return this.eGui;
            }

            ImageCellRenderer.prototype.destroy = function(params) {
                if(this.eGui){
                    this.eGui.removeEventListener('click', this.checkedHandler);
                }
            }

            return ImageCellRenderer;
        },
        // getUserCellEditor : function(){
        //     function UserCellEditor() {}

        //     UserCellEditor.prototype.init = function(params) {
        //         this.params = params;
        //         this.eGui = document.createElement('input');
        //         this.eGui.setAttribute("type", "text");
                
        //         if (params.keyPress && params.keyPress === 46) {                    	
        //             this.params.value = undefined;
        //             return;
        //         }
                
        //         HTGF.Popup('${pageContext.request.contextPath}/common/popup/user-dept-search.html?mode=USER', {
        //             id: 'popup-user-dept-search',
        //             width: 740, height: 900
        //         }, function(res) {
        //             //console.log('user-dept-search', res)
        //             // res.data.users
        //             //res.data.depts
        //             //setTargetData(__this.targetData, res.data);
        //             if(res.data.users[0]){

        //                 if(this.params.column.colId === 'leader') {
        //                     this.params.data.leader = {
        //                         name : res.data.users[0].userdata.name,
        //                         managerId : res.data.users[0].userdata.empNo,
        //                     };
        //                 } else {
        //                     this.params.data.manager = {
        //                         name : res.data.users[0].userdata.name,
        //                         managerId : res.data.users[0].userdata.empNo,
        //                     }; 
        //                 }	                        

        //                 this.params.api.refreshCells({
        //                     force: true,
        //                     columns: [this.params.column.colId],
        //                     rowNodes: [this.params.node]
        //                 });
        //             }
        //         }.bind(this));                                     
        //     }                

        //     UserCellEditor.prototype.getGui = function(params) {
        //         return this.eGui;
        //     }

        //     UserCellEditor.prototype.afterGuiAttached = function() {
        //         this.eGui.focus();
        //     };

        //     UserCellEditor.prototype.getValue = function() {                    
        //         //return this.eGui.value;
        //         return this.params.value;
        //     };

        //     UserCellEditor.prototype.destroy = function(params) {                    
        //     }

        //     UserCellEditor.prototype.isPopup = function() {
        //         return false;
        //     };
            
        //     return UserCellEditor;               
        // },
        // getUserCellRenderer : function(params){
        //     var spanElement = document.createElement('span');
        //     spanElement.classList.add('ag-grid-cell-text-overflow');
        //     spanElement.innerText = params.value ? params.value.name : '';

        //     return spanElement;                               
        // },
        getDeptCellEditor : function(){
            function DeptCellEditor() {}

            DeptCellEditor.prototype.init = function(params) {
                this.params = params;
                this.eGui = document.createElement('input');
                this.eGui.setAttribute("type", "text");
                
                if (params.keyPress && params.keyPress === 46) {                    	
                    this.params.value = undefined;
                    return;
                }
                
                HTGF.Popup('${pageContext.request.contextPath}/common/popup/user-dept-search.html?mode=DEPT', {
                    id: 'popup-user-dept-search',
                    width: 740, height: 900
                }, function(res) {
                    //console.log('user-dept-search', res)
                    // res.data.users
                    //res.data.depts
                    //setTargetData(__this.targetData, res.data);
                    // console.log('this.params', this.params)
                    // console.log('res.data.depts', res.data.depts)
                    if(res.data.depts[0]){
                        this.params.data.deptCode = res.data.depts[0].id;
                        this.params.data.deptName = res.data.depts[0].name;
                        this.params.data.dept = {
                            code: res.data.depts[0].id,
                            name: res.data.depts[0].name,
                        }
                        if(this.params.data.rowStatus === 'R') {
                            this.params.data.rowStatus = 'U';
                        }

                        // if(this.params.column.colId === 'dept') {
                        //     this.params.data.dept = {
                        //         name : res.data.depts[0].userdata.name,
                        //         managerId : res.data.users[0].userdata.empNo,
                        //     };
                        // } else {
                        //     this.params.data.manager = {
                        //         name : res.data.users[0].userdata.name,
                        //         managerId : res.data.users[0].userdata.empNo,
                        //     }; 
                        // }	                        
// console.log('this.params', this.params)

                        this.params.api.refreshCells({
                            force: true,
                            columns: [this.params.column.colId],
                            rowNodes: [this.params.node]
                        });
                    }
                }.bind(this));                                     
            }                

            DeptCellEditor.prototype.getGui = function(params) {
                return this.eGui;
            }

            DeptCellEditor.prototype.afterGuiAttached = function() {
                this.eGui.focus();
            };

            DeptCellEditor.prototype.getValue = function() {                    
                //return this.eGui.value;
                return this.params.value;
            };

            DeptCellEditor.prototype.destroy = function(params) {                    
            }

            DeptCellEditor.prototype.isPopup = function() {
                return false;
            };
            
            return DeptCellEditor;               
        },
        getDeptCellRenderer : function(params){
            // console.log('params', params)
            var spanElement = document.createElement('span');
            spanElement.classList.add('ag-grid-cell-text-overflow');
            spanElement.innerText = params.value ? params.value.name : '';

            return spanElement;                               
        },
        getDateCellEditor : function(params){
            function DateCellEditor() {}

            DateCellEditor.prototype.init = function(params) {
                this.params = params;
                this.eGui = document.createElement('input');
                this.eGui.setAttribute("type", "text");

                //this.eGui.value = params.value;
                
                $(this.eGui).flatpickr({
                    // mode: "range",
                    //minDate: 'today',
                    dateFormat: 'Ymd',
                    // dateFormat: 'Y-m-d',
                    // dateFormat: 'Ym',
                    // defaultDate: [params.value.startDate, params.value.endDate],
                    defaultDate: params.value,
                    onClose: function(selectedDates, dateStr, instance){
                        // console.log('(selectedDates, dateStr, instance)', selectedDates, dateStr, instance)
                        // this.params.value.startDate = selectedDates[0];
                        // this.params.value.endDate = selectedDates[1];
                        // this.params.value.duration = (new Date(this.params.value.endDate) - new Date(this.params.value.startDate)) / (1000*24*60*60);
                        // this.params.node.setDataValue(this.params.column.colId, Object.assign({}, this.params.value));                                
                        this.params.node.setDataValue(this.params.column.colId, dateStr);                                
                    }.bind(this),
                    
                    // plugins: [
                    //     new monthSelectPlugin({
                    //     // shorthand: true, //defaults to false
                    //     dateFormat: "Y.m", //defaults to "F Y"
                    //     // altFormat: "F Y", //defaults to "F Y"
                    //     // theme: "dark" // defaults to "light"
                    // // defaultDate: '2023.01',
                    //     })
                    // ],
                });
            }                

            DateCellEditor.prototype.getGui = function(params) {
                return this.eGui;
            }

            DateCellEditor.prototype.afterGuiAttached = function() {
                this.eGui.focus();
            };

            DateCellEditor.prototype.getValue = function() {                    
                return this.eGui.value;
            };

            DateCellEditor.prototype.destroy = function(params) {                    
            }

            DateCellEditor.prototype.isPopup = function() {
                return false;
            };
            
            return DateCellEditor;               
        }  ,
        getDateMonthCellEditor : function(params){
            function DateMonthCellEditor() {}

            DateMonthCellEditor.prototype.init = function(params) {
                this.params = params;
                this.eGui = document.createElement('input');
                this.eGui.setAttribute("type", "text");

                //this.eGui.value = params.value;
                
                $(this.eGui).flatpickr({
                    // mode: "range",
                    //minDate: 'today',
                    // dateFormate: 'Y-m-d',
                    dateFormat: 'Ym',
                    // defaultDate: [params.value.startDate, params.value.endDate],
                    defaultDate: params.value,
                    onClose: function(selectedDates, dateStr, instance){
                        // console.log('(selectedDates, dateStr, instance)', selectedDates, dateStr, instance)
                        // this.params.value.startDate = selectedDates[0];
                        // this.params.value.endDate = selectedDates[1];
                        // this.params.value.duration = (new Date(this.params.value.endDate) - new Date(this.params.value.startDate)) / (1000*24*60*60);
                        // this.params.node.setDataValue(this.params.column.colId, Object.assign({}, this.params.value));                                
                        this.params.node.setDataValue(this.params.column.colId, dateStr);                                
                    }.bind(this),
                    
                    plugins: [
                        new monthSelectPlugin({
                        // shorthand: true, //defaults to false
                        dateFormat: "Y.m", //defaults to "F Y"
                        // altFormat: "F Y", //defaults to "F Y"
                        // theme: "dark" // defaults to "light"
                    // defaultDate: '2023.01',
                        })
                    ],
                });
            }                

            DateMonthCellEditor.prototype.getGui = function(params) {
                return this.eGui;
            }

            DateMonthCellEditor.prototype.afterGuiAttached = function() {
                this.eGui.focus();
            };

            DateMonthCellEditor.prototype.getValue = function() {                    
                return this.eGui.value;
            };

            DateMonthCellEditor.prototype.destroy = function(params) {                    
            }

            DateMonthCellEditor.prototype.isPopup = function() {
                return false;
            };
            
            return DateMonthCellEditor;               
        }  ,
        // getDateCellEditor : function() {
            
        //     function DateCellEditor() {}
            
        //     DateCellEditor.prototype.init = function(params) {
        //         this.params = params;
                
        //         // create the cell
        //         this.eInput = document.createElement('input');
        //         // let tDate = params.value.split('.');
        //         // this.eInput.value = new Date([tDate[0], tDate[0], 1]);
        //         // this.eInput.value = dateFormatterSop(params);
        //         this.eInput.value = params.value;
        //         this.eInput.classList.add('ag-input');
        //         // this.eInput.classList.add('flatpickr-input');
        //         this.eInput.style.height = '100%';

        //         // $(this.eInput).datepicker({
        //         $(this.eInput).flatpickr({
        //             dateFormat: 'Ym',
        //             // wrap: true,
        //             onChange: function(selectedDates, dateStr, instance) {
        //                 this.value = selectedDates;
        //                 params.value = dateStr;
        //                 console.log('this.value', this.value, dateStr);
        //                 console.log('params.column.colId', params.column.colId);
        //                 console.log('params.node', params.node);
        //                 params.api.refreshCells({
        //                     force: true,
        //                     columns: [params.column.colId],
        //                     rowNodes: [params.node]
        //                 });
        //                 // this.getValue();
        //                 this.params.node.setValue(this.params.value);                                
                    
        //             },
        //             // defaultDate: params.value,
        //             defaultDate: this.value,
        //             // onSelect: () => {
        //             //     this.eInput.focus();
        //             // },
        //             // plugins: [
        //             //     new monthSelectPlugin({
        //             //     // shorthand: true, //defaults to false
        //             //     dateFormat: "Y.m", //defaults to "F Y"
        //             //     // altFormat: "F Y", //defaults to "F Y"
        //             //     // theme: "dark" // defaults to "light"
        //             // defaultDate: '2023.01',
        //             //     })
        //             // ]
        //         });
                
        //     }                

        //     DateCellEditor.prototype.getGui = function(params) {
        //         // return this.eGui;
        //             return this.eInput;
        //     }

        //     DateCellEditor.prototype.afterGuiAttached = function() {
        //         // this.eGui.focus();
        //             this.eInput.focus();
        //             this.eInput.select();
        //     };

        //     DateCellEditor.prototype.getValue = function() {                    
        //         //return this.eGui.value;
        //         console.log('getValue', this.params.value)
        //         return this.params.value;
        //         // console.log('this.eInput.value', this.eInput.value)
        //         //     return this.eInput.value;
        //     };

        //     DateCellEditor.prototype.destroy = function(params) {                    
        //     }

        //     DateCellEditor.prototype.isPopup = function() {
        //         return false;
        //     };
            
        //     return DateCellEditor; 
        // },
        // getDateCellRenderer : function(params){
        //     console.log('params', params)
        //     var spanElement = document.createElement('span');
        //     spanElement.classList.add('ag-grid-cell-text-overflow');
        //     spanElement.innerText = params ? params.value : '';

        //     return spanElement;                               
        // },
        strToMonthFormatter2: function(params){
            var val = params.value;
            if ( COMMONJS.isNotEmpty( val ) ){
                return val.substring(0,2) + '.' + val.substring(2, 4);
            }
        },
        strToMonthFormatter4: function(params){
            var val = params.value;
            if ( COMMONJS.isNotEmpty( val ) ){
                return val.substring(0,4) + '.' + val.substring(4, 6);
            }
        },
        getRfqDelRenderer: function(params){
            var rowData = params.data;
            if (rowData.delYn === 'Y') {
                return {color: 'red'};
            }
            return null;
        },
        getTooltipRenderer : function(innerText, title){

            if(innerText){
                let val = innerText;
                if(innerText.indexOf('│') > -1) {
                    val = innerText.split('│')[0];
                }
                var code = CODE(val.trim());
                if(code) {
                    innerText = code.codeName;            
                // } else {
                //     return val;
                }
                
                var spanElement = document.createElement('span');
                spanElement.classList.add('ag-grid-cell-text-overflow');
                spanElement.innerText = val;                    
                spanElement.title = title;
                return spanElement;
            } else {
                return undefined;
            }
        },
        dateFormatter(params){
            let ret = null;
            if(params.data[params.colDef.field]) {
                let val = dateReplace(params.data[params.colDef.field]);
                switch(val.length) {
                    case 6 : ret = val.substring(0,4) + '.' + val.substring(4);break;
                    case 8 : ret = val.substring(0,4) + '.' + val.substring(4, 6) + '.' + val.substring(6);break;
                    default : ret = val;break;
                }
                return params.data[params.colDef.field] = ret;
            }else {
                return '';
            }
            
        }
    }

    window.GRID_COMPONENTS = GRID_COMPONENTS;

});

function numberFormat(params, fixed){
    // if(params.column.colId === 'othrSalesCostQty')     console.log('params.value', params)
    if(params.value == undefined || params.value == '') {
        return 0;
    }else {
        let val = params.value.toString();//.replaceAll(',', '').replaceAll(' ', '');
        if(val.indexOf('│') > -1) {
            val = val.split('│')[0];
        }
        if(fixed) {
            return Number(val).toFixed(fixed).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        } else {
            return Number(val).toFixed().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
    }
}
function numberFormatNull(params, fixed){
    if(params.value == undefined || params.value == '') {
        return undefined;
    }else {
        numberFormat(params, fixed);
    }
}
function dateFormatter(params){
    if(!params.value) {
        return '';
    }else {
        return moment(params.value, "YYYY-MM-DD HH:mm:ss").format("YYYY-MM-DD HH:mm");
    }
}
function dateFormatterByDot(params){
    if(!params.value) {
        return '';
    }else {
        let val = dateReplace(params.value);
        if(val.length > 6) {
            return val.substring(0,4) + '.' + val.substring(4, 6) + '.' + val.substring(6);
        } else {
            return params.value;
        }
    }
}
function dateFormatterSop(params){
    if(!params.value) {
        return '';
    }else {
        let val = dateReplace(params.value);
        if(val.length > 4) {
            return val.substring(0,4) + '.' + val.substring(4);
        } else {
            return params.value;
        }
    }
}
// var date = new Date('2022','06','01');
//         var day = date.getDate().toString().padStart(2, '0');
//         var month = (date.getMonth() + 1).toString().padStart(2, '0');
//         var year = date.getFullYear().toString();
//         console.log( year + '.' + month );
function dateReplace(value){
    return value.toString().replaceAll('.', '').replaceAll('-', '').replaceAll('/', '');
}
function percentFormatter(params, fixed){    
    // let val=0;
    // if(params.value == undefined || params.value == '') {
    //     val = '0';
    // }else {
    //     val=Number(params.value) * 100;
    //     if(fixed) {
    //         val = Number(val).toFixed(fixed).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    //     } else {
    //         val = Number(val).toFixed().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    //     }
    // }
    // return val + '%';
    return numberFormat(params, fixed) + '%';
}
function percent100Formatter(params, fixed){    
    let val=0;
    if(params.value == undefined || params.value == '') {
        val = '0.00';
    }else {
        val=Number(params.value) * 100;
    }
    if(fixed) {
        val = Number(val).toFixed(fixed).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    } else {
        val = Number(val).toFixed().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
    return val + '%';
    // return numberFormat(params, fixed) + '%';
}

const CELL_CLASS_RULES = {
    'diff-cell': (params) => GRID_COMPONENTS.diffCellStyle(params),
    'cell-span-odd': (params) => GRID_COMPONENTS.oddRowSpan(params),
    'cell-span-even': (params) => GRID_COMPONENTS.evenRowSpan(params),
    'matter-issue-cell': (params) => GRID_COMPONENTS.matterIssueCellStyle(params),
}
</script>