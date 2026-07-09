//
//  EasySAdSDKLoadADModel.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/11.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface EasySAdSDKLoadADModel : NSObject

@property (nonatomic, strong) NSString *requestId; //广告计划ID
@property (nonatomic, strong) NSString *adPlanId; //广告计划ID
@property (nonatomic, strong) NSString *adPlanName;//广告计划名称
@property (nonatomic, strong) NSString *advertiserName; //广告主名称
@property (nonatomic, assign) NSInteger adType; //广告类型：1-开屏广告  2-信息流广告 3-激励视频  4-Banner广告  5-插屏广告
@property (nonatomic, assign) NSInteger materialType;//素材类型 0 =静态图
@property (nonatomic, strong) NSString *imageUrl; //图片地址
@property (nonatomic, assign) NSInteger interactionType;//0 点击 1 点击-下方 2 上划
@property (nonatomic, strong) NSString *buttonText; //按钮文案
@property (nonatomic, strong) NSString *planDescription; //计划描述
@property (nonatomic, assign) NSInteger deliveryType;//投放方式：0=H5落地页，1=小程序，2=APP直连下载
@property (nonatomic, strong) NSString *landingUrl; //落地页链接/小程序链接/deeplink地址
@property (nonatomic, strong) NSString *market; //0=华为，1=小米，2=OPPO，3=VIVO，4=荣耀，5=魅族 多个，分割  例如："0,1,2"
@property (nonatomic, strong) NSString *appName; //APP名称
@property (nonatomic, strong) NSString *appPackageName; //APP包名
@property (nonatomic, strong) NSString *iosWhite; //IOS白名单
@property (nonatomic, strong) NSString *iosUrl; //AppStore链接
@property (nonatomic, assign) NSInteger logoType; //易推logo类型 默认0易推 1穿山甲
@property (nonatomic, strong) NSString *adTemplateId; //信息流广告模版ID


- (instancetype)initWithDic:(NSDictionary *)result;
@end

NS_ASSUME_NONNULL_END
