//
//  EasySAESUtil.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySAESUtil.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation EasySAESUtil
+ (NSString *)aesEncrypt:(NSString *)plainText key:(NSString *)key iv:(NSString *)iv {
    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = plainData.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyData.bytes,
                                          kCCKeySizeAES128,
                                          ivData.bytes,
                                          plainData.bytes,
                                          plainData.length,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *encData = [NSData dataWithBytes:buffer length:numBytesEncrypted];
        free(buffer);
        return [encData base64EncodedStringWithOptions:0];
    }
    free(buffer);
    return nil;
}

+ (NSString *)aesDecrypt:(NSString *)encryptText key:(NSString *)key iv:(NSString *)iv {
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedString:encryptText options:0];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = encryptData.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyData.bytes,
                                          kCCKeySizeAES128,
                                          ivData.bytes,
                                          encryptData.bytes,
                                          encryptData.length,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *plainData = [NSData dataWithBytes:buffer length:numBytesDecrypted];
        free(buffer);
        return [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

@end
