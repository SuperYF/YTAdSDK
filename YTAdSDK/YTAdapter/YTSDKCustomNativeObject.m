//
//  YTSDKCustomNativeObject.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTSDKCustomNativeObject.h"
#import "YTSDKNavtiveAdModel.h"

@interface YTSDKCustomNativeObject()

@property (nonatomic, strong) ATNativeAdRenderConfig *configuration;

@end

@implementation YTSDKCustomNativeObject

#pragma mark - 必须实现，获取配置并设置给自定义广告平台 SDK
- (void)setNativeADConfiguration:(ATNativeAdRenderConfig *)configuration {
    self.configuration = configuration;
//    [self getMSFeedVideoView].presentVc = configuration.rootViewController;
}

#pragma mark - 必须实现，根据渲染类型注册容器
- (void)registerClickableViews:(NSArray<UIView *> *)clickableViews withContainer:(UIView *)container registerArgument:(ATNativeRegisterArgument *)registerArgument {
     
    if (self.nativeAdRenderType == ATNativeAdRenderExpress) { //模板广告
        [self templateRender];
        return;
    }
//    [self slefRenderRenderClickableViews:clickableViews withContainer:container registerArgument:registerArgument];
}
#pragma mark - 模板
- (void)templateRender {
    UIViewController *rootVC = self.configuration.rootViewController;
    if (rootVC == nil) {
        rootVC = [ATGeneralManage getCurrentViewControllerWithWindow:nil];
    }
    self.feedAdModel.nativePresentVC = rootVC;
}

@end
