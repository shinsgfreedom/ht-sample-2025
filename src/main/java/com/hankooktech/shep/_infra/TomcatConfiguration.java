package com.hankooktech.shep._infra;

import org.apache.tomcat.util.http.Rfc6265CookieProcessor;
import org.apache.tomcat.util.http.SameSiteCookies;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.embedded.tomcat.TomcatContextCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TomcatConfiguration {
	
	@Value("${spring.profiles.active}") 
	private String activeProfile;
	
	private final String profile = "prod";
	
	@Bean
	public TomcatContextCustomizer sameSiteCookiesConfig() {
		return context -> {
			if(profile.equals(activeProfile)) {
				final Rfc6265CookieProcessor cookieProcessor = new Rfc6265CookieProcessor();
				// SameSite
				cookieProcessor.setSameSiteCookies(SameSiteCookies.NONE.getValue());
				context.setCookieProcessor(cookieProcessor);
			}
		};
	}
}