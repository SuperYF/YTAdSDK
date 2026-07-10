//
//  EasySNetWorkManager.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/8.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySNetWorkManager.h"

@implementation EasySNetWorkManager
+ (instancetype)sharedWork {
    static EasySNetWorkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
//        instance.timestamp = @"";
//        instance.sessionId = @"";
//        instance.appId = @"";
    });
    return instance;
}
@end
