//
//  YTSDKSplashAdListener.h
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/14.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "YTSDKAdDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YTSDKSplashAdDelegate;
@class YTSSDKSplashView;

@interface YTSDKSplashAdListener : NSObject

@property (nonatomic, weak) id<YTSDKSplashAdDelegate> delegate;

@property (nonatomic, strong, readonly, nullable) YTSSDKSplashView *splashView;


//@property (nonatomic, weak, readonly, nullable) UIViewController *splashRootViewController;

// 单例
+ (instancetype)shared;


- (BOOL)isAdReady:(NSString *)placementID; //是否有广告

// 对外提供的方法
//加载开屏广告
- (void)setSlotId:(NSString *)slotId withAdSize:(CGSize)size;


//请求广告
- (void)loadAD:(NSString *)placementID withContainerView:(UIView * _Nullable)containerView;
//show
- (void)showSplashViewInRootViewController:(UIViewController *)viewController;
- (void)showSplashViewInWindow:(UIWindow *)window delegate:(id<YTSDKSplashAdDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
