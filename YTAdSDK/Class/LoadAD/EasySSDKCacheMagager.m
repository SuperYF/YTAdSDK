//
//  EasySSDKCacheMagager.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/15.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySSDKCacheMagager.h"

@interface EasySSDKCacheMagager ()
/// 内存缓存：系统自带，自动处理内存警告
@property (nonatomic, strong) NSCache *memoryCache;
@end

@implementation EasySSDKCacheMagager
+ (instancetype)shared {
    static EasySSDKCacheMagager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.memoryCache = [[NSCache alloc] init];
        instance.memoryCache.countLimit = 50; // 限制内存缓存最大数量
    });
    return instance;
}

#pragma mark - 核心读取：优先级判定 + 过期校验
- (id)getCacheForKey:(NSString *)key {
    if (!key || key.length == 0) return nil;
    
    // ========== 1. 最高优先级：读内存缓存 ==========
    id memoryData = [self.memoryCache objectForKey:key];
    if (memoryData) {
        // 内存有数据，校验是否过期
        if (![self isCacheExpiredForKey:key]) {
            return memoryData;
        }
        // 内存过期，移除无效缓存
        [self.memoryCache removeObjectForKey:key];
    }
    
    // ========== 2. 次优先级：读磁盘缓存 ==========
    NSDictionary *diskDict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (diskDict && [diskDict isKindOfClass:[NSDictionary class]]) {
        id diskData = diskDict[@"data"];
        if (![self isCacheExpiredForKey:key]) {
            // 磁盘有有效数据，同步到内存，下次直接读内存
            [self.memoryCache setObject:diskData forKey:key];
            return diskData;
        }
    }
    
    // ========== 3. 缓存都失效，返回nil，触发网络请求 ==========
    return nil;
}

#pragma mark - 写入缓存：同时写内存+磁盘
- (void)saveCache:(id)data forKey:(NSString *)key {
    if (!key || key.length == 0 || !data) return;
    
    @synchronized (self) { // 加锁：多线程读写安全
        // 1. 写入内存缓存
        [self.memoryCache setObject:data forKey:key];
        
        // 2. 写入磁盘：格式：@{@"data": 数据, @"timestamp": 写入时间戳}
        NSTimeInterval timestamp = [NSDate date].timeIntervalSince1970;
        NSDictionary *saveDict = @{
            @"data": data,
            @"timestamp": @(timestamp)
        };
        [[NSUserDefaults standardUserDefaults] setObject:saveDict forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - 过期校验
- (BOOL)isCacheExpiredForKey:(NSString *)key {
    if (!key || key.length == 0) return YES;
    
    NSDictionary *diskDict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!diskDict) return YES;
    
    NSNumber *timestamp = diskDict[@"timestamp"];
    if (!timestamp) return YES;
    
    // 计算时间差：当前时间 - 写入时间 > 有效期 → 过期
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    NSTimeInterval diff = now - timestamp.doubleValue;
    BOOL isExpired = diff > kCacheValidTime;
    
    return isExpired;
}

#pragma mark - 清理API
- (void)removeCacheForKey:(NSString *)key {
    if (!key) return;
    @synchronized (self) {
        [self.memoryCache removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)clearAllCache {
    @synchronized (self) {
        [self.memoryCache removeAllObjects];
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
