package com.hankooktech.shep.main.member;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface FindMemberMapper {
	List<Map<String, Object>> list();
	
	public abstract List<Map<String, String>> findMemberList(Map<String, String> param);
	public abstract Map<String, String> findMemberDetail(Map<String, String> param);
	public abstract List<Map<String, String>> getOrganizationTree(Map<String, String> param);
	public abstract List<Map<String, String>> findOrganization(Map<String, String> param);
	public abstract List<Map<String, String>> getFavoriteMemberList(Map<String, String> param);
	public abstract Integer deleteFavorite(Map<String, String> param);
	public abstract Integer mergeRecentlyViewed(Map<String, String> paramMap);
	public abstract List<Map<String, String>> findRecentlyViewedList(Map<String, String> param);
	public abstract Integer deleteRecentlyViewed(Map<String, String> param);
	public abstract Integer deleteAllRecentlyViewed(String userId);
	public abstract List<Map<String, String>> getUsers(String deptCode);

}
