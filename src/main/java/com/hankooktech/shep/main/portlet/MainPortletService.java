package com.hankooktech.shep.main.portlet;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.biz_common.common.CommonUtils;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MainPortletService {
	private final MainPortletMapper mapper;
	
	public Page<Map<String, String>> selectRecentVisit(UserSessionDTO session, Map<String, String> param, Pageable page) {
		param.put("userId", session.getUserId());
		param.put("userUuid", session.getId());
		List<Map<String, String>> list = Optional.ofNullable(mapper.selectRecentVisit(param, page)).orElse(Collections.emptyList());
		
		long count = 0L;
		if ((list != null) && (list.size() > 0)) {
			try { 
				count = Long.parseLong( CommonUtils.nvl(list.get(0).get("TOTAL_CNT"), "0") ); 
			} catch(Exception e) {}
		}
		
		return new PageImpl(list, page, count);		
	}
	
	public Page<Map<String, String>> selectTodoList(UserSessionDTO session, Map<String, String> param, Pageable page) {
		param.put("userId", session.getUserId());
		param.put("userUuid", session.getId());
		param.put("userDeptCode", session.getDeptCode());
		List<Map<String, String>> list = Optional.ofNullable(mapper.selectTodoList(param, page)).orElse(Collections.emptyList());
		
		long count = 0L;
		if ((list != null) && (list.size() > 0)) {
			try { 
				count = Long.parseLong( CommonUtils.nvl(list.get(0).get("TOTAL_CNT"), "0") ); 
			} catch(Exception e) {}
		}
		
		return new PageImpl(list, page, count);	
	}
	
	public Page<Map<String, String>> selectSendMessageList(UserSessionDTO session, Map<String, String> param, Pageable page) {
		param.put("userId", session.getId());
		param.put("userUuid", session.getId());
		List<Map<String, String>> list = Optional.ofNullable(mapper.selectSendMessageList(param, page)).orElse(Collections.emptyList());
		
		long count = 0L;
		if ((list != null) && (list.size() > 0)) {
			try { 
				count = Long.parseLong( CommonUtils.nvl(list.get(0).get("TOTAL_CNT"), "0") ); 
			} catch(Exception e) {}
		}
		
		return new PageImpl(list, page, count);	
	}
	
	public List<Map<String, String>> selectSendMessageTargetList(UserSessionDTO session, String messageId) {
		return this.mapper.selectSendMessageTargetList(messageId);
	}
	
	public Page<Map<String, String>> selectBbsNoticeQna(UserSessionDTO session, Map<String, String> param, Pageable page) {
		List<Map<String, String>> list = Optional.ofNullable(mapper.selectBbsNoticeQna(param, page)).orElse(Collections.emptyList());
		
		long count = 0L;
		if ((list != null) && (list.size() > 0)) {
			try { 
				count = Long.parseLong( CommonUtils.nvl(list.get(0).get("TOTAL_CNT"), "0") ); 
			} catch(Exception e) {}
		}
		
		return new PageImpl(list, page, count);		
	}
	
	public Page<Map<String, String>> selectBbsRecent(UserSessionDTO session, Map<String, String> param, Pageable page) {
		List<Map<String, String>> list = Optional.ofNullable(mapper.selectBbsRecent(page)).orElse(Collections.emptyList());
		
		long count = 0L;
		if ((list != null) && (list.size() > 0)) {
			try { 
				count = Long.parseLong( CommonUtils.nvl(list.get(0).get("TOTAL_CNT"), "0") ); 
			} catch(Exception e) {}
		}
		
		return new PageImpl(list, page, count);		
	}
}
