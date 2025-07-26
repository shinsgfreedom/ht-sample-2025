package com.hankooktech.shep.main.favorite;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface MyFavoriteMapper {
	List<Map<String, Object>> list();
	
	public abstract List<Map<String, String>> selectFavoriteList(Map<String, String> param);
	public abstract Map<String, String> selectFavoriteDetail(Map<String, String> param);
	public abstract Integer insertFavorite(Map<String, String> paramMap);
	public abstract Integer updateFavoriteTitle(Map<String, String> paramMap);
	public abstract Integer deleteFavorite(String uuid);
	
	public abstract List<Map<String, String>> selectMyBookmarkLatelyList(Map<String, String> param);
	public abstract List<Map<String, String>> selectMyBookmarkMostviewList(Map<String, String> param);
	
	public abstract Map<String, String> selectMyContentsBookmarkStatus(Map<String, String> param);
	public abstract Integer updateMyContentsBookmarkReadCnt(String myFavoriteUid);
	public abstract Integer insertMyContentsBookmark(Map<String, String> paramMap);
}
