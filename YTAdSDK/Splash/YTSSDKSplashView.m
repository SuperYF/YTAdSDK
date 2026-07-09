//
//  YTSSDKSplashView.m
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/15.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import "YTSSDKSplashView.h"
#import "EasySSplashDetailViewController.h"
#import "UIView+EasyS.h"
#import "UIDevice+EasyS.h"
#import "EasySAdSDKSplashCircleProgressButton.h"
#import "EasySAdSDKLoadADModel.h"
#import "EasySImageDownloader.h"
#import "EasySSDKGeneralTool.h"
#import "YTSDKConst.h"


@interface YTSSDKSplashView ()<EasySSplashDetailDelegate>
// 广告图
@property (nonatomic, strong) UIImageView *adImgView;

// 跳过按钮
@property (nonatomic, strong) EasySAdSDKSplashCircleProgressButton *skipBtn;

// 倒计时
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval totalTime;

//@property (nonatomic, strong) CADisplayLink *countLink;
//@property (nonatomic, assign) NSTimeInterval lastTickTime;

@property (nonatomic, strong) NSTimer *countTimer;

// 环形倒计时图层
@property (nonatomic, strong) CAShapeLayer *bgCircleLayer;
@property (nonatomic, strong) CAShapeLayer *progressCircleLayer;

// 跳转链接 数据model
@property (nonatomic, strong) EasySAdSDKLoadADModel *adModel;

@property (nonatomic, strong) UILabel *buttonText;
@property (nonatomic, strong) UILabel *planDescription;

@property (nonatomic, strong) UIView *bottomBgV;

@property (nonatomic, strong) UIImageView *gestureImg;
@property (nonatomic, strong) UIImageView *logoImg;

@property (nonatomic, assign) BOOL isRepeatClick; //防止连点
@property (nonatomic, assign) BOOL isRepeatSkip; //防止跳过连点

@property (nonatomic, strong) UIImageView *jumpBg;

@property (nonatomic, assign) CGFloat bottomLogoLayout; //底部sdk logo的距离
@property (nonatomic, assign) CGFloat jumpVHeight; //tiaozh

//@property (nonatomic, assign) CGFloat bottomSkiptLayout; //底部跳过按钮的距离

@end

@implementation YTSSDKSplashView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configDefault];
//        [self setupSubViews:frame];
    }
    return self;
}

- (void)configDefault {
    self.isRepeatClick = NO;
    self.isRepeatSkip = NO;
    self.totalTime = 5;
    self.currentTime = self.totalTime;
    self.backgroundColor = [UIColor whiteColor];
    self.bottomLogoLayout =  15;
    self.jumpVHeight = 80;
    self.clipsToBounds = YES;
    
}
//点击图片
- (void)dianJiImageSetupSubviews:(CGRect)frame {
        for (UIView *subv in self.subviews) {
            [subv removeFromSuperview];
        }
        
        // 1. 广告图片View
        [self addSubview:self.adImgView];
        [[EasySImageDownloader sharedDownloader] setImageWithUIImageView:self.adImgView withURL:self.adModel.imageUrl];
        self.adImgView.userInteractionEnabled = YES;
    // 创建手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImgClick)];
    // 点击次数：1次点击触发
    tap.numberOfTapsRequired = 1;
//    // 几根手指点击
//    tap.numberOfTouchesRequired = 1;
    [self.adImgView addGestureRecognizer:tap];
    
    
        [self addSubview:self.logoImg];
        if (self.adModel.logoType == 1) {
            self.logoImg.image = [EasySSDKGeneralTool imageNamed:@"yt_splash_csj_logo" withClass:self.class];
        }
        self.skipBtn.progress = 0;
        [self addSubview:self.skipBtn];
    
}
//底部点击方法view设置
- (void)dianJiSetupSubViews:(CGRect)frame {
    for (UIView *subv in self.subviews) {
        [subv removeFromSuperview];
    }
    
    // 1. 广告图片View
    [self addSubview:self.adImgView];
    [[EasySImageDownloader sharedDownloader] setImageWithUIImageView:self.adImgView withURL:self.adModel.imageUrl];
    self.adImgView.userInteractionEnabled = YES;
    
    
    
    
    //点击跳转详情
    UIView *jumpV = [[UIView alloc] init];
    jumpV.clipsToBounds = YES;
    jumpV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    jumpV.layer.masksToBounds = YES;
    jumpV.layer.cornerRadius = 40;
    jumpV.layer.borderWidth = 2;
    jumpV.layer.borderColor = [[UIColor whiteColor] CGColor];
    jumpV.frame = CGRectMake(30, self.frame.size.height - 142 - self.jumpVHeight, self.frame.size.width - 60, self.jumpVHeight);
    [self addSubview:jumpV];
    UILabel *jumpLB = [[UILabel alloc] init];
    jumpLB.text = @"点击跳转详情页或第三方应用";
    jumpLB.textColor = [UIColor whiteColor];
    jumpLB.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
//    jumpLB.frame = CGRectMake(0, 28, 240, 24);
//    jumpLB.textAlignment = NSTextAlignmentCenter; // 文字居中
    jumpLB.numberOfLines = 1;
    jumpLB.lineBreakMode = UILineBreakModeTailTruncation;
    [jumpLB sizeToFit] ;
    [jumpV addSubview:jumpLB];
    jumpLB.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [jumpLB.topAnchor constraintEqualToAnchor:jumpV.topAnchor constant:28],
        [jumpLB.centerXAnchor constraintEqualToAnchor:jumpV.centerXAnchor]
    ]];
    
    
