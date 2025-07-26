package com.hankooktech.shep.main.mypage;

import static com.hankooktech.shep.main.mypage.MyPageController.MENU_ID;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hankooktech.fc.annotations.FcMenuId;

import lombok.AllArgsConstructor;

@Validated
@RestController
@FcMenuId(MENU_ID)
@RequestMapping("/api/" + MENU_ID)
@AllArgsConstructor
public class MyPageApiController {
	/**
	 * 메뉴 ID
	 */
	private final MyPageService service;
	
}
