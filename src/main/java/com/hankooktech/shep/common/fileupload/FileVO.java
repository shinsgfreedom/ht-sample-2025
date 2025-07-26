package com.hankooktech.shep.common.fileupload;

import lombok.Data;

@Data
public class FileVO {
	private String id;
	private String guid;
	private String name;
	private String chgName;
	private String chgFullName;
	private String ext;
	private long size;
	private String path;
	private String fullPath;
	private String link;
}