//    jumpLB.center = CGPointMake(jumpV.frame.size.width/2, 40);
    
    UIImageView *jumpNext = [[UIImageView alloc] initWithImage:[EasySSDKGeneralTool imageNamed:@"yt_splash_sdk_next" withClass:self.class]];
    jumpNext.translatesAutoresizingMaskIntoConstraints = NO;
//    jumpNext.frame = CGRectMake(CGRectGetMaxX(jumpLB.frame), 28, 24, 24);
    [jumpV addSubview:jumpNext];
    [NSLayoutConstraint activateConstraints:@[
        [jumpNext.leftAnchor constraintEqualToAnchor:jumpLB.rightAnchor],
        [jumpNext.centerYAnchor constraintEqualToAnchor:jumpV.centerYAnchor],
        [jumpNext.widthAnchor constraintEqualToConstant:24],
        [jumpNext.heightAnchor constraintEqualToConstant:24]
    ]];
    
    [jumpV addSubview:self.jumpBg];
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpBtn.backgroundColor = [UIColor clearColor];
    [jumpBtn addTarget:self action:@selector(adImgClick) forControlEvents:UIControlEventTouchUpInside];
    jumpBtn.frame = jumpV.bounds;
    [jumpV addSubview:jumpBtn];
    
    
    
    // 4. 广告源 Logo
