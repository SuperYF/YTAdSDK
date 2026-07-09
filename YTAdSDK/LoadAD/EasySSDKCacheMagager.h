//
//  EasySSDKCacheMagager.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/15.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 缓存有效期常量（60分钟）
//static const NSTimeInterval kCacheValidTime = 3600;
static const NSTimeInterval kCacheValidTime = 36;

@interface EasySSDKCacheMagager : NSObject
/// 单例
+ (instancetype)shared;

#pragma mark - 核心读写API（自动优先级判定 + 过期校验）
/// 读取缓存：优先内存→磁盘，自动校验有效期
/// @param key 缓存唯一key
/// @return 未过期返回缓存数据，过期/无缓存返回nil
- (id _Nullable)getCacheForKey:(NSString *)key;

/// 写入缓存：同时写内存+磁盘，自动记录时间戳
/// @param data 要缓存的数据（支持基本类型/字典/数组/模型）
/// @param key 缓存唯一key
- (void)saveCache:(id)data forKey:(NSString *)key;

#pragma mark - 辅助API
/// 手动校验某个缓存是否过期
- (BOOL)isCacheExpiredForKey:(NSString *)key;

/// 清除指定缓存
- (void)removeCacheForKey:(NSString *)key;

/// 清除所有缓存（SDK重置时使用）
- (void)clearAllCache;

@end

NS_ASSUME_NONNULL_END
