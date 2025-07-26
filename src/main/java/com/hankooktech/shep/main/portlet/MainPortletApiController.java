package com.hankooktech.shep.main.portlet;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcNoAuth;

import lombok.AllArgsConstructor;

@Validated
@RestController
@RequestMapping("/api/portlet")
@AllArgsConstructor
public class MainPortletApiController {
	private final MainPortletService service;
	
	@FcNoAuth
	@GetMapping({"/selectRecentVisit"})
	public Page<Map<String, String>> selectRecentVisit(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch, Pageable page) {
		return this.service.selectRecentVisit(session, reqSearch, page);
	}
	
	@FcNoAuth
	@GetMapping({"/selectTodoList"})
	public Page<Map<String, String>> selectTodoList(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch, Pageable page) {
		return this.service.selectTodoList(session, reqSearch, page);
	}
	
	@FcNoAuth
	@GetMapping({"/selectSendMessageList"})
	public Page<Map<String, String>> selectSendMessageList(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch, Pageable page) {
		return this.service.selectSendMessageList(session, reqSearch, page);
	}
	
	@FcNoAuth
	@GetMapping({"/selectSendMessageTargetList/{messageId}"})
	public List<Map<String, String>> selectSendMessageTargetList(@UserSession UserSessionDTO session, @PathVariable String messageId) {
		return this.service.selectSendMessageTargetList(session, messageId);
	}
	
	@FcNoAuth
	@GetMapping({"/selectBbsNoticeQna"})
	public Page<Map<String, String>> selectBbsNoticeQna(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch, Pageable page) {
		return this.service.selectBbsNoticeQna(session, reqSearch, page);
	}
	
	@FcNoAuth
	@GetMapping({"/selectBbsRecent"})
	public Page<Map<String, String>> selectBbsRecent(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch, Pageable page) {
		return this.service.selectBbsRecent(session, reqSearch, page);
	}
}
