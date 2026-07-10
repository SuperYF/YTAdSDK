//
//  YTSDKConst.h
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/14.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> // 引入UIKit，用于屏幕宽高相关定义

// 说明：所有常量均添加 MySDK 前缀，避免与宿主App命名冲突
// 可根据自己SDK的实际前缀修改（如：CompanySDK_XXX）

#pragma mark - 宏定义（SDK专用，按功能分类，避免滥用）
// 1. 通用便捷宏（简化代码，提升开发效率）
#define MySDKWeakSelf __weak typeof(self) weakSelf = self; // 弱引用，避免循环引用
#define MySDKStrongSelf __strong typeof(weakSelf) strongSelf = weakSelf; // 强引用，配合weakSelf使用
#define MySDKIsEmptyString(str) (str == nil || [str isEqualToString:@""] || str == NULL) // 判断空字符串
#define MySDKLog(fmt, ...) if (MySDKDebugMode) NSLog((@"[YTAdSDK] " fmt), ##__VA_ARGS__) // 调试日志（仅Debug模式输出）

// 2. 条件宏（区分Debug/Release环境、设备适配）
#ifdef DEBUG
#define MySDKDebugLog MySDKLog // Debug模式：启用日志
#else
#define MySDKDebugLog(...) // Release模式：屏蔽所有日志
#endif

// 3. 设备适配宏（结合屏幕宽高，简化适配逻辑）
#define MySDKAdaptWidth(x) (x * MySDKScreenWidth() / 375.0) // 按375宽度适配（iPhone SE2/8基准）
#define MySDKAdaptHeight(x) (x * MySDKScreenHeight() / 667.0) // 按667高度适配（iPhone SE2/8基准）
#define MySDKIsIphoneXSeries (MySDKStatusBarHeight() > 20.0) // 判断是否为刘海屏（iPhone X及以上）

#pragma mark - 基础配置常量
// SDK版本号（与SDK主版本保持一致）
FOUNDATION_EXPORT NSString *const MySDKVersion;
// SDK唯一标识（用于区分不同SDK，可填写bundleId格式）
FOUNDATION_EXPORT NSString *const MySDKAppID;
// SDK默认请求BaseUrl（若有网络请求场景）
FOUNDATION_EXPORT NSString *const MySDKDefaultBaseUrl;


#pragma mark - 屏幕相关方法（适配所有iOS设备，修复编译报错）
// 屏幕宽度（物理宽度，适配横屏/竖屏）
FOUNDATION_EXPORT CGFloat MySDKScreenWidth(void);
// 屏幕高度（物理高度，适配横屏/竖屏）
FOUNDATION_EXPORT CGFloat MySDKScreenHeight(void);
// 屏幕缩放比例（Retina屏为2.0/3.0）
FOUNDATION_EXPORT CGFloat MySDKScreenScale(void);
// 状态栏高度（适配刘海屏/非刘海屏）
FOUNDATION_EXPORT CGFloat MySDKStatusBarHeight(void);
FOUNDATION_EXPORT UIColor* MySDKColor(void);

#pragma mark - 错误相关常量
// 错误域（用于NSError，区分SDK自身错误）
FOUNDATION_EXPORT NSString *const MySDKErrorDomain;
// 错误码：初始化失败
FOUNDATION_EXPORT const NSInteger MySDKErrorCodeInitFailed;
// 错误码：参数非法
FOUNDATION_EXPORT const NSInteger MySDKErrorCodeInvalidParam;
// 错误码：网络异常
FOUNDATION_EXPORT const NSInteger MySDKErrorCodeNetworkError;

#pragma mark - 通知名称（SDK内部/外部通信）
// SDK初始化完成通知
FOUNDATION_EXPORT NSString *const MySDKInitFinishNotification;
// SDK登录成功通知
FOUNDATION_EXPORT NSString *const MySDKLoginSuccessNotification;
// SDK退出登录通知
FOUNDATION_EXPORT NSString *const MySDKLogoutNotification;
// SDK网络状态变化通知
FOUNDATION_EXPORT NSString *const MySDKNetworkStatusChangeNotification;

#pragma mark - 配置参数常量
// 最大重试次数（请求失败时）
FOUNDATION_EXPORT const NSInteger MySDKMaxRetryCount;
// 超时时间（单位：秒）
FOUNDATION_EXPORT const NSTimeInterval MySDKRequestTimeout;
// 是否开启调试模式（默认关闭，Release包需置为NO）
FOUNDATION_EXPORT const BOOL MySDKDebugMode;

#pragma mark - 通用字符串常量（可根据业务补充）
// 空字符串占位符
FOUNDATION_EXPORT NSString *const MySDKEmptyString;
// 未知状态占位符
FOUNDATION_EXPORT NSString *const MySDKUnknown;

// 可根据SDK实际业务，添加自定义常量（如：支付相关、统计相关等）

typedef NS_ENUM(NSInteger, EasySSplashAdCloseType) {
    EasySSplashAdCloseType_Unknow = 0,             // unknow
    EasySSplashAdCloseType_ClickSkip = 1,          // click skip 点击跳过
    EasySSplashAdCloseType_CountdownToZero = 2,    // countdown 倒计时结束
    EasySSplashAdCloseType_ClickAd = 3,            // click Ad 点击广告
    EasySSplashAdCloseType_ForceQuit = 4,           // Forced shutdown when an error is encountered 遇到错误时系统将自动关闭
    EasySSplashAdCloseType_DetailBack = 5,          //  详情页面，返回，最后进入上一面，且时间为 0
    EasySSplashAdCloseType_DetailClose = 6           // 详情页面，点击X

};


FOUNDATION_EXPORT NSString *const YTAdSDKRequest_Begin;
FOUNDATION_EXPORT NSString *const YTAdSDKRequest_Loading;
FOUNDATION_EXPORT NSString *const YTAdSDKRequest_Success;
FOUNDATION_EXPORT NSString *const YTAdSDKRequest_Fail;
FOUNDATION_EXPORT NSString *const YTAdSDKRequest_Unknown;

FOUNDATION_EXPORT NSString *const YTAdSDKRequest_Local;
FOUNDATION_EXPORT NSString *const YTAdSDKRequest_Pierce;


//#define DebugHeader  @{@"deviceId":@"test123",@"brand":@"xiaomi",@"model":@"Mi11",@"osVersion":@"Android 12",@"appPackage":@"com.example.yitui",@"os":@"1"}


