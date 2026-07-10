//
//  YTSDKNativeExpressView.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/9.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTSDKNativeExpressView.h"
#import "UIView+EasyS.h"
#import "EasySSDKGeneralTool.h"
#import "EasySImageDownloader.h"
#import "EasySAdSDKLoadADModel.h"
#import "EasySSplashDetailViewController.h"
#import "YTSDKNavtiveAdModel.h"


@interface YTSDKNativeExpressView ()<EasySSplashDetailDelegate>
@property (nonatomic, strong) UIImageView *nativeImg;
@property (nonatomic, strong) UILabel *contentLB;
//@property (nonatomic, strong) UIView *logoV;
@property (nonatomic, strong) UIImageView *logoImg;

@property (nonatomic, strong) UILabel *remarkLB;
@property (nonatomic, strong) UIButton *closeBtn;
//@property (nonatomic, strong) UIImageView *adLogoImg;
@property (nonatomic, strong) UIButton *clickBtn;

@property (nonatomic, strong) EasySAdSDKLoadADModel *adModel;


@property (nonatomic, assign) BOOL isRepeatClose; //防止连点
@property (nonatomic, assign) BOOL isRepeatClick; //防止连点

@property (nonatomic, strong) UIViewController *rootViewController;

@end
@implementation YTSDKNativeExpressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews {
    self.isRepeatClose = NO;
    self.isRepeatClick = NO;

    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.nativeImg];
    [self addSubview:self.contentLB];
    [self addSubview:self.logoImg];
    [self addSubview:self.remarkLB];
    [self addSubview:self.clickBtn];
    [self addSubview:self.closeBtn];

}


- (UIImageView *)nativeImg {
    if (!_nativeImg) {
        _nativeImg = [[UIImageView alloc] init];
        _nativeImg.contentMode = UIViewContentModeScaleAspectFill;
        _nativeImg.userInteractionEnabled = YES;
        _nativeImg.clipsToBounds = YES;
    }
    return _nativeImg;
}
- (UILabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.font = [UIFont systemFontOfSize:15];
        _contentLB.textColor = [UIColor blackColor];
        _contentLB.numberOfLines = 0;
        _contentLB.textAlignment = NSTextAlignmentLeft;
        _contentLB.userInteractionEnabled = YES;

    }
    return _contentLB;
}
- (UIImageView *)logoImg {
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc] initWithImage:[EasySSDKGeneralTool imageNamed:@"yt_native_sdk_logo" withClass:self.class]];
    }
    return _logoImg;
}


