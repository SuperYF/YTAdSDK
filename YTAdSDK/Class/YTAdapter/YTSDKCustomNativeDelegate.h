//
//  YTSDKCustomNativeDelegate.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YTNavtiveAdDelegete;
@interface YTSDKCustomNativeDelegate : NSObject<YTNavtiveAdDelegete>

@property (nonatomic,strong) ATNativeAdStatusBridge *adStatusBridge;

//@property (nonatomic, strong) ATAdMediationArgument *adMediationArgument;

@end

NS_ASSUME_NONNULL_END
