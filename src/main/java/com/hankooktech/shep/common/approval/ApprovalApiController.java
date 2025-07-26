package com.hankooktech.shep.common.approval;

import static com.hankooktech.shep.common.approval.ApprovalApiController.MENU_ID;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hankooktech.fc._infra.Api;
import com.hankooktech.fc._infra.Api.FCResponseStatus;
import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcMenuId;
import com.hankooktech.fc.annotations.FcNoAuth;

import lombok.RequiredArgsConstructor;

@Controller
@FcMenuId(MENU_ID)
@RequiredArgsConstructor
public class ApprovalApiController {
	public static final String MENU_ID = "APPROVAL_ARENA";
	private final ApprovalService approvalService;
	
	/**
	 * 결재 master SELECT
	 */
	@FcNoAuth
	@GetMapping("/api/APPROVAL_ARENA/approval-info")
	@ResponseBody
	public Map<String, Object> selectApprovalInfo(@ModelAttribute ApprovalDTO.Request.Search param) throws Exception {
		ApprovalDTO.Response.ApprovalInfo result = this.approvalService.selectApprovalInfo( param );
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", result);
		
		return resultMap;
	}
	
	
	/**
	 * 결재 master INSERT
	 */
	@FcNoAuth
	@PostMapping("/api/APPROVAL_ARENA/save")
	@ResponseBody
	public Api.Response<FCResponseStatus> saveApprovalMas(@UserSession UserSessionDTO session, @RequestBody ApprovalDTO.Request.Save param) {
		approvalService.saveApprovalMas(session, param);
		return Api.Response.success();
	}
	
}
