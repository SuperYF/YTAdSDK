//
//  EasySSDKtrackMagager.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/15.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// <#Description#>
@class EasySAdSDKLoadADModel;
@interface EasySSDKtrackMagager : NSObject
//错误埋点

/// <#Description#>
/// - Parameters:
///   - requestId: <#requestId description#>
///   - slotId: <#slotId description#>
///   - adType: 1    开屏广告  2    信息流广告  3    激励视频  4    Banner广告  5    插屏广告
///   - step: 环节，例如：init/start/load；
///   - errorCode: <#errorCode description#>
///   - rawData: <#rawData description#>
+ (void)errorLog:(NSString *)requestId withSlotId:(NSString *)slotId withAdType:(NSString *)adType withstep:(NSString *)step withErrorCode:(NSString *)errorCode withRawData:(NSDictionary *)rawData;




/// 数据埋点
/// - Parameters:
///   - eventId: 事件ID
///   - requestId: 广告请求ID
///   - placementId: 代码位ID
///   - placementType: 代码位类型：0-开屏广告、1-信息流模版广告
///   - adId: 广告计划ID
///   - result: 处理结果：0-成功、1-失败
///   - adModelType: 广告模版类型：0-左图右文
///   - btnName: 按钮名称：0-查看广告；1-跳过；2-关闭；3-倒计时结束；4-打开APP；5-取消打开APP
///   - nextStep: 下一步：0-打开APP提醒弹窗；1-进入H5着陆页；2-唤起小程序；3-移除广告；4-跳转应用市场；5-关闭广告
+ (void)reportLog:(NSString *)eventId withRequestId:(NSString *)requestId withPlacementId:(NSString *)placementId withPlacementType:(NSString *)placementType withAdId:(NSString *)adId withResult:(NSString *)result withAdModelType:(NSString *)adModelType withBtnName:(NSString *)btnName withNextStep:(NSString *)nextStep;
//+ (void)reportLog:(NSString *)eventId withRequestId:(NSString *)requestId withPlacementId:(NSString *)placementId withPlacementType:(NSInteger)placementType withAdId:(NSString *)adId withResult:(NSInteger)result withAdModelType:(NSInteger)adModelType withBtnName:(NSString *)btnName withNextStep:(NSInteger)nextStep;

+ (void)reportRender:(EasySAdSDKLoadADModel *)adModel withPlacementId:(NSString *)placementId withPlacementType:(NSInteger)placementType;

+ (void)reportRenderResult:(EasySAdSDKLoadADModel *)adModel withPlacementId:(NSString *)placementId withPlacementType:(NSInteger)placementType withResult:(NSInteger)result;

@end

NS_ASSUME_NONNULL_END
