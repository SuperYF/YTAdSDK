//
//  EasySAdSDKSplashCircleProgressButton.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/11.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySAdSDKSplashCircleProgressButton.h"

@interface EasySAdSDKSplashCircleProgressButton ()
@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end

@implementation EasySAdSDKSplashCircleProgressButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLayer];
        // 默认参数
        _progress = 0;
        _progressLineWidth = 1;
        _progressColor = [UIColor lightGrayColor];
        _progressBgColor = [UIColor systemBlueColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupLayer];
        _progress = 0;
        _progressLineWidth = 1;
        _progressColor = [UIColor lightGrayColor];
        _progressBgColor = [UIColor systemBlueColor];
    }
    return self;
}

- (void)setupLayer {
    // 底层圆环
    _bgLayer = [CAShapeLayer layer];
    _bgLayer.fillColor = [UIColor clearColor].CGColor;
    _bgLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_bgLayer];
    
    // 进度圆环
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeEnd = 1.0;
    [self.layer addSublayer:_progressLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat radius = MIN(width, height) / 2.0 - self.progressLineWidth / 2.0;
    CGPoint center = CGPointMake(width/2, height/2);
    
    // 圆环路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI * 2 - M_PI_2
                                                     clockwise:YES];
    
    // 配置底层圆环
    _bgLayer.path = path.CGPath;
    _bgLayer.lineWidth = self.progressLineWidth;
    _bgLayer.strokeColor = self.progressBgColor.CGColor;
    
    // 配置进度圆环
    _progressLayer.path = path.CGPath;
    _progressLayer.lineWidth = self.progressLineWidth;
    _progressLayer.strokeColor = self.progressColor.CGColor;
}

- (void)setProgress:(CGFloat)progress {
    _progress = MAX(0, MIN(1, progress));
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.fromValue = @(self.progressLayer.strokeEnd);
    anim.toValue = @(_progress);
    anim.duration = 0.3; // 动画时长
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.progressLayer addAnimation:anim forKey:@"progressAnim"];
    self.progressLayer.strokeEnd = _progress;
    
//        if (_progress == progress) return;
//        _progress = progress;
        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.016]; // 一帧动画时长
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        self.progressLayer.strokeEnd = progress;
//        [CATransaction commit];
}

@end
