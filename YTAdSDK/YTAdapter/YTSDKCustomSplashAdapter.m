//
//  YTSDKCustomSplashAdapter.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTSDKCustomSplashAdapter.h"
#import "YTSDKSplashAdListener.h"
#import "YTSDKCustomSplashDelegate.h"
#import "YTSDKAPIConfiguration.h"
@interface YTSDKCustomSplashAdapter()
@property (nonatomic, strong) YTSDKCustomSplashDelegate *splashDelegate;
@property (nonatomic, strong) YTSDKSplashAdListener *splashAd;
@end
@implementation YTSDKCustomSplashAdapter

#pragma mark - lazy
- (YTSDKCustomSplashDelegate *)splashDelegate{
    if (_splashDelegate == nil) {
        _splashDelegate = [[YTSDKCustomSplashDelegate alloc] init];
        _splashDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _splashDelegate;
}
//用于获取服务器下发和本地配置的参数，实现自定义广告的加载逻辑

- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    dispatch_async(dispatch_get_main_queue(), ^{

        //Get the bottom logo view
        UIView *containerView = argument.localInfoDic[kATSplashExtraContainerViewKey];
        
        CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        if (containerView) {
            size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - containerView.frame.size.height);
        }
        //tolerate_timeout
        //
        NSInteger timeoutInterval = [argument.localInfoDic[kATSplashExtraTolerateTimeoutKey] integerValue];
        YTSDKAPIConfiguration.shared.timeoutInterval = timeoutInterval;
        self.splashAd = [[YTSDKSplashAdListener alloc] init];
        self.splashAd.delegate = self.splashDelegate;
        [self.splashAd loadAD:argument.serverContentDic[@"slot_id"] withContainerView:containerView];
    });
}



#pragma mark - Ad show
- (void)showSplashAdInWindow:(nonnull UIWindow *)window inViewController:(nonnull UIViewController *)inViewController parameter:(nonnull NSDictionary *)parameter {
    [self.splashAd showSplashViewInRootViewController:inViewController];

}
#pragma mark - Ad ready
- (BOOL)adReadySplashWithInfo:(NSDictionary *)info {
    return [self.splashAd isAdReady:info[@"slot_id"]];
}




@end
