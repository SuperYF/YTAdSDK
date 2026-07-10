//
//  YTSDKCustomSplashDelegate.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>


//#import <AnyThinkSDK.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YTSDKSplashAdDelegate;
@interface YTSDKCustomSplashDelegate : NSObject<YTSDKSplashAdDelegate>
@property (nonatomic, strong) ATSplashAdStatusBridge * adStatusBridge;

@end

NS_ASSUME_NONNULL_END
