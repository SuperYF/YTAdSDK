//
//  UIView+EasyS.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "UIView+EasyS.h"

@implementation UIView (EasyS)
#pragma mark - 获取当前控制器
- (UIViewController *)es_currentViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *responder = [view nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}
#pragma mark - 获取顶层 VC（安全稳定）
- (UIViewController *)findTopViewController {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)frameOrigin {
    CGRect rect = self.frame;
    rect.origin = frameOrigin;
    self.frame = rect;
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)frameSize {
    CGRect rect = self.frame;
    rect.size = frameSize;
    self.frame = rect;
}

@end