//    UIView *logoBgV = [[UIView alloc] init];
//    logoBgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
//    logoBgV.frame = CGRectMake(16, frame.size.height-self.bottomLogoLayout-13, 38, 13);
//    logoBgV.layer.masksToBounds = YES;
//    logoBgV.layer.cornerRadius = 2;
//    [self addSubview:logoBgV];
//    UIImageView *myLogo = [[UIImageView alloc] init];
//    myLogo.image = [EasySSDKGeneralTool imageNamed:@"bu_sdk_logo" withClass:self.class];
//    //默认0易推 1穿山甲
//       if (self.adModel.logoType == 1) {
//           myLogo.image = [EasySSDKGeneralTool imageNamed:@"yt_sdk_csj_logo" withClass:self.class];
//       }
//    myLogo.frame = CGRectMake(3, 1.5, 12, 10);
//    [logoBgV addSubview:myLogo];
//    UILabel *myLB = [[UILabel alloc] init];
//    myLB.text = @"广告";
//    myLB.textColor = [UIColor whiteColor];
//    myLB.font = [UIFont systemFontOfSize:8];
//    myLB.frame = CGRectMake(18, 1.5, 16, 10);
//    [logoBgV addSubview:myLB];
    
    [self addSubview:self.logoImg];
    if (self.adModel.logoType == 1) {
        self.logoImg.image = [EasySSDKGeneralTool imageNamed:@"yt_splash_csj_logo" withClass:self.class];
    }
    self.skipBtn.progress = 0;
    [self addSubview:self.skipBtn];
}
//上扫
- (void)setupSubViews:(CGRect)frame {
    for (UIView *subv in self.subviews) {
        [subv removeFromSuperview];
    }
    
    // 1. 广告图片View
    [self addSubview:self.adImgView];
    [[EasySImageDownloader sharedDownloader] setImageWithUIImageView:self.adImgView withURL:self.adModel.imageUrl];
    self.adImgView.userInteractionEnabled = YES;

    
   //底部小的背景图
    [self addSubview:self.bottomBgV];
    
    //底部
    CGFloat textLeft = 16+39+16;
    CGFloat textHeight = 17;
    CGFloat textY = self.frame.size.height - 72 - 17;
    CGFloat textWidth = self.frame.size.width - 2*textLeft;
    self.planDescription.frame = CGRectMake(textLeft, textY, textWidth, 17);
    [self addSubview:self.planDescription];
    
    self.buttonText.frame = CGRectMake(textLeft, textY-17-11, textWidth, 24);
    [self addSubview:self.buttonText];
    
    // 4. 广告源 Logo
//    UIView *logoBgV = [[UIView alloc] init];
//    logoBgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
//    logoBgV.frame = CGRectMake(16, frame.size.height-self.bottomLogoLayout-13, 38, 13);
//    logoBgV.layer.masksToBounds = YES;
//    logoBgV.layer.cornerRadius = 2;
//    [self addSubview:logoBgV];
//    UIImageView *myLogo = [[UIImageView alloc] init];
//    myLogo.image = [EasySSDKGeneralTool imageNamed:@"bu_sdk_logo" withClass:self.class];
//    //默认0易推 1穿山甲
//       if (self.adModel.logoType == 1) {
//           myLogo.image = [EasySSDKGeneralTool imageNamed:@"yt_sdk_csj_logo" withClass:self.class];
//       }
//    myLogo.frame = CGRectMake(3, 1.5, 12, 10);
//    [logoBgV addSubview:myLogo];
//    UILabel *myLB = [[UILabel alloc] init];
//    myLB.text = @"广告";
//    myLB.textColor = [UIColor whiteColor];
//    myLB.font = [UIFont systemFontOfSize:8];
//    myLB.frame = CGRectMake(18, 1.5, 16, 10);
//    [logoBgV addSubview:myLB];
//    
    [self addSubview:self.logoImg];
    if (self.adModel.logoType == 1) {
        self.logoImg.image = [EasySSDKGeneralTool imageNamed:@"yt_splash_csj_logo" withClass:self.class];
    }
    
    
    
    CGFloat bottomDJY = CGRectGetMaxY(self.buttonText.frame)-200;
    CGFloat bottomDJH = 250;
    CGFloat bottomDJX = CGRectGetMaxX(self.buttonText.frame);
    UIButton *bottomDJBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomDJBtn.frame = CGRectMake(bottomDJX, bottomDJY, self.frame.size.width-2*bottomDJX, bottomDJH);
    bottomDJBtn.backgroundColor = [UIColor clearColor];
//    bottomDJBtn.backgroundColor = [UIColor redColor];
    [bottomDJBtn addTarget:self action:@selector(adImgClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomDJBtn];
    // 2. 上滑手势（手指向上滑）
       UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(adImgClick)];
       upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
       [bottomDJBtn addGestureRecognizer:upSwipe];
    
    
    
    //手势滑动
    CGFloat sylinderLeft = self.frame.size.width/2-5;
    UIImageView *cylinderImg = [[UIImageView alloc] initWithImage:[EasySSDKGeneralTool imageNamed:@"yt_splash_sdk_cylinder" withClass:self.class]];
    cylinderImg.frame = CGRectMake(sylinderLeft, textY-17-11-146-33, 10, 146);
    [self addSubview:cylinderImg];
    
    [self addSubview:self.gestureImg];
    
    //跳过
     self.skipBtn.progress = 0;
     [self addSubview:self.skipBtn];
     
    
}
/**
 图片从左往右循环滑动动画
 @param imgView 目标UIImageView
 @param endX 向右滑动停止的X坐标
 @param totalDuration 一轮完整动画总时长
 @param stayTime 滑到右侧后停留多久再回弹（0=不等待直接回去）
 */
