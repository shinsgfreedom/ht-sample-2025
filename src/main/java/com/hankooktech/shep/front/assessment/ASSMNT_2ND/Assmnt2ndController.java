package com.hankooktech.shep.front.assessment.ASSMNT_2ND;

import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;
import com.hankooktech.fc.annotations.FcMenuId;
import com.hankooktech.fc.annotations.FcReadable;
import com.hankooktech.shep.sample.SampleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;

import static com.hankooktech.shep.front.assessment.ASSMNT_2ND.Assmnt2ndController.MENU_ID;

@Validated
@Controller
@FcMenuId(MENU_ID)
@RequestMapping(MENU_ID)
@RequiredArgsConstructor
public class Assmnt2ndController {
    /**
     * 메뉴 ID
     */
    public static final String MENU_ID = "ASSMNT_2ND";
    private final SampleService sampleService;

    /**
     * 읽기 가능한 랜딩 페이지
     * entryPoint = true 이면 메뉴 클릭시 첫 랜딩 페이지가 됩니다
     * 컨트롤러 내부에 적어도 하나의 entryPoint=true 인 url Mapping이 존재해야합니다.
     */
    @FcReadable(entryPoint = true) // 읽기 권한이 있는 사람만 접근 가능
    @RequestMapping("/index.html")
    public String page(@UserSession UserSessionDTO session) {
        return "views/" + MENU_ID + "/step2";
    }
}
