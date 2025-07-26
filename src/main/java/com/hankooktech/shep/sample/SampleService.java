package com.hankooktech.shep.sample;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;

@Slf4j
@Service
public class SampleService {
    private final SampleMapper mapper;

    public SampleService(SampleMapper mapper) {
        this.mapper = mapper;
    }

    @PostConstruct
    void setUp() {
        log.debug(" SampleService.list() => " + mapper.list());
    }
}
