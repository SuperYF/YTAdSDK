//
//  EasySAdSDKLoadADModel.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/11.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySAdSDKLoadADModel.h"

@implementation EasySAdSDKLoadADModel
- (instancetype)initWithDic:(NSDictionary *)result {
    self = [super init];
    if (!self || !result) return nil;
        self.requestId = result[@"requestId"] ?:@"";
        self.adPlanId = result[@"adPlanId"] ?:@"";
        self.adPlanName = result[@"adPlanName"] ?:@"";
        self.advertiserName = result[@"advertiserName"] ?:@"";
        self.adType = [result[@"adType"] integerValue];
        self.materialType = [result[@"materialType"] integerValue];
        self.imageUrl = result[@"imageUrl"] ?:@"";
        self.interactionType = [result[@"interactionType"] integerValue];
        self.buttonText = result[@"buttonText"] ?:@"";
        self.planDescription = result[@"planDescription"] ?:@"";
        self.deliveryType = [result[@"deliveryType"] integerValue];
        self.landingUrl = result[@"landingUrl"] ?:@"";
        self.market = result[@"market"] ?:@"";
        self.appName = result[@"appName"] ?:@"";
        self.appPackageName = result[@"appPackageName"] ?:@"";
        self.iosWhite = result[@"iosWhite"] ?:@"";
    self.iosUrl = result[@"iosUrl"] ?:@"";
    self.adTemplateId = result[@"adTemplateId"] ?:@"";
        self.logoType = [result[@"logoType"] integerValue] ?:0;
    
    
    return self;
}
@end


