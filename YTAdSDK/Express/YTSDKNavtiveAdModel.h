//
//  YTSDKNavtiveAdModel.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/30.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EasySAdSDKLoadADModel.h"
#import "YTSDKNativeExpressView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTSDKNavtiveAdModel : NSObject
@property (nonatomic, strong) YTSDKNativeExpressView *adView;
//@property (nonatomic, strong) EasySAdSDKLoadADModel *adModel;
@property (nonatomic, strong) UIViewController *nativePresentVC;
//@property (nonatomic, strong) UIImage *nativeImg;

@end

NS_ASSUME_NONNULL_END
