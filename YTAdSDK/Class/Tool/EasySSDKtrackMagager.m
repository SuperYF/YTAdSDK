//
//  EasySSDKtrackMagager.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/15.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySSDKtrackMagager.h"
#import "EasySNetWorkUtil.h"
#import "EasySNetWorkPath.h"
#import "EasySSDKStartConfiguration.h"
#import "YTSDKConst.h"
#import "EasySAdSDKLoadADModel.h"
#import "EasySSDKGeneralTool.h"


@implementation EasySSDKtrackMagager
+ (void)errorLog:(NSString *)requestId withSlotId:(NSString *)slotId withAdType:(NSString *)adType withstep:(NSString *)step withErrorCode:(NSString *)errorCode withRawData:(NSDictionary *)rawData {
    EasySNetWorkPath *initPath = [[EasySNetWorkPath alloc] initErrorLog:requestId withSlotId:slotId withAdType:[adType integerValue] withstep:step withErrorCode:errorCode withRawData:rawData];
    
    [EasySNetWorkUtil request:initPath success:^(NSDictionary * _Nonnull respDict) {

                
    } fail:^(NSError * _Nonnull error) {
    }];
}

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
+ (void)reportLog:(NSString *)eventId withRequestId:(NSString *)requestId withPlacementId:(NSString *)placementId withPlacementType:(NSString *)placementType withAdId:(NSString *)adId withResult:(NSString *)result withAdModelType:(NSString *)adModelType withBtnName:(NSString *)btnName withNextStep:(NSString *)nextStep {
    NSMutableDictionary *reportDic = [[NSMutableDictionary alloc] init];
    if (eventId) {
        reportDic[@"eventId"] = eventId;
    }
    if (requestId) {
        reportDic[@"requestId"] = requestId;
    }
    if (placementId) {
        reportDic[@"placementId"] = placementId;
    }
    if (placementType) {
        reportDic[@"placementType"] = placementType;
    }
    if (adId) {
        reportDic[@"adId"] = adId;
    }
    if (result) {
        reportDic[@"result"] = result;
    }
    if (adModelType) {
        reportDic[@"adModelType"] = adModelType;
    }
    if (btnName) {
        reportDic[@"btnName"] = btnName;
    }
    if (nextStep) {
        reportDic[@"nextStep"] = nextStep;
    }
    
    [EasySNetWorkUtil request:[[EasySNetWorkPath alloc] initWithType:1 withParam:reportDic] success:^(NSDictionary * _Nonnull respDict) {
        
        
                
    } fail:^(NSError * _Nonnull error) {

    }];
}

#pragma mark - 广告开始渲染
/// <#Description#>
/// - Parameters:
/// //   - placementId: 代码位ID
///   - placementType: 代码位类型：0-开屏广告、1-信息流模版广告
+ (void)reportRender:(EasySAdSDKLoadADModel *)adModel withPlacementId:(NSString *)placementId withPlacementType:(NSInteger)placementType{
    [EasySSDKtrackMagager reportLog:@"render" withRequestId:adModel.requestId ?:@"" withPlacementId:placementId withPlacementType:[NSString stringWithFormat:@"%d",placementType] withAdId:adModel.adPlanId withResult:nil withAdModelType:adModel.adTemplateId ?:@"" withBtnName:nil withNextStep:nil];

}
#pragma mark - 广告渲染结果
/// 处理结果：0-成功、1-失败
/// - Parameters:
+ (void)reportRenderResult:(EasySAdSDKLoadADModel *)adModel withPlacementId:(NSString *)placementId withPlacementType:(NSInteger)placementType withResult:(NSInteger)result{
    [EasySSDKtrackMagager reportLog:@"render_result" withRequestId:adModel.requestId ?:@"" withPlacementId:placementId withPlacementType:[NSString stringWithFormat:@"%d",placementType] withAdId:adModel.adPlanId withResult:[NSString stringWithFormat:@"%d",result] withAdModelType:adModel.adTemplateId ?:@"" withBtnName:nil withNextStep:nil];

}


@end
