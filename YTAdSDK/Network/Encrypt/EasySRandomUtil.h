//
//  EasySRandomUtil.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasySRandomUtil : NSObject
/// 生成 16 位随机字符串（AES专用）
+ (NSString *)generate16BytesRandom;

/// 时间戳
+ (NSString *)timestamp;

+ (NSString *)jsonStringFromDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
