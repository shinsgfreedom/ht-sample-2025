package com.hankooktech.shep.main.favorite;

import java.util.Collections;
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
public class MyFavoriteService {
	private final MyFavoriteMapper mapper;
	
	public List<Map<String, String>> selectFavoriteList(UserSessionDTO session, Map<String, String> reqSearch) {
		reqSearch.put("userId", session.getId());
		List<Map<String, String>> list = Optional.ofNullable(mapper.selectFavoriteList(reqSearch)).orElse(Collections.emptyList());
		return list;
	}
	
	@Transactional
	public Api.Response<FCResponseStatus> insertFavorite(UserSessionDTO session, Map<String, String> paramMap) {
		paramMap.put("userId", session.getId());
		paramMap.put("uuid", CommonUtils.uuid());
		mapper.insertFavorite(paramMap);
		return Api.Response.success();
	}
	
	@Transactional
	public Api.Response<FCResponseStatus> updateFavoriteTitle(UserSessionDTO session, Map<String, String> paramMap) {
		paramMap.put("userId", session.getId());
		mapper.updateFavoriteTitle(paramMap);
		return Api.Response.success();
	}
	
	@Transactional
	public Api.Response<FCResponseStatus> deleteFavorite(UserSessionDTO session, String uuid) {
		mapper.deleteFavorite(uuid);
		return Api.Response.success();
	}
	
	public List<Map<String, String>> selectMyBookmarkLatelyList(UserSessionDTO session, Map<String, String> reqSearch) {
		reqSearch.put("userId", session.getId());
		List<Map<String, String>> list = Optional.ofNullable(mapper.selectMyBookmarkLatelyList(reqSearch)).orElse(Collections.emptyList());
		return list;
	}
	
	public List<Map<String, String>> selectMyBookmarkMostviewList(UserSessionDTO session, Map<String, String> reqSearch) {
		reqSearch.put("userId", session.getId());
		List<Map<String, String>> list = Optional.ofNullable(mapper.selectMyBookmarkMostviewList(reqSearch)).orElse(Collections.emptyList());
		return list;
	}
	
	public Map<String, String> selectMyContentsBookmarkStatus(UserSessionDTO session, Map<String, String> reqSearch) {
		reqSearch.put("userId", session.getId());
		Map<String, String> data = mapper.selectMyContentsBookmarkStatus(reqSearch);
		if(data != null) {
			mapper.updateMyContentsBookmarkReadCnt(data.get("MY_FAVORITE_UID"));
		}
		return data;
	}
	
	@Transactional
	public String insertMyContentsBookmark(UserSessionDTO session, Map<String, String> paramMap) {
		String uuid = CommonUtils.uuid();
		paramMap.put("userId", session.getId());
		paramMap.put("uuid", uuid);
		int result = mapper.insertMyContentsBookmark(paramMap);
		log.info("insertMyContentsBookmark:" + result);
		if(result != 1) {
			uuid = "";
		}
		return uuid;
	}

}
