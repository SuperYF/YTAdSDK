//
//  EasySSDKStartConfiguration.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/10.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySSDKStartConfiguration.h"

@implementation EasySSDKStartConfiguration
+ (instancetype)shared {
    static EasySSDKStartConfiguration *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.sessionDic = [[NSMutableDictionary alloc] init];
//        instance.debugLog = YES;
    });
    return instance;
}
- (NSString *)sessionId {
    NSString *appid = EasySSDKStartConfiguration.shared.appId ?:@"";
    NSString *appkey = EasySSDKStartConfiguration.shared.appKey ?:@"";
    NSString *sessionId = EasySSDKStartConfiguration.shared.sessionDic[[NSString stringWithFormat:@"%@+%@",appid,appkey]] ?:@"";
    return sessionId;
}
@end
