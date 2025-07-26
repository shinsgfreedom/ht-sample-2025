package com.hankooktech.shep.main;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.annotation.PostConstruct;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hankooktech.shep.common.result.HTDataMap;
import com.hankooktech.fc._infra.Api;
import com.hankooktech.fc._infra.Api.FCResponseStatus;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.biz_common.common.CommonUtils;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@AllArgsConstructor
public class MainService {
	private final MainMapper mapper;

	@PostConstruct
	void setUp() {
		log.debug(" MainService.list() => " + mapper.list());
	}
	
	public List<Map<String, String>> selectUserTab(UserSessionDTO session) {
		List<Map<String, String>> list = Optional.ofNullable(mapper.selectUserTab(session.getId())).orElse(Collections.emptyList());
		return list;
	}
	
	@Transactional
	public Api.Response<FCResponseStatus> saveUserTab(UserSessionDTO session, Map<String, String> paramMap) {
		paramMap.put("userId", session.getId());
		if("I".equals(paramMap.get("saveFlag"))) {
			paramMap.put("uuid", CommonUtils.uuid());
			mapper.insertUserTab(paramMap);
		} else if("D".equals(paramMap.get("saveFlag"))) {
			mapper.deleteUserTab(paramMap);
		}
		return Api.Response.success();
	}
	
	public HTDataMap getUserConfigDetail(UserSessionDTO session) throws Exception {
		HTDataMap userConfig = mapper.getUserConfigDetail(session.getId());

		if (userConfig == null) {
			userConfig = new HTDataMap();
			userConfig.put("userId", session.getId());
			userConfig.put("quickAll", "Y");
			userConfig.put("topLayerDisplay", "Y");
			userConfig.put("quickLinkDisplay", "Y");
			userConfig.put("quickMenuDisplay", "Y");
			userConfig.put("myMenuDisplay", "Y");
			userConfig.put("myMenuFix", "N");
			userConfig.put("memberAutoSave", "Y");
			userConfig.put("portletDynamicLoad", "Y");
		}
		
		return userConfig;
	}
	
	@Transactional
	public Api.Response<FCResponseStatus> saveUserConfig(UserSessionDTO session, Map<String, String> paramMap) {
		paramMap.put("userId", session.getId());
		mapper.saveUserConfig(paramMap);
		return Api.Response.success();
	}
	
	public List<Map<String, String>> selectSearchWords(UserSessionDTO session) {
		List<Map<String, String>> list = Optional.ofNullable(mapper.selectSearchWords(session.getId())).orElse(Collections.emptyList());
		return list;
	}
	
}
