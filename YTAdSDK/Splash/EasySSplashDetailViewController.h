//
//  EasySSplashDetailViewController.h
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/18.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTSDKConst.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ETSplashDetailBack)(void);

@protocol EasySSplashDetailDelegate <NSObject>

//关闭本页面
- (void)splashDetailAdDidCloseType:(EasySSplashAdCloseType)closeType;

- (void)splashDetailBackTime:(NSInteger )cuttentTime;

///// 跳过/倒计时结束
//- (void)splashDetailAdDidFinish:(EasySSplashView *)splashAd closeType:(EasySSplashAdCloseType)closeType;


@end
@interface EasySSplashDetailViewController : UIViewController
@property (nonatomic, weak) id<EasySSplashDetailDelegate> delegate;

@property (nonatomic, strong) NSString *splashUrl;
@property (nonatomic, strong) NSString *splashTitle;

@property (nonatomic, assign) NSInteger currentTime;
@property (nonatomic, assign) BOOL isSplash;

@end

NS_ASSUME_NONNULL_END
