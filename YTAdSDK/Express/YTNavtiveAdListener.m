//
//  YTNavtiveAdListener.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/17.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTNavtiveAdListener.h"
#import "UIDevice+EasyS.h"
#import "EasySSDKtrackMagager.h"
#import "EasySAdSDKLoadADModel.h"
#import "EasySSDKCacheMagager.h"
#import "EasySImageDownloader.h"
#import "EasySAdSDKLoadADRequestTypeManager.h"
#import "EasySAdSDKLoadADManager.h"
#import "EasySSDKGeneralTool.h"
#import "YTSDKConst.h"
//#import "YTSDKNativeExpressView.h"
#import <YTAdSDK/YTSDKNativeExpressView.h>
#import <YTAdSDK/YTSDKAdDelegate.h>

#import "YTSDKNavtiveAdModel.h"



#import <objc/runtime.h>
// 静态变量保存原始 IMP
static IMP original_start_IMP = NULL;
// 比 +load 更早执行，保证保存时方法未被篡改
static __attribute__((constructor)) void es_sdk_navtive_original_imp(void) {
    Method method = class_getInstanceMethod([YTNavtiveAdListener class], @selector(load));
    original_start_IMP = method_getImplementation(method);
}

@interface YTNavtiveAdListener ()<EasySNativeExpressDelegate>

//@property (nonatomic, copy) NSString *adImgUrl;
//@property (nonatomic, strong) YTSSDKSplashView *splashView;
//@property (nonatomic, weak) UIViewController *splashRootViewController;
//@property (nonatomic, assign) CGSize adSize;
//@property (nonatomic, strong) UIWindow *adWindow;
//@property (nonatomic, strong) UINavigationController *naVC;
//
//@property (nonatomic, strong) NSString *slotId; //广告位
@property (nonatomic, strong) EasySAdSDKLoadADModel *adModel;
@property (nonatomic, strong) NSString *adType;
@property (nonatomic, strong) YTSDKNativeExpressView *adView;


@end

@implementation YTNavtiveAdListener
//+ (instancetype)shared {
//    static YTNavtiveAdListener *instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//    });
//    return instance;
//}
/// 检测启动方法是否被 Hook
- (BOOL)isLoadMethodHooked {
    if (original_start_IMP == NULL) return NO;
    Method currentMethod = class_getInstanceMethod(self.class, @selector(load));
    IMP currentIMP = method_getImplementation(currentMethod);
    // 原始实现地址 ≠ 当前实现地址 = 被 Hook
    return currentIMP != original_start_IMP;
}
- (instancetype)initWithSlot:(NSString * _Nullable)slot adSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.slotId = slot;
        self.adSize = size;
    }
    return self;
}

