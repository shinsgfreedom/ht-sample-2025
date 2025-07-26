package com.hankooktech.shep._infra;

import java.util.List;
import java.util.Locale;

import org.springdoc.core.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.servlet.view.BeanNameViewResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesView;
import org.springframework.web.servlet.view.tiles3.TilesViewResolver;

import com.hankooktech.fc._infra.UserSessionMethodArgumentResolver;
import com.hankooktech.fc._infra.configs.FcConfig;
import com.hankooktech.fc._infra.interceptors.AuthInterceptor;
import com.hankooktech.fc._infra.interceptors.DefaultDataInterceptor;
import com.hankooktech.fc._infra.interceptors.LoggingInterceptor;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Configuration
public class WebConfig implements WebMvcConfigurer {
    private final DefaultDataInterceptor defaultDataInterceptor;
    private final AuthInterceptor authInterceptor;
    private final LoggingInterceptor loggingInterceptor;
    private final UserSessionMethodArgumentResolver userSessionMethodArgumentResolver;
    // portlet snapshot 설정을 위한 fcConfig 의존성 추가 
    private final FcConfig fcConfig;

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(this.userSessionMethodArgumentResolver);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        LocaleChangeInterceptor localeChangeInterceptor = new LocaleChangeInterceptor();
        localeChangeInterceptor.setParamName("lang");
        registry.addInterceptor(localeChangeInterceptor);
        registry.addInterceptor(this.defaultDataInterceptor)
                .addPathPatterns("/**/*.html")
                .excludePathPatterns("/swagger-ui/**", "/swagger-ui.html");
        registry.addInterceptor(this.loggingInterceptor)
                .addPathPatterns("/**/*.html", "/api/**");
        registry.addInterceptor(this.authInterceptor)
                .addPathPatterns("/api/**/*")
                .addPathPatterns("/**/*.html")
                .excludePathPatterns("/ssoLoginPage.html")
                .excludePathPatterns(
                		"/api/auth/login", "/login.html", "/logout.html", "/ssoprocess.html", 
                		"/api/auth/request-token", "/api/auth/refresh-token",
                		"/sso/process.html",
                		"/swagger-ui/**", "/swagger-ui.html");
    }

    @Bean
    public SessionLocaleResolver localeResolver() {
        SessionLocaleResolver sessionLocaleResolver = new SessionLocaleResolver();
        sessionLocaleResolver.setDefaultLocale(Locale.KOREAN);
        return sessionLocaleResolver;
    }
    
	@Bean
	public BeanNameViewResolver beanNameViewResolver() {
		final BeanNameViewResolver beanNameViewResolver = new BeanNameViewResolver();
		beanNameViewResolver.setOrder(0);
		return beanNameViewResolver;
	}

    @Bean
    public TilesConfigurer tilesConfigurer() {
        final TilesConfigurer configurer = new TilesConfigurer();
        configurer.setDefinitions("classpath:tiles.xml");
        configurer.setCheckRefresh(true);
        return configurer;
    }

    @Bean
    public TilesViewResolver tilesViewResolver() {
        final TilesViewResolver tilesViewResolver = new TilesViewResolver();
        tilesViewResolver.setViewClass(TilesView.class);
        tilesViewResolver.setOrder(1);
        return tilesViewResolver;
    }

	@Bean
	public ViewResolver viewResolver() {
		InternalResourceViewResolver internalResourceViewResolver = new InternalResourceViewResolver();
		internalResourceViewResolver.setPrefix("/WEB-INF/views/");
		internalResourceViewResolver.setSuffix(".jsp");
		internalResourceViewResolver.setOrder(2);
		return internalResourceViewResolver;
	}
    
    @Bean
    public GroupedOpenApi publicApi() {
        return GroupedOpenApi.builder()
                .group("_public")
                .packagesToScan("com.hankooktech.shep")
                .packagesToExclude("com.hankooktech.fc")
                .build();
    }
}
