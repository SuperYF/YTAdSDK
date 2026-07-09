//
//  EasySNetWorkUtil.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasySNetWorkPath.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ESNetSuccess)(NSDictionary *respDict);
typedef void(^ESNetFailure)(NSError *error);

@interface EasySNetWorkUtil : NSObject
/// 全局配置RSA公钥（APP初始化调用一次）
+ (void)configRSAPublicKey:(NSString *)pubKey;

/// 加密POST请求（自动：生成AESKey/IV→RSA加密key&iv→AES加密入参→SHA256签名）
/// @param api 接口短路径 /api/v1/xxx
/// @param params 明文业务参数
/// @param success 解密后明文回调
/// @param fail 失败回调
+ (void)postEncrypt:(NSString *)api params:(NSDictionary *)params success:(ESNetSuccess)success fail:(ESNetFailure)fail;

+ (void)request:(id<EasySNetWorkType>)target success:(ESNetSuccess)success fail:(ESNetFailure)fail;
@end

NS_ASSUME_NONNULL_END
