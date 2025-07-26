package com.hankooktech.shep.main.favorite;

import java.util.List;
import java.util.Map;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hankooktech.fc._infra.Api;
import com.hankooktech.fc._infra.Api.FCResponseStatus;
import com.hankooktech.fc._infra.Api.Response;
import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcNoAuth;

import lombok.AllArgsConstructor;

@Validated
@RestController
@RequestMapping("/api/favorite")
@AllArgsConstructor
public class MyFavoriteApiController {
	private final MyFavoriteService service;
	
	@FcNoAuth
	@GetMapping
	public List<Map<String, String>> get(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch) {
		return this.service.selectFavoriteList(session, reqSearch);
	}
	
	@FcNoAuth
	@PostMapping
	public Api.Response<FCResponseStatus> post(@UserSession UserSessionDTO session, @RequestBody Map<String, String> reqParam) {
		service.insertFavorite(session, reqParam);
		return Api.Response.success();
	}
	
	@FcNoAuth
	@PutMapping
	public Api.Response<FCResponseStatus> putTitle(@UserSession UserSessionDTO session, @RequestBody Map<String, String> reqParam) {
		service.updateFavoriteTitle(session, reqParam);
		return Api.Response.success();
	}
	
	@FcNoAuth
	@DeleteMapping("/{uuid}")
	public Api.Response<FCResponseStatus> delete(@PathVariable final String uuid , @UserSession UserSessionDTO session ) {
		service.deleteFavorite(session, uuid);
		return Api.Response.success();
	}
	
	@FcNoAuth
	@GetMapping({"/getMyBookmarkLately"})
	public List<Map<String, String>> selectMyBookmarkLatelyList(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch) {
		return this.service.selectMyBookmarkLatelyList(session, reqSearch);
	}
	
	@FcNoAuth
	@GetMapping({"/getMyBookmarkMostview"})
	public List<Map<String, String>> selectMyBookmarkMostviewList(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch) {
		return this.service.selectMyBookmarkMostviewList(session, reqSearch);
	}
	
	@FcNoAuth
	@GetMapping({"/getMyContentsBookmarkStatus"})
	public Map<String, String> selectMyContentsBookmarkStatus(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch) {
		return this.service.selectMyContentsBookmarkStatus(session, reqSearch);
	}
	
	@FcNoAuth
	@PostMapping({"/saveMyContentsBookmark"})
	public Api.Response<FCResponseStatus> insertMyContentsBookmark(@UserSession UserSessionDTO session, @RequestBody Map<String, String> reqParam) {
		String uuid = service.insertMyContentsBookmark(session, reqParam);
		return new Response<>("ok",uuid);
	}
}
