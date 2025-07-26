package com.hankooktech.shep;

import javax.annotation.PostConstruct;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;

import com.google.gson.Gson;
import com.hankooktech.fc.FcCoreConfiguration;

import lombok.extern.slf4j.Slf4j;

@Import(FcCoreConfiguration.class)
@SpringBootApplication(scanBasePackages = "com.hankooktech.shep")
@MapperScan("com.hankooktech.shep")
@Slf4j
public class App {
	
	public static void main(String[] args) {
		SpringApplication.run(App.class, args);
	}

	@PostConstruct
	public void init() {
		log.info("App ", "init()");
	}
	
	@Bean
	public Gson gson() {
		return new Gson();
	}
}
