package com.hankooktech.shep.sample;

import com.hankooktech.fc._infra.Api;
import com.hankooktech.fc._infra.exceptions.FcBizException;
import com.hankooktech.fc.annotations.*;
import com.hankooktech.fc._infra.UserSession;
import com.hankooktech.fc._infra.UserSessionDTO;

import org.springframework.util.StringUtils;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import static com.hankooktech.shep.sample.SampleController.MENU_ID;

import java.util.Collections;
import java.util.Map;

@Validated
@RestController
@FcMenuId(MENU_ID)
@RequestMapping("/api/" + MENU_ID)
public class SampleApiController {
    /**
     * 메뉴 ID
     */
    public static final String MENU_ID = "SAMPLE-MENU";
    private final SampleService sampleService;

    public SampleApiController(SampleService sampleService) {
        this.sampleService = sampleService;
    }


    // 상세 조회 API
    @FcReadable // 읽기 권한이 있는 사람만 접근 가능
    @GetMapping("/{id}")
    public Map<String, String> detailApi(@PathVariable String id, @UserSession UserSessionDTO session) {
        // TODO
        return Collections.singletonMap("name", "Choi woon-soo");
    }

    /**
     *
     */
    @FcWritable // 쓰기 권한이 있는 사람만 접근 가능
    @PostMapping
    public Api.Response create(@RequestBody Map<String, Object> dto, @UserSession UserSessionDTO session) {
        // TODO 아래는 validation 샘플 코드입니다.
        if (StringUtils.isEmpty(dto.get("id"))) throw new FcBizException("id is required field");
        return Api.Response.success();
    }

    @FcCustomAuth("PDF_EXPORT")
    @FcModifiable // 수정 권한이 있는 사람만 접근 가능
    @PutMapping("/{id}")
    public Api.Response update(@PathVariable final String id, @RequestBody Map<String, Object> dto) {
        // TODO Something
        return Api.Response.success();
    }

    @FcDeletable // 삭제 권한이 있는 사람만 접근 가능
    @DeleteMapping("/{id}")
    public Api.Response delete(@PathVariable final String id, @UserSession UserSessionDTO session) {
        // TODO Something
        return Api.Response.success();
    }
}