- (void)startImageLeftToRightLoopAnim:(UIImageView *)imgView endX:(CGFloat)endX totalDuration:(CFTimeInterval)totalDuration stayTime:(CFTimeInterval)stayTime {
    // 初始原点：图片完全在左侧外部
    CGFloat startX = -imgView.bounds.size.width;
    CGFloat originX = startX;

    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    anim.duration = totalDuration;
    anim.repeatCount = HUGE_VALF; // 无限循环

    // 关键帧坐标：起点 → 右侧终点 → 停留 → 返回起点
//    if (stayTime > 0) {
        CGFloat moveRatio = (totalDuration - stayTime) / totalDuration;
        anim.values = @[@(startX), @(endX), @(endX), @(originX)];
        anim.keyTimes = @[@0.0, @(moveRatio), @(moveRatio + stayTime / totalDuration), @1.0];
        anim.timingFunctions = @[
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
        ];
//    } else {
//        // 无停留，滑到终点立刻回弹
//        anim.values = @[@(startX), @(endX), @(originX)];
//        anim.keyTimes = @[@0.0, @0.5, @1.0];
//        anim.timingFunctions = @[
//            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
//            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
//        ];
//    }

    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    anim.autoreverses = NO;

    [imgView.layer addAnimation:anim forKey:@"left_right_loop_anim"];
}


/**
 图片循环上滑回弹动画
 @param imgView 目标UIImageView
 @param targetY 向上滑动到达的指定Y坐标
 @param totalDuration 一次完整循环总时长
 @param stayTime 滑到目标位置后停留时长（秒）
 */
- (void)startImageUpDownLoopAnimation:(UIImageView *)imgView targetY:(CGFloat)targetY totalDuration:(CFTimeInterval)totalDuration stayTime:(CFTimeInterval)stayTime {
    // 初始起点：图片底部屏幕外
    CGFloat startY = CGRectGetMaxY(imgView.frame);
    // 终点：回到初始位置
    CGFloat originY = startY;
    
    // 分段时间占比计算
    CFTimeInterval moveUpTime = totalDuration - stayTime;
    CGFloat upRatio = moveUpTime / totalDuration;
    CGFloat stayStartRatio = upRatio;
    CGFloat stayEndRatio = upRatio + stayTime / totalDuration;
    
    CAKeyframeAnimation *posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    posAnim.duration = totalDuration;
    posAnim.repeatCount = HUGE_VALF; // 无限重复
    
    // 关键帧坐标：起点 → 目标位置(停留) → 回到起点
    posAnim.values = @[
        @(startY),
        @(targetY),
        @(targetY),
        @(originY)
    ];
    // 各节点时间比例 0~1
    posAnim.keyTimes = @[
        @0.0,
        @(stayStartRatio),
        @(stayEndRatio),
        @1.0
    ];
    
    // 动画缓动：上滑先快后慢，下滑先慢后快，停留无缓动
    posAnim.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
    ];
    
    posAnim.fillMode = kCAFillModeForwards;
    posAnim.removedOnCompletion = NO;
    
    // 添加动画到图片图层
    [imgView.layer addAnimation:posAnim forKey:@"img_up_loop_anim"];
}


#pragma mark - 展示广告
- (void)setUpSubviews:(EasySAdSDKLoadADModel *)model logoImg:(UIImage *)logoImg{
    self.adModel = model;
    if (model.interactionType == 2) { //上滑
        [self setupSubViews:self.frame];
//        self.buttonText.text = model.buttonText ?:@"点击 或 上滑";
        self.planDescription.text = model.buttonText ?:@"跳转至详情页或第三方应用";
    }else if (model.interactionType == 1) { //点击-下方
        [self dianJiSetupSubViews:self.frame];
    } else {
        [self dianJiImageSetupSubviews:self.frame];
    }
    
    
    self.currentTime = self.totalTime;
    self.skipBtn.progress = 0;

    [self startCountDownTimer];
}


#pragma mark - 倒计时
- (void)startCountDownTimer {
    [self stopTimer];
    if (self.adModel.interactionType == 2) { //上滑
        // 2. 启动往复循环动画
        [self startImageUpDownLoopAnimation:self.gestureImg targetY:CGRectGetMaxY(self.buttonText.frame)-4-67-25-80 totalDuration:2.5 stayTime:0.4];
    }else { //点击
        [self startImageLeftToRightLoopAnim:self.jumpBg endX:self.frame.size.width - 60 totalDuration:2.5 stayTime:0];
    }
    __weak typeof(self) weakSelf = self;
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            [timer invalidate];
            return;
        }
        
        strongSelf.currentTime = strongSelf.currentTime-0.1;
        CGFloat progress = (CGFloat)strongSelf.currentTime / strongSelf.totalTime;
        strongSelf.skipBtn.progress = progress;
        
        if (strongSelf.currentTime <= 0) {
            [strongSelf dismissSplash:EasySSplashAdCloseType_CountdownToZero];
        }
        
    }];
