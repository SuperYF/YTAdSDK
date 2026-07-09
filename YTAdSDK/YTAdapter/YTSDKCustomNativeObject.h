//
//  YTSDKCustomNativeObject.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>
NS_ASSUME_NONNULL_BEGIN
@class YTSDKNavtiveAdModel;
@interface YTSDKCustomNativeObject : ATCustomNetworkNativeAd

@property (nonatomic, strong) YTSDKNavtiveAdModel *feedAdModel;

@end

NS_ASSUME_NONNULL_END
