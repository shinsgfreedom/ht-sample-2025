package com.hankooktech.shep.common.fileupload;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc._infra.configs.FcFileConfig;
import com.hankooktech.fc.annotations.FcNoAuth;
import com.hankooktech.fc.biz_common.excel.ExcelReader;
import com.hankooktech.fc.biz_common.file.DrmDecodingUtil;

import lombok.Cleanup;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * Excel File API REST Controller (User API)
 * fc-config.file-config.file-root-path 속성이 존재할때만 구동됨
 */
@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/api/excel")
@ConditionalOnProperty("fc-config.file-config.file-root-path")
public class ExcelApiController {
	
	private final FcFileConfig fileConfig;
	private final ExcelReader excelReader;
	
	@FcNoAuth
	@SuppressWarnings("unchecked")
	@PostMapping("/upload")
	@ResponseBody
	public Map<String, Object> upload(@UserSession UserSessionDTO session, MultipartFile file, HttpServletRequest request, HttpServletResponse response, @RequestParam boolean drm, @RequestParam String workId, @RequestParam String category) throws Exception {
		@Cleanup InputStream is = null;
		Map<String, Object> result = new HashMap<String, Object>();
		
		log.info("File Info : " + file.getOriginalFilename() + ", " + file.getSize());
		String[] file_nm = file.getOriginalFilename().split("\\.");

		String ext = file_nm.length > 1 ? file_nm[file_nm.length - 1] : "";
		List<String> extList = Arrays.asList("xls","xlsx");
		
		boolean isClientSideParsinge = (workId == null || "".equals(workId) || "client".equals(workId)) ? true : false;
		String excelUploadTemplateFile = category;
		
		if(drm) {
			if(extList.contains(ext)) {
				log.info("DRM SEND");
				DrmDecodingUtil multipart = new DrmDecodingUtil(fileConfig.getDrmUrl(), "UTF-8");
				multipart.addFilePart("file", file);
				is = multipart.finish();
			} else {
				is = file.getInputStream();
			}
		} else {
			is = file.getInputStream();
		}
		
		if(isClientSideParsinge) {
			byte[] resBytes = inputStreamToByteArray(is);	
			result.put("data", resBytes);
		} else {
			Map<String, Object> beans = new HashMap<String, Object>();
			List<Map<String, Object>> readList = new ArrayList<Map<String, Object>>();
			beans.put("xuList", readList);
			Map<String, Object> readData = excelReader.readExcel(is, excelUploadTemplateFile, beans);
			List<Map<String, Object>> resultList = (List<Map<String, Object>>) readData.get("xuList");
			
			result.put("data", resultList);
		}
		
		return result;
	}
	
	@FcNoAuth
	@RequestMapping("/form_download")
	public String form_download(@UserSession UserSessionDTO session, @RequestParam Map<String, String> param, Model model) {
		model.addAttribute("templateFileName", param.get("templateFileName"));	// 템플릿명
		model.addAttribute("fileName", param.get("fileName"));				// 다운파일명
		model.addAttribute("data", new ArrayList());
		return "fcExcelView";
	}
	
	public static byte[] inputStreamToByteArray(InputStream is) {
		byte[] resBytes = null;
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		
		byte[] buffer = new byte[1024];
		int read = -1;
		
		try {
			while ( (read = is.read(buffer)) != -1 ) {
				bos.write(buffer, 0, read);
			}
			
			resBytes = bos.toByteArray();
			bos.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resBytes;
	}
}
