//
//  YTSDKInterstitialAdListener.h
//  YTAdSDK
//
//  Created on 2026/10/9.
//  Copyright © 2026 易推app. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YTSDKInterstitialAdDelegate;
@class YTSDKInterstitialAdView;

/// 插屏广告加载 / 展示门面（流程对齐信息流 YTNavtiveAdListener）
@interface YTSDKInterstitialAdListener : NSObject

@property (nonatomic, weak, nullable) id<YTSDKInterstitialAdDelegate> delegate;
@property (nonatomic, weak, nullable) UIViewController *rootViewController;
@property (nonatomic, strong, nullable) NSString *slotId;
@property (nonatomic, strong, readonly, nullable) YTSDKInterstitialAdView *adView;

- (instancetype)initWithSlot:(NSString * _Nullable)slot;

/// 是否就绪（缓存命中或本次加载成功）
- (BOOL)isAdReady:(NSString *)slotId;

/// 请求广告物料并渲染
- (void)load;

/// 在指定控制器上展示（半透明遮罩 + 居中插屏视图）
- (void)showInViewController:(UIViewController *)viewController;

/// 销毁并移除视图
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
