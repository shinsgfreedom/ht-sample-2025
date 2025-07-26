<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/common/js/commonUtile.js"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/lodash.min.js"></script>
<!-- <script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script> -->

<script src="${pageContext.request.contextPath}/webjars/flatpickr/4.6.9/dist/plugins/monthSelect/index.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/flatpickr/4.6.9/dist/plugins/monthSelect/style.css">

<!-- <script src="https://cdn.jsdelivr.net/npm/ag-grid-enterprise@31.3.4/dist/ag-grid-enterprise.min.noStyle.js"></script>
<link href="https://cdn.jsdelivr.net/npm/ag-grid-enterprise@31.3.4/styles/ag-grid.min.css" rel="stylesheet"> -->
<!-- <script src="https://cdn.jsdelivr.net/npm/ag-grid-charts-enterprise@31.3.4/dist/ag-grid-charts-enterprise.js"></script>
<link href="https://cdn.jsdelivr.net/npm/ag-grid-charts-enterprise@31.3.4/styles/ag-grid.min.css" rel="stylesheet"> -->
<!-- 31.3.4 >
<script src="/ag_grid/ag-grid-enterprise.min.noStyle.js"></script>
<link href="/ag_grid/styles/ag-grid.min.css" rel="stylesheet">
<link href="/ag_grid/styles/ag-theme-alpine.min.css" rel="stylesheet">
<link href="/ag_grid/styles/ag-theme-balham.min.css" rel="stylesheet"-->
<style>

    /* ag-grid header align : center */
	.ag-header-cell-label {justify-content: center;}
    /* .ag-header-group-text {font-weight: bolder;} */
    /* .ag-header-group-cell-label {font-weight: bold;} */
    .header-read {
        background-color: #fce4d6 !important;
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
	/* .show-cell {	  
        background-color: #eef79e  !important;
	    border-bottom: 1px solid lightgrey !important; 
	} */
    .show-cell {        
        background-color:inherit;
        border-bottom: 1px solid lightgrey !important; 
        align-content: center;
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
</style>
<script>
$(function(){
    const AG_GRID = {
        myTransaction : {
            add: [],   
            update: [],
            remove: []
        },
    // };
    // AG_GRID.UTILS = {        
        makeGridOptions : function(opts) {
            let _col = [];
            const _columnDefs =  [
                this.makeColDefHide('rowStatus','rowStatus'),
                this.makeColDefHide('uuid','uuid'),
            ];
            // console.log('opts.columnDefs.push', opts.columnDefs.push(..._columnDefs));
            // common.js 의 HTGF.Table 을 참고함.
            const _gridOptions = {
                rowData: [],
                // loading: true,                
                pagination: true,
                paginationPageSize: 20,
                // paginationPageSizeSelector: [20, 50, 100],// v31.1 ~
                // suppressPaginationPanel: true, // default false
                // cacheBlockSize: 20,  // serverSide 용. default 100
                domLayout: 'autoHeight',
                rowModelType: 'clientSide',
                rowSelection: 'single', //multiple
                selectAll: 'currentPage',//all(default), filtered, currentPage
                // columnDefs: _columnDefs,
                defaultColDef: {
                    width: 140,
                    // minWidth: 100,
                    // maxWidth: 140,
                    resizable: true,
                    // editable: true, // default false
                    // flex: 1,
                    // filter: true,
                    // suppressMenu: true,// 컬럼 상단 === 메뉴 없애기
                    suppressHeaderMenuButton: true,// v31.1 ~ 컬럼 상단 === 메뉴 없애기
                },
                localeText: ('de' === '${lang}')?AG_GRID_LOCALE_DE:null,  // 다국어 설정.
                // localeText: {
                //     // 기본 메시지 번역
                //     noRowsToShow: "Keine Daten verfügbar", // "No rows to show"
                //     loadingOoo: "Lädt...", // "Loading..."
                //     page: "Seite", // "Page"
                //     of: "von", // "of"
                //     to: "bis", // "to"
                //     nextPage: "Nächste Seite", // "Next Page"
                //     previousPage: "Vorherige Seite", // "Previous Page"
                //     filterOoo: "Filter...", // "Filter..."
                //     searchOoo: "Suchen...", // "Search..."
                //     columns: "Spalten", // "Columns"
                //     applyFilter: "Filter anwenden", // "Apply Filter"
                // },
                // loadingCellRenderer: "agLoadingCellRenderer",
                // loadingOverlayComponentParams: {
                //     loadingMessage: "데이터 불러오는 중..." // 기본 로딩 메시지 변경
                // },
                // suppressMenuHide: false,
                // suppressHeaderMenuButton: true,
                // suppressHeaderFilterButton: true,
                // suppressHeaderContextMenu: true,
                suppressMovableColumns: true,  // default false, 개인화 설정으로 칼럼 이동 가능하게 함. 
                suppressRowClickSelection: false, // default false row select 안됨.
                // suppressRowClickSelection: true,    // 행 클릭 시 자동 선택 방지 (체크박스 전용)
                suppressAutoSize: false,    // default false 더블클릭시 창 사이즈 조정됨.
                // autoSizeStrategy: {
                //     // type: 'fitProvidedWidth', width: 50,
                //     // type: 'fitCellContents',  // 첫 번째 데이터가 그리드에 렌더링될 때 콘텐츠에 맞게 열 크기를 조정하려면 유형 = 'fitCellContents'인 그리드 옵션 autoSizeStrategy를 제공하세요.

                //     type: 'fitGridWidth',    // cell contents length 에 맞춤
                //     defaultMinWidth: 100,
                //     columnLimits: [
                //         // {colId: 'country', minWidth: 900}
                //     ]
                // },
                skipHeaderOnAutoSize: true,
                // suppressSizeToFit: true,
                // stopEditingWhenGridLosesFocus: true,// 하위ver.
                // stopEditingWhenCellsLoseFocus: false, // Ver31~, 옵션 활성화(true)/주석 해제 시 고객 차량 제조사/모델 조회 select2 팝업 오류 발생함.
                suppressCopyRowsToClipboard: true, //선택한 셀만 복사
                // noRowsOverlayComponent: 'customNoRowsOverlay',
                components: {
                    codeCellRenderer : AG_GRID.getCodeCellRenderer,
                    dateCellRenderer : AG_GRID.getDateCellEditor(),
                    dateMonthCellEditor : AG_GRID.getDateMonthCellEditor(),
                    // customHeaderGroup : AG_GRID.getCustomHeaderGroup(),
                    // customHeaderSusbleRation : _this.getCustomHeaderSusbleRation(),
                    // checkboxRenderer : AG_GRID.getTargetMarketCheckRenderer(this.pageType == 'Edit'),
                    // deptCellEditor : AG_GRID.getDeptCellEditor(),
                    // deptCellRenderer : AG_GRID.getDeptCellRenderer,
                    numericCellEditor : AG_GRID.getNumericCellEditor(),
                    textCellEditor : AG_GRID.getTextCellEditor(),
                    select2AjaxCellEditor : AG_GRID.getSelect2AjaxCellEditor(),
                    // select2CellRenderer: AG_GRID.getSelect2CellRenderer,
                    select2CellEditor : AG_GRID.getSelect2CellEditor(),
                    comboCellEditor : AG_GRID.getComboCellEditor(),
                    customNoRowsOverlay: AG_GRID.getCustomNoRowsOverlay,
                },
                onGridReady: function (params) {
                    // params.api.sizeColumnsToFit();// 폭 맞춤
                    // params.columnApi.autoSizeAllColumns();  // autoSizeStrategy 에 따라 맞춤.
                    params.api.showNoRowsOverlay();
                },
                onGridSizeChanged: function (params) {// 창 크기 변경 되었을 때 이벤트
                    // params.api.sizeColumnsToFit();   // 폭 맞춤
                    // params.columnApi.autoSizeAllColumns();  // autoSizeStrategy 에 따라 맞춤.
                },
                
            };

            let _opts = _.merge(_gridOptions, opts);
            // console.log('_.merge(_gridOptions, opts)', _opts)
            return _opts;            
        },
        createGrid : function(gridId, opts){
            let _opts = this.makeGridOptions(opts);
            new agGrid.Grid(gridId[0], _opts);
            // let _opts = HTGF.Table(gridId, this.makeGridOptions(opts));
            // console.log('_opts=====================', _opts)
            return _opts;// ~ver31
            // return agGrid.createGrid(gridId[0], this.makeGridOptions(opts));    //ver31~
        },
        resetColumnState(gridApi, pGridId, pMenuId) {// AG Grid 개인화
            const _params = {
                // 'saveFlag' : 'I',
                'GRID_ID' : pGridId,
                'MENU_ID' : pMenuId,
                'GRID_STATUS_NAME' : pMenuId,
                'APPLC_YN':'N', // 미적용(N)
            };
            console.log('_params',_params);

            try {
                HTGF.Backdrop.show(); // ...
                HTGF.Api.put('${pageContext.request.contextPath}/api/AG_GRID_UTIL/save-GridSettingApplcYn', _params).then( function(resData) {
                    console.log('resData', resData)
                    HTGF.Backdrop.hide(); 

                    if(resData.result == 'success') {
                        // alert('successfully!!');
                        COMMON_POPUP.showAlert('Verarbeitet.');
                        
                        gridApi.api.resetColumnState();// 그리드 설정값 초기화
                    } else {
                        // alert(resData.msg);
                        COMMON_POPUP.showAlert(resData.msg);
                    }
                    // if(resData != null) {
                    //     alert('Save.');
                    //     // $('#regrid_state_name_${pageUuid}').text(gridStateName);
                    // } else {
                    //     alert('Failed.');
                    // }
                }).catch(function (resData){
                    //console.log(resData)
                    HTGF.Backdrop.hide(); // ...
                    if (resData.status === 403){
                        // alert('페이지 예외- 권한없음(HTTP 401 Or 403)이 발생');
                        COMMON_POPUP.showAlert('페이지 예외- 권한없음(HTTP 401 Or 403)이 발생');
                    } else if (resData.status === 400) {
                        // alert(resData.response.message);
                        COMMON_POPUP.showAlert(resData.response.message);
                    }
                });
            } catch (e) {
                alert(e);
                COMMON_POPUP.showAlert(e);
            }
        },
        setColumnState(gridApi, pGridId, pMenuId) {// AG Grid 개인화
            const _params = {
                'saveFlag' : 'I',
                'GRID_ID' : pGridId,
                'MENU_ID' : pMenuId,
                'GRID_STATUS_NAME' : pMenuId,
                'GRID_STATUS_DATA': JSON.stringify(gridApi.api.getColumnState()),
            };
            console.log('_params',_params);

            try {
                HTGF.Backdrop.show(); // ...
                HTGF.Api.put('${pageContext.request.contextPath}/api/AG_GRID_UTIL/save-GridSetting', _params).then( function(resData) {
                    console.log('resData', resData)
                    HTGF.Backdrop.hide(); 

                    if(resData.result == 'success') {
                        // alert('successfully!!');
                        COMMON_POPUP.showAlert(COMMON_TEXT['Gespeichert.']);
                    } else {
                        // alert(resData.msg);
                        COMMON_POPUP.showAlert(resData.msg);
                    }
                    // if(resData != null) {
                    //     alert('Save.');
                    //     // $('#regrid_state_name_${pageUuid}').text(gridStateName);
                    // } else {
                    //     alert('Failed.');
                    // }
                }).catch(function (resData){
                    //console.log(resData)
                    HTGF.Backdrop.hide(); // ...
                    if (resData.status === 403){
                        // alert('페이지 예외- 권한없음(HTTP 401 Or 403)이 발생');
                        COMMON_POPUP.showAlert('페이지 예외- 권한없음(HTTP 401 Or 403)이 발생');
                    } else if (resData.status === 400) {
                        // alert(resData.response.message);
                        COMMON_POPUP.showAlert(resData.response.message);
                    }
                });
            } catch (e) {
                alert(e);
                COMMON_POPUP.showAlert(e);
            }
        },
        getGridColumnState(gridApi, pGridId, pMenuId) {// AG Grid 개인화
            // update suppressMovableColumns: true => false, 개인화 설정으로 칼럼 이동 가능하게 함. 
            gridApi.api.setGridOption('suppressMovableColumns', false); 

            // 개인화 설정 조회.
			HTGF.Api.get('${pageContext.request.contextPath}/api/AG_GRID_UTIL/search-GridSetting/', {'GRID_ID' : pGridId,'MENU_ID' : pMenuId,'GRID_STATUS_NAME' : pMenuId,}).then( function(resData) {
                console.log('getGridColumnState resData', resData)
                if(resData != null && resData != '') {
                    const _gridState = {
                        state: JSON.parse(resData.GRID_STATUS_DATA),
                        applyOrder: true,
                        // defaultState: [{sort: null}	]
                    };

                    gridApi.api.applyColumnState(_gridState);
                    // $('#regrid_state_name_${pageUuid}').text(resData.GRID_STATUS_NAME);
                    console.log('Grid Setting is changed.');
                } else {
                }
            });
		},
        showLoadingOverlay(gridApi) {
            gridApi.api.showLoadingOverlay();
            // HTGF.Backdrop.show()
        },
        hideOverlay(gridApi) {
            gridApi.api.hideOverlay();
            // HTGF.Backdrop.hide()
        },
        setRowData : function(gridApi, data) {
            // console.log('gridApi', gridApi)
            // gridApi.api.setRowData(data);// ~ver31,AG Grid: setRowData is deprecated. Please use 'api.setGridOption('rowData', newValue)' or 'api.updateGridOptions({ rowData: newValue })' instead.
            gridApi.api.setGridOption('rowData', data);// ~ver31
            // gridApi.api.updateGridOptions({ rowData: data })// ~ver31
            // gridApi.setGridOption('rowData', data); // ver32~
            // gridApi.updateGridOptions({rowData: data}); // ver32~            
        },
        getRowData : function(gridApi, id){
            let node = gridApi.api.getRowNode(String(id))
            if($.isEmptyObject(node)){
                return {};
            }
            return node.data;
        },
        setDataValue : function(gridApi, id, colKey, data){
            gridApi.api.getRowNode(String(id)).setDataValue(colKey, data);
        },
        addRow : function(gridApi, newData={}, check = false, addIndex=0){
            /**
             * grid row 추가
             * @param newData {} :새로운 row에 셋팅할 데이터 (default = {} 공백 )
             * @param check true/false :새로운 row 체크 여부 (default = false )
             * @param addIndex :새로운 row를 추가할 index (default = 0 (최상단))
             */
            let addData = [newData];
            let rowCnt = 1;
            if(Array.isArray(newData)){ //복수건
                addData = newData;
                rowCnt = newData.length;
            }

            let newRow = gridApi.api.applyTransaction({
                add: addData
                , addIndex: addIndex
            });

            if(check) {
                for (let i = 0; i < rowCnt; i++) {
                    newRow.add[i].setSelected(true);
                }
            }
        },
        deleteRow : function(gridApi, data){
            let delData = $.isEmptyObject(data) ? gridApi.api.getSelectedRows() : [data];
            if(Array.isArray(data)){ //복수건
                delData = data;
            }
            gridApi.api.applyTransaction({ remove: delData});
        },
        makeHeaderCheckbox : function() {
            //AG Grid: only supported with rowSelection=multiple
            return {
                headerCheckboxSelection: true , headerCheckboxSelectionFilteredOnly: true,
                //headerCheckboxSelectionCurrentPageOnly: true,//ver31~
            }
        },
        makeColDefHide : function(pHeaderName, pField) {
            return {
                headerName: pHeaderName, field: pField, filter: false, hide:true
            }
        },
        makeColDef : function(pHeaderName, pField, pWidth, pOpt) {
            if(pWidth > 0) {
                return {
                    headerName: pHeaderName, field: pField, width: pWidth,
                    ...pOpt,
                }
            } else {
                return {
                    headerName: pHeaderName, field: pField,
                    ...pOpt,
                }
            }
        },
        makeColDefCenter : function(pHeaderName, pField, pWidth, pOpt) {
            if(pWidth > 0) {
                return {
                    headerName: pHeaderName, field: pField, width: pWidth,
                    cellStyle: {'textAlign': 'center'},
                    ...pOpt,
                }
            } else {
                return {
                    headerName: pHeaderName, field: pField,
                    cellStyle: {'textAlign': 'center'},
                    ...pOpt,
                }
            }
        },
        makeColDefRowIndex : function(pHeaderName, pField) {
            return {
                ...this.makeColDef(pHeaderName, pField, '70'),
                cellStyle: {'textAlign': 'center'},
                cellRenderer: params => {
                    return params.node.rowIndex + 1;
                },
            }
        },
        makeColDefCodeCellRenderer : function(pHeaderName, pField, pWidth) {
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth),
                cellStyle: {'textAlign': 'center'},
                cellRenderer: 'codeCellRenderer',
            }
        },
        makeColDefInputText : function(pHeaderName, pField, pWidth, pOpt) {
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth, pOpt),
                cellClass: 'cell-form1',
                cellEditor: 'textCellEditor',
                cellRenderer: this.inputTextRenderer,
            }
        },
        makeColDefNumber : function(pHeaderName, pField, pWidth, pFixed, pOpt) {
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth),
                cellStyle: {'textAlign': 'right'},
                valueFormatter: params => COMMON_SCRIPT.numberFormat(params.value, pFixed),
                // cellEditor: "agNumberCellEditor",
                cellEditor: 'numericCellEditor',
                cellClass: ['cell-form1','ag-right-aligned-cell'],
                cellRenderer: this.inputNumberRenderer,
                ...pOpt,
                valueParser: (params) => {
                //     // console.log('params valueParser', params)
                //     // console.log('params.newValue==============', params.newValue, params.oldValue)
                //     // // 사용자가 입력한 값이 숫자로 변환될 수 있도록 처리
                //     // const value = params.newValue;
                //     // const parsedValue = parseFloat(value);
                //     // return value
                //     // return isNaN(parsedValue) ? 0 : parsedValue;  // 숫자가 아니면 0으로 처리
                }
            }
        },
        makeColDefNumberReadonly : function(pHeaderName, pField, pWidth, pFixed, pOpt) {
            return {
                ...this.makeColDefNumber(pHeaderName, pField, pWidth, pFixed, pOpt),
                editable: false,
            }
        },
        makeColDefPercent : function(pHeaderName, pField, pWidth, pFixed) {
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth),
                cellStyle: {'textAlign': 'right'},
                // valueFormatter: params => percentFormatter(params, pFixed),
                valueFormatter: params => {COMMON_SCRIPT.numberFormat(params.value, pFixed) + '%'},
                //cellEditor: AG_GRID.getNumericCellEditor(),
            }
        },
        makeColDefDateCellRenderer : function(pHeaderName, pField, pWidth, pFormat, pOpt) {
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth, pOpt),
                valueFormatter: params => COMMON_SCRIPT.dateFormat(params.value),
                // valueGetter: params => COMMON_SCRIPT.dateFormat(params.data[pField]),
                cellStyle: {'textAlign': 'center'},
                cellEditor: 'dateCellRenderer',
                cellClass: ['cell-form1','ag-center-aligned-cell'],
                cellRenderer: this.dateRenderer,
            }
        },
        makeColDefDate : function(pHeaderName, pField, pWidth, pOpt) {
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth, pOpt),
                // valueFormatter: params => COMMON_SCRIPT.dateTimeFormat(params.value),
                valueGetter: function (param) {
                    // console.log('param, param.value', param, param.data[pField])
                    return COMMON_SCRIPT.dateFormat(param.data[pField]);
                    // return moment(param.data[pField], 'YYYY-MM-DD HH:mm').format('DD-MM-YYYY HH:mm')
                },
                cellStyle: {'textAlign': 'center'},
                comparator: (valueA, valueB, nodeA, nodeB, isDescending) => {
                    // console.log('makeColDefDateTime valueA, valueA', valueA, valueA)
                    let valA = moment(valueA, 'DD-MM-YYYY').format('YYYY-MM-DD');
                    let valB = moment(valueB, 'DD-MM-YYYY').format('YYYY-MM-DD');
                    if (valA == valB) return 0;
                    return (valA > valB) ? 1 : -1;
                }
            }
        },
        makeColDefDateTime : function(pHeaderName, pField, pWidth, pFormat) {
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth),
                // valueFormatter: params => COMMON_SCRIPT.dateTimeFormat(params.value),
                valueGetter: function (param) {
                    // console.log('param, param.value', param, param.data[pField])
                    return COMMON_SCRIPT.dateTimeFormat(param.data[pField], pFormat);
                    // return moment(param.data[pField], 'YYYY-MM-DD HH:mm').format('DD-MM-YYYY HH:mm')
                },
                cellStyle: {'textAlign': 'center'},
                comparator: (valueA, valueB, nodeA, nodeB, isDescending) => {
                    // console.log('makeColDefDateTime valueA, valueA', valueA, valueA)
                    let valA = moment(valueA, 'DD-MM-YYYY HH:mm').format('YYYY-MM-DD HH:mm');
                    let valB = moment(valueB, 'DD-MM-YYYY HH:mm').format('YYYY-MM-DD HH:mm');
                    if (valA == valB) return 0;
                    return (valA > valB) ? 1 : -1;
                }
            }
        },
        makeColDefPopup : function(pHeaderName, pField, pWidth, pOpt) {
            /**
             * 팝업 오픈
             * pOpt {func:"팝업 오픈 function", funcParam = 'id or data'}
             * funcParam : func에 넘길 파라미터 설정(default: param, id: param.node.id, data: param.data)
             */
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth, pOpt)
                , cellClass: 'cell-form1'
                , cellRenderer: this.popupRenderer
            }
        },
        makeColDefSelectRenderer : function(pHeaderName, pField, pWidth, pValues) {
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth),
                cellStyle: {'textAlign': 'center'},

                // v31~
                // cellEditor: 'agSelectCellEditor',
                cellEditor: 'agRichSelectCellEditor',
                // cellRenderer: ColourCellRenderer,
                cellEditorParams: //(params) => { return
                    {
                        values: pValues,
                        // values: CUSTOMER_VEHICLE.getVehicleModelData(params),
                        // values: (params) => {return ['850CSI', 'M 3', 'M COUPE', 'M Coupe', 'M ROADSTER', 'M Roadster', 'M3', 'M3 CSL', 'M5', 'M6']},
                        // values: (params) => {console.log('params.getValue(pRefId)', pRefId, params.getValue(pRefId)); return params.getValue(pRefId)},
                        // values: [{id:'id-1',text:'text-1'}, {id:'id-2',text:'text-2'}],
                        // values: () => {return ['AliceBlue', 'AntiqueWhite', 'Aqua', /* .... many colours */ ]},
                        // searchType: "matchAny",
                        // allowTyping: pAllowTyping,
                        // filterList: true,
                        // highlightMatch: true,
                        // valueListMaxHeight: 220
                    },
                cellClass: ['cell-form1','ag-center-aligned-cell'],
                cellRenderer: this.selectRenderer,
                // }
            }
        },
        makeColDefCodeCombo : function(pHeaderName, pField, pWidth, codeId, pOpt) {
            /**
             * 시스템 코드를 사용한 Combo Box
             * codeId : 시스템 코드  ID
             */
            return {
                ...this.makeColDefCenter(pHeaderName, pField, pWidth, pOpt)
                , cellRendererParams: {codeId : codeId}
                , cellEditor: 'comboCellEditor'
                , cellClass: ['cell-form1','ag-center-aligned-cell']
                , cellRenderer: this.selectRenderer
            }
        },
        // makeColDefSelectRenderer : function(pHeaderName, pField, pWidth, pOpt = {cellEditor:'select2AjaxCellEditor', url:'', values: []}, callbackFn) {
        //     return {
        //         ...this.makeColDef(pHeaderName, pField, pWidth),
        //         cellStyle: {'textAlign': 'center'},
        //         // editable: true,
        //         // cellEditor: pOpt.cellEditor,
        //         cellEditor: 'agRichSelectCellEditor',
        //         cellEditorParams: {
        //             // values: pOpt.values,
        //             values: (params) => {return CUSTOMER_VEHICLE.getVehicleModelData(params)},
        //             url: pOpt.url,
        //             callbackFn: callbackFn,
        //         }
        //     }
        // },
        makeColDefSelect2Renderer : function(pHeaderName, pField, pWidth, pOpt) {
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth),
                cellStyle: {'textAlign': 'center'},
                // editable: true,
                // cellEditor: 'select2CellEditor',//select2AjaxCellEditor select2CellEditor
                cellEditor: pOpt.cellEditor,//select2AjaxCellEditor select2CellEditor
                cellEditorParams:
                // (params) => { return
                    {
                        values: pOpt.values,
                        url: pOpt.url,
                        refIds: pOpt.refIds,
                        minimumInputLength: pOpt.minimumInputLength,
                    },
                cellClass: ['cell-form1','ag-center-aligned-cell'],
                cellRenderer: this.selectRenderer,
                // },

            }
        },
        makeColDefReadonly : function(pHeaderName, pField, pWidth, pOpt) {
            return {
                ...this.makeColDef(pHeaderName, pField, pWidth, pOpt),
                editable: false,
            }
        },
        makePinnedNoEditColDef : function(pHeaderName, pField, pWidth) {
            return {
                ...this.makeNoEditColDef(pHeaderName, pField, pWidth), cellStyle: {'textAlign': 'left'}, pinned: 'left',
            }
        },
        makePinnedNoEditColDefRowspan : function(pHeaderName, pField, pWidth) {
            return {
                ...this.makePinnedNoEditColDef(pHeaderName, pField, pWidth),
                ...this.makeRowSpan(),
            }
        },
        makeColDefRowSpanSameValue : function(pHeaderName, pField, pWidth, pOpt) {
            return {
                ...this.makeColDefCenter(pHeaderName, pField, pWidth, pOpt)
                , rowSpan: this.rowSpanSameValue
                , cellClassRules: { 'cell-merge': params => params.data.rowSpanCnt !== 1 }
            }
        },
        makeColDefIcon : function(pHeaderName, pField, pWidth, pOpt) {
            /**
             * 아이콘 버튼
             * cellRendererParams {
             *     icon(필수*) : icon class
             *     func : 버튼 클릭시 실행할 function명 (string)
             *     funcParam : 'id or data' -> func에 넘길 파라미터 설정 (default: param, id: param.node.id, data: param.data)
             *     showCond : 동적 버튼 표시 조건 (function)
             * }
             */
            return {
                ...this.makeColDefCenter(pHeaderName, pField, pWidth, pOpt)
                , cellClass: 'cell-ico'
                , editable: false
                , cellRenderer: this.iconRenderer
            }
        },
        makeColDefTextButton : function(pHeaderName, pField, pWidth, pOpt) {
            /**
             * 텍스트 버튼
             * cellRendererParams {
             *     text(필수*) : text 내용
             *     func : 버튼 클릭시 실행할 function명 (string)
             *     funcParam : 'id or data' -> func에 넘길 파라미터 설정 (default: param, id: param.node.id, data: param.data)
             *     showCond : 동적 버튼 표시 조건 (function)
             * }
             */
            return {
                ...this.makeColDefCenter(pHeaderName, pField, pWidth, pOpt)
                , cellClass: 'cell-ico'
                , editable: false
                , cellRenderer: this.textButtonRenderer
            }
        },
        makeColDefIconTextButton : function(pHeaderName, pField, pWidth, pOpt) {
            /**
             * 아이콘 + 텍스트 버튼
             * cellRendererParams {
             *     icon(필수*) : icon class
             *     text(필수*) : text 내용
             *     func : 버튼 클릭시 실행할 function명 (string)
             *     funcParam : 'id or data' -> func에 넘길 파라미터 설정 (default: param, id: param.node.id, data: param.data)
             *     showCond : 동적 버튼 표시 조건 (function)
             * }
             */
            return {
                ...this.makeColDefCenter(pHeaderName, pField, pWidth, pOpt)
                , cellClass: 'cell-ico'
                , editable: false
                , cellRenderer: this.iconTextButtonRenderer
            }
        },
        // col: 병합할 기준 컬럼이 있는 경우 column 이름
        makeRowSpan : function(col) {
            return {
                rowSpan: function (params )
                {
                    return AG_GRID.getRowspan(params, col);
                }

            }
        },
        getRowspan(params, col) {
            let cnt = 0;
            let isSame = true;
            let isMakeSpan = true;
            let key = typeof col === 'undefined' && col === null ? params.colDef.field : col;
            params.api.forEachNode(function(node, index){
                if(node.data){
                    if(index >= params.node.rowIndex) {
                        if(params.data[key] === node.data[key] && isSame){
                            cnt++;
                        } else {
                            isSame = false;
                        }
                    } else if(index < params.node.rowIndex
                        && params.data[key] === node.data[key])  {
                        isMakeSpan = false;
                    } else if(index < params.node.rowIndex
                        && params.data[key] !== node.data[key])  {
                        isMakeSpan = true;
                    }
                }
            });

            if(isMakeSpan){
                return cnt;
            } else {
                return 1;
            }
        },
        rowSpanSameValue : function(params) {
            if (!params.data || !params.column || !params.api) return 1;

            /**
             * css를 위한 class 설정값
             */
            const rowSpanCnt = 'rowSpanCnt';             // row span 갯수
            const rowSpanLastClass = 'rowSpanLastClass'; // page 마지막 row span Class
            const rowSpanClass = 'rowSpanClass';         // row span grid에서 사용할 odd/even class
            const rowSpanClassEven = 'row-merge-even';   // row span grid : even class 명
            const rowSpanClassOdd = 'row-merge-odd';     // row span grid : odd class 명

            const colId = params.column.colId;
            const rowIndex = params.node.rowIndex; // 전체 index
            const rowData = params.data;
            const pageIndex = params.api.paginationGetCurrentPage();
            const pageSize = params.api.paginationGetPageSize();
            const pageRowIndex = params.node.rowIndex - (pageIndex * pageSize); //현재 페이지 index

            let spanCnt  = 1;
            let preType = rowSpanClassOdd;

            if(rowIndex > 0 && pageRowIndex > 0) {
                const preData = params.api.getDisplayedRowAtIndex(rowIndex - 1).data;
                if (preData && preData[colId] === rowData[colId]) {
                    rowData[rowSpanClass] = preData[rowSpanClass];
                    return spanCnt;
                }
                preType = preData[rowSpanClass];
            }

            let rowLast = '';
            for (let i = rowIndex + 1; i < params.api.getDisplayedRowCount(); i++) {
                if( i % pageSize === 0){
                    //마지막 페이지 이외
                    rowLast = 'row-merge-last2';
                    break;
                }
                const nextData = params.api.getDisplayedRowAtIndex(i).data;
                if (nextData && nextData[colId] === rowData[colId]) {
                    spanCnt++;
                } else {
                    break;
                }

                if(params.api.getDisplayedRowAtIndex(i).lastChild){
                    //마지막 페이지
                    rowLast = 'row-merge-last1';
                }
            }

            rowData[rowSpanCnt] = spanCnt;
            rowData[rowSpanClass] = preType === rowSpanClassOdd ? rowSpanClassEven : rowSpanClassOdd;
            rowData[rowSpanLastClass] = spanCnt !== 1 && rowLast !== '' ? rowLast : '';

            return spanCnt;
        },
        inputTextRenderer: function(params) {
            let value = params.value || '';

            if (params.colDef.valueFormatter !== undefined) {
                value = params.colDef.valueFormatter(params);
            } else if (params.colDef.valueGetter !== undefined) {
                value = params.colDef.valueGetter(params);
            }

            if(typeof params.colDef.editable == "boolean" && params.colDef.editable || $.isFunction(params.colDef.editable) && params.colDef.editable(params)){
                return `<div class="inForm-write"><span class="intxt" title="\${value}">\${value}</span></div>`;
            }else{
                return `<span class="intxt" title="\${value}">\${value}</span>`;
            }
        },
        inputNumberRenderer: function(params) {
            let value = params.value || '';

            if (params.colDef.valueFormatter !== undefined) {
                value = params.colDef.valueFormatter(params);
            } else if (params.colDef.valueGetter !== undefined) {
                value = params.colDef.valueGetter(params);
            }
            if(typeof params.colDef.editable == "boolean" && params.colDef.editable || $.isFunction(params.colDef.editable) && params.colDef.editable(params)){
                return `<div class="inForm-write" style="text-align: right; justify-content: flex-end;"><span class="intxt" title="\${value}" style="padding-right:2px;">\${value}</span></div>`;
            }else{
                return `<span class="intxt" title="\${value}" style="padding-right:10px;">\${value}</span>`;
            }
        },
        dateRenderer: function(params) {
            let value = params.value || '';

            if (params.colDef.valueFormatter !== undefined) {
                value = params.colDef.valueFormatter(params);
            } else if (params.colDef.valueGetter !== undefined) {
                value = params.colDef.valueGetter(params);
            }

            if(typeof params.colDef.editable == "boolean" && params.colDef.editable || $.isFunction(params.colDef.editable) && params.colDef.editable(params)){
                return `<div class="inForm-date" style="justify-content: center;"><span class="day intxt">\${value}</span></div>`;
            }else{
                return `<span style="margin: 0 auto; display: block;">\${value}</span>`;
            }
        },
       selectRenderer: function(params) {
            let value = params.value || '';

            if(params.codeId !== undefined) {
                value = HTGF.UTILS.codeI18n(value);
            } else if (params.colDef.valueFormatter !== undefined) {
                value = params.colDef.valueFormatter(params);
            } else if (params.colDef.valueGetter !== undefined) {
                value = params.colDef.valueGetter(params);
            }

            if(typeof params.colDef.editable == "boolean" && params.colDef.editable || $.isFunction(params.colDef.editable) && params.colDef.editable(params)){
                return `<div class="inForm-select1" style="justify-content: center;"><span class="intxt">\${value}</span></div>`;
            }else{
                return `<span style="margin: 0 auto; display: block;">\${value}</span>`;
            }
        },
        popupRenderer: function(params) {
            const { func = '', funcParam = ''} = params.colDef.cellRendererParams || {};
// console.log('popupRenderer - params', params)
            let div = document.createElement('div');
            div.className = 'inForm-search';
            div.style['cursor'] = 'pointer';
            let span = document.createElement('span');
            span.className = 'intxt';
            span.innerHTML = params.value === 0 ? 0 : (params.value || '');
            div.appendChild(span);

            if (func) {
                div.addEventListener('click', () => {
                    let setFuncParam = params
                    if(funcParam === 'data'){
                        setFuncParam = params.data;
                    }else if(funcParam === 'id'){
                        setFuncParam = params.node.id;
                    }

                    const execFunc = new Function('param',`return \${func}(param)`);
                    execFunc(setFuncParam);
                })
            }

            return div;
        },
        iconRenderer: function(params) {
            const { icon = '', func = '', funcParam = '', showCond} = params.colDef.cellRendererParams || {};

            let visible = true; //아이콘 표시 여부
            if (showCond && $.isFunction(showCond)) {
                visible = showCond(params);
            }

            let span =  document.createElement('span');
            let button = document.createElement('button');
            button.type = 'button';
            button.className = 'btn-ix';
            let _span = document.createElement('span');
            _span.className = icon
            button.appendChild(_span);
            span.appendChild(button);

            if(!visible){
                button.style.display = 'none';
            }

            if (func) {
                button.addEventListener('click', () => {
                    let setFuncParam = params
                    if(funcParam === 'data'){
                        setFuncParam = params.data;
                    }else if(funcParam === 'id'){
                        setFuncParam = params.node.id;
                    }

                    const execFunc = new Function('param',`return \${func}(param)`);
                    execFunc(setFuncParam);
                })
            }
            return span;
        },
        textButtonRenderer: function(params) {
            const { text = '', func = '', funcParam = '', showCond} = params.colDef.cellRendererParams || {};

            let visible = true; //버튼 표시 여부
            if (showCond && $.isFunction(showCond)) {
                visible = showCond(params);
            }

            let span =  document.createElement('span');
            let button = document.createElement('button');
            button.type = 'button';
            button.className = 'btn-ix';
            let _span = document.createElement('span');
            _span.className = 'txt'
            _span.innerText = text;
            button.appendChild(_span);
            span.appendChild(button);

            if(!visible){
                button.style.display = 'none';
            }

            if (func) {
                button.addEventListener('click', () => {
                    let setFuncParam = params
                    if(funcParam === 'data'){
                        setFuncParam = params.data;
                    }else if(funcParam === 'id'){
                        setFuncParam = params.node.id;
                    }

                    const execFunc = new Function('param',`return \${func}(param)`);
                    execFunc(setFuncParam);
                })
            }
            return span;
        },
        iconTextButtonRenderer: function(params) {
            const { text = '', icon = '', func = '', funcParam = '' , showCond} = params.colDef.cellRendererParams || {};

            let visible = true; //버튼 표시 여부
            if (showCond && $.isFunction(showCond)) {
                visible = showCond(params);
            }

            let span =  document.createElement('span');
            let button = document.createElement('button');
            button.type = 'button';
            button.className = 'btn-ix type1';
            let spanIcon = document.createElement('span');
            spanIcon.className = icon
            let spanText = document.createElement('span');
            spanText.className = 'txt';
            spanText.innerText = text;

            button.appendChild(spanIcon);
            button.appendChild(spanText);
            span.appendChild(button);

            if(!visible){
                button.style.display = 'none';
            }

            if (func) {
                button.addEventListener('click', () => {
                    let setFuncParam = params
                    if(funcParam === 'data'){
                        setFuncParam = params.data;
                    }else if(funcParam === 'id'){
                        setFuncParam = params.node.id;
                    }

                    const execFunc = new Function('param',`return \${func}(param)`);
                    execFunc(setFuncParam);
                })
            }
            return span;
        },
        isShowCell (params) {
            let cnt = 0 ;
            // console.log('isShowCell params', params)
            params.api.forEachNode(function(node){
                if(node.data){
                    if(node.data[params.colDef.field] === params.data[params.colDef.field] ){
                        cnt++;
                    }
                }
            });
            if(cnt > 1) return true;  
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
        getCodeCellRenderer : function(params, pI18n=true){
            // console.log('params', params)
            if(params.value){
                let val = params.value;
                if(params.value.indexOf('│') > -1) {
                    val = params.value.split('│')[0];
                }
                var code = CODE(val.trim());
                if(code) {
                    return (pI18n) ? code.i18n : code.codeName;
                } else {
                    return val;
                }
            } else {
                return undefined;
            }
        },
        getSelectCellRenderer : function(params, pI18n=true){
            console.log('params', params)
            if(params.value){
                let val = params.value;
                if(params.value.indexOf('│') > -1) {
                    val = params.value.split('│')[0];
                }
                var code = CODE(val.trim());
                if(code) {
                    return (pI18n) ? code.i18n : code.codeName;
                } else {
                    return val;
                }
            } else {
                return undefined;
            }
        },
        getSelect2CellRenderer : function(params){
            let html = "";
            let value = String(params.value||'');

            console.log('getSelect2CellRenderer - params', params)
            console.log('getSelect2CellRenderer - value1', value)
            let cellEditorParams = {} ;
            if ($.isFunction(params.colDef.cellEditorParams)) {
                cellEditorParams = params.colDef.cellEditorParams(params) ;
            } else if (params.colDef.cellEditorParams !== undefined) {
                cellEditorParams = params.colDef.cellEditorParams;
            }

            // if ( cellEditorParams.hasOwnProperty("renderField") && cellEditorParams.renderField != "id" ) { // renderField: id, text, [id]text
            //     let text = "";
            //     let colId = params.colDef.field;
            //     if (cellEditorParams.values != undefined) {
            //         cellEditorParams.values.filter(item => item.id == value).forEach(function(item, idx, arr){
            //             text = item.text || '';
            //         })
            //     } else if ( params.data.hasOwnProperty(colId+"_NM") ) {
            //         text = params.data[colId+"_NM"] || '';
            //     }

            //     if (!text) {
            //         value = value;
            //     } else if ( cellEditorParams.renderField == "text" ) {
            //         value = text;
            //     } else {
            //         value = GRID_COMPONENTS.makeCodeName(value, text);
            //     }
            // }
console.log('getSelect2CellRenderer - value2', value)
            if ( (typeof params.colDef.editable == "boolean" && params.colDef.editable) || ($.isFunction(params.colDef.editable) && params.colDef.editable(params)) ) {
                html = "<div class='inForm-select2'>" + value + "</div>";
            } else {
                html = "<div style='margin-left:7px'>" + value + "</div>";
            }

            return html;
        },
        getSelect2AjaxCellEditor: function () {
            /*
                cellEditorParams :
                {
                    values: [{id:'id-1',text:'text-1'}],
                    minimumResultsForSearch: 'Infinity'
                }
            */
            function Select2AjaxCellEditor() {}

            Select2AjaxCellEditor.prototype.init = function (params) {

                this.eContainer = document.createElement('div');
                this.eContainer.classList.add("inForm-select2");

                this.eGui = document.createElement('select');
                this.eGui.classList.add("select2");

                this.eContainer.appendChild(this.eGui);

                this.params = params;

                console.log('params', params);
            };

            Select2AjaxCellEditor.prototype.getGui = function () {
                return this.eContainer;
            };

            Select2AjaxCellEditor.prototype.afterGuiAttached = function () {
                let _editorParams = this.params.colDef.cellEditorParams;
                // let _editorParams = this.params.colDef.cellEditorParams(this.params) ;
                // let _search = this.params.data[_editorParams.refIds[0]];
                let _query = {};
                if(_editorParams.refIds) {
                    console.log('_editorParams.refIds', _editorParams.refIds)
                    _editorParams.refIds.map(_o => {
                        let _temp={}; 
                        _temp[_o] = this.params.data[_o]; 
                        return Object.assign(_query, _temp);
                    });
                }
                
                let _select2Opt = {
                    ajax: {
                        url: _editorParams.url,
                        dataType: 'json',
                        // tags: true,
                        // createTag: function (params) {
                        //     console.log('createTag - params', params)
                        //     var term = $.trim(params.term);

                        //     if (term === '') {
                        //     return null;
                        //     }

                        //     return {
                        //         id: term,
                        //         text: term,
                        //         newTag: true // add additional parameters
                        //     }
                        // },
                        // insertTag: function (data, tag) {
                        //     // Insert the tag at the end of the results
                        //     data.push(tag);
                        // },
                        data: function (params) {
                            let query = Object.assign({
                                    search: params.term,
                                    // type: 'public'
                                }, _query);
                            // Query parameters will be ?search=[term]&type=public
                            console.log('query', query)
                            return query;
                        },
                        processResults: function (data, params) {
                            // parse the results into the format expected by Select2
                            // since we are using custom formatting functions we do not need to
                            // alter the remote JSON data, except to indicate that infinite
                            // scrolling can be used
                            // params.page = params.page || 1;
                            // let _data = data.reduce(function(pre, _d) {
                            //     pre.push( {id:_d.manufacturer, text: _d.manufacturer} );
                            //     return pre;
                            // }, []);
                            console.log('data, params', data, params)
                            if(data.length <= 0) {  // tag 기능 구현.
                                data = [{id:params.term, text:params.term}];
                            }
                            return {
                                results: data,
                                // pagination: {
                                // more: (params.page * 30) < data.total_count
                                // }
                            };
                        }
                    },
                    minimumInputLength: _editorParams.minimumInputLength,
                    minimumResultsForSearch: Infinity,
                };
                $(this.eGui).select2(_select2Opt);

                // 미리 선택된 값 적용 (pre-select)
                let value = this.params.value || '';
                $(this.eGui).val(value);//.trigger('change');

                $(this.eGui).select2('open');
            };

            Select2AjaxCellEditor.prototype.getValue = function () {
                return $(this.eGui).val();
            };

            Select2AjaxCellEditor.prototype.destroy = function(params) {
                $(this.eGui).select2('close');
            }

            return Select2AjaxCellEditor;
        },
        getSelect2CellEditor: function () {
            /*
                cellEditorParams :
                {
                    values: [{id:'id-1',text:'text-1'}],
                    minimumResultsForSearch: 'Infinity'
                }
            */
            function Select2CellEditor() {}

            Select2CellEditor.prototype.init = function (params) {

                this.eContainer = document.createElement('div');
                this.eContainer.classList.add("inForm-select2");

                this.eGui = document.createElement('select');
                this.eGui.classList.add("select2");

                this.eContainer.appendChild(this.eGui);

                this.params = params;
                console.log('params', params);
            };

            Select2CellEditor.prototype.getGui = function () {
                return this.eContainer;
            };

            Select2CellEditor.prototype.afterGuiAttached = function () {
                let _editorParams = this.params.colDef.cellEditorParams;
                let _values = _editorParams.values;
                console.log('_editorParams', _editorParams)

                $(this.eGui).select2({
                    placeholder: '',
                    closeOnSelect: true,
                    theme: "single",
                    // tags: editorParams.tags||false,
                    data: _values,
                    // data: [{id:'id-1',text:'text-1'}],
                    // minimumResultsForSearch: editorParams.minimumResultsForSearch || '1',
                    minimumResultsForSearch: 1,//Infinity,
                    matcher: function(params, data) {
                        // If there are no search terms, return all of the data
                        if ($.trim(params.term) === '') {
                        return data;
                        }

                        // Do not display the item if there is no 'text' property
                        if (typeof data.text === 'undefined') {
                        return null;
                        }

                        // `params.term` should be the term that is used for searching
                        // `data.text` is the text that is displayed for the data object
                        if (data.text.indexOf(params.term) > -1) {
                        var modifiedData = $.extend({}, data, true);
                        // modifiedData.text += ' (matched)';

                        // You can return modified objects from here
                        // This includes matching the `children` how you want in nested data sets
                        return modifiedData;
                        }

                        // Return `null` if the term should not be displayed
                        return null;
                    },                    
                    tags: true,
                    createTag: function (params) {
                        console.log('createTag - params', params)
                        var term = $.trim(params.term);

                        if (term === '') {
                        return null;
                        }

                        return {
                        id: term,
                        text: term,
                        newTag: true // add additional parameters
                        }
                    },
                });

                let value = this.params.value || '';
                $(this.eGui).val(value);

                $(this.eGui).select2('open');
            };

            Select2CellEditor.prototype.getValue = function () {
                return $(this.eGui).val();
            };

            Select2CellEditor.prototype.destroy = function(params) {
                $(this.eGui).select2('close');
            }

            return Select2CellEditor;
        },
        // getCustomHeaderGroup : function() {
        //     function CustomHeaderGroup() {}

        //     CustomHeaderGroup.prototype.init = function (params) {
        //         this.params = params;
        //         this.eGui = document.createElement('div');
        //         this.eGui.className = 'ag-header-group-cell-label';
        //         this.eGui.innerHTML =
        //             '' +
        //             '<div class="customHeaderLabel">' +
        //             this.params.displayName +
        //             // '</div>' +
        //             //// '<div class="customExpandButton"><i class="fa fa-arrow-right"></i></div>';
        //             // '<div >' +
        //             '    &nbsp;&nbsp;(<i class="far fa-square" style="opacity: 0.5; font-size: 1.5em; background-color: rgb(16, 91, 255);"></i>' +
        //             '    <span>Main</span>' +
        //             '    <i class="far fa-square" style="opacity: 0.5; font-size: 1.5em; background-color: rgb(85, 247, 0);"></i>' +
        //             '    <span>Sub</span>)' +
        //             '    <span>${I18["#OEM_TARGET_MARKET"]}</span>' +
        //             '</div>';

        //         // this.onExpandButtonClickedListener = this.expandOrCollapse.bind(this);
        //         // this.eExpandButton = this.eGui.querySelector('.customExpandButton');
        //         // this.eExpandButton.addEventListener(
        //         // 'click',
        //         // this.onExpandButtonClickedListener
        //         // );

        //         // this.onExpandChangedListener = this.syncExpandButtons.bind(this);
        //         // this.params.columnGroup
        //         // .getOriginalColumnGroup()
        //         // .addEventListener('expandedChanged', this.onExpandChangedListener);

        //         // this.syncExpandButtons();
        //     };

        //     CustomHeaderGroup.prototype.getGui = function () {
        //         return this.eGui;
        //     };

        //     CustomHeaderGroup.prototype.expandOrCollapse = function () {
        //         var currentState = this.params.columnGroup
        //             .getOriginalColumnGroup()
        //             .isExpanded();
        //         this.params.setExpanded(!currentState);
        //     };

        //     CustomHeaderGroup.prototype.syncExpandButtons = function () {
        //         function collapsed(toDeactivate) {
        //             toDeactivate.className =
        //                 toDeactivate.className.split(' ')[0] + ' collapsed';
        //         }

        //         function expanded(toActivate) {
        //             toActivate.className = toActivate.className.split(' ')[0] + ' expanded';
        //         }

        //         if (this.params.columnGroup.getOriginalColumnGroup().isExpanded()) {
        //             expanded(this.eExpandButton);
        //         } else {
        //             collapsed(this.eExpandButton);
        //         }
        //     };

        //     CustomHeaderGroup.prototype.destroy = function () {
        //         this.eExpandButton.removeEventListener(
        //             'click',
        //             this.onExpandButtonClickedListener
        //         );
        //     };

        //     return CustomHeaderGroup;
        // },
        // getCustomHeaderGroupExpand : function(doExpand) {
        //     function CustomHeaderGroup() {}

        //     CustomHeaderGroup.prototype.init = function (params) {
        //         this.params = params;
        //         this.eGui = document.createElement('div');
        //         this.eGui.className = 'ag-header-group-cell-label';
        //         this.eGui.innerHTML =
        //             '' +
        //             '<div class="customHeaderLabel">' +
        //             this.params.displayName +
        //             '</div>' +
        //             '<div class="customExpandButton" style="cursor: pointer;"><i class="fa fa-arrow-right"></i></div>' +
        //             '<div class="customExpandButtonDesc" style="display: inline-block;color: cornflowerblue;margin-left: 5px; cursor: pointer;">Expand</div>';

        //         this.onExpandButtonClickedListener = this.expandOrCollapse.bind(this);
        //         this.eExpandButton = this.eGui.querySelector('.customExpandButton');
        //         this.buttonText = this.eGui.querySelector('.customExpandButtonDesc');
        //         this.eExpandButton.addEventListener('click',this.onExpandButtonClickedListener);
        //         this.buttonText.addEventListener('click',this.onExpandButtonClickedListener);

        //         this.onExpandChangedListener = this.syncExpandButtons.bind(this);
        //         this.params.columnGroup.getOriginalColumnGroup().addEventListener('expandedChanged', this.onExpandChangedListener);

        //         if(doExpand && !this.params.columnGroup.isExpanded()){
        //             this.params.setExpanded(true);
        //         }

        //         this.syncExpandButtons();
        //     };

        //     CustomHeaderGroup.prototype.getGui = function () {
        //         return this.eGui;
        //     };

        //     CustomHeaderGroup.prototype.expandOrCollapse = function () {
        //         var currentState = this.params.columnGroup.getOriginalColumnGroup().isExpanded();
        //         this.params.setExpanded(!currentState);
        //         this.params.api.sizeColumnsToFit();
        //     };

        //     CustomHeaderGroup.prototype.syncExpandButtons = function () {
        //         function collapsed(toDeactivate) {
        //             toDeactivate.className =
        //                 toDeactivate.className.split(' ')[0] + ' collapsed';
        //         }

        //         function expanded(toActivate) {
        //             toActivate.className = toActivate.className.split(' ')[0] + ' expanded';
        //         }

        //         if (this.params.columnGroup.getOriginalColumnGroup().isExpanded()) {
        //             expanded(this.eExpandButton);
        //             this.buttonText.textContent = 'Close';
        //         } else {
        //             collapsed(this.eExpandButton);
        //             this.buttonText.textContent = 'Expand';
        //         }
        //     };

        //     CustomHeaderGroup.prototype.destroy = function () {
        //         this.eExpandButton.removeEventListener('click',this.onExpandButtonClickedListener);
        //     };

        //     return CustomHeaderGroup;
        // },
        // getTargetMarketCheckRenderer : function(isEditable){
        //     function CheckboxRenderer() {}

        //     CheckboxRenderer.prototype.init = function(params) {
        //         this.params = params;
        //         this.eGui = document.createElement('div');                  
        //         var itag = document.createElement('i');
        //         itag.classList.add('far');
        //         itag.classList.add('fa-square');
        //         itag.style.opacity = '0.5';
        //         itag.style.fontSize = '1.5em';
        //         switch(params.value){
        //         case 'BIZ_DVSN_MARKET_TYPE_M':
        //             itag.style.backgroundColor = '#105bff';//opacity:0.8;
        //             break;
        //         case 'BIZ_DVSN_MARKET_TYPE_S':
        //             itag.style.backgroundColor = '#55f700';
        //             break;                    
        //         default:
        //             itag.style.backgroundColor = '';
        //         }
                
        //         if(isEditable){                    
        //             this.checkedHandler = this.checkedHandler.bind(this);                    
        //             this.eGui.addEventListener('click', this.checkedHandler);
        //             params.eGridCell.addEventListener('click', this.checkedHandler);
        //         } 

        //         this.eGui.appendChild(itag);
                
        //         params.eGridCell.addEventListener('dblclick', this.stopdblClickHandler);
        //     }

        //     CheckboxRenderer.prototype.stopdblClickHandler = function(e) {
        //         e.stopImmediatePropagation();
        //     }

        //     CheckboxRenderer.prototype.checkedHandler = function(e) {                    
        //         //var checked = e.target.checked ? 'Y': 'N';
        //         let _this = this;
        //         let colId = this.params.column.colId;
        //         // console.log('colId', colId);
        //         let newValue = undefined;
        //         //Main Market 선택 여부 체크
        //         let targetMarketMain = AG_GRID.getTargetMarketMain(this.params);

        //         if(targetMarketMain) {
        //             switch(this.params.data[colId]){
        //             case 'BIZ_DVSN_MARKET_TYPE_S':
        //                 newValue = 'N';
        //                 break;                    
        //             default:
        //                 newValue = 'BIZ_DVSN_MARKET_TYPE_S';
        //             } 
        //         } else {
        //             switch(this.params.data[colId]){
        //             case 'BIZ_DVSN_MARKET_TYPE_M': 
        //                 newValue = 'BIZ_DVSN_MARKET_TYPE_S';                       
        //                 break;
        //             case 'BIZ_DVSN_MARKET_TYPE_S':
        //                 newValue = 'N';
        //                 break;                    
        //             default:
        //                 newValue = 'BIZ_DVSN_MARKET_TYPE_M';
        //             } 

        //         }
        //         /*
        //         switch(this.params.data[colId]){
        //         case 'BIZ_DVSN_MARKET_TYPE_M': 
        //             newValue = 'BIZ_DVSN_MARKET_TYPE_S';                       
        //             break;
        //         case 'BIZ_DVSN_MARKET_TYPE_S':
        //             newValue = 'N';
        //             break;                    
        //         default:
        //             newValue = 'BIZ_DVSN_MARKET_TYPE_M';
        //         } 
        //         */
        //         this.params.node.setDataValue(colId, newValue);
        //         e.stopImmediatePropagation();
        //     }

        //     CheckboxRenderer.prototype.getGui = function(params) {
        //         return this.eGui;
        //     }

        //     CheckboxRenderer.prototype.destroy = function(params) {
        //         this.eGui.removeEventListener('click', this.checkedHandler);
        //         this.eGui.removeEventListener('dblclick', this.stopdblClickHandler);
        //     }

        //     return CheckboxRenderer;
        // }, 
        // getTargetMarketMain : function(params) {
        //     let _this = this;
        //     const markColId = ['markNaCode','markSaCode','markEuCode','markMeCode','markAfriCode'
        //                     ,'markApCode','markCnCode','markAseaCode','markIndiCode','markKrCode'];
        //     let targetMarketMain = false;
        //     markColId.forEach((o) => {                    
        //         if(params.data[o] == 'BIZ_DVSN_MARKET_TYPE_M')  {
        //             targetMarketMain = true;
        //         }
        //     })  
        //     return targetMarketMain;
        // },
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
                    let imageUid = AG_GRID.getDiffValue(params);
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
                
                $(this.eGui).flatpickr({
                    // mode: "range",
                    //minDate: 'today',
                    // dateFormat: 'Y-m-d',
                    dateFormat: ('de' === '${lang}')?'d-m-Y':'Y-m-d',
                    // defaultDate: params.value,
                    defaultDate: COMMON_SCRIPT.dateFormat(params.value),
                    onClose: function(selectedDates, dateStr, instance){
                        // this.params.node.setDataValue(this.params.column.colId, dateStr);
                        let toDate = COMMON_SCRIPT.dateFormatSvr(dateStr);
                        console.log('getDateCellEditor:dateStr', dateStr, toDate)
                        this.params.node.setDataValue(this.params.column.colId, toDate);
                    }.bind(this),
                });
            }                

            DateCellEditor.prototype.getGui = function(params) {
                return this.eGui;
            }

            DateCellEditor.prototype.afterGuiAttached = function() {
                this.eGui.focus();
            };

            DateCellEditor.prototype.getValue = function() {
                // return this.eGui.value;
                return COMMON_SCRIPT.dateFormatSvr(this.eGui.value);
            };

            DateCellEditor.prototype.destroy = function(params) {                    
            }

            DateCellEditor.prototype.isPopup = function() {
                return false;
            };
            
            return DateCellEditor;               
        },
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
                    dateFormat: ('de' === '${lang}')?'mY':'Ym',
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
                        dateFormat: ('de' === '${lang}')?'m.Y':"Y.m", //defaults to "F Y"
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
        },
        getNumericCellEditor : function () {
            function NumericCellEditor() {}

            // gets called once before the renderer is used
            NumericCellEditor.prototype.init = function (params) {
                this.div = document.createElement('div');
                this.div.setAttribute("class","inForm-write");

                // create the cell
                this.eInput = document.createElement('input');
                this.eInput.setAttribute("type", "text");
                this.eInput.setAttribute("class", "input");

                this.link = document.createElement('a');
                this.link.setAttribute("href","#");
                this.link.setAttribute("class","btn btn-del clear");

                if (AG_GRID.isCharNumeric(params.charPress)) {
                    this.eInput.value = params.charPress;
                } else {
                    if (params.value !== undefined && params.value !== null) {
                        let value = params.value || '';
                        if (params.colDef.valueFormatter !== undefined) {
                            value = params.colDef.valueFormatter(params);
                        } else if (params.colDef.valueGetter !== undefined) {
                            value = params.colDef.valueGetter(params);
                        }
                        this.eInput.value = value;
                    }
                }

                const allowNegative = params.colDef.cellRendererParams ? params.colDef.cellRendererParams.allowNegative || false : false; // 음수 입력 가능 여부
                var that = this;
                this.eInput.addEventListener('keypress', function (event) {
                    if (!AG_GRID.isKeyPressedNumeric(event, allowNegative)) {
                        that.eInput.focus();
                        if (event.preventDefault) event.preventDefault();
                    } else if (that.isKeyPressedNavigation(event)) {
                        event.stopPropagation();
                    }
                });

                this.link.addEventListener('click', () => {
                    this.eInput.value = '';
                    this.eInput.focus();
                })

                // only start edit if key pressed is a number, not a letter
                var charPressIsNotANumber = params.charPress && ('1234567890'.indexOf(params.charPress) < 0);
                this.cancelBeforeStart = charPressIsNotANumber;

                this.div.appendChild(this.eInput);
                this.div.appendChild(this.link);
            };

            NumericCellEditor.prototype.isKeyPressedNavigation = function (event) {
                return event.keyCode === 39
                    || event.keyCode === 37;
            };


            // gets called once when grid ready to insert the element
            NumericCellEditor.prototype.getGui = function () {
                return this.div;
            };

            // focus and select can be done after the gui is attached
            NumericCellEditor.prototype.afterGuiAttached = function () {
                this.eInput.focus();
            };

            // returns the new value after editing
            NumericCellEditor.prototype.isCancelBeforeStart = function () {
                return this.cancelBeforeStart;
            };

            // example - will reject the number if it contains the value 007
            // - not very practical, but demonstrates the method.
            NumericCellEditor.prototype.isCancelAfterEnd = function () {
                // var value = this.getValue();
                // return value.indexOf('007') >= 0;
            };

            // returns the new value after editing
            NumericCellEditor.prototype.getValue = function () {
                if(COMMONJS.isEmpty(this.eInput.value)) {
                    return this.eInput.value;
                }
                // return Number(COMMON_SCRIPT.numberFormatStd(this.eInput.value));
                return COMMON_SCRIPT.numberFormatStd(this.eInput.value);
            };

            // any cleanup we need to be done here
            NumericCellEditor.prototype.destroy = function () {
                // but this example is simple, no cleanup, we could  even leave this method out as it's optional
            };

            // if true, then this editor will appear in a popup
            NumericCellEditor.prototype.isPopup = function () {
                // and we could leave this method out also, false is the default
                return false;
            };

            return NumericCellEditor;
        },
        getTextCellEditor : function () {
            function TextCellEditor() {}

            // gets called once before the renderer is used
            TextCellEditor.prototype.init = function (params) {
                this.div = document.createElement('div');
                this.div.setAttribute("class","inForm-write");

                // create the cell
                this.eInput = document.createElement('input');
                this.eInput.setAttribute("type", "text");
                this.eInput.setAttribute("class", "input");

                this.link = document.createElement('a');
                this.link.setAttribute("href","#");
                this.link.setAttribute("class","btn btn-del clear");

                this.params = params;

                if (params.value !== null && params.value !== undefined) {
                    this.eInput.value = params.value;
                }
                if (params.charPress) {
                    this.eInput.value = params.charPress;
                }

                this.link.addEventListener('click', () => {
                    this.eInput.value = '';
                    this.eInput.focus();
                })

                this.div.appendChild(this.eInput);
                this.div.appendChild(this.link);
            };

            TextCellEditor.prototype.getGui = function () {
                return this.div;
            };

            TextCellEditor.prototype.getValue = function () {
                return this.eInput.value;
            };

            TextCellEditor.prototype.afterGuiAttached = function () {
                this.eInput.focus();
            };

            return TextCellEditor;
        },
        getComboCellEditor : function () {
            function ComboCellEditor() {}

            ComboCellEditor.prototype.init = function (params) {
                this.div = document.createElement('div');
                this.div.setAttribute("class","inForm-select1");

                this.select = document.createElement('select');
                this.select.setAttribute("class","select1");

                const codeId = params.colDef.cellRendererParams.codeId || '';
                $(this.select).empty().html(HTGF.UTILS.getCombo(codeId).join(''));

                this.select.value = params.value;
                this.div.appendChild(this.select);
            };

            ComboCellEditor.prototype.getGui = function () {
                return this.div;
            };

            ComboCellEditor.prototype.getValue = function () {
                return this.select.value;
            };

            return ComboCellEditor;
        },
        getCustomNoRowsOverlay: function() {
            function CustomNoRowsOverlay() {}

            CustomNoRowsOverlay.prototype.getGui = function () {
                const eDiv = document.createElement('div');
                eDiv.classList.add('ag-overlay-no-rows-center'); // AG Grid 기본 스타일 적용
                eDiv.innerText = 'Keine Daten';
                return eDiv;
            };

            return new CustomNoRowsOverlay();
        },
        isCharNumeric : function (charStr) {
            // console.log('isCharNumeric (charStr) => ', charStr, !!/\d/.test(charStr))
            // return !!/\d/.test(charStr);
            
            if('de' === '${lang}') {
                console.log('isCharNumeric (charStr) => ', charStr, !!/\d/.test(charStr) || !!/\,/.test(charStr) )
                return !!/\d/.test(charStr) || !!/\,/.test(charStr) ;
            } else {
                console.log('isCharNumeric (charStr) => ', charStr, !!/\d/.test(charStr) || !!/\,/.test(charStr) || !!/\./.test(charStr))
                return !!/\d/.test(charStr) || !!/\,/.test(charStr) || !!/\./.test(charStr);
            }
        },
        isKeyPressedNumeric : function (event, allowNegative = false) {
            var charCode = AG_GRID.getCharCodeFromEvent(event);
            var charStr = String.fromCharCode(charCode);
            if(allowNegative){
                return AG_GRID.isCharNumeric(charStr) || !!/\-/.test(charStr);
            }else{
                return AG_GRID.isCharNumeric(charStr);
            }
        },
        getCharCodeFromEvent : function (event) {
            event = event || window.event;
            return (typeof event.which == "undefined") ? event.keyCode : event.which;
        },
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
        cell(text, styleId) {
            return {
                styleId: styleId,
                data: {
                type: /^\d+$/.test(text) ? "Number" : "String",
                value: (text == undefined || text == null) ? '':String(text),
                },
            };
        },
        getSelectedRowsOnCurrentPage(gridApi) {
            // 현재 페이지에 렌더링된 노드 가져오기
            const renderedNodes = gridApi.getRenderedNodes();

            // 렌더링된 노드 중 선택된 행 필터링
            const currentPageRows = renderedNodes
                .filter(node => node.isSelected())
                .map(node => node.data);

            return currentPageRows;
        }
        
    };

    window.AG_GRID = AG_GRID;

});

// const CELL_CLASS_RULES = {
//     'diff-cell': (params) => AG_GRID.diffCellStyle(params),
//     'cell-span-odd': (params) => AG_GRID.oddRowSpan(params),
//     'cell-span-even': (params) => AG_GRID.evenRowSpan(params),
//     'matter-issue-cell': (params) => AG_GRID.matterIssueCellStyle(params),
// }
</script>