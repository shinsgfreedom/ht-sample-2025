package com.hankooktech.shep;

import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc._infra.configs.FcSsoConfig;
import com.hankooktech.fc.annotations.FcNoAuth;
import com.hankooktech.fc.annotations.FcNoLogin;
import com.hankooktech.fc.biz_common.auth.AuthService;
import com.hankooktech.fc.biz_common.user.UserDTO;
import com.hankooktech.fc.biz_common.user.UserService;
import com.hankooktech.fc.common.Constants;

import lombok.RequiredArgsConstructor;
import static org.springframework.util.StringUtils.parseLocale;

@ConditionalOnProperty(prefix = "fc-config.sso", name = {"ssid", "success-redirect-url"})
@Controller
@RequiredArgsConstructor
public class AuthController {
	private final AuthService authService;	
	private final UserService userService;
	private final FcSsoConfig ssoConfig;
	
	@Value("${spring.profiles.active}") 
	private String activeProfile;
	
	private final String profile = "prod";
	
	@FcNoAuth
	@RequestMapping(value = {"/index.html", "/"})
	public String indexPage(@UserSession UserSessionDTO session) {
		return Optional.ofNullable(session).map(v -> "redirect:/MAIN/main.html").orElse("redirect:/login.html");
	}

	@FcNoLogin(onlyLocalhost=false)
	@RequestMapping("/login.html")
	public String ssoLoginPage(HttpSession session, HttpServletRequest request) {		
		if(profile.equals(activeProfile)) { 
			return "redirect:/sso/business.jsp"; 
		}	
		 
		return "login/login";		
	}

	@FcNoLogin 
    @GetMapping("/ssoprocess.html") 
    public  String  processSSO( 
                    @SessionAttribute("ID")  String  userId, 
                    @SessionAttribute(name  =  "returnURL",  required  =  false)  String  returnUrl, 
                    HttpSession  httpSession, 
                    HttpServletRequest  request, 
                    HttpServletResponse  response 
    )  { 
            //httpSession.invalidate(); 
            UserDTO.Response.User  userInfo  =  userService.getUserInfoByUserId(userId); 

            var  newSession  =  request.getSession(true); 
            var  dto  =  authService.autoLogin(userInfo.getUuid(),  newSession); 

            /** 
              *  사용자에게  세팅된  Locale  적용 
              */ 
            var  selectedLocale  =  parseLocale(Optional.ofNullable(dto.getLocale()).orElse("en")); 
            var  localeResolver  =  RequestContextUtils.getLocaleResolver(request); 
            localeResolver.setLocale(request,  response,  selectedLocale); 
            dto.setLocale(selectedLocale.toString()); 

            var  redirectUrl  =  StringUtils.isEmpty(returnUrl)  ?  ssoConfig.getSuccessRedirectUrl()  :  returnUrl; 
            return  "redirect:"  +  redirectUrl; 
    } 
	
	
	@FcNoLogin
	@RequestMapping("/ssoLoginPage.html")
	public ModelAndView ssologinPage(HttpServletRequest req, HttpSession session, @RequestParam(required = false) String returnURL) {
		ModelAndView mv = new ModelAndView();

		String checkServer = session.getAttribute("checkServer") == null ? ""
				: session.getAttribute("checkServer").toString();
		if (StringUtils.isEmpty(checkServer)) {
			String returnUrlParam = (StringUtils.isEmpty(returnURL)) ? "" : "?returnURL=" + returnURL;
			mv.setViewName("redirect:/login.html" + returnUrlParam);
			return mv;
		}		
		
		mv.setViewName("login/login");
		return mv;
	}
	
	//@FcNoAuth
	@RequestMapping("/logout.html")
//	public String logout(HttpSession session) {
//		session.invalidate();
//		return "redirect:/login.html";
//	}
	public String logout(HttpSession session, HttpServletRequest request, HttpServletResponse response, @UserSession UserSessionDTO sessionDTO) {
		String returnUrl = "redirect:/login.html";
		if(sessionDTO != null && sessionDTO.isSwitchSession()) {
			final UserSessionDTO imitatedSession = authService.getUserInfoFromUserUuid(sessionDTO.getOriginalUserUid());
			authService.setLocaleForWeb(request, response, imitatedSession);
			
			imitatedSession.setOriginalUserUid(null);
			imitatedSession.setOriginalUserId(null);
			
			session.setAttribute(Constants.REQ_ATTR_USER_SESSION_KEY, imitatedSession);
			
			returnUrl = "redirect:/admin/user.html";
		} else {
			if (profile.equals(activeProfile) && !"admin".equals(sessionDTO.getUserId())) {
				String logoutUrl = (StringUtils.isEmpty(session.getAttribute("SERVICE_LOGOUT_PAGE"))) ? "/sso/logout.jsp"
						: (String) session.getAttribute("SERVICE_LOGOUT_PAGE");
				return "redirect:" + logoutUrl;
			}
			session.invalidate();
			returnUrl = "redirect:/login.html";
		}
		
		return returnUrl;
	}
	

}
