//
//  EasySSDKStartModel.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/10.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySSDKStartModel.h"

@implementation EasySSDKStartModel
- (instancetype)initWithDic:(NSDictionary *)result {
    self = [super init];
    if (self) {
        self.code = result[@"code"] ?:@"";
        self.timestamp = result[@"timestamp"] ?:@"";
        self.trackId = result[@"trackId"] ?:@"";
        self.msg = result[@"msg"] ?:@"";
        self.data = result[@"data"] ?:@{};
    }
    return self;}
@end
