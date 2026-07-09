//
//  YTSSDKSplashView.h
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/15.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTSDKConst.h"


NS_ASSUME_NONNULL_BEGIN
@class YTSSDKSplashView,EasySAdSDKLoadADModel;
@protocol YTSSDKSplashViewDelegate <NSObject>
///// 跳过/倒计时结束
//- (void)splashAdDidFinish;

////广告素材下载失败
//- (void)splashAdDownloadFail:(EasySAdSDKLoadADModel *)splashModel withError:(NSError *)error;

/// 点击广告跳转H5
- (void)splashAdDidClick:(EasySAdSDKLoadADModel *)splashModel  withNextStep:(NSInteger)nextStep;


///// 跳过/倒计时结束
- (void)splashAdDidFinish:(EasySAdSDKLoadADModel *)splashModel closeType:(EasySSplashAdCloseType)closeType;


@end
@interface YTSSDKSplashView : UIView
@property (nonatomic, weak) id<YTSSDKSplashViewDelegate> delegate;

@property (nonatomic, strong) UIViewController *rootVC;
- (void)setUpSubviews:(EasySAdSDKLoadADModel *)model logoImg:(UIImage *)logoImg;

//- (void)showWithAdImgUrl:(UIImage *)adImg linkUrl:(NSString *)linkUrl logoImg:(UIImage *)logoImg ;

@end

NS_ASSUME_NONNULL_END
