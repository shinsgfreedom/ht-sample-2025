package com.hankooktech.shep.common.approval;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hankooktech.fc._infra.Api;
import com.hankooktech.fc._infra.Api.FCResponseStatus;
import com.hankooktech.fc._infra.UserSessionDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class ApprovalService {
	private final ApprovalMapper mapper;
	
	public ApprovalDTO.Response.ApprovalInfo selectApprovalInfo(ApprovalDTO.Request.Search search) {
		ApprovalDTO.Response.ApprovalInfo info = mapper.selectApprovalInfo(search);
		return info;
	}
	
	
	@Transactional
	public Api.Response<FCResponseStatus> saveApprovalMas(UserSessionDTO session, ApprovalDTO.Request.Save save) {
		save.setApprovalUserUid( session.getUserId() );
		mapper.saveApprovalMas(save);
		
		return Api.Response.success();
	}
	
}
