//
//  YTSDKSplashAdListener.m
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/14.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import "YTSDKSplashAdListener.h"
#import "YTSSDKSplashView.h"
#import "EasySAdSDKLoadADManager.h"
#import "YTSDKStartManager.h"
#import "UIDevice+EasyS.h"
#import "EasySSDKtrackMagager.h"
#import "EasySAdSDKLoadADRequestTypeManager.h"
#import "EasySSDKCacheMagager.h"
#import "EasySAdSDKLoadADModel.h"
#import "EasySSDKGeneralTool.h"
#import "EasySImageDownloader.h"
#import "EasySSDKGeneralTool.h"
#import <YTAdSDK/YTSDKAdDelegate.h>


#import <objc/runtime.h>
// 静态变量保存原始 IMP
static IMP original_start_IMP = NULL;

// 比 +load 更早执行，保证保存时方法未被篡改
static __attribute__((constructor)) void es_sdk_splash_original_imp(void) {
    Method method = class_getInstanceMethod([YTSDKSplashAdListener class], @selector(loadAD:));
    original_start_IMP = method_getImplementation(method);
}

@interface YTSDKSplashAdListener () <YTSSDKSplashViewDelegate>

@property (nonatomic, copy) NSString *adImgUrl;
@property (nonatomic, strong) YTSSDKSplashView *splashView;
@property (nonatomic, weak) UIViewController *splashRootViewController;
@property (nonatomic, assign) CGSize adSize;
@property (nonatomic, strong) UIWindow *adWindow;
@property (nonatomic, strong) UINavigationController *naVC;

@property (nonatomic, strong) NSString *slotId; //广告位
@property (nonatomic, strong) EasySAdSDKLoadADModel *adModel;
@property (nonatomic, strong) NSString *placementType;
@property (nonatomic, strong) UIView *containerView; //底部logoview
@end

@implementation YTSDKSplashAdListener
/// 检测启动方法是否被 Hook
- (BOOL)isLoadMethodHooked {
    if (original_start_IMP == NULL) return NO;
    
    Method currentMethod = class_getInstanceMethod(self.class, @selector(loadAD:));
    IMP currentIMP = method_getImplementation(currentMethod);
    
    // 原始实现地址 ≠ 当前实现地址 = 被 Hook
    return currentIMP != original_start_IMP;
}

+ (instancetype)shared {
    static YTSDKSplashAdListener *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.placementType = @"1";
    });
    return instance;
}

- (void)setSlotId:(NSString *)slotId withAdSize:(CGSize)size {
    self.slotId = slotId;
    self.placementType = @"1";
}



