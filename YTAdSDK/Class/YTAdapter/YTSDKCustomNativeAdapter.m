//
//  YTSDKCustomNativeAdapter.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTSDKCustomNativeAdapter.h"
#import "YTNavtiveAdListener.h"
#import "YTSDKCustomNativeDelegate.h"

@interface YTSDKCustomNativeAdapter()
@property (nonatomic, strong) YTSDKCustomNativeDelegate * nativeDelegate;
@property (nonatomic, strong) YTNavtiveAdListener           * nativeExpressAd;
 
@end
@implementation YTSDKCustomNativeAdapter
#pragma mark - lazy
- (YTSDKCustomNativeDelegate *)nativeDelegate{
    if (_nativeDelegate == nil) {
        _nativeDelegate = [[YTSDKCustomNativeDelegate alloc] init];
        _nativeDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _nativeDelegate;
}

#pragma mark - init
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
   
    dispatch_async(dispatch_get_main_queue(), ^{
        //通过argument对象获取必要的加载信息，如尺寸等，创建好必要的参数，准备传入给第三方的原生加载方法，开始加载广告
        CGSize size = CGSizeMake(0, 0);
        if ([argument.localInfoDic[kATExtraInfoNativeAdSizeKey] respondsToSelector:@selector(CGSizeValue)]) {
            size = [argument.localInfoDic[kATExtraInfoNativeAdSizeKey] CGSizeValue];
        }
        self.nativeExpressAd = [[YTNavtiveAdListener alloc]initWithSlot:argument.serverContentDic[@"slot_id"] adSize:size];
        //注意设置代理给DemoCustomNativeDelegate
        self.nativeExpressAd.delegate = self.nativeDelegate;
        [self.nativeExpressAd load];

        
    });
}
@end
