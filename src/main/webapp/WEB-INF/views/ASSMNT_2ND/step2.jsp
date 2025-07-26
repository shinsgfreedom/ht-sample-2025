<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="${menuId}">
    <div class="page-head">
        <h2 class="page-title">2차 평가</h2>
    </div>
    <div class="page-cont">
        <!--cont-search-box-->
        <div class="cont-search-box type2">
            <div class="form-box">
                <div class="dl-col row4 sb50">
                    <dl>
                        <dt style="width: 100px;">
                            <span>평가연도</span>
                        </dt>
                        <dd>
                            <select class="select1">
                                <option>2025년</option>
                            </select>
                        </dd>
                    </dl>
                    <dl>
                        <dt style="width: 100px;">
                            <span>평가시기</span>
                        </dt>
                        <dd>
                            <select class="select1">
                                <option>상반기</option>
                            </select>
                        </dd>
                    </dl>
                </div>
            </div>
            <div class="btn-box">
                <button type="button" class="btn-search">SEARCH</button>
                <button type="button" class="btn-refresh">REFRESH</button>
            </div>
        </div>
        <!--//cont-search-box-->

        <!--cont-col-box-->
        <div class="cont-col-box mgt10">
            <div class="box-head flex-sb">
                <div class="sb-l">
                    <h3 class="cont-tit dep1">평가그룹</h3>
                    <div class="tag-group">
                        <select class="select1" style="width: 200px;">
                            <option>3. 관리감독자</option>
                        </select>
                        <a href="#" class="btn-l type2">
                            <i class="ico ico-search2-20-20">검색</i>
                        </a>
                    </div>
                </div>
            </div>
            <div class="box-body">
                <!--cont-border-box-->
                <div class="cont-border-box type-style2">
                    <div class="box-head">
                        <div class="flex-row sb10">
                            <!--dl-info-box-->
                            <div class="dl-info-box">
                                <dl>
                                    <dt class="tit">
                                        <i class="ico ico-user-20-20"></i>
                                        <p class="txt">피평가자</p>
                                    </dt>
                                    <dd class="info">
                                        <!--table-style-box-->
                                        <div class="table-style-box type2">
                                            <table>
                                                <colgroup>
                                                    <col style="width: 36%;" />
                                                    <col />
                                                    <col />
                                                </colgroup>
                                                <tbody>
                                                <tr>
                                                    <th scope="row">평가그룹</th>
                                                    <td colspan="2">3.관리감독자</td>
                                                </tr>
                                                <tr>
                                                    <th scope="col">평가대상</td>
                                                    <th scope="col">완료</td>
                                                    <th scope="col">미완료</td>
                                                </tr>
                                                <tr>
                                                    <td>7명</td>
                                                    <td>5명</td>
                                                    <td>2명</td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <!--//table-style-box-->
                                    </dd>
                                </dl>
                            </div>
                            <!--//dl-info-box-->
                            <!--dl-info-box-->
                            <div class="dl-info-box">
                                <dl>
                                    <dt class="tit">
                                        <i class="ico ico-user-20-20"></i>
                                        <p class="txt">1차평가</p>
                                    </dt>
                                    <dd class="info">
                                        <p class="txt">DP)제조팀</p>
                                        <p class="txt">팀장</p>
                                        <p class="txt">흥아무개</p>
                                    </dd>
                                </dl>
                            </div>
                            <!--//dl-info-box-->
                            <!--dl-info-box-->
                            <div class="dl-info-box">
                                <dl>
                                    <dt class="tit">
                                        <i class="ico ico-user-20-20"></i>
                                        <p class="txt">2차평가</p>
                                    </dt>
                                    <dd class="info">
                                        <p class="txt">ES) 대전공장</p>
                                        <p class="txt">공장장</p>
                                        <p class="txt">이아무개</p>
                                    </dd>
                                </dl>
                            </div>
                            <!--//dl-info-box-->
                        </div>
                    </div>
                    <div class="box-head flex-sb">
                        <div class="sb-l total-box">
                            <div class="txt-box">
                                <span class="txt">Total 100</span>
                            </div>
                        </div>
                        <div class="sb-r">
                            <div class="cont-btn-box">
                                <a href="#" class="btn-s type3">
                                    <span class="txt">제출</span>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="box-body">
                        <!--table-style-box-->
                        <div class="table-style-box">
                            <table>
                                <colgroup>
                                    <col style="width: 70px;" />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                </colgroup>
                                <thead>
                                <tr>
                                    <th scope="col">No.</th>
                                    <th scope="col">소속</th>
                                    <th scope="col">직책</th>
                                    <th scope="col">성명</th>
                                    <th scope="col">평가표</th>
                                    <th scope="col">1차 평가점수</th>
                                    <th scope="col">진행현황</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>DP)제조팀</td>
                                    <td>주임</td>
                                    <td>김아무개</td>
                                    <td></td>
                                    <td>96</td>
                                    <td>완료</td>
                                </tr>
                                <tr class="bg3">
                                    <td>2</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td>
                                        <a href="#" class="btn-s type4">
                                            <span class="txt">입력</span>
                                        </a>
                                    </td>
                                    <td></td>
                                    <td>미완료</td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>4</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!--//table-style-box-->
                    </div>
                </div>
                <!--//cont-border-box-->
            </div>
        </div>
        <!--//cont-col-box-->
    </div>
</div>