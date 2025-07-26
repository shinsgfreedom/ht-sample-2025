package com.hankooktech.shep.common.domain;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Getter @Setter @ToString
public class CommonVO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String	userId;		// 사용자ID
	private String createDate;		// 등록일자	
	private String updateDate;		// 수정일자		
	private String useYn;		// 사용여부
	
}