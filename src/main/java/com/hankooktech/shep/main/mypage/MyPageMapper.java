package com.hankooktech.shep.main.mypage;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface MyPageMapper {
	List<Map<String, Object>> list();

	void deleteTempFiles();
	
}
