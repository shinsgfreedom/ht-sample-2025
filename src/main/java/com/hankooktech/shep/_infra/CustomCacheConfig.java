package com.hankooktech.shep._infra;

import lombok.AllArgsConstructor;
import org.ehcache.config.builders.CacheConfigurationBuilder;
import org.ehcache.config.builders.ExpiryPolicyBuilder;
import org.ehcache.config.builders.ResourcePoolsBuilder;
import org.ehcache.config.units.MemoryUnit;
import org.ehcache.jsr107.Eh107Configuration;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import javax.cache.CacheManager;
import java.time.Duration;

@AllArgsConstructor
@Configuration
public class CustomCacheConfig {
    private final CacheManager cacheManager;

    @PostConstruct
    public void ehcacheManager(){
        cacheManager.createCache("custom-cache-mcodes", //캐쉬 이름
                Eh107Configuration.fromEhcacheCacheConfiguration(
                        CacheConfigurationBuilder.newCacheConfigurationBuilder(
                                String.class,       //key type
                                Object.class,       //value type
                                ResourcePoolsBuilder.newResourcePoolsBuilder()
                                        .offheap(50, MemoryUnit.MB))                                               //해당 키에 대한 최대 용량
                                .withExpiry(ExpiryPolicyBuilder.timeToLiveExpiration(Duration.ofHours(24)))     //유지시간 (현재 24시간)
                ));
    }
}
