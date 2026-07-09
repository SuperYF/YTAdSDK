//
//  UIDevice+EasyS.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (EasyS)
+ (CGFloat)getStatusBarHeight ;

///1.设备品牌 Apple
+ (NSString *)es_deviceBrand;
///2.设备型号 iPhone15
+ (NSString *)es_deviceModelName;
///3.系统版本 17.2.1
+ (NSString *)es_systemVersion;
///4.屏幕分辨率、屏幕密度
+ (NSString *)es_screenPixel;
+ (NSString *)es_screenDensity;
///5.系统语言
+ (NSString *)es_systemLanguage;
///6.系统时区
+ (NSString *)es_timeZoneName;
///7.设备总内存 MB
///
+ (NSString *)es_totalRAM;
///8.磁盘总容量 GB
+ (NSString *)es_totalDiskSize;
///9.IDFV
+ (NSString *)es_idfv;
///10.IDFA(未授权返回空)
+ (NSString *)es_idfa;
+ (void)requestTrackingAuthorization;
///11.是否越狱(Root)
+ (NSString *)es_isJailBreak;
///12.是否模拟器
+ (NSString *)es_isSimulator;
///13.运营商名称
+ (NSInteger)es_carrierName;
///14.WiFi内网IP
+ (NSString *)es_wifiIP;
///15.宿主BundleID(包名)
+ (NSString *)es_appBundleId;
///16.APP版本号
+ (NSString *)es_appVersion;
+ (NSString *)es_appName;
///17.当前APP是否前台
+ (BOOL)es_isAppForeground;
///18.CPU架构
+ (NSString *)es_cpuArch;
//sim卡信息（mcc&mnc）
+ (NSArray *)mccMncInfo;
+ (NSString *)screenWidth;
+ (NSString *)screenHeight;

+ (NSString *)getNetworkTypeCode;

+ (NSString *)isProxyOn;

@end

NS_ASSUME_NONNULL_END
