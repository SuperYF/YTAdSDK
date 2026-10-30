//
//  YTAdSDKLoadADModel.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/11.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface YTAdSDKLoadADModel : NSObject


@property (nonatomic, strong) NSDictionary *resultDic; //广告计划ID
@property (nonatomic, strong) NSString *requestId; //广告计划ID
@property (nonatomic, strong) NSString *slotId; //广告位ID
@property (nonatomic, strong) NSString *adPlanId; //广告计划ID
@property (nonatomic, strong) NSString *adPlanName;//广告计划名称
@property (nonatomic, strong) NSString *advertiserName; //广告主名称
@property (nonatomic, assign) NSInteger adType; //广告类型：1-开屏广告  2-信息流广告 3-激励视频  4-Banner广告  5-插屏广告
@property (nonatomic, assign) NSInteger materialType;//素材类型 0 =静态图
@property (nonatomic, strong) NSString *imageUrl; //图片地址、视频地址
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

//需求1.2
@property (nonatomic, assign) NSInteger skipType; //跳过模式 1 左-下 2 右-上

//需求1.3
@property (nonatomic, strong) NSString *landingPageTitle; //落地页标题
@property (nonatomic, assign) NSInteger logType; /**
                                                  1.DEBUG

                                                  2.INFO

                                                  3.WARN

                                                  4.ERROR
                                                  */
 //日志类型；通过 EasyAdminClient#logLevelByDevice 使用设备号、机型和 SDK 版本查询，查询失败时返回 2（INFO）；枚举见文档最后「日志类型枚举」部分。

//1.1.0新增
@property (nonatomic, assign) NSInteger isSecondConfirm; //是否需要二次确认弹窗 0 否 1 是
@property (nonatomic, assign) NSInteger sceneType; //场景分类 0纯观看（视频播放） 1任务型
@property (nonatomic, assign) NSInteger taskDuration; //任务时长
@property (nonatomic, assign) NSInteger videoDuration; //视频时长

//插屏广告
@property (nonatomic, assign) NSInteger closedType; //跳过模式 1 左-下 2 右-上

//2.0.0
@property (nonatomic, assign) NSInteger adStyle; //广告样式 1左图右文 2左文右图 3上图下文 4三小图双文

- (instancetype)initWithDic:(NSDictionary *)result;
@end

NS_ASSUME_NONNULL_END
