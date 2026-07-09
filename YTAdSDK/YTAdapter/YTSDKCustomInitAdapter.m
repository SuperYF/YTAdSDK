//
//  YTSDKCustomInitAdapter.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTSDKCustomInitAdapter.h"
#import "YTSDKCustomInfo.h"
//#import <YTAdSDK/YTAdSDK.h>
#import "YTSDKStartManager.h"
@implementation YTSDKCustomInitAdapter
/// Init Ad SDK
/// - Parameter adInitArgument: server info
- (void)initWithInitArgument:(ATAdInitArgument *)adInitArgument{
    //从adInitArgument对象中拿取后台配置的信息，例如adInitArgument.serverContentDic[@"appId"]
  //拿取到相关信息后，调用广告平台SDK的初始化方法进行初始化，您可以根据需要，在这里对广告平台的SDK进行设置，例如海外平台的隐私设置（如：CCPA，COPPA，GDPR）等。
  //如果广告平台SDK初始化有返回值，使用[self notificationNetworkInitSuccess];通知我们初始化成功；
  //如果第三方初始化失败，使用[self notificationNetworkInitFail:error];通知我们初始化失败。
  //如果广告平台SDK初始化没有成功或者失败，可直接通知我们初始化成功，使用:[self notificationNetworkInitSuccess];
    NSString *appId = adInitArgument.serverContentDic[@"app_id"];
    NSString *appkey = adInitArgument.serverContentDic[@"app_key"];

    [YTSDKStartManager.shared startWithAppID:appId appKey:appkey completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [self notificationNetworkInitSuccess];
        }else {
            [self notificationNetworkInitFail:error];
        }
    }];
    
}

/// 返回广告平台SDK 的版本号
- (nullable NSString *)sdkVersion {
    //例如
    return @"1.0.0";
}

/// 返回适配器版本号
- (nullable NSString *)adapterVersion {
    return [YTSDKCustomInfo getAdapterVersion];
}
@end
