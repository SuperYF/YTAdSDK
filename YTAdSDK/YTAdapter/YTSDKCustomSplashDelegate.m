//
//  YTSDKCustomSplashDelegate.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTSDKCustomSplashDelegate.h"
#import "YTSDKCustomBaseAdapter.h"
#import "YTSDKAdDelegate.h"

@implementation YTSDKCustomSplashDelegate

//- (void)onYtAdLoaded:(NSString *)placementID {
//
//}
//func didFailToLoadAD(withPlacementID placementID: String!, error: (any Error)!) {

- (void)onYtNoAdError:(NSString *)placementID error:(NSError *_Nullable)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}
//超时
- (void)onYtAdLoadTimeout:(NSString *)placementID error:(NSError *_Nullable)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}


#pragma mark - 展示
//展示成功
- (void)onYtAdShow:(NSString *)placementID {
    [self.adStatusBridge atOnAdShow:@{@"placementID":placementID}];
}

//关闭开屏广告
- (void)onYtAdDismiss:(NSString *)placementID closeType:(EasySSplashAdCloseType)closeType {
    [self.adStatusBridge atOnAdClosed:@{@"placementID":placementID}];

}

//渲染 -
- (void)splashAdRenderSuccess:(NSString *)placementID {

    [self.adStatusBridge atOnSplashAdLoadedExtra:@{@"placementID":placementID}];

}
- (void)splashAdRenderFail:(NSString *)placementID error:(NSError *_Nullable)error {
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];

}

/// 点击开屏广告，进入详情页 广告点击回调
- (void)onYtAdClick:(NSString *)placementID {
    [self.adStatusBridge atOnAdClick:@{@"placementID":placementID}];

}



@end


