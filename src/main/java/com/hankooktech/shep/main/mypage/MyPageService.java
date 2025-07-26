package com.hankooktech.shep.main.mypage;

import javax.annotation.PostConstruct;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@AllArgsConstructor
public class MyPageService {
	private final MyPageMapper mapper;

	@PostConstruct
	void setUp() {
		log.debug(" MyPageService.list() => " + mapper.list());
	}

	@Scheduled(cron = "0 30 7 * * *")
	public void deleteTempFiles() {
		mapper.deleteTempFiles();
	}
}