//    [self startCountDown];
}
/*
// 启动倒计时
- (void)startCountDown {
    // 先销毁旧定时器
    [self stopCountDown];
    
    self.lastTickTime = CACurrentMediaTime();
    self.countLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(countTick)];
    // 滑动ScrollView不暂停
    [self.countLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// 屏幕每一帧都会执行，60帧/秒，进度丝滑无断层
- (void)countTick {
    NSTimeInterval now = CACurrentMediaTime();
    NSTimeInterval delta = now - self.lastTickTime;
    self.lastTickTime = now;
    
    // 总倒计时秒数，每秒递减
    static NSTimeInterval reduceAcc = 0;
    reduceAcc += delta;
    if (reduceAcc >= 1.0) {
        reduceAcc -= 1.0;
        self.currentTime --;
    }
    
    // 修复进度逻辑：倒计时从 totalTime → 0，进度 1.0 → 0
    CGFloat progress = (CGFloat)self.currentTime / self.totalTime;
    self.skipBtn.progress = progress;
    
    if (self.currentTime <= 0) {
        [self stopCountDown];
        [self dismissSplash:EasySSplashAdCloseType_CountdownToZero];
    }
}
// 销毁定时器（必须在dismiss/dealloc调用）
- (void)stopCountDown {
    if (self.countLink) {
        [self.countLink invalidate];
        self.countLink = nil;
    }
}
*/

- (void)stopTimer {
    if (self.countTimer) {
        [self.countTimer invalidate];
        self.countTimer = nil;
    }
    [self.gestureImg.layer removeAnimationForKey:@"img_up_loop_anim"];
    [self.jumpBg.layer removeAnimationForKey:@"left_right_loop_anim"];

}

#pragma mark - 事件
- (void)skipBtnClick {
    
    if (self.isRepeatSkip) {
        return;
    }
    self.isRepeatSkip = YES;
    // 延迟恢复点击
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isRepeatSkip = NO;
        });
    [self dismissSplash:EasySSplashAdCloseType_ClickSkip];
}
//点击广告，事件
- (void)adImgClick {
    if (self.isRepeatClick) {
        return;
    }
    self.isRepeatClick = YES;
    // 延迟恢复点击
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isRepeatClick = NO;
        });
    NSInteger nextStep = -1;
    if (self.adModel.deliveryType == 0) { //落地页
    //    if (self.window == nil) return;
        if (self.adModel.landingUrl.length == 0) return;

//        UIViewController *topVC = [self es_currentViewController];
//        if (!topVC) return;
        
        EasySSplashDetailViewController *detailVC = [[EasySSplashDetailViewController alloc] init];
        detailVC.splashUrl = self.adModel.landingUrl;
        detailVC.isSplash = YES;

        detailVC.splashTitle = self.adModel.planDescription;
        detailVC.delegate = self;
        detailVC.currentTime = self.currentTime;
        [self stopTimer];
        detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.rootVC presentViewController:detailVC animated:YES completion:nil];
    //    self.naVC = [[UINavigationController alloc] initWithRootViewController:splashVC];
    //    self.naVC.navigationBarHidden = YES;
    //    self.naVC.modalPresentationStyle = UIModalPresentationFullScreen;
    //    [viewController addChildViewController:self.naVC];
    //    [viewController.view addSubview:self.naVC.view];
    //    [topVC.navigationController pushViewController:detailVC animated:YES];
        
        nextStep = 1;
    }else if (self.adModel.deliveryType == 1){//小程序
        NSURL *appUrl = [NSURL URLWithString:self.adModel.landingUrl];
        BOOL isLanding = [[UIApplication sharedApplication] canOpenURL:appUrl];
        if (isLanding ) {
            [[UIApplication sharedApplication] openURL:appUrl options:nil completionHandler:nil];
            nextStep = 2;
        }else {
            return;
        }
    }else if (self.adModel.deliveryType == 2) { //直接打开或者下载
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
    if ([self.delegate respondsToSelector:@selector(splashAdDidClick:withNextStep:)]) {
        [self.delegate splashAdDidClick:self.adModel withNextStep:nextStep];
    }
}
#pragma mark - EasySSplashDetailDelegate
- (void)splashDetailAdDidCloseType:(EasySSplashAdCloseType)closeType {
    [self dismissSplash:closeType]; //点击X或者返回
}
//返回回来继续倒计时
- (void)splashDetailBackTime:(NSInteger)cuttentTime {
    self.currentTime = cuttentTime;
    [self startCountDownTimer];
}

