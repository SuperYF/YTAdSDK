//
//  EasySSDKGeneralTool.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/15.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySSDKGeneralTool.h"

@implementation EasySSDKGeneralTool
/// 校验是否为合法 http/https 网址
+ (BOOL)isValidWebURL:(NSString *)urlStr {
    if (!urlStr || urlStr.length == 0) {
        return NO;
    }
    // 去除首尾空格（前端/接口常带空格）
    NSString *trimUrl = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimUrl.length == 0) {
        return NO;
    }
    
    NSURL *url = [NSURL URLWithString:trimUrl];
    if (!url) {
        return NO;
    }
    
    // 校验协议头
    NSString *scheme = url.scheme.lowercaseString;
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        return YES;
    }
    return NO;
}
+ (NSDictionary *)removeDictionaryNullObject:(NSDictionary *)resultDic {
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [resultDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            mutDic[key] = [EasySSDKGeneralTool removeDictionaryNullObject:obj];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            mutDic[key] = [EasySSDKGeneralTool removeArrayNullObject:obj];
        } else if ([obj isKindOfClass:[NSNull class]]) {
            // NSNull 替换为空字符串
            mutDic[key] = @"";
        } else if (obj) {
            mutDic[key] = obj;
        }
    }];
    return [mutDic copy];
}
+ (NSArray *)removeArrayNullObject:(NSArray *)resultArr {
    NSMutableArray *mutArr = [NSMutableArray array];
    for (id obj in resultArr) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [mutArr addObject:[EasySSDKGeneralTool removeDictionaryNullObject:obj]];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [mutArr addObject:[EasySSDKGeneralTool removeArrayNullObject:obj]];
        } else if ([obj isKindOfClass:[NSNull class]]) {
            [mutArr addObject:@""];
        } else if (obj) {
            [mutArr addObject:obj];
        }
    }
    return [mutArr copy];
}
+ (UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
}
+ (UIImage *)imageNamed:(NSString *)name withClass:(Class)aClass{
    static NSBundle *resBundle = nil;
        static dispatch_once_t token;
        dispatch_once(&token, ^{//YTAdSDKRes
            // 获取当前Framework所在Bundle
            NSBundle *frameworkBundle = [NSBundle bundleForClass:aClass];
            NSString *bundlePath = [frameworkBundle pathForResource:@"YTAdSDKRes" ofType:@"bundle"];
            if (bundlePath) {
                resBundle = [NSBundle bundleWithPath:bundlePath];
            }
        });
        if (!resBundle || !name) return nil;
        NSString *path = [resBundle pathForResource:name ofType:@"png"];
        return [UIImage imageWithContentsOfFile:path];
}
//超时判断
+ (BOOL)isRequestTimeoutError:(NSError *)error {
    if (!error) return NO;
    // 域匹配 + 错误码 -1001
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorTimedOut) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNumberValid:(NSNumber *)num {
    if (!num) return NO;
    if ([num isKindOfClass:[NSNull class]]) return NO;
    return YES;
}
@end
