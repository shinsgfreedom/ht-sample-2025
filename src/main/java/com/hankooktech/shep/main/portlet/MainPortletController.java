package com.hankooktech.shep.main.portlet;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcNoAuth;

import lombok.AllArgsConstructor;

@Validated
@Controller
@RequestMapping("portlet")
@AllArgsConstructor
public class MainPortletController {
	private final MainPortletService service;
	
	@FcNoAuth
	@RequestMapping("/recentVisit.html")
	public String recentVisit(Model model, @UserSession UserSessionDTO session) {
		return "portlet/recentVisitPortlet";
	}
	
	@FcNoAuth
	@RequestMapping("/todoList.html")
	public String todoList(Model model, @UserSession UserSessionDTO session) {
		return "portlet/todoListPortlet";
	}
	
	@FcNoAuth
	@RequestMapping("/myAlram.html")
	public String myAlram(Model model, @UserSession UserSessionDTO session) {
		return "portlet/myAlramPortlet";
	}
	
	@FcNoAuth
	@RequestMapping("/outlook.html")
	public String outlook(Model model, @UserSession UserSessionDTO session) {
		return "portlet/outlookPortlet";
	}
	
	@FcNoAuth
	@RequestMapping("/mySchedule.html")
	public String mySchedule(Model model, @UserSession UserSessionDTO session) {
		return "portlet/mySchedulePortlet";
	}
	
	@FcNoAuth
	@RequestMapping("/myMessage.html")
	public String myMessage(Model model, @UserSession UserSessionDTO session) {
		return "portlet/myMessagePortlet";
	}
	
	@FcNoAuth
	@RequestMapping("/projectStatusOeDetail.html")
	public String projectStatusOeDetail(Model model, @UserSession UserSessionDTO session) {
		/* OE Project Status (2021 MP-Gate) */
		return "portlet/projectStatusOePortletDetail";
	}
	
	@FcNoAuth
	@RequestMapping("/projectStatusReDetail.html")
	public String projectStatusReDetail(Model model, @UserSession UserSessionDTO session) {
		/* RE Project Status (2021 S-spec) */
		return "portlet/projectStatusRePortletDetail";
	}
	
	@FcNoAuth
	@RequestMapping("/projectStatusTbDetail.html")
	public String projectStatusTbDetail(Model model, @UserSession UserSessionDTO session) {
		/* TB Project Status (2021 S-spec) */
		return "portlet/projectStatusTbPortletDetail";
	}
	
	@FcNoAuth
	@RequestMapping("/techInfoDetail.html")
	public String techInfoDetail(Model model, @UserSession UserSessionDTO session) {
		/* Tech. Info. */
		return "portlet/techInfoPortletDetail";
	}
	
	@FcNoAuth
	@RequestMapping("/handlingSkuDetail.html")
	public String handlingSkuDetail(Model model, @UserSession UserSessionDTO session) {
		/* 2021 Handling SKU */
		return "portlet/handlingSkuPortletDetail";
	}
	
	@FcNoAuth
	@RequestMapping("/operatingSkuDetail.html")
	public String operatingSkuDetail(Model model, @UserSession UserSessionDTO session) {
		/* 2021 Operating SKU */
		return "portlet/operatingSkuDetailPortletDetail";
	}
	
	@FcNoAuth
	@RequestMapping("/tbrMonthProfitTrendDetail.html")
	public String tbrMonthProfitTrendDetail(Model model, @UserSession UserSessionDTO session) {
		/* TBR 월별 손익 추이 */
		return "portlet/tbrMonthProfitTrendPortletDetail";
	}
	
	@FcNoAuth
	@RequestMapping("/oeProjectMonitoringSumDetail.html")
	public String oeProjectMonitoringSumDetail(Model model, @UserSession UserSessionDTO session) {
		/* OE Project Monitoring (SUM.) */
		return "portlet/oeProjectMonitoringSumPortletDetail";
	}
	
	@FcNoAuth
	@RequestMapping("/oeSalesProfitReportDetail.html")
	public String oeSalesProfitReportDetail(Model model, @UserSession UserSessionDTO session) {
		/* OE Sales & Profit Report */
		return "portlet/oeSalesProfitReportPortletDetail";
	}
	
	@FcNoAuth
	@RequestMapping("/oeSellinDetail.html")
	public String oeSellinDetail(Model model, @UserSession UserSessionDTO session) {
		/* 판매주체별 Sell-in */
		return "portlet/oeSellinPortletDetail";
	}
	
	@FcNoAuth
	@RequestMapping("/bbsNoticeQna.html")
	public String bbsNoticeQna(Model model, @UserSession UserSessionDTO session) {
		/* 판매주체별 Sell-in */
		return "portlet/bbsNoticeQnaPortlet";
	}
	
	@FcNoAuth
	@RequestMapping("/bbsRecentPortlet.html")
	public String bbsRecentPortlet(Model model, @UserSession UserSessionDTO session) {
		/* 판매주체별 Sell-in */
		return "portlet/bbsRecentPortlet";
	}

}