- (UILabel *)remarkLB {
    if (!_remarkLB) {
        _remarkLB = [[UILabel alloc] init];
        _remarkLB.font = [UIFont systemFontOfSize:12];
        _remarkLB.textColor = [UIColor blackColor];
        _remarkLB.numberOfLines = 0;
        _remarkLB.text = @"查看详情";
        _remarkLB.textColor = [UIColor colorWithRed:0.1 green:0.39 blue:1 alpha:1];
//        _remarkLB.frame = CGRectMake(0, 0, 48, 14);
        _remarkLB.userInteractionEnabled = YES;
        _remarkLB.numberOfLines = 1;
        _remarkLB.lineBreakMode = UILineBreakModeTailTruncation;
        [_remarkLB sizeToFit] ;
        _remarkLB.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return _remarkLB;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[EasySSDKGeneralTool imageNamed:@"yt_native_sdk_close" withClass:self.class] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(nativeCloseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.frame = CGRectMake(0, 0, 16, 16);
    }
    return _closeBtn;
}
- (UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.backgroundColor = [UIColor clearColor];
        [_clickBtn addTarget:self action:@selector(nativeClickBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _clickBtn.frame = self.bounds;
    }
    return _clickBtn;
}
- (UIViewController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = [self es_currentViewController];
    }
    return _rootViewController;
}
//点击关闭
- (void)nativeCloseBtnAction {
 
    if (self.isRepeatClose) {
        return;
    }
    self.isRepeatClose = YES;
    // 延迟恢复点击
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isRepeatClose = NO;
        });
    if ([self.delegate respondsToSelector:@selector(onAdCloseClick:)]) {
        [self.delegate onAdCloseClick:self];
    }
}
//点击详情
- (void)nativeClickBtnAction {
//    EasySSplashDetailViewController *detailVC = [[EasySSplashDetailViewController alloc] init];
//    detailVC.splashUrl = @"https://www.baidu.com/";
//    detailVC.splashTitle = self.adModel.planDescription;
//    detailVC.delegate = self;
//    detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.rootViewController presentViewController:detailVC animated:YES completion:nil];
//    return;

    if (self.isRepeatClick) {
        return;
    }
    self.isRepeatClick = YES;
    // 延迟恢复点击
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isRepeatClick = NO;
        });
    NSInteger nextStep = -1;
    NSInteger deliveryType = self.adModel.deliveryType;
    if (deliveryType == 0) { //落地页
        if (self.adModel.landingUrl.length == 0 || !self.rootViewController) return;
        EasySSplashDetailViewController *detailVC = [[EasySSplashDetailViewController alloc] init];
        detailVC.splashUrl = self.adModel.landingUrl;
        detailVC.isSplash = NO;
        detailVC.splashTitle = self.adModel.planDescription;
        detailVC.delegate = self;
        
        detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.rootViewController presentViewController:detailVC animated:YES completion:nil];
   
        
        nextStep = 1;
    }else if (deliveryType == 1){//小程序
        NSURL *appUrl = [NSURL URLWithString:self.adModel.landingUrl];
        BOOL isLanding = [[UIApplication sharedApplication] canOpenURL:appUrl];
        if (isLanding ) {
            [[UIApplication sharedApplication] openURL:appUrl options:nil completionHandler:nil];
            nextStep = 2;
        }else {
            return;
        }
    }else if (deliveryType == 2) { //直接打开或者下载
        NSURL *whiteUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://",self.adModel.iosWhite]];
        BOOL whiteLanding = [[UIApplication sharedApplication] canOpenURL:whiteUrl];
        if (whiteLanding) { //直接打开
            [[UIApplication sharedApplication] openURL:whiteUrl options:nil completionHandler:nil];
            nextStep = 0;

        }else {
            NSURL *appUrl = [NSURL URLWithString:self.adModel.iosUrl];
            BOOL appLanding = [[UIApplication sharedApplication] canOpenURL:appUrl];
            if (appLanding) {
                [[UIApplication sharedApplication] openURL:appUrl options:nil completionHandler:nil];
                nextStep = 4;

            }else {
                return;
            }
        }
    }else {
        return;
    }
    /*
     "O
     点击名称 = 查看广告时，必传
     0-打开APP提醒弹窗；
     1-进入H5着陆页；
     2-唤起小程序；
     3-移除广告；
     4-跳转应用市场；
     5-关闭广告"
     **/
    if ([self.delegate respondsToSelector:@selector(onAdClick:withNextStep:)]) {
        [self.delegate onAdClick:self withNextStep:nextStep];
    }
}

//设置model
//模板设置
//- (void)setNativeModel:(EasySAdSDKLoadADModel *)nativeModel {
//    [self setUpSubviews:nativeModel withAdImage:nativeModel.nativeImg withRootViewController:nativeModel.nativePresentVC];
//}
- (void)setUpSubviews:(EasySAdSDKLoadADModel *)model withAdImage:(UIImage *)image {
    CGSize mySize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 277);
    self.frame = CGRectMake(0, 0, mySize.width, mySize.height);
    
    self.adModel = model;
    self.nativeImg.image = image;
    self.contentLB.text = model.planDescription;
    self.nativeImg.contentMode = UIViewContentModeScaleAspectFill;
    self.clickBtn.frame = self.bounds;
    
    self.nativeImg.frame = CGRectMake(12, 16, mySize.width-24, 195);
    self.contentLB.frame = CGRectMake(12, 219, mySize.width-9-24, 18);
    self.logoImg.frame = CGRectMake(12, 246, 38, 13);
