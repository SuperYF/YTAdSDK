//
//  YTSDKCustomSplashAdapter.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTSDKCustomBaseAdapter.h"

NS_ASSUME_NONNULL_BEGIN
//@class YTSDKCustomSplashDelegate,YTSDKSplashAdListener;
@interface YTSDKCustomSplashAdapter : YTSDKCustomBaseAdapter <ATBaseSplashAdapterProtocol>
@property (nonatomic, strong) UIView * containerView;

@end

NS_ASSUME_NONNULL_END
