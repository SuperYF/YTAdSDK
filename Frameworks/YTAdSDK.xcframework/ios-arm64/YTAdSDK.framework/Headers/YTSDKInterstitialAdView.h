//
//  YTSDKInterstitialAdView.h
//  YTAdSDK
//
//  Created on 2026/10/8.
//  Copyright © 2026 易推app. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YTSDKInterstitialAdView, YTAdSDKLoadADModel;

@protocol YTSDKInterstitialAdViewDelegate <NSObject>

/// 点击广告（含 CTA），并完成投放跳转后回调
- (void)interstitialAdViewDidClick:(YTSDKInterstitialAdView *)adView withNextStep:(NSInteger)nextStep;

/// 点击关闭（顶部或底部关闭按钮）
- (void)interstitialAdViewDidClose:(YTSDKInterstitialAdView *)adView;

/// 视图即将挂到 Window（曝光时机）
- (void)interstitialAdViewWillMoveToWindow:(YTSDKInterstitialAdView *)adView;

@end

/// 插屏弹窗视图：圆角广告图 + 顶部关闭 + 底部关闭 +「广告」logo + CTA
@interface YTSDKInterstitialAdView : UIView

@property (nonatomic, weak, nullable) id<YTSDKInterstitialAdViewDelegate> delegate;

/// 使用广告图初始化（默认按图片比例自适应尺寸）
- (instancetype)initWithAdImage:(UIImage *)adImage;

/// 配置物料与主图
- (void)setUpSubviews:(YTAdSDKLoadADModel *)model withAdImage:(UIImage *)image;

/// 配置物料、主图与跳转用 rootVC（rootVC 可空，展示时再补）
- (void)setUpSubviews:(YTAdSDKLoadADModel *)model
          withAdImage:(UIImage *)image
withRootViewController:(nullable UIViewController *)rootVC;

/// 仅更新背景图 / CTA 副标题
- (void)configureWithAdImage:(UIImage *)adImage;
- (void)configureWithAdImage:(UIImage *)adImage detailText:(nullable NSString *)detailText;

/// 更新跳转用 rootVC（展示前可再次设置）
- (void)updateRootViewController:(nullable UIViewController *)rootVC;

@end

NS_ASSUME_NONNULL_END
