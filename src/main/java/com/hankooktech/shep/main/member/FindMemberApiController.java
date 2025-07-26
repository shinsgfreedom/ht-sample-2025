package com.hankooktech.shep.main.member;

import java.util.List;
import java.util.Map;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hankooktech.shep.common.result.HTDataMap;
import com.hankooktech.fc._infra.Api;
import com.hankooktech.fc._infra.Api.FCResponseStatus;
import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcNoAuth;

import lombok.AllArgsConstructor;

@Validated
@RestController
@RequestMapping("/api/FIND_MEMBER")
@AllArgsConstructor
public class FindMemberApiController {
	private final FindMemberService service;
	
	
	@FcNoAuth
	@GetMapping
	public HTDataMap findMember (@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch) throws Exception{
		HTDataMap result = new HTDataMap();
		result.put("list", this.service.findMemberList(session, reqSearch));
		return result;
	}
	
	@FcNoAuth
	@GetMapping("/{uuid}")
	public HTDataMap findMemberDetail (@UserSession UserSessionDTO session, @PathVariable final String uuid) throws Exception{
		HTDataMap result = new HTDataMap();
		
		Map<String, String> detail = this.service.findMemberDetail(session, uuid);
		result.put("detail", detail );
		return result;
	}
	
	@FcNoAuth
	@DeleteMapping("/{detailId}")
	public Api.Response<FCResponseStatus> delete(@UserSession UserSessionDTO session, @PathVariable final String detailId) {
		this.service.deleteFavorite(session, detailId);
		return Api.Response.success(); 
	}
	
	@FcNoAuth
	@GetMapping("/recently")
	public List<Map<String, String>> recently(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch) {
		return this.service.findRecentlyViewedList(session, reqSearch);
	}
	
	@FcNoAuth
	@PostMapping("/recently/{targetId}")
	public Api.Response<FCResponseStatus> saveRecentlyViewd(@UserSession UserSessionDTO session, @PathVariable(value = "targetId") String targetId) {
		this.service.mergeRecentlyViewed(session, targetId);
		return Api.Response.success();
	}
	
	@FcNoAuth
	@DeleteMapping("/recently/{targetId}")
	public Api.Response<FCResponseStatus> removeRecentlyViewed(@UserSession UserSessionDTO session, @PathVariable(value = "targetId") String targetId) {
		this.service.deleteRecentlyViewed(session, targetId);
		return Api.Response.success();
	}

	@FcNoAuth
	@DeleteMapping("/recently")
	public Api.Response<FCResponseStatus> removeAllRecentlyViewed(@UserSession UserSessionDTO session) {
		this.service.deleteAllRecentlyViewed(session);
		return Api.Response.success();
	}
	
	@FcNoAuth
	@GetMapping("/favorite/list")
	public HTDataMap getFavoriteMemberList(@UserSession UserSessionDTO session, @RequestParam Map<String, String> reqSearch) throws Exception{
		HTDataMap result = new HTDataMap();
		result.put("list", this.service.getFavoriteMemberList(session, reqSearch));
		return result;
	}
	
	@FcNoAuth
	@GetMapping("/userList/{deptCd}")
	public HTDataMap getUsers(@PathVariable("deptCd") String deptCd) {
		HTDataMap result = new HTDataMap();
		result.put("list", this.service.getUsers(deptCd));
		return result;
	}
}