- (void)loadAD:(NSString *)placementID withContainerView:(UIView * _Nullable)containerView {
    self.placementType = @"1";
    if (containerView) {
        CGFloat CHeight = containerView.frame.size.height;
        if (CHeight > MySDKScreenHeight()/5) { //大于20%的时候，拖低为 20%
            CHeight = MySDKScreenHeight()/5;
        }
        containerView.frame = CGRectMake(containerView.frame.origin.x, MySDKScreenHeight()-CHeight, containerView.frame.size.width, CHeight);
        self.containerView = containerView;
        self.adSize = CGSizeMake(MySDKScreenWidth(), MySDKScreenHeight()-containerView.frame.size.height);
    }else {
        self.adSize = CGSizeMake(MySDKScreenWidth(), MySDKScreenHeight());
    }
    self.slotId = placementID;
    if (!_splashView) {
        self.splashView = [[YTSSDKSplashView alloc] initWithFrame:CGRectMake(0, 0, self.adSize.width, self.adSize.height)];
        self.splashView.delegate = self;
    }
    /*
     ├─ 2.【SDK】全局状态前置校验（本地拦截，不联网）
     │     ├─ a.SDK检查APP运行环境：识别 ROOT、虚拟机、多开、Hook、代理高危环境
     │     │      ├─ 命中 → 直接拦截，【SDK】onYtNoAdError（具体运行环境的报错信息），上传失败日志
     │     │      └─ 未命中，继续
     │     ├─ b.校验应用前后台状态，后台静默状态下部分版本会直接禁止加载开屏
     │     │      ├─ 后台 → 结束，【SDK】onYtNoAdError（应用非前台，禁止加载广告），上传失败日志
     │     │      └─ 非后台，继续
     │     ├─ c.本地缓存优先级判定，缓存有效期60分钟（后端下发）
     │     │      ├─ 缓存未过期 → 直接使用，结束
     │     │      └─ 缓存过期，继续，清理同广告位下过期废弃缓存，释放本地存储。
     │     ├─ d.校验并发请求锁：判断当前广告位ID是否正在加载
     │     │      ├─ 存在 → 直接拦截，【SDK】onYtNoAdError（当前有存在其他广告正在加载中，请勿重复加载），上传失败日志
     │     │      └─ 不存在，继续
     **/
    // 异步模拟请求
    if (!self.slotId) {
        //id为空
        if ([self.delegate respondsToSelector:@selector(onYtNoAdError:error:)]) {
            [self.delegate onYtNoAdError:self.slotId error:[NSError errorWithDomain:@"load" code:200000 userInfo:@{NSLocalizedDescriptionKey:@"开屏广告位ID为空",NSStringEncodingErrorKey:@"Er200000"}]];
        }
        return;
    }
    if ([[UIDevice es_isJailBreak] isEqualToString:@"1"] || [[UIDevice es_isSimulator] isEqualToString:@"1"] || [[UIDevice isProxyOn] isEqualToString:@"1"] || [self isLoadMethodHooked]) { //手机root Er100020
        if ([self.delegate respondsToSelector:@selector(onYtNoAdError:error:)]) {
            [self.delegate onYtNoAdError:self.slotId error:[NSError errorWithDomain:@"load" code:100020 userInfo:@{NSLocalizedDescriptionKey:@"当前APP运行环境处于root、虚拟机、模拟器、多开身份、代理等高危环境。",NSStringEncodingErrorKey:@"Er100020"}]];
        }
        [EasySSDKtrackMagager errorLog:@"" withSlotId:self.slotId withAdType:@"1" withstep:@"load" withErrorCode:@"Er100020" withRawData:@{@"msg":@"当前APP运行环境处于root、虚拟机、模拟器、多开身份、代理等高危环境。"}];
        return;
    }
    if (![UIDevice es_isAppForeground]) {
        if ([self.delegate respondsToSelector:@selector(onYtNoAdError:error:)]) {
            [self.delegate onYtNoAdError:self.slotId error:[NSError errorWithDomain:@"load" code:100021 userInfo:@{NSLocalizedDescriptionKey:@"当前APP处于后台，禁止加载广告",NSStringEncodingErrorKey:@"Er100021"}]];
        }
        [EasySSDKtrackMagager errorLog:@"" withSlotId:self.slotId withAdType:@"1" withstep:@"load" withErrorCode:@"Er100021" withRawData:@{@"msg":@"当前APP处于后台，禁止加载广告"}];
        return;
    }
    
    //本地缓存优先级判定，缓存有效期60分钟（后端下发） timestamp
    NSDictionary *cacheDic = [[EasySSDKCacheMagager shared] getCacheForKey:self.slotId];
    if (cacheDic) {
        EasySAdSDKLoadADModel *adModel = [[EasySAdSDKLoadADModel alloc] initWithDic:cacheDic];
        [self renderAdData:adModel];
        
        if ([self.delegate respondsToSelector:@selector(onYtAdLoaded:)]) {
            [self.delegate onYtAdLoaded:self.slotId];
        }
        return;
    }
    
    //校验并发请求锁：判断当前广告位ID是否正在加载
    NSString *requestType = EasySAdSDKLoadADRequestTypeManager.shared.requestTypeDic[self.slotId] ?:@"";
    if ([requestType isEqualToString:YTAdSDKRequest_Loading]) {
        if ([self.delegate respondsToSelector:@selector(onYtNoAdError:error:)]) {
            [self.delegate onYtNoAdError:self.slotId error:[NSError errorWithDomain:@"EasySSDK" code:100022 userInfo:@{NSLocalizedDescriptionKey:@"其他开屏广告正在加载中",NSStringEncodingErrorKey:@"Er100022"}]];
        }
        [EasySSDKtrackMagager errorLog:@"" withSlotId:self.slotId withAdType:self.placementType withstep:@"load" withErrorCode:@"Er100022" withRawData:@{@"msg":@"其他开屏广告正在加载中"}];
        return;
    }
    [EasySAdSDKLoadADRequestTypeManager.shared upDataSlotId:self.slotId withType:YTAdSDKRequest_Loading];
    [[[EasySAdSDKLoadADManager alloc] init] loadAdData:self.placementType withSlotId:self.slotId withHandler:^(BOOL success, EasySAdSDKLoadADModel * _Nullable model, NSError * _Nullable error) {

        if (success) {
            [EasySAdSDKLoadADRequestTypeManager.shared upDataSlotId:self.slotId withType:YTAdSDKRequest_Success];

            [self renderAdData:model];
            
            if ([self.delegate respondsToSelector:@selector(onYtAdLoaded:)]) {
                [self.delegate onYtAdLoaded:@""];
            }
        }else {
            [EasySAdSDKLoadADRequestTypeManager.shared upDataSlotId:self.slotId withType:YTAdSDKRequest_Fail];

            if ([EasySSDKGeneralTool isRequestTimeoutError:error]) {
                if ([self.delegate respondsToSelector:@selector(onYtAdLoadTimeout:error:)]) {
                    [self.delegate onYtAdLoadTimeout:self.slotId error:error];
                }
                
            }else {
                if ([self.delegate respondsToSelector:@selector(onYtNoAdError:error:)]) {
                    [self.delegate onYtNoAdError:self.slotId error:error];
                }
            }
                    
            [EasySSDKtrackMagager errorLog:@"" withSlotId:self.slotId withAdType:self.placementType withstep:@"load" withErrorCode:@"Er100024" withRawData:@{@"msg":@"广告素材下载失败"}]; //错误埋点

        }
    }];
    
    
}