- (void)load {
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
        if ([self.delegate respondsToSelector:@selector(onYtErrorLoad:withError:)]) {
            [self.delegate onYtErrorLoad:self withError:[NSError errorWithDomain:@"load" code:100000 userInfo:@{NSLocalizedDescriptionKey:@"信息流广告位ID为空",NSStringEncodingErrorKey:@"Er100000"}]];
        }
        return;
    }
    if ([[UIDevice es_isJailBreak] isEqualToString:@"1"] || [[UIDevice es_isSimulator] isEqualToString:@"1"] || [[UIDevice isProxyOn] isEqualToString:@"1"] || [self isLoadMethodHooked]) { //手机root Er100020
        if ([self.delegate respondsToSelector:@selector(onYtErrorLoad:withError:)]) {
            [self.delegate onYtErrorLoad:self withError:[NSError errorWithDomain:@"load" code:100030 userInfo:@{NSLocalizedDescriptionKey:@"当前APP运行环境处于root、虚拟机、模拟器、多开身份、代理等高危环境。",NSStringEncodingErrorKey:@"Er100030"}]];
        }
        [EasySSDKtrackMagager errorLog:@"" withSlotId:self.slotId withAdType:self.adType withstep:@"load" withErrorCode:@"Er100030" withRawData:@{@"msg":@"当前APP运行环境处于root、虚拟机、模拟器、多开身份、代理等高危环境。"}];
        return;
    }
    if (![UIDevice es_isAppForeground]) {
        if ([self.delegate respondsToSelector:@selector(onYtErrorLoad:withError:)]) {
            [self.delegate onYtErrorLoad:self withError:[NSError errorWithDomain:@"load" code:100031 userInfo:@{NSLocalizedDescriptionKey:@"当前APP处于后台，禁止加载广告",NSStringEncodingErrorKey:@"Er100031"}]];
        }
        [EasySSDKtrackMagager errorLog:@"" withSlotId:self.slotId withAdType:self.adType withstep:@"load" withErrorCode:@"Er100031" withRawData:@{@"msg":@"当前APP处于后台，禁止加载广告"}];
        return;
    }
    
    //本地缓存优先级判定，缓存有效期60分钟（后端下发） timestamp
    NSDictionary *cacheDic = [[EasySSDKCacheMagager shared] getCacheForKey:self.slotId];
    if (cacheDic) {
        EasySAdSDKLoadADModel *adModel = [[EasySAdSDKLoadADModel alloc] initWithDic:cacheDic];
        [self renderAdData:adModel];
        
        if ([self.delegate respondsToSelector:@selector(onYtSuccessLoad:)]) {
            [self.delegate onYtSuccessLoad:self];
        }
        return;
    }
    
    //校验并发请求锁：判断当前广告位ID是否正在加载
    NSString *requestType = EasySAdSDKLoadADRequestTypeManager.shared.requestTypeDic[self.slotId] ?:@"";
    if ([requestType isEqualToString:YTAdSDKRequest_Loading]) {
        if ([self.delegate respondsToSelector:@selector(onYtErrorLoad:withError:)]) {
            [self.delegate onYtErrorLoad:self withError:[NSError errorWithDomain:@"EasySSDK" code:100022 userInfo:@{NSLocalizedDescriptionKey:@"其他开屏广告正在加载中",NSStringEncodingErrorKey:@"Er100022"}]];
        }
        [EasySSDKtrackMagager errorLog:@"" withSlotId:self.slotId withAdType:self.adType withstep:@"load" withErrorCode:@"Er100022" withRawData:@{@"msg":@"其他开屏广告正在加载中"}];
        return;
    }
    [EasySAdSDKLoadADRequestTypeManager.shared upDataSlotId:self.slotId withType:YTAdSDKRequest_Loading];
    [[[EasySAdSDKLoadADManager alloc] init] loadAdData:self.adType withSlotId:self.slotId withHandler:^(BOOL success, EasySAdSDKLoadADModel * _Nullable model, NSError * _Nullable error) {

        if (success) {
            [EasySAdSDKLoadADRequestTypeManager.shared upDataSlotId:self.slotId withType:YTAdSDKRequest_Success];

            [self renderAdData:model];
            
            if ([self.delegate respondsToSelector:@selector(onYtSuccessLoad:)]) {
                [self.delegate onYtSuccessLoad:self];
            }
        }else {
            [EasySAdSDKLoadADRequestTypeManager.shared upDataSlotId:self.slotId withType:YTAdSDKRequest_Fail];
            if ([self.delegate respondsToSelector:@selector(onYtErrorLoad:withError:)]) {
                [self.delegate onYtErrorLoad:self withError:error];
            }

                    
            [EasySSDKtrackMagager errorLog:@"" withSlotId:self.slotId withAdType:self.adType withstep:@"load" withErrorCode:@"Er100034" withRawData:@{@"msg":@"广告素材下载失败"}]; //错误埋点

        }
    }];

}

//下载图片进行渲染
- (void)renderAdData:(EasySAdSDKLoadADModel *)resultModel {

    self.adModel = resultModel;
    [EasySSDKtrackMagager reportRender:resultModel withPlacementId:self.slotId withPlacementType:[self.adType integerValue]]; //广告开始渲染
    [[EasySImageDownloader sharedDownloader] downloadImageWithURL:resultModel.imageUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (!image || error) {
            
            
            if ([self.delegate respondsToSelector:@selector(onRenderFail:withError:)]) { //渲染失败
                [self.delegate onRenderFail:self withError:[NSError errorWithDomain:@"render" code:100035 userInfo:@{NSLocalizedDescriptionKey:@"广告素材缓存失败",NSStringEncodingErrorKey:@"Er100035"}]];
            }
            [EasySSDKtrackMagager errorLog:@"" withSlotId:self.slotId withAdType:self.adType withstep:@"load" withErrorCode:@"Er100035" withRawData:@{@"msg":@"广告素材缓存失败"}]; //错误埋点
            //渲染失败
            [EasySSDKtrackMagager reportRenderResult:resultModel withPlacementId:self.slotId withPlacementType:[self.adType integerValue] withResult:1];
        }
        if (image) {
            
            YTSDKNativeExpressView *expressView =  [[YTSDKNativeExpressView alloc] init];
//            [expressView setUpSubviews:resultModel withAdImage:image withAdSize:self.adSize withSizeToFit:self.sizeToFit withRootViewController:self.rootViewController];
            
//            [expressView setUpSubviews:resultModel withAdImage:image withRootViewController:self.rootViewController];
            [expressView setUpSubviews:resultModel withAdImage:image];
            expressView.delegate = self;
            self.adView = expressView;
            if ([self.delegate respondsToSelector:@selector(onRenderSuccess:)]) {
                [self.delegate onRenderSuccess:expressView];
            }
            
            //渲染成功
            [EasySSDKtrackMagager reportRenderResult:resultModel withPlacementId:self.slotId withPlacementType:[self.adType integerValue] withResult:0];
        }
    }];

}

