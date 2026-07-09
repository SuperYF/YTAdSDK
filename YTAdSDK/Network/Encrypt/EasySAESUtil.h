//
//  EasySAESUtil.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasySAESUtil : NSObject
/// AES 加密（CBC 128位）
+ (NSString *)aesEncrypt:(NSString *)plainText key:(NSString *)key iv:(NSString *)iv;

/// AES 解密
+ (NSString *)aesDecrypt:(NSString *)encryptText key:(NSString *)key iv:(NSString *)iv;

@end

NS_ASSUME_NONNULL_END
