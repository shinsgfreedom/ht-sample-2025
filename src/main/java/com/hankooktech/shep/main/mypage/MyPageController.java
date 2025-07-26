package com.hankooktech.shep.main.mypage;

import static com.hankooktech.shep.main.mypage.MyPageController.MENU_ID;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
public class MyPageController {
	/**
	 * 메뉴 ID
	 */
	public static final String MENU_ID = "MY_PAGE";
	private final MyPageService service;
	
	@FcNoAuth
	@RequestMapping("/index.html")
	public String page(Model model, @UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch) {
		String tabName = (reqSearch.get("tabName") != null) ? reqSearch.get("tabName") : "Todolist";
		model.addAttribute("tabName", tabName);
		return (reqSearch.get("option") != null && "tab".equals(reqSearch.get("option") ))? "mypage/mypage" : "views/mypage/mypage";
	}
	
	@FcNoAuth
	@RequestMapping("/getTabContent.html")
	public String getTabContent(Model model, @UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch) {
		String tabName = (reqSearch.get("tabName") != null) ? reqSearch.get("tabName") : "Todolist";
		String page = "mypage/todo_list";
		if("Todolist".equals(tabName)) {
			page = "mypage/my_todo_list";
		} else if("Notification".equals(tabName)) {
			page = "mypage/my_notification";
		} else if("Message".equals(tabName)) {
			page = "mypage/my_message";
		} else if("SCHEDULE".equals(tabName)) {
			page = "mypage/my_schedule";
		} else if("OUTLOOK".equals(tabName)) {
			page = "mypage/my_outlook";
		} else if("RecentVisit".equals(tabName)) {
			page = "mypage/my_recent_visit";
		} else if("FileUploadTest".equals(tabName)) {
			page = "mypage/my_fileupload_test";
		}
		return page;
	}
	
	@ModelAttribute("menuId")
	public String getMenuId(@UserSession UserSessionDTO session) {
		return MENU_ID;
	}
}
