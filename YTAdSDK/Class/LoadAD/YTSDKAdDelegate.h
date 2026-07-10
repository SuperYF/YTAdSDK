//
//  YTSDKAdDelegate.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTAdSDK/YTSDKConst.h>

NS_ASSUME_NONNULL_BEGIN
@class YTSSDKSplashView,YTSDKConst;
@protocol YTSDKSplashAdDelegate <NSObject>
@required


@optional

#pragma mark - 加载

/// 开屏广告加载完成
/// - Parameters:
///   - placementID: 广告位ID
- (void)onYtAdLoaded:(NSString *)placementID;

/// 广告位加载失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
/// 开屏广告加载失败
- (void)onYtNoAdError:(NSString *)placementID error:(NSError *_Nullable)error;
//超时
- (void)onYtAdLoadTimeout:(NSString *)placementID error:(NSError *_Nullable)error;


#pragma mark - 展示
//展示成功
- (void)onYtAdShow:(NSString *)placementID;

//关闭开屏广告
- (void)onYtAdDismiss:(NSString *)placementID closeType:(EasySSplashAdCloseType)closeType;







//渲染 -
- (void)splashAdRenderSuccess:(NSString *)placementID;
- (void)splashAdRenderFail:(NSString *)placementID error:(NSError *_Nullable)error;


/// 点击开屏广告，进入详情页 广告点击回调
- (void)onYtAdClick:(NSString *)placementID;





/*
/// This method is called when splash view will show
- (void)splashAdWillShow:(BUSplashAd *)splashAd;

/// This method is called when splash view did show
// Mediation:/// @Note :  当加载聚合维度广告时，支持该回调的adn有：CSJ
- (void)splashAdDidShow:(BUSplashAd *)splashAd;



/// This method is called when splash viewControllr is closed.
// Mediation:/// @Note : 当加载聚合维度广告，最终展示的广告关闭时，
// Mediation:///         如该adn未提供“控制器关闭”回调，为保持逻辑完整，聚合逻辑内部在DidClose后补齐该回调，
// Mediation:///         如该adn提供“控制器关闭”回调，则以对应adn为准。
- (void)splashAdViewControllerDidClose:(BUSplashAd *)splashAd;


*/
@end

@class YTNavtiveAdListener,YTSDKNavtiveAdModel,YTSDKNativeExpressView;
@protocol YTNavtiveAdDelegete <NSObject>
@required
//渲染成功，添加
//- (void)onRenderSuccess:(YTSDKNavtiveAdModel *)adModel;
- (void)onRenderSuccess:(YTSDKNativeExpressView *)adModel;
//点击关闭，移除
- (void)onAdCloseClick:(YTSDKNativeExpressView *)adView;

@optional
//- (void)onYtErrorLoad:(YTNavtiveAdListener *)placementID extra:(NSDictionary *)extra withError:(NSError *)error;
//广告下载
- (void)onYtErrorLoad:(YTNavtiveAdListener *)asListener withError:(NSError *)error;
- (void)onYtSuccessLoad:(YTNavtiveAdListener *)asListener;

//渲染
- (void)onRenderFail:(YTNavtiveAdListener *)asListener withError:(NSError *)error;

//点击广告
- (void)atOnAdClick:(YTSDKNativeExpressView *)adView;


@end

@interface YTSDKAdDelegate : NSObject

@end

NS_ASSUME_NONNULL_END
