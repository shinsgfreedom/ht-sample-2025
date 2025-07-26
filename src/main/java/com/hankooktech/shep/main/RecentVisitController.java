package com.hankooktech.shep.main;

import static com.hankooktech.shep.main.RecentVisitController.MENU_ID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcMenuId;
import com.hankooktech.fc.annotations.FcNoAuth;

import lombok.AllArgsConstructor;

@Validated
@Controller
@FcMenuId(MENU_ID)
@RequestMapping(MENU_ID)
@AllArgsConstructor
public class RecentVisitController {
	/**
	 * 메뉴 ID
	 */
	public static final String MENU_ID = "RECENT_VISIT";
	
	@FcNoAuth
	@RequestMapping("/index.html")
	public String page(Model model, @UserSession UserSessionDTO session) {
		model.addAttribute("menuId", MENU_ID);
		return "views/portlet/recentVisitList";
	}
	
}
