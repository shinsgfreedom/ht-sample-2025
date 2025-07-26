package com.hankooktech.shep.common.approval;

import java.sql.Date;

import lombok.Data;

public class ApprovalDTO {
	
	public static class Request {
		
		@Data
		public static class Search {
			private String approvalMasUid;
			private String approvalDocumentUid;
			private String approvalDocumentNo;
			private String approvalTypeCode;
			private String approvalTitle;
			
			private String approvalDate;
			private String approvalUserUid;
		}
		
		@Data
		 public static class Save {
			private String approvalMasUid;
			private String approvalDocumentUid;
			private String approvalDocumentNo;
			private String approvalTypeCode;
			private String approvalStatusCode;
			
			private String approvalTitle;
			private String approvalContents;
			private String approvalUserUid;
		}
	}
	
	public static class Response {
		@Data
		public static class ApprovalInfo {
			private String approvalMasUid;
			private String approvalDocumentUid;
			private String approvalDocumentNo;
			private String approvalTypeCode;
			private String approvalStatusCode;
			
			private String approvalTitle;
			private String approvalContents;
			private Date approvalDate;
			private String approvalUserUid;
            private String approvalArenaUid;
            
            private String arenaDocumentId;
            private String arenaPath;
            private String arenaStatusMessage;
		}
	}

}
