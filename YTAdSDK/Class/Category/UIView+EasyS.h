//
//  UIView+EasyS.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (EasyS)
/// 获取当前view所属的控制器
- (UIViewController *)es_currentViewController;

///获取顶层 VC（安全稳定）
- (UIViewController *)findTopViewController;


@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGSize frameSize;
@end

NS_ASSUME_NONNULL_END
