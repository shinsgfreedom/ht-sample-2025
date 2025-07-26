package com.hankooktech.shep.main;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankooktech.shep.common.result.HTDataMap;

@Mapper
@Repository
public interface MainMapper {
	List<Map<String, Object>> list();
	
	public abstract List<Map<String, String>> selectUserTab(String userId);
	public abstract Integer insertUserTab(Map<String, String> paramMap);
	public abstract Integer deleteUserTab(Map<String, String> paramMap);
	
	HTDataMap getUserConfigDetail(String userId) throws Exception;	
	public abstract Integer saveUserConfig(Map<String, String> paramMap);
	
	public abstract List<Map<String, String>> selectSearchWords(String userId);
	public abstract int insertSearchWord(Map<String, String> param);
	public abstract int deleteSearchWord(Map<String, String> param);
	public abstract int deleteSearchWordByTen(Map<String, String> param);

}
