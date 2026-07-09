//
//  EasySAdSDKLoadADRequestTypeManager.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/13.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySAdSDKLoadADRequestTypeManager.h"

@implementation EasySAdSDKLoadADRequestTypeManager
+ (instancetype)shared {
    static EasySAdSDKLoadADRequestTypeManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
//        instance.type = EasySAdSDKLoadADRequestType_Begin;
        instance.requestTypeDic = @{};
    });
    return instance;
}
- (void)upDataSlotId:(NSString *)slotId withType:(NSString *)type {
    NSMutableDictionary *allDic = [NSMutableDictionary dictionaryWithDictionary:self.requestTypeDic];
    allDic[slotId] = type;
    self.requestTypeDic = allDic;
}
@end
