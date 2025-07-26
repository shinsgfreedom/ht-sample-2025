package com.hankooktech.shep.main;

import static com.hankooktech.shep.main.MainController.MENU_ID;

import java.util.List;
import java.util.Map;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hankooktech.shep.common.result.HTDataMap;
import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcMenuId;
import com.hankooktech.fc.annotations.FcReadable;

import lombok.AllArgsConstructor;

@Slf4j
@Validated
@Controller
@FcMenuId(MENU_ID)
@RequestMapping(MENU_ID)
@AllArgsConstructor
public class MainController {
	/**
	 * 메뉴 ID
	 */
	public static final String MENU_ID = "MAIN";
	private final MainService service;

	/**
	 * 읽기 가능한 랜딩 페이지
	 * entryPoint = true 이면 메뉴 클릭시 첫 랜딩 페이지가 됩니다
	 * 컨트롤러 내부에 적어도 하나의 entryPoint=true 인 url Mapping이 존재해야합니다.
	 */
	@FcReadable(entryPoint = true) // 읽기 권한이 있는 사람만 접근 가능
	@RequestMapping("/main.html")
	public String index(Model model, @UserSession UserSessionDTO session) throws Exception {

		HTDataMap userConfig = this.service.getUserConfigDetail(session);

		// 로그인 사용자 Tab 정보
//		List<Map<String, String>> userTabs= this.service.selectUserTab(session);
//		userConfig.put("userTabs", userTabs);

		List<Map<String, String>> searchWords= this.service.selectSearchWords(session);
		userConfig.put("searchWords", searchWords);

		model.addAttribute("globalUserConfig", userConfig);
		model.addAttribute("menuId", MENU_ID);
		return "main/main";
	}

	@FcReadable // 읽기 권한이 있는 사람만 접근 가능
	@RequestMapping("/fullscreen.html")
	public String fullscreen(Model model, @UserSession UserSessionDTO session) throws Exception {
		HTDataMap userConfig = new HTDataMap();
		
		model.addAttribute("globalUserConfig", userConfig);
		return "common/fullscreen";
	}
	
	@FcReadable // 읽기 권한이 있는 사람만 접근 가능
	@RequestMapping("/refresh.html")
	public String refresh(Model model, @UserSession UserSessionDTO session) throws Exception {
		return "shep-tpl/main";
	}
}
