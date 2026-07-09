//
//  EasySRSAUtil.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySRSAUtil.h"
#import <Security/Security.h>

@implementation EasySRSAUtil
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)publicKey {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [self encryptData:data publicKey:publicKey];
}

+ (NSString *)encryptData:(NSData *)data publicKey:(NSString *)publicKey {
    NSString *key = [publicKey stringByReplacingOccurrencesOfString:@"-----BEGIN PUBLIC KEY-----" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"-----END PUBLIC KEY-----" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:0];
    if (!keyData) return nil;
    
    NSDictionary *attributes = @{
        (__bridge id)kSecAttrKeyType: (__bridge id)kSecAttrKeyTypeRSA,
        (__bridge id)kSecAttrKeyClass: (__bridge id)kSecAttrKeyClassPublic,
        (__bridge id)kSecAttrKeySizeInBits: @2048
    };
    
    SecKeyRef secKey = SecKeyCreateWithData((__bridge CFDataRef)keyData, (__bridge CFDictionaryRef)attributes, nil);
    if (!secKey) return nil;
    
    size_t blockSize = SecKeyGetBlockSize(secKey);
    uint8_t *plainBuffer = (uint8_t *)data.bytes;
    size_t plainBufferSize = data.length;
    
    NSMutableData *encryptData = [NSMutableData data];
    size_t index = 0;
    while (index < plainBufferSize) {
        size_t chunkSize = MIN(plainBufferSize - index, blockSize - 11);
        uint8_t *chunk = plainBuffer + index;
        uint8_t cipherBuffer[blockSize];
        size_t cipherBufferSize = blockSize;
        
        OSStatus status = SecKeyEncrypt(secKey,
                                        kSecPaddingPKCS1,
                                        chunk,
                                        chunkSize,
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status != noErr) break;
        [encryptData appendBytes:cipherBuffer length:cipherBufferSize];
        index += chunkSize;
    }
    CFRelease(secKey);
    return [encryptData base64EncodedStringWithOptions:0];
}

@end
