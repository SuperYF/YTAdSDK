//
//  YTSDKConst.m
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/14.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import "YTSDKConst.h"


#pragma mark - 基础配置常量 赋值
NSString *const MySDKVersion = @"1.0.0"; // 可根据SDK版本修改
NSString *const MySDKAppID = @"com.ios.YTAdSDK"; // 替换为自己的bundleId格式

#pragma mark - 屏幕相关常量 赋值（修复编译报错：改为方法获取，避免非编译期常量）
CGFloat MySDKScreenWidth(void) {
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat MySDKScreenHeight(void) {
    return [UIScreen mainScreen].bounds.size.height;
}

CGFloat MySDKScreenScale(void) {
    return [UIScreen mainScreen].scale;
}

CGFloat MySDKStatusBarHeight(void) {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

UIColor* MySDKColor(void) {
    return [UIColor colorWithRed:1 green:0.88 blue:0 alpha:1];
}


#pragma mark - 错误相关常量 赋值
NSString *const MySDKErrorDomain = @"com.ios.YTAdSDK";
const NSInteger MySDKErrorCodeInitFailed = 10001;
const NSInteger MySDKErrorCodeInvalidParam = 10002;
const NSInteger MySDKErrorCodeNetworkError = 10003;

#pragma mark - 通知名称 赋值
NSString *const MySDKInitFinishNotification = @"MySDKInitFinishNotification";
NSString *const MySDKLoginSuccessNotification = @"MySDKLoginSuccessNotification";
NSString *const MySDKLogoutNotification = @"MySDKLogoutNotification";
NSString *const MySDKNetworkStatusChangeNotification = @"MySDKNetworkStatusChangeNotification";

#pragma mark - 配置参数常量 赋值
const NSInteger MySDKMaxRetryCount = 3; // 可根据需求调整
const NSTimeInterval MySDKRequestTimeout = 30.0; // 30秒超时，可调整
const BOOL MySDKDebugMode = NO; // Release包固定为NO，Debug可改为YES

#pragma mark - 通用字符串常量 赋值
NSString *const MySDKEmptyString = @"";
NSString *const MySDKUnknown = @"未知";


#pragma mark - 请求状态 赋值
NSString *const YTAdSDKRequest_Begin = @"YT_YTAdSDKRequest_Begin";
NSString *const YTAdSDKRequest_Loading = @"YT_YTAdSDKRequest_Loading";
NSString *const YTAdSDKRequest_Success = @"YT_YTAdSDKRequest_Success";
NSString *const YTAdSDKRequest_Fail = @"YT_YTAdSDKRequest_Fail";
NSString *const YTAdSDKRequest_Unknown = @"YT_YTAdSDKRequest_Unknown";

#pragma mark - 请求地址设置-测试使用
NSString *const YTAdSDKRequest_Local = @"YTAdSDKRequest_Local"; //本地
NSString *const YTAdSDKRequest_Pierce = @"YTAdSDKRequest_Pierce";//外网穿透

