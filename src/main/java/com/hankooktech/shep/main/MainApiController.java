package com.hankooktech.shep.main;

import static com.hankooktech.shep.main.MainController.MENU_ID;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hankooktech.shep.common.result.HTDataMap;
import com.hankooktech.shep.common.result.Result;
import com.hankooktech.fc._infra.Api;
import com.hankooktech.fc._infra.Api.FCResponseStatus;
import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcMenuId;
import com.hankooktech.fc.annotations.FcNoAuth;

import lombok.AllArgsConstructor;

@Validated
@RestController
@FcMenuId(MENU_ID)
@RequestMapping("/api/" + MENU_ID)
@AllArgsConstructor
public class MainApiController {
	/**
	 * 메뉴 ID
	 */
	private final MainService service;
	
	@FcNoAuth
	@PostMapping("/save-usertab")
	public Api.Response<FCResponseStatus> saveUserTab(@UserSession UserSessionDTO session, @RequestBody Map<String, String> reqParam) {
		service.saveUserTab(session, reqParam);
		return Api.Response.success();
	}
	
	@FcNoAuth
	@GetMapping("/userConfig/detail")
	public ResponseEntity<Result<HTDataMap>> getUserConfigDetail(@UserSession UserSessionDTO session, Map<String, String> reqParam) throws Exception {
		HTDataMap result = new HTDataMap();
		result  = service.getUserConfigDetail(session);
		return ResponseEntity.ok(new Result<>(result));
	}
	
	@FcNoAuth
	@PostMapping("/save-userConfig")
	public Api.Response<FCResponseStatus> saveUserConfig(@UserSession UserSessionDTO session, @RequestBody Map<String, String> reqParam) {
		service.saveUserConfig(session, reqParam);
		return Api.Response.success();
	}
}
