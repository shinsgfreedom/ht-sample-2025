<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/ag_grid/de-DE.js"></script><!-- 다국어 파일 추가 : 독일 -->
<script src="/ag_grid/ag-grid-enterprise.min.noStyle.js"></script>
<link href="/ag_grid/styles/ag-grid.min.css" rel="stylesheet">
<link href="/ag_grid/styles/ag-theme-alpine.min.css" rel="stylesheet">
<link href="/ag_grid/styles/ag-theme-balham.min.css" rel="stylesheet">

<script>
    (function () {
        var licenseKey = 'Using_this_{AG_Grid}_Enterprise_key_{AG-065879}_in_excess_of_the_licence_granted_is_not_permitted___Please_report_misuse_to_legal@ag-grid.com___For_help_with_changing_this_key_please_contact_info@ag-grid.com___{Reifen_Mueller_GmbH_&_Co._KG}_is_granted_a_{Multiple_Applications}_Developer_License_for_{3}_Front-End_JavaScript_developers___All_Front-End_JavaScript_developers_need_to_be_licensed_in_addition_to_the_ones_working_with_{AG_Grid}_Enterprise___This_key_has_not_been_granted_a_Deployment_License_Add-on___This_key_works_with_{AG_Grid}_Enterprise_versions_released_before_{26_August_2025}____[v3]_[01]_MTc1NjE2MjgwMDAwMA==38ffe37b91fb0e8be45fee42c63f9ee3'
        agGrid.LicenseManager.setLicenseKey(licenseKey)

        agGrid.getRequestInfo = function(){
            return this.__requestInfo;
        }
        agGrid.fcHttpRequest = function(request, gridOptions){
            if( gridOptions ) {
                gridOptions.__requestInfo = {
                    params: request.params,
                    paramsMeta: request.paramsMeta,
                    gridName: request.gridName,
                };
            }
            if( request.method === 'GET') return HTGF.Api.get(request.url, request.params, request.header)
            else if( request.method === 'POST') return HTGF.Api.post(request.url, request.params, request.header)
            else if( request.method === 'PUT') return HTGF.Api.put(request.url, request.params, request.header)
            else if( request.method === 'DELETE') return HTGF.Api.delete(request.url, request.params)
            else return HTGF.Api.get(request.url, request.params, request.header)
        }
    })()
</script>