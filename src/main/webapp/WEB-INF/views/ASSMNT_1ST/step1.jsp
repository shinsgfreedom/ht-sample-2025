<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="${menuId}">
    <div class="page-head">
        <h2 class="page-title">1차 평가</h2>
    </div>
    <div class="page-cont" id="${menuId}">
        <div class="cont-col-box">
            <div class="box-body">
                <!--cont-table-box-->
                <div class="cont-table-box type-border">
                    <div class="box-body">
                        <div class="table-style-box">
                            <table>
                                <colgroup>
                                    <col style="width: 100px;"/>
                                    <col />
                                    <col style="width: 100px;"/>
                                    <col style="width: 100px;"/>
                                    <col style="width: 34%;"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th scope="col">No</th>
                                    <th scope="col">평가항목</th>
                                    <th scope="col">점수</th>
                                    <th scope="col">선택</th>
                                    <th scope="col">평가등급</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td rowspan="2">1</td>
                                    <td class="ta-l" rowspan="2">기계, 기구 또는 설비의 안전, 보건 점검 및 이상 유무의 확인</td>
                                    <td>3</td>
                                    <td>
                                        <label class="raBox solo">
                                            <input type="radio" />
                                            <span class="label">check</span>
                                        </label>
                                    </td>
                                    <td class="ta-l">기계,기구 안정장치 위반 0건</td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>
                                        <label class="raBox solo">
                                            <input type="radio" />
                                            <span class="label">check</span>
                                        </label>
                                    </td>
                                    <td class="ta-l">기계,기구 안정장치 위반 0건</td>
                                </tr>

                                <tr class="bg3">
                                    <td>2</td>
                                    <td class="ta-l">미 입력상태 tr.bg3</td>
                                    <td></td>
                                    <td>
                                        <!-- <label class="raBox solo">
                                            <input type="radio" />
                                            <span class="label">check</span>
                                        </label> -->
                                    </td>
                                    <td class="ta-l"></td>
                                </tr>
                                </tbody>
                                <tfoot>
                                <tr>
                                    <td></td>
                                    <td class="bold">점수 합계</td>
                                    <td><span class="fs-type1 bold">1642</span></td>
                                    <td></td>
                                    <td class="ta-l"></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td class="bold">환산 점수</td>
                                    <td><span class="fs-type1 bold">89</span></td>
                                    <td></td>
                                    <td class="ta-l">총점 100점 기준</td>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
                <!--//cont-table-box-->
            </div>
        </div>
    </div>
</div>