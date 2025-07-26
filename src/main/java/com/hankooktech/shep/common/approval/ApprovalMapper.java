package com.hankooktech.shep.common.approval;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
@Mapper
@Repository
public interface ApprovalMapper {
	ApprovalDTO.Response.ApprovalInfo selectApprovalInfo(ApprovalDTO.Request.Search search);
	void saveApprovalMas(ApprovalDTO.Request.Save data);
}
