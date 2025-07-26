package com.hankooktech.shep.main.member;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hankooktech.fc._infra.Api;
import com.hankooktech.fc._infra.Api.FCResponseStatus;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.biz_common.common.CommonUtils;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@AllArgsConstructor
public class FindMemberService {
	private final FindMemberMapper mapper;

	public List<Map<String, String>> findMemberList(UserSessionDTO session, Map<String, String> reqSearch) {
		reqSearch.put("userId", session.getId());
		List<Map<String, String>> list = Optional.ofNullable(mapper.findMemberList(reqSearch)).orElse(Collections.emptyList());
		return list;
	}
	
	public Map<String, String> findMemberDetail(UserSessionDTO session, String uuid) {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userId", session.getId());
		paramMap.put("uuid", uuid);
		
		return mapper.findMemberDetail(paramMap);
	}
	
	@Transactional
	public Api.Response<FCResponseStatus> deleteFavorite(UserSessionDTO session, String detailId) {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userId", session.getId());
		paramMap.put("detailId", detailId);
		
		mapper.deleteFavorite(paramMap);
		return Api.Response.success();
	}
	
	public List<Map<String, String>> findRecentlyViewedList(UserSessionDTO session, Map<String, String> paramMap) {
		paramMap.put("userId", session.getId());
		return this.mapper.findRecentlyViewedList(paramMap);
	}
	
	@Transactional
	public Api.Response<FCResponseStatus> mergeRecentlyViewed(UserSessionDTO session, String targetId) {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("uuid", CommonUtils.uuid());
		paramMap.put("userId", session.getId());
		paramMap.put("targetId", targetId);
		
		mapper.mergeRecentlyViewed(paramMap);
		return Api.Response.success();
	}
	
	@Transactional
	public Api.Response<FCResponseStatus> deleteRecentlyViewed(UserSessionDTO session, String targetId) {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userId", session.getId());
		paramMap.put("targetId", targetId);
		
		mapper.deleteRecentlyViewed(paramMap);
		return Api.Response.success();
	}
	
	@Transactional
	public Api.Response<FCResponseStatus> deleteAllRecentlyViewed(UserSessionDTO session) {
		mapper.deleteAllRecentlyViewed(session.getId());
		return Api.Response.success();
	}
	
	public List<Map<String, String>> getFavoriteMemberList(UserSessionDTO session, Map<String, String> reqSearch) {
		reqSearch.put("userId", session.getId());
		List<Map<String, String>> list = Optional.ofNullable(mapper.getFavoriteMemberList(reqSearch)).orElse(Collections.emptyList());
		return list;
	}
	
	public List<Map<String, String>> getUsers(String deptCd) {
		List<Map<String, String>> list = Optional.ofNullable(mapper.getUsers(deptCd)).orElse(Collections.emptyList());
		return list;
	}
}