//    self.remarkLB.frame = CGRectMake(mySize.width-32-48, 246, 48, 14);
    self.closeBtn.frame = CGRectMake(mySize.width-16-12, 245, 16, 16);
    [NSLayoutConstraint activateConstraints:@[
        [self.remarkLB.rightAnchor constraintEqualToAnchor:self.closeBtn.leftAnchor constant:-4],
        [self.remarkLB.centerYAnchor constraintEqualToAnchor:self.closeBtn.centerYAnchor],
    ]];
    //默认0易推 1穿山甲
    if (model.logoType == 1) {
        self.logoImg.image = [EasySSDKGeneralTool imageNamed:@"yt_native_csj_logo" withClass:self.class];
    }
    
}
- (void)setUpSubviews:(EasySAdSDKLoadADModel *)model withAdImage:(UIImage *)image withRootViewController:(UIViewController *)rootVC {
    //适配taku adapter
//    self.nativeModel = model;
//    self.nativeModel.nativeImg = image;
    self.rootViewController = rootVC;
    [self setUpSubviews:model withAdImage:image];
    

}
//自适应
- (void)setUpSubviews:(EasySAdSDKLoadADModel *)model withAdImage:(UIImage *)image withAdSize:(CGSize)size withSizeToFit:(BOOL)sizeToFit withRootViewController:(UIViewController *)rootVC {
    self.rootViewController = rootVC;
    self.adModel = model;
    self.nativeImg.image = image;
    self.contentLB.text = model.planDescription;
    self.nativeImg.contentMode = UIViewContentModeScaleAspectFill;

    if (sizeToFit) { //为true时，高度自适应
        if (size.width > 0) {
            [self setSubviewsAdaptive:image withAdSize:size];
        }else { //为0或者未设置
            self.frame = CGRectMake(0, 0, 0, 0);
        }
    }else {
        CGFloat width = size.width;
        CGFloat height = size.height;

        if (width > 0 && height == 0) { //高度为0 自适应
            [self setSubviewsAdaptive:image withAdSize:size];
        } else if (width > 0 && height > 0) {
            CGFloat bottomHeight = 16+8+18+8;
            CGFloat vHeigth = [self getNativeImgHeight:image withAdSize:size];
            CGFloat imgHH = height - bottomHeight;
            if (imgHH <= 0) { //小于0，意味着图片尺寸为0
                imgHH = 0;
            }
            if (vHeigth > height) {
                CGFloat vHeight = size.height;
                CGFloat vWidth = size.width;
                self.nativeImg.frame = CGRectMake(0, 0, vWidth, imgHH);

                self.logoImg.frame = CGRectMake(0, vHeight-15, 38, 13);
//                self.remarkLB.frame = CGRectMake(vWidth-20-48, vHeight-15, 48, 14);
                self.closeBtn.frame = CGRectMake(vWidth-16, vHeight-16, 16, 16);
                
                self.contentLB.frame = CGRectMake(0, vHeight-23-18, vWidth-8, 18);
                self.frame = CGRectMake(0, 0, vWidth, vHeight);
            }else {//配置的高度高于或等于自适应的高度 则为配置 的高度
                [self getNativeImgHeight:image withAdSize:size];
                self.frame = CGRectMake(0, 0, size.width, size.height);
            }
        }else {//为0或者未设置
            self.frame = CGRectMake(0, 0, 0, 0);
        }
    }
    [NSLayoutConstraint activateConstraints:@[
        [self.remarkLB.rightAnchor constraintEqualToAnchor:self.closeBtn.leftAnchor constant:-4],
        [self.remarkLB.centerYAnchor constraintEqualToAnchor:self.closeBtn.centerYAnchor],
    ]];
    self.clickBtn.frame = self.bounds;
    

}
//高度自适应
- (void)setSubviewsAdaptive:(UIImage *)image withAdSize:(CGSize)size {
    self.frame = CGRectMake(0, 0, size.width, [self getNativeImgHeight:image withAdSize:size]);
}
- (CGFloat)getNativeImgHeight:(UIImage *)image withAdSize:(CGSize)size {
    CGFloat ImgHeight = (image.size.height/image.size.width)*size.width;
    CGFloat ImgWidth = size.width;
    self.nativeImg.frame = CGRectMake(0, 0, ImgWidth, ImgHeight);
    self.contentLB.frame = CGRectMake(0, ImgHeight+8, ImgWidth-8, 18);
    self.logoImg.frame = CGRectMake(0, ImgHeight+8+18+10, 38, 13);
//    self.remarkLB.frame = CGRectMake(ImgWidth-20-48, ImgHeight+8+18+9, 48, 14);
    self.closeBtn.frame = CGRectMake(ImgWidth-16, ImgHeight+8+18+8, 16, 16);
    CGFloat viewHeight = ImgHeight+8+18+8+16;
    return viewHeight;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
        if (newWindow) {
            if ([self.delegate respondsToSelector:@selector(onAdWillMoveToWindow:)]) {
                [self.delegate onAdWillMoveToWindow:self];
            }
            // 有window = 当前即将展示到屏幕

        } else {
            // window为空 = 被移除、隐藏

        }
}



#pragma mark - EasySSplashDetailDelegate
//关闭详情页面
- (void)splashDetailAdDidCloseType:(EasySSplashAdCloseType)closeType {
    
}
@end
