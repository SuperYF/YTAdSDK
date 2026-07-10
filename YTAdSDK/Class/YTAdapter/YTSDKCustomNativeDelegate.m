//
//  YTSDKCustomNativeDelegate.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTSDKCustomNativeDelegate.h"
#import "YTSDKCustomNativeObject.h"
#import "YTSDKCustomBaseAdapter.h"
#import "YTSDKAdDelegate.h"
#import "YTSDKNavtiveAdModel.h"
@implementation YTSDKCustomNativeDelegate

//关闭
- (void)onAdCloseClick:(nonnull YTSDKNativeExpressView *)adView {
    [self.adStatusBridge atOnAdClosed:nil];
}

//去加载
- (void)onRenderSuccess:(nonnull YTSDKNativeExpressView *)adView {
    //判断是自渲染广告还是模版广告，走对应不同的处理逻辑
    YTSDKCustomNativeObject *nativeObj = [[YTSDKCustomNativeObject alloc] init];
    nativeObj.feedAdModel = adView.nativeModel;
    nativeObj.templateView = adView;
    nativeObj.nativeAdRenderType = ATNativeAdRenderExpress;
    nativeObj.nativeExpressAdViewWidth = adView.frame.size.width;
    nativeObj.nativeExpressAdViewHeight = adView.frame.size.height;
    [self.adStatusBridge atOnNativeAdLoadedArray:@[nativeObj] adExtra:nil];
    
}
//渲染失败
- (void)onRenderFail:(YTNavtiveAdListener *)asListener withError:(NSError *)error {
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];
}
// 请求广告失败
- (void)onYtErrorLoad:(YTNavtiveAdListener *)asListener withError:(NSError *)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];

}

- (void)atOnAdClick:(YTSDKNativeExpressView *)adView {
    [self.adStatusBridge atOnAdClick:nil];
}
@end
