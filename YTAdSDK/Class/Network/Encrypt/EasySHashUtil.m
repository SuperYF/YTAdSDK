//
//  EasySHashUtil.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySHashUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation EasySHashUtil
+ (NSString *)sha256:(NSString *)string {
//    const char *data = [string UTF8String];
//    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
//    CC_SHA256(data, (CC_LONG)strlen(data), digest);
//    
//    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
//    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
//        [result appendFormat:@"%02x", digest[i]];
//    }
//    return result;
    
    // 2. 转 UTF-8 字节
       const char *cString = [string UTF8String];
       NSUInteger length = strlen(cString);
       
       // 3. SHA256 哈希
       unsigned char hash[CC_SHA256_DIGEST_LENGTH];
       CC_SHA256(cString, (CC_LONG)length, hash);
       
       // 4. 转 NSData
       NSData *hashData = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
       
       // 5. Base64 编码（和 Java Base64.getEncoder() 完全一致）
       NSString *base64Sign = [hashData base64EncodedStringWithOptions:0];
       
       return base64Sign;
}
@end
