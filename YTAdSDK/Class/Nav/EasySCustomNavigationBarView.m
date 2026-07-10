//
// EasySCustomNavigationBarView.m
// EasySpreadSDK
//
// Created by renpin-ios on 2026/5/18.
// Copyright © 2026 易推SDK. All rights reserved.
//

#import "EasySCustomNavigationBarView.h"
#import "EasySSDKGeneralTool.h"
@interface EasySCustomNavigationBarView()
@property (nonatomic, strong) UILabel *titleLB;
@end

@implementation EasySCustomNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [EasySSDKGeneralTool imageNamed:@"yt_na_sdk_back" withClass:self.class];

    [backBtn setImage:backImage forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(10, 12, 26, 20);
    [self addSubview:backBtn];

    // 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeImage = [EasySSDKGeneralTool imageNamed:@"yt_na_sdk_close" withClass:self.class];
    [closeBtn setImage:closeImage forState:UIControlStateNormal];
    closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(CGRectGetMaxX(backBtn.frame) + 8, 12, 26, 20);
    [self addSubview:closeBtn];

    // 标题
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLB.textColor = [UIColor blackColor];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLB];
}

// 布局子控件 - 自动适配宽度
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    self.titleLB.frame = CGRectMake(100, 0, width - 200, 44);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLB.text = title;
}

// 返回
- (void)backBtnClick {
    if ([self.delegate respondsToSelector:@selector(navigationBarBack)]) {
        [self.delegate navigationBarBack];
    }
}

- (void)closeBtnClick {
    if ([self.delegate respondsToSelector:@selector(navigationBarClose)]) {
        [self.delegate navigationBarClose];
    }
}

@end
