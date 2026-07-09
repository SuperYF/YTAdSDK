//
//  EasySRSAUtil.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasySRSAUtil : NSObject
/// 公钥加密（返回 base64）
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)publicKey;

@end

NS_ASSUME_NONNULL_END
