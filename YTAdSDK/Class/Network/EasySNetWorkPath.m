//
//  EasySNetWorkPath.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/9.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySNetWorkPath.h"
#import "EasySNetWorkManager.h"
#import "UIDevice+EasyS.h"
#import "YTSDKSplashAdListener.h"
#import "EasySRandomUtil.h"
#import "EasySSDKStartConfiguration.h"
#import "YTSDKAPIConfiguration.h"

@interface EasySNetWorkPath()
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSDictionary *param;
@end

@implementation EasySNetWorkPath
- (instancetype)initWithType:(NSInteger)type withParam:(NSDictionary *)param {
    self = [super init];
    if (self) {
        self.type = type;
        self.param = param;
    }
    return self;
}
- (instancetype)initErrorLog:(NSString *)requestId withSlotId:(NSString *)slotId withAdType:(NSInteger)adType withstep:(NSString *)step withErrorCode:(NSString *)errorCode withRawData:(NSDictionary *)rawData {
    self = [super init];
    if (self) {
        self.type = 6;
        self.param = @{@"requestId":requestId,@"slotId":slotId,@"adType":[NSNumber numberWithInt:adType],@"step":step,@"errorCode":errorCode,@"rawData":[EasySRandomUtil jsonStringFromDictionary:rawData]};
    }
    return self;
}
- (NSString *)path {
    switch (self.type) {
        case 1://埋点接口
            return @"/easy-sdk/api/v1/report";
            break;
        case 2://2.init接口
            return @"/easy-sdk/api/v1/init-verify";
            break;
        case 3://3.start接口
            return @"/easy-sdk/api/v1/start-check";
            break;
        case 4://4.获取RequestId接口
            return @"/easy-sdk/api/v1/getRequestId";
            break;
        case 5://5.广告结果获取接口-林刚
            return @"/easy-sdk/api/v1/adLoad";
            break;
        case 6:
            return @"/trace/errorLog";
            break;

        default:
            return @"";
            break;
    }
}
- (NSDictionary *)params {
    NSMutableDictionary * allDic = [[NSMutableDictionary alloc] init];
    [allDic addEntriesFromDictionary:self.param];
    allDic[@"appId"] = EasySSDKStartConfiguration.shared.appId ?:@"";
    allDic[@"appKey"] = EasySSDKStartConfiguration.shared.appKey ?:@"";
    switch (self.type) {
        case 1://埋点
            allDic[@"appSignature"] = UIDevice.es_appBundleId ?:@"";
            allDic[@"sessionId"] = EasySSDKStartConfiguration.shared.sessionId ?:@"";

            break;
        case 2://
            allDic[@"appSignature"] = UIDevice.es_appBundleId ?:@"";
            break;
        case 3://3.start接口
            allDic[@"deviceInfo"] = [self deviceInfoDic];
            allDic[@"internetInfo"] = [self internetInfoDic];
            allDic[@"appInfo"] = [self appInfoDic];
        case 4://获取RequestId接口
            /*
             广告类型：1-开屏广告  2-信息流广告

             3-激励视频 4-Banner广告  5-插屏广告
             allDic[@"adType"]
             **/
            break;
        case 5: //5.广告结果获取接口
            allDic[@"deviceInfo"] = [self deviceInfoDic];
            break;
        case 6:
            
            break;
        default:
            break;
            
    }

    return allDic;
}
//设备信息对象
- (NSDictionary *)deviceInfoDic {
    return @{@"deviceId":UIDevice.es_idfa ?:@"",
             @"uuid":UIDevice.es_idfv ?:@"",
             @"idfa":UIDevice.es_idfa ?:@"",
             @"androidId":@"",
             @"brand":@"apple",
             @"model":UIDevice.es_deviceModelName ?:@"",
             @"serialNumber":@"",
             @"osVersion":UIDevice.es_systemVersion ?:@"",
             @"sdkVersion":YTSDKAPIConfiguration.shared.getSDKVersion ?:@"",
             @"density":UIDevice.es_screenDensity ?:@"",
             @"screenResolution":UIDevice.es_screenPixel ?:@"",
             @"deviceLanguage":UIDevice.es_systemLanguage ?:@"",
             @"deviceTimeZone":UIDevice.es_timeZoneName ?:@"",
             @"simInfo":UIDevice.mccMncInfo,
             @"cpuInfo":UIDevice.es_cpuArch,
             @"memorySize":UIDevice.es_totalRAM,
             @"totalDiskSpace":UIDevice.es_totalDiskSize,
             @"macHash":@"",//网卡 MAC 哈希
             @"idfv":UIDevice.es_idfv,
             @"oaid":@"",
             @"rootFlag":UIDevice.es_isJailBreak,
             @"simulatorFlag":UIDevice.es_isSimulator,
             @"doubleOpenFlag":@"0",
             @"systemLanguage":UIDevice.es_systemLanguage,
             @"timeZone":UIDevice.es_timeZoneName,
             @"startupDuration":EasySRandomUtil.timestamp,
             @"isClone":@"0",
             @"isEmulator":UIDevice.es_isSimulator,
             @"isRoot":UIDevice.es_isJailBreak,
             @"platform":@"2",//平台：1=Android 2=iOS
             @"screenWidth":UIDevice.screenWidth,
             @"screenHeight":UIDevice.screenHeight,
             @"storageSize":UIDevice.es_totalDiskSize,
             @"networkType":UIDevice.getNetworkTypeCode,
             @"operatorType":[NSNumber numberWithInt:UIDevice.es_carrierName],
             @"country":@"",
             @"province":@"",
             @"city":@"",
             @"longitude":@"",
             @"latitude":@"",
             @"isVpn":UIDevice.isProxyOn,

    };
}
//网络信息对象
- (NSDictionary *)internetInfoDic {
    return  @{@"operatorInfo":UIDevice.mccMncInfo,
              @"networkType":UIDevice.getNetworkTypeCode,
              @"signalStrength":@"",
              @"ip":UIDevice.es_wifiIP};
}
//应用信息对象
- (NSDictionary *)appInfoDic {
    return  @{@"processInfo":@"",
              @"frontAndRearStatus":[NSNumber numberWithBool:UIDevice.es_isAppForeground]};
}
- (NSDictionary *)advertInfoDic {
    return  @{};
}
- (NSDictionary *)performanceInfoDic {
    
    

    NSDictionary *internetInfo = @{};
    NSDictionary *appInfo = @{};
    NSDictionary *advertInfo = @{};
    NSDictionary *performanceInfo = @{};
    return @{@"appId":EasySSDKStartConfiguration.shared.appId,
             @"appKey":EasySSDKStartConfiguration.shared.appKey,
             @"sessionId":EasySSDKStartConfiguration.shared.sessionId,
             @"appPackge":UIDevice.es_appBundleId,
             @"appVersion":UIDevice.es_appVersion,
             @"appSource":@"AppStore",
             @"appSignature":UIDevice.es_appBundleId,
             @"deviceInfo":@"",
             @"internetInfo":internetInfo,
             @"appInfo":appInfo,
             @"advertInfo":advertInfo,
             @"performanceInfo":performanceInfo};

}
- (NSString *)method {
    return @"POST";

}

//- (NSDictionary *)testDic {
//    return @{@"appId": @"WDIEYXNSPUEMQHP7",
//             @"appKey": @"YM56Q9JU0PBO29XCMXE2YFI1L381WIPN",
//             @"appName": @"易推IOS",
//             @"appPackage": @"com.example.yitui",
//             @"appSignature": @"asfjskhgfkrs",
//             @"sha1BundleId": @"asfjskhgfkrs"};
//}

@end
