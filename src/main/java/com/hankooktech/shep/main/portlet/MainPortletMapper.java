package com.hankooktech.shep.main.portlet;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface MainPortletMapper {
	List<Map<String, String>> selectRecentVisit(@Param("search") Map<String, String> param, @Param("page") Pageable paramPageable);
	List<Map<String, String>> selectTodoList(@Param("search") Map<String, String> param, @Param("page") Pageable paramPageable);
	List<Map<String, String>> selectSendMessageList(@Param("search") Map<String, String> param, @Param("page") Pageable paramPageable);
	List<Map<String, String>> selectSendMessageTargetList(String messageId);
	List<Map<String, String>> selectBbsNoticeQna(@Param("search") Map<String, String> param, @Param("page") Pageable paramPageable);
	List<Map<String, String>> selectBbsRecent(@Param("page") Pageable paramPageable);
}
