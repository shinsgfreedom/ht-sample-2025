package com.hankooktech.shep.main.search;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hankooktech.shep.main.MainMapper;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@AllArgsConstructor
public class IntegratedSearchService {
	private final MainMapper mapper;
	
	@Transactional
	int saveSearchWord(String userUuid, String searchWord) {
		Map<String, String> param = new <String, String>HashMap();
		param.put("userUuid", userUuid);
		param.put("searchWord", searchWord);
		
		int cnt = this.mapper.insertSearchWord(param);
		cnt = cnt+this.mapper.deleteSearchWordByTen(param);
		
		return cnt;
	}

	@Transactional
	int removeSearchWord(String userUuid, String searchWord) {
		Map<String, String> param = new <String, String>HashMap();
		param.put("userUuid", userUuid);
		param.put("searchWord", searchWord);
		
		return this.mapper.deleteSearchWord(param);
	}
}
