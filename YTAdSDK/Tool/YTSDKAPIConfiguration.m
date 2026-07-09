//
//  YTSDKAPIConfiguration.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTSDKAPIConfiguration.h"

@implementation YTSDKAPIConfiguration
+ (instancetype)shared {
    static YTSDKAPIConfiguration *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.timeoutInterval = 10; //默认10秒
        instance.debugLog = NO;
    });
    return instance;
}
- (NSString *)getSDKVersion {
    return @"1.0.0";
}
@end
