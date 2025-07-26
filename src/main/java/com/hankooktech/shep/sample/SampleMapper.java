package com.hankooktech.shep.sample;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Mapper
@Repository
public interface SampleMapper {
    List<Map<String, Object>> list();
}
