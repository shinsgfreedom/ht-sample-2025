package com.hankooktech.shep.main.search;

import static com.hankooktech.shep.main.search.IntegratedSearchController.MENU_ID;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hankooktech.shep.common.result.Result;
import com.hankooktech.shep.main.MainService;
import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcMenuId;
import com.hankooktech.fc.annotations.FcNoAuth;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Validated
@RestController
@FcMenuId(MENU_ID)
@RequestMapping("/api/search/integrated")
@AllArgsConstructor
public class IntegratedSearchApiController {
	private final IntegratedSearchService service;
	private final MainService mainService;
	
	@FcNoAuth
	@GetMapping()
	public ResponseEntity<Result<?>> fetchSearchWord(@UserSession UserSessionDTO session) {
		List<Map<String, String>> result= this.mainService.selectSearchWords(session);
		return ResponseEntity.ok(new Result<>(result));
	}

	@FcNoAuth
	@PostMapping()
	public ResponseEntity<Result<?>> saveSearchWord(@RequestBody String searchWord, @UserSession UserSessionDTO session) {
		searchWord = searchWord.replaceAll("\"", "");
		this.service.saveSearchWord(session.getId(), searchWord);
		List<Map<String, String>> result= this.mainService.selectSearchWords(session);
		return ResponseEntity.ok(new Result<>(result));
	}

	@FcNoAuth
	@DeleteMapping("/{searchWord}")
	public ResponseEntity<Result<?>>  removeSearchWord(@PathVariable final String searchWord, @UserSession UserSessionDTO session) {
		this.service.removeSearchWord(session.getId(), searchWord);
		List<Map<String, String>> result= this.mainService.selectSearchWords(session);
		return ResponseEntity.ok(new Result<>(result));
	}
}
