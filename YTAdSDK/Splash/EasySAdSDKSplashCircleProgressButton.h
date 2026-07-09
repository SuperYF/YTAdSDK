//
//  EasySAdSDKSplashCircleProgressButton.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/11.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasySAdSDKSplashCircleProgressButton : UIButton
/// 进度 0 ~ 1
@property (nonatomic, assign) CGFloat progress;
/// 进度条宽度
@property (nonatomic, assign) CGFloat progressLineWidth;
/// 进度条前景色
@property (nonatomic, strong) UIColor *progressColor;
/// 进度条背景色
@property (nonatomic, strong) UIColor *progressBgColor;

@end

NS_ASSUME_NONNULL_END