//渲染成功的时候才会有这个判断
- (BOOL)isAdReady:(NSString *)slotId {
    //本地缓存优先级判定，缓存有效期60分钟（后端下发） timestamp
    
    if ([[EasySSDKCacheMagager shared] getCacheForKey:slotId]) {
        return YES;
    }
    NSString *requestType = EasySAdSDKLoadADRequestTypeManager.shared.requestTypeDic[slotId] ?:@""; //请求是否加载成功
    if ([requestType isEqualToString:YTAdSDKRequest_Success]) {
        
        return YES;
    }
    return NO;
}
//渲染，其实目前没啥用
- (void)render {
    
}
- (void)destroy {
    [self.adView removeFromSuperview];
    self.adView = nil;
}



- (void)setExpressViewAcceptedSize:(CGSize)size {
    self.adSize = size;
}

//placementType: 代码位类型：1-开屏广告、2-信息流模版广告
- (NSString *)adType {
    return @"2";
}
//点击下一步
- (void)onAdClick:(nonnull YTSDKNativeExpressView *)adView withNextStep:(NSInteger)nextStep {
    if ([self.delegate respondsToSelector:@selector(atOnAdClick:)]) {
        [self.delegate atOnAdClick:adView];
    }
    //查看广告
    [self reportADClick:@"0" withNextStep:nextStep];
}
//点击关闭
- (void)onAdCloseClick:(nonnull YTSDKNativeExpressView *)adView {
    if ([self.delegate respondsToSelector:@selector(onAdCloseClick:)]) {
        [self.delegate onAdCloseClick:adView];
    }
    [self reportADClick:@"2" withNextStep:5];
}
/// <#Description#>
/// - Parameters:
///   - btnName: 按钮名称：0-查看广告；1-跳过；2-关闭；3-倒计时结束；4-打开APP；5-取消打开APP
///   - nextStep: 下一步：0-打开APP提醒弹窗；1-进入H5着陆页；2-唤起小程序；3-移除广告；4-跳转应用市场；5-关闭广告
- (void)reportADClick:(NSString *)btnName withNextStep:(NSInteger)nextStep{
    
    [EasySSDKtrackMagager reportLog:@"ad_click" withRequestId:self.adModel.requestId ?:@"" withPlacementId:self.slotId withPlacementType:self.adType withAdId:self.adModel.adPlanId withResult:nil withAdModelType:self.adModel.adTemplateId ?:@"" withBtnName:btnName withNextStep:[NSString stringWithFormat:@"%d",nextStep]];

}
//加载到主window上
- (void)onAdWillMoveToWindow:(nonnull YTSDKNativeExpressView *)adView {
    //APP调用show方法时
    [EasySSDKtrackMagager reportLog:@"show_q" withRequestId:self.adModel.requestId ?:@"" withPlacementId:self.slotId withPlacementType:self.adType withAdId:self.adModel.adPlanId withResult:nil withAdModelType:self.adModel.adTemplateId ?:@"" withBtnName:nil withNextStep:nil];

    [[EasySSDKCacheMagager shared] removeCacheForKey:self.slotId]; //展示完毕，删除model缓存
    [[EasySImageDownloader sharedDownloader] removeImageCacheForKey:self.adModel.imageUrl]; //展示完毕，删除图片缓存
 //APP调用show方法并成功展示时
    [EasySSDKtrackMagager reportLog:@"show" withRequestId:self.adModel.requestId ?:@"" withPlacementId:self.slotId withPlacementType:self.adType withAdId:self.adModel.adPlanId withResult:nil withAdModelType:self.adModel.adTemplateId ?:@"" withBtnName:nil withNextStep:nil];

}

@end
