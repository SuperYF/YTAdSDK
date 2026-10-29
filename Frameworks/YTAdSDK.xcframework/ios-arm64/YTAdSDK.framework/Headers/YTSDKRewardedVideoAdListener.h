//
//  YTSDKRewardedVideoAdListener.h
//  YTAdSDK
//
//  Created by renpin-ios on 2026/9/3.
//  Copyright © 2026 易推app. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YTSDKRewardedDelegate;
@interface YTSDKRewardedVideoAdListener : NSObject
@property (nonatomic, weak) id<YTSDKRewardedDelegate> delegate;
@property (nonatomic, assign) BOOL isAdValid;


//请求广告
- (void)loadAD:(NSString *)placementID;
//show
- (void)showRewardedVideoInRootViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