//下载图片进行渲染
- (void)renderAdData:(EasySAdSDKLoadADModel *)resultModel {

    self.adModel = resultModel;
    [EasySSDKtrackMagager reportRender:resultModel withPlacementId:self.slotId withPlacementType:[self.placementType integerValue]];
    [[EasySImageDownloader sharedDownloader] downloadImageWithURL:resultModel.imageUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (!image || error) {
            //渲染失败
            [EasySSDKtrackMagager reportRenderResult:resultModel withPlacementId:self.slotId withPlacementType:[self.placementType integerValue] withResult:1];
            if ([self.delegate respondsToSelector:@selector(splashAdRenderFail:error:)]) { //渲染失败
                [self.delegate splashAdRenderFail:self.adModel.requestId error:[NSError errorWithDomain:@"render" code:100024 userInfo:@{NSLocalizedDescriptionKey:@"广告素材下载失败",NSStringEncodingErrorKey:@"Er100024"}]];
            }
            
        }
        if (image) {
            //渲染成功
            [EasySSDKtrackMagager reportRenderResult:resultModel withPlacementId:self.slotId withPlacementType:[self.placementType integerValue] withResult:0];

            [self.splashView setUpSubviews:resultModel logoImg:NULL];
            if ([self.delegate respondsToSelector:@selector(splashAdRenderSuccess:)]) {
                [self.delegate splashAdRenderSuccess:@""];
            }
        }
    }];

    
   
    

}
//渲染成功的时候才会有这个判断
- (BOOL)isAdReady:(NSString *)placementID {
    //本地缓存优先级判定，缓存有效期60分钟（后端下发） timestamp
    
    if ([[EasySSDKCacheMagager shared] getCacheForKey:placementID]) {
        return YES;
    }
    NSString *requestType = EasySAdSDKLoadADRequestTypeManager.shared.requestTypeDic[placementID] ?:@""; //请求是否加载成功
    if ([requestType isEqualToString:YTAdSDKRequest_Success]) {
        
        return YES;
    }
    return NO;
}

- (void)showSplashViewInWindow:(UIWindow *)window delegate:(id<YTSDKSplashAdDelegate>)delegate {
    if (!delegate || !window) {
        return;
    }
    self.delegate = delegate;
    self.splashView.frame = CGRectMake(0, 0, self.adSize.width, self.adSize.height);
    self.splashView.layer.zPosition = 9999;
    [window addSubview:self.splashView];
    if (self.containerView) {
        [window addSubview:self.containerView];
    }
    //展示成功
    if ([self.delegate respondsToSelector:@selector(onYtAdShow:)]) {
        [self.delegate onYtAdShow:self.slotId];
    }
    [self reportShow];

}
- (void)showSplashViewInRootViewController:(UIViewController *)viewController {
    if (!viewController || !viewController.view.window) {
        return;
    }
    self.splashView.frame = CGRectMake(0, 0, self.adSize.width, self.adSize.height);
    self.splashView.rootVC = viewController;
    self.splashView.layer.zPosition = 9999;
    [viewController.view addSubview:self.splashView];
    if (self.containerView) {
        [viewController.view addSubview:self.containerView];
    }
    //展示成功
    if ([self.delegate respondsToSelector:@selector(onYtAdShow:)]) {
        [self.delegate onYtAdShow:self.slotId];
    }
    [self reportShow];
    
//    self.adWindow = viewController.view.window;
    /*
    self.splashRootViewController = viewController;
    UIViewController *splashVC = [[UIViewController alloc] init];
    self.splashView.frame = CGRectMake(0, 0, self.adSize.width, self.adSize.height);
    [splashVC.view addSubview:self.splashView];
    self.naVC = [[UINavigationController alloc] initWithRootViewController:splashVC];
    self.naVC.navigationBarHidden = YES;
    self.naVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [viewController addChildViewController:self.naVC];
    [viewController.view addSubview:self.naVC.view];
     */
    
//    self.adWindow.rootViewController = naVC;
//    [self.adWindow.rootViewController presentViewController:naVC animated:YES completion:nil];
//    [viewController.view.window.rootViewController addSubview:self.splashView];
}

