//
//  EasySAdSDKLoadADManager.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/11.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySAdSDKLoadADManager.h"
#import "EasySNetWorkUtil.h"
#import "EasySNetWorkPath.h"
#import "EasySSDKStartModel.h"
#import "YTSDKStartManager.h"
#import "EasySAdSDKLoadADModel.h"
#import "YTSDKConst.h"
#import "EasySAdSDKLoadADRequestTypeManager.h"
#import "EasySSDKtrackMagager.h"
#import "EasySSDKCacheMagager.h"
#import "EasySRandomUtil.h"


@implementation EasySAdSDKLoadADManager


/// 加载广告
/// - Parameters:
///   - adType: 广告类型：1-开屏广告  2-信息流广告 3-激励视频  4-Banner广告  5-插屏广告
///   - slotId: 广告位ID
///   - comple: <#comple description#>
- (void)loadAdData:(NSString *)adType withSlotId:(NSString *)slotId withHandler:(EasySAdSDKLoadCompletionHandler)comple{

    
    /*
 1.【SDK】检查是否已初始化&是否已启动
 │     ├─ 是 → 继续
 │     └─ 否 → 结束
 **/
    if (YTSDKStartManager.shared.isStart) {
            [self loadAdRequestIdData:adType withSlotId:slotId withHandler:comple];
        }else {
//            if (comple) {
//                NSError *err = [NSError errorWithDomain:@"adLoad" code:100023 userInfo:@{NSLocalizedDescriptionKey:model.msg ?:@"",NSStringEncodingErrorKey:model.code}];
//                comple(NO,NULL,err);
//            }
            MySDKLog(@"初始化失败");
        }
}

//获取requestId  验签校验

- (void)loadAdRequestIdData:(NSString *)adType withSlotId:(NSString *)slotId withHandler:(EasySAdSDKLoadCompletionHandler)comple{

#pragma mark - SDK请求后端获取requestId
    [EasySSDKtrackMagager reportLog:@"request_q" withRequestId:nil withPlacementId:slotId withPlacementType:adType withAdId:nil withResult:nil withAdModelType:nil withBtnName:nil withNextStep:nil];
    [EasySNetWorkUtil request:[[EasySNetWorkPath alloc] initWithType:4 withParam:@{@"adType":adType}] success:^(NSDictionary * _Nonnull respDict) {
        
        EasySSDKStartModel *model = [[EasySSDKStartModel alloc] initWithDic:respDict];
        NSString *requestId = model.data[@"requestId"] ?:@"";
        if ([model.code isEqualToString:@"200"] && requestId.length > 0) {
#pragma mark - SDK请求后端获取requestId 0-成功、1-失败
    [EasySSDKtrackMagager reportLog:@"request_r" withRequestId:requestId withPlacementId:slotId withPlacementType:adType withAdId:nil withResult:@"0" withAdModelType:nil withBtnName:nil withNextStep:nil];
            [self loadData:adType withSlotId:slotId withRequestId:requestId withHandler:comple];
        }else {
            [EasySSDKtrackMagager reportLog:@"request_r" withRequestId:nil withPlacementId:slotId withPlacementType:adType withAdId:nil withResult:@"1" withAdModelType:nil withBtnName:nil withNextStep:nil];

            if (comple) {
                NSError *err = [NSError errorWithDomain:@"getRequestId" code:100023 userInfo:@{NSLocalizedDescriptionKey:model.msg ?:@"验签失败",NSStringEncodingErrorKey:model.code}];
                comple(NO,NULL,err);
            }
        }
    } fail:^(NSError * _Nonnull error) {
        if (comple) {
            comple(NO,NULL,error);
        }
    }];
}
- (void)loadData:(NSString *)adType withSlotId:(NSString *)slotId withRequestId:(NSString *)requestId withHandler:(EasySAdSDKLoadCompletionHandler)comple {
#pragma mark - APP调用load时
    [EasySSDKtrackMagager reportLog:@"load" withRequestId:requestId withPlacementId:slotId withPlacementType:adType withAdId:nil withResult:nil withAdModelType:nil withBtnName:nil withNextStep:nil];
    [EasySNetWorkUtil request:[[EasySNetWorkPath alloc] initWithType:5 withParam:@{@"adType":adType,@"requestId":requestId,@"slotId":slotId}] success:^(NSDictionary * _Nonnull respDict) {
        EasySSDKStartModel *model = [[EasySSDKStartModel alloc] initWithDic:respDict];
        if ([model.code isEqualToString:@"200"]) {
            if (comple) {
                EasySAdSDKLoadADModel *adModel = [[EasySAdSDKLoadADModel alloc] initWithDic:model.data];
                [[EasySSDKCacheMagager shared] saveCache:model.data forKey:slotId];
                comple(YES,adModel,NULL);
                [self reportLoadResult:adType withSlotId:slotId withRequestId:requestId withAdId:adModel.adPlanId withResult:0];//load结果 成功

            }
        }else {
            if (comple) {
                NSError *err = [NSError errorWithDomain:@"adLoad" code:100023 userInfo:@{NSLocalizedDescriptionKey:model.msg ?:@"",NSStringEncodingErrorKey:model.code}];
                comple(NO,NULL,err);
                [self reportLoadResult:adType withSlotId:slotId withRequestId:requestId withAdId:nil withResult:1];//load结果 失败
            }
        }
    } fail:^(NSError * _Nonnull error) {
        comple(NO,NULL,error);
        [self reportLoadResult:adType withSlotId:slotId withRequestId:requestId withAdId:nil withResult:1];//load结果 失败
    }];
}

#pragma mark - APP调用load的结果 处理结果：0-成功、1-失败
- (void)reportLoadResult:(NSString *)adType withSlotId:(NSString *)slotId withRequestId:(NSString *)requestId withAdId:(NSString *)adId withResult:(NSInteger)result{
    //0-开屏广告、1-信息流模版广告
//    NSString *PlacementType = @"1";
//    if ([adType isEqualToString:@"1"]) {
//        PlacementType = @"0";
//    }
    [EasySSDKtrackMagager reportLog:@"load_result" withRequestId:requestId withPlacementId:slotId withPlacementType:adType withAdId:adId withResult:[NSString stringWithFormat:@"%d",result] withAdModelType:nil withBtnName:nil withNextStep:nil];
}
    
@end