#pragma mark - 关闭开屏
- (void)dismissSplash:(EasySSplashAdCloseType)closeType {
    [self stopTimer];
    
    //    UIViewController *topVC = [self es_currentViewController];
    //    if (!topVC) return;
    //    [topVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(splashAdDidFinish:closeType:)]) {
        [self.delegate splashAdDidFinish:self.adModel closeType:closeType];
    }
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.alpha = 0;
    //    } completion:^(BOOL finished) {
    //
    //    }];
}

#pragma mark - 懒加载
//背景大图
- (UIImageView *)adImgView {
    if (!_adImgView) {
        _adImgView = [[UIImageView alloc] init];
        _adImgView.frame = self.bounds;
        _adImgView.contentMode = UIViewContentModeScaleAspectFill;
        _adImgView.clipsToBounds = YES;
        _adImgView.userInteractionEnabled = YES;

    }
    return _adImgView;
}

- (EasySAdSDKSplashCircleProgressButton *)skipBtn {
    if (!_skipBtn) {
        CGFloat btnWH = 39;
        CGFloat btnX = 16;
        CGFloat btnY = self.frame.size.height - 44 - 39;
        _skipBtn = [EasySAdSDKSplashCircleProgressButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
        _skipBtn.backgroundColor = [UIColor whiteColor];
        _skipBtn.layer.masksToBounds = YES;
        _skipBtn.layer.cornerRadius = btnWH/2;
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _skipBtn.progress = 0;
        _skipBtn.progressBgColor = MySDKColor();
        _skipBtn.userInteractionEnabled = YES;
    }
    return _skipBtn;
}

- (UILabel *)buttonText {
    if (!_buttonText) {
        _buttonText = [[UILabel alloc] init];
        _buttonText.text = @"点击 或 上滑";
        _buttonText.textColor = [UIColor whiteColor];
        _buttonText.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        _buttonText.textAlignment = NSTextAlignmentCenter; // 文字居中
    }
    return _buttonText;
}
- (UILabel *)planDescription {
    if (!_planDescription) {
        _planDescription = [[UILabel alloc] init];
        _planDescription.text = @"跳转至详情页或第三方应用";
        _planDescription.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        _planDescription.font = [UIFont systemFontOfSize:14];
        _planDescription.textAlignment = NSTextAlignmentCenter; // 文字居中
    }
    return _planDescription;
}
- (UIView *)bottomBgV {
    if (!_bottomBgV) {
        _bottomBgV = [[UIView alloc] init];
        _bottomBgV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
        CGFloat bgW = self.frame.size.width+84;
        _bottomBgV.layer.masksToBounds = YES;
        _bottomBgV.layer.cornerRadius = bgW/2;
        _bottomBgV.layer.borderWidth = 1;
//        _bottomBgV.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
        _bottomBgV.layer.borderColor = [UIColor whiteColor].CGColor;
        _bottomBgV.frame = CGRectMake(-42, 200+bgW, bgW, bgW);
        _bottomBgV.center = CGPointMake(self.frame.size.width/2, self.frame.size.height+30);
    }
    return _bottomBgV;
}

//104*67 17
-(UIImageView *)gestureImg {
    if (!_gestureImg) {
        _gestureImg = [[UIImageView alloc] initWithImage:[EasySSDKGeneralTool imageNamed:@"yt_splash_sdk_circle" withClass:self.class]];
        _gestureImg.frame = CGRectMake(self.frame.size.width/2-17, CGRectGetMaxY(self.buttonText.frame)-4-67-25, 104, 67);
    }
    return _gestureImg;
}
//左右滑动的image
- (UIImageView *)jumpBg {
    if (!_jumpBg) {
        _jumpBg = [[UIImageView alloc] initWithImage:[EasySSDKGeneralTool imageNamed:@"yt_splash_sdk_bg" withClass:self.class]];
        _jumpBg.frame = CGRectMake(36, 2, 64, 80);
    }
    return _jumpBg;
}
- (UIImageView *)logoImg {
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc] initWithImage:[EasySSDKGeneralTool imageNamed:@"yt_splash_sdk_logo" withClass:self.class]];
        _logoImg.frame = CGRectMake(16, self.frame.size.height-self.bottomLogoLayout-13, 38, 13);
    }
    return _logoImg;
}
#pragma mark - 销毁时清理
- (void)dealloc {
    [self stopTimer];
//    [self stopCountDown];

    MySDKLog(@"✅ YTSSDKSplashView 已安全释放");
}

@end