#pragma mark - YTSSDKSplashViewDelegate
//点击
- (void)splashAdDidClick:(EasySAdSDKLoadADModel *)splashModel withNextStep:(NSInteger)nextStep {
    if ([self.delegate respondsToSelector:@selector(onYtAdClick:)]) {
        [self.delegate onYtAdClick:@""];
    }
    //点击广告埋点
    [self reportADClick:@"0" withNextStep:nextStep];
}


- (void)splashAdDidFinish:(EasySAdSDKLoadADModel *)splashModel closeType:(EasySSplashAdCloseType)closeType {
    // 安全销毁
    [self.containerView removeFromSuperview];
    [self.splashView removeFromSuperview];
    self.splashView = nil;
    self.containerView = nil;
//    [viewController.view.window.rootViewController ]
//    self.adWindow.rootViewController = self.splashRootViewController;
    [self.naVC.view removeFromSuperview];
    [self.naVC removeFromParentViewController];
    
    if ([self.delegate respondsToSelector:@selector(onYtAdDismiss:closeType:)]) {
        [self.delegate onYtAdDismiss:@"" closeType:closeType];

    }
//    EasySSplashAdCloseType_ClickSkip = 1,          // click skip 点击跳过
//    EasySSplashAdCloseType_CountdownToZero = 2,    // countdown 倒计时结束
//    EasySSplashAdCloseType_ClickAd = 3,            // click Ad 点击广告
    switch (closeType) { //跳过，倒计时结束埋点
        case 1:
            [self reportADClick:@"1" withNextStep:5];

            break;
        case 2:
            [self reportADClick:@"3" withNextStep:5];

            break;
            
        default:
            break;
    }

}

    
#pragma mark - APP调用show方法并成功展示时
- (void)reportShow {
    [EasySSDKtrackMagager reportLog:@"show_q" withRequestId:self.adModel.requestId ?:@"" withPlacementId:self.slotId withPlacementType:self.placementType withAdId:self.adModel.adPlanId withResult:nil withAdModelType:nil withBtnName:nil withNextStep:nil];

    [[EasySSDKCacheMagager shared] removeCacheForKey:self.slotId]; //展示完毕，删除model缓存
    [[EasySImageDownloader sharedDownloader] removeImageCacheForKey:self.adModel.imageUrl]; //展示完毕，删除图片缓存
    
    [EasySSDKtrackMagager reportLog:@"show" withRequestId:self.adModel.requestId ?:@"" withPlacementId:self.slotId withPlacementType:self.placementType withAdId:self.adModel.adPlanId withResult:nil withAdModelType:nil withBtnName:nil withNextStep:nil];
}
#pragma mark - 广告被点击时，如：查看广告、跳过、倒计时结束、关闭广告

/// <#Description#>
/// - Parameters:
///   - btnName: 按钮名称：0-查看广告；1-跳过；2-关闭；3-倒计时结束；4-打开APP；5-取消打开APP
///   - nextStep: 下一步：0-打开APP提醒弹窗；1-进入H5着陆页；2-唤起小程序；3-移除广告；4-跳转应用市场；5-关闭广告
- (void)reportADClick:(NSString *)btnName withNextStep:(NSInteger)nextStep{
    [EasySSDKtrackMagager reportLog:@"ad_click" withRequestId:self.adModel.requestId ?:@"" withPlacementId:self.slotId withPlacementType:self.placementType withAdId:self.adModel.adPlanId withResult:nil withAdModelType:nil withBtnName:btnName withNextStep:[NSString stringWithFormat:@"%d",nextStep]];

}


@end
