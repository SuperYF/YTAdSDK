//
//  YTSDKStartManager.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/10.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, EasySSDKStartType) {
    EasySSDKStartType_Unknow = 0,             // unknow
    EasySSDKStartType_Begin = 1,          // click skip 点击跳过
    EasySSDKStartType_Going = 2,    // countdown 倒计时结束
    EasySSDKStartType_Success = 3,            // click Ad 点击广告
    EasySSDKStartType_Fail = 4,           // Forced shutdown when an error is encountered 遇到错误时系统将自动关闭
    EasySSDKStartType_Other = 5,          //  详情页面，返回，最后进入上一面，且时间为 0

};
typedef void (^EasySCompletionHandler)(BOOL success, NSError * _Nullable error);

@interface YTSDKStartManager : NSObject
@property (nonatomic, assign, readonly) BOOL isStart; //初始化是否成功：true 成功 false 失败

+ (instancetype)shared;

- (void)startWithAppID:(NSString *)appID
                appKey:(NSString *)appKey
    completionHandler:(EasySCompletionHandler)completionHandler;

/// 关闭非必要信息采集与权限申请开关
/// @param enable NO:关闭非必要采集 YES:开启（默认YES）
- (void)infoCollectionEnable:(BOOL)enable;


@end

NS_ASSUME_NONNULL_END
