//
//  UIDevice+EasyS.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "UIDevice+EasyS.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <net/if.h>
#import <net/if_types.h>
#import <net/if_dl.h>

#import "YTSDKAPIConfiguration.h"
@implementation UIDevice (EasyS)
+ (CGFloat)getStatusBarHeight {
    CGFloat statusBarHeight = 0;
    
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    return statusBarHeight;
}

#pragma mark 1.品牌
+ (NSString *)es_deviceBrand{
    return @"Apple";
}

#pragma mark 2.真实机型
+ (NSString *)es_deviceModelName{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    /*
     struct utsname systemInfo;
         uname(&systemInfo);
         NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
         return model; 
     */
    
//    //自行扩展机型映射，示例
//    if([platform isEqualToString:@"iPhone15,2"]) return @"iPhone14 Pro";
//    if([platform isEqualToString:@"arm64"]) return @"Simulator";
    return platform ?:@"";
}

#pragma mark 3.系统版本
+ (NSString *)es_systemVersion{
    return [UIDevice currentDevice].systemVersion ?:@"";
}

#pragma mark 4.屏幕
+ (NSString *)es_screenPixel{
    UIScreen *scr = [UIScreen mainScreen];
    CGFloat scale = scr.scale;
    return [NSString stringWithFormat:@"%.0fX%.0f",scr.bounds.size.width*scale, scr.bounds.size.height*scale] ?:@"";
//    CGSizeMake(scr.bounds.size.width*scale, scr.bounds.size.height*scale);
}
+ (NSString *)es_screenDensity{
    return [NSString stringWithFormat:@"%.1f",[UIScreen mainScreen].scale] ?:@"";
}

#pragma mark 5.语言
+ (NSString *)es_systemLanguage{
    return [[NSLocale preferredLanguages].firstObject copy] ?:@"";
}

#pragma mark 6.时区
+ (NSString *)es_timeZoneName{
    return [NSTimeZone systemTimeZone].name ?:@"";
}

#pragma mark 7.总内存 MB
+ (NSString *)es_totalRAM{
    int mib[2] = {CTL_HW,HW_MEMSIZE};
    size_t len;
    uint64_t total;
    len = sizeof(total);
    sysctl(mib,2,&total,&len,NULL,0);
    return [NSString stringWithFormat:@"%.0llu",total/1024/1024] ?:@"";
}

#pragma mark 8.磁盘总容量
+ (NSString *)es_totalDiskSize{
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [NSString stringWithFormat:@"%.0lld",[attr[NSFileSystemSize] longLongValue]/1024/1024/1024] ?:@"";
}

#pragma mark 9.IDFV
+ (NSString *)es_idfv{
    return [[UIDevice currentDevice].identifierForVendor UUIDString] ?:@"";
}

#pragma mark 10.IDFA
+ (void)requestTrackingAuthorization {
    if (@available(iOS 14.0, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
        }];
    }
}
+ (NSString *)es_idfa {
//    // 1. 先判断广告追踪是否可用
//    if (![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
//        return @"";
//    }
//
//    // 2. iOS14及以上必须判断授权状态
//    if (@available(iOS 14.0, *)) {
//        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
//        if (status != ATTrackingManagerAuthorizationStatusAuthorized) {
//            return @"";
//        }
//    }

    // 3. 授权通过，返回IDFA
    NSUUID *adId = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    return [adId UUIDString];
}

#pragma mark 11.越狱检测
+ (NSString *)es_isJailBreak{
    NSArray *paths = @[@"/Applications/Cydia.app",@"/private/var/stash",@"/bin/bash"];
    for(NSString *p in paths){
        if([[NSFileManager defaultManager] fileExistsAtPath:p]) return @"1";
    }
    return @"0";
}

#pragma mark 12.模拟器
+ (NSString *)es_isSimulator{
#if TARGET_OS_SIMULATOR
    return @"1";
#else
    return @"0";
#endif
}

#pragma mark 13.运营商
+ (NSInteger)es_carrierName{ //运营商：1=移动 2=联通 3=电信 4未知
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *carrierName = carrier.carrierName ?:@"";
    if ([carrierName containsString:@"移动"]) {
        return 1;
    }
    if ([carrierName containsString:@"联通"]) {
        return 1;
    }
    if ([carrierName containsString:@"电信"]) {
        return 1;
    }
    return 4;
}

#pragma mark 14.WiFi内网IP
+ (NSString *)es_wifiIP{
//    NSString *ipAddr = nil;
//       struct ifaddrs *interfaces = NULL;
//       struct ifaddrs *tempAddr = NULL;
//       int success = getifaddrs(&interfaces);
//       if (success == 0) {
//           tempAddr = interfaces;
//           while (tempAddr != NULL) {
//               // 只取IPv4
//               if (tempAddr->ifa_addr->sa_family == AF_INET) {
//                   NSString *name = [NSString stringWithUTF8String:tempAddr->ifa_name];
//                   // 过滤回环lo0、虚拟VPN网卡，只保留Wi‑Fi(en0)、蜂窝(pdp_ip0)
//                   if ([name isEqualToString:@"en0"] || [name isEqualToString:@"pdp_ip0"]) {
//                       char addrBuf[INET_ADDRSTRLEN];
//                       inet_ntop(AF_INET, &((struct sockaddr_in *)tempAddr->ifa_addr)->sin_addr, addrBuf, sizeof(addrBuf));
//                       ipAddr = [NSString stringWithUTF8String:addrBuf];
//                       // 过滤127本地回环
//                       if (![ipAddr isEqualToString:@"127.0.0.1"]) {
//                           break;
//                       }
//                   }
//               }
//               tempAddr = tempAddr->ifa_next;
//           }
//       }
//       freeifaddrs(interfaces);
//       return ipAddr;
   
    /*
    NSString *ip = nil;
    struct ifaddrs *addrs;
    if(getifaddrs(&addrs)==0){
        struct ifaddrs *tmp = addrs;
        while(tmp){
            if(tmp->ifa_addr->sa_family == AF_INET && [[NSString stringWithUTF8String:tmp->ifa_name] isEqualToString:@"en0"]){
                ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)tmp->ifa_addr)->sin_addr)];
                break;
            }
            tmp = tmp->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return ip?:@"";
    */
    struct ifaddrs *allInterfaces = NULL;
      int ret = getifaddrs(&allInterfaces);
      if (ret != 0) return nil;
      
      NSString *targetIP = nil;
      struct ifaddrs *curAddr = allInterfaces;
      
      for (; curAddr != NULL; curAddr = curAddr->ifa_next) {
          sa_family_t family = curAddr->ifa_addr->sa_family;
          if (family != AF_INET) continue;
          
          NSString *name = [NSString stringWithUTF8String:curAddr->ifa_name];
          if ([name isEqualToString:@"lo"]) continue;
          
          struct sockaddr_in *addr = (struct sockaddr_in *)curAddr->ifa_addr;
          NSString *ip = [NSString stringWithUTF8String:inet_ntoa(addr->sin_addr)];
          if ([ip isEqualToString:@"127.0.0.1"]) continue;
          
          if ([name isEqualToString:@"en0"]) {
              targetIP = ip;
              break;
          }
          if (!targetIP && [name isEqualToString:@"pdp_ip0"]) {
              targetIP = ip;
          }
      }
      freeifaddrs(allInterfaces);
    if (YTSDKAPIConfiguration.shared.debugLog) {
        NSLog(@"本机IP地址为：%@",targetIP ?: @"");
    }
      return targetIP ?: @"";

}

#pragma mark 15.包名
+ (NSString *)es_appBundleId{
    return [[NSBundle mainBundle] bundleIdentifier] ?:@"";
}

#pragma mark 16.APP版本
+ (NSString *)es_appVersion{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?:@"";
}
+ (NSString *)es_appName{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"] ?:@"";
}
#pragma mark 17.是否前台
+ (BOOL)es_isAppForeground{
    return [UIApplication sharedApplication].applicationState == UIApplicationStateActive;
}

#pragma mark 18.CPU架构
+ (NSString *)es_cpuArch{
#ifdef __arm64__
    return @"arm64";
#elif __x86_64__
    return @"x86_64";
#else
    return @"unknown";
#endif
}
//sim卡信息（mcc&mnc）
+ (NSArray *)mccMncInfo { //SIM状态 1 就绪 2 未插卡 3 锁定 4 服务受限制(欠费，停机...)
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSMutableArray *res = [NSMutableArray array];
    if (@available(iOS 12.1, *)) {
        NSDictionary *cars = netInfo.serviceSubscriberCellularProviders;
        for (NSString *k in cars) {
            CTCarrier *c = cars[k];
            [res addObject:@{
                @"mcc": c.mobileCountryCode ?: @"",
                @"mnc": c.mobileNetworkCode ?: @"",
                @"carrier": c.carrierName ?: @"",
                @"simCountryIso":c.isoCountryCode ?: @"",
                @"simState":[UIDevice simState:c]
            }];
        }
    } else {
        CTCarrier *c = netInfo.subscriberCellularProvider;
        [res addObject:@{
            @"mcc": c.mobileCountryCode ?: @"",
            @"mnc": c.mobileNetworkCode ?: @"",
            @"carrier": c.carrierName ?: @"",
            @"simCountryIso":c.isoCountryCode ?: @"",
            @"simState":[UIDevice simState:c]
        }];
    }
    return res;
}
+ (NSString *)screenWidth {
    UIScreen *scr = [UIScreen mainScreen];
    return  [NSString stringWithFormat:@"%.0f",scr.bounds.size.width] ?:@"";
}
+ (NSString *)screenHeight{
    UIScreen *scr = [UIScreen mainScreen];
    return  [NSString stringWithFormat:@"%.0f",scr.bounds.size.height] ?:@"";
}
+ (NSString *)getNetworkTypeCode {
    // 0=未知 1=WiFi 2=2G 3=3G 4=4G 5=5G

        // 1. 判断是否有网
        BOOL isReachable = NO;
        struct sockaddr_in zero_addr;
        bzero(&zero_addr, sizeof(zero_addr));
        zero_addr.sin_len = sizeof(zero_addr);
        zero_addr.sin_family = AF_INET;

        SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr *)&zero_addr);
        if (ref) {
            SCNetworkReachabilityFlags flags;
            if (SCNetworkReachabilityGetFlags(ref, &flags)) {
                isReachable = (flags & kSCNetworkReachabilityFlagsReachable) != 0;
            }
            CFRelease(ref);
        }

        if (!isReachable) {
            return @"0"; // 无网
        }

        // 2. 判断是否是 WiFi
        BOOL isWiFi = NO;
        struct ifaddrs *interfaces = NULL;
        if (getifaddrs(&interfaces) == 0) {
            struct ifaddrs *cursor = interfaces;
            while (cursor != NULL) {
                if (strcmp(cursor->ifa_name, "en0") == 0) {
                    if (cursor->ifa_flags & IFF_UP && !(cursor->ifa_flags & IFF_LOOPBACK)) {
                        isWiFi = YES;
                        break;
                    }
                }
                cursor = cursor->ifa_next;
            }
            freeifaddrs(interfaces);
        }

        if (isWiFi) {
            return @"1";
        }

        // 3. 判断蜂窝网络 2G/3G/4G/5G
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *radioType = nil;

        if (@available(iOS 12.1, *)) {
            radioType = networkInfo.serviceCurrentRadioAccessTechnology.allValues.firstObject;
        } else {
            radioType = networkInfo.currentRadioAccessTechnology;
        }

        if (!radioType) {
            return @"0";
        }

        if ([radioType.uppercaseString containsString:@"5G"]) {
            return @"5";
        } else if ([radioType isEqualToString:CTRadioAccessTechnologyLTE]) {
            return @"4";
        } else if ([radioType isEqualToString:CTRadioAccessTechnologyWCDMA] ||
                   [radioType isEqualToString:CTRadioAccessTechnologyHSDPA] ||
                   [radioType isEqualToString:CTRadioAccessTechnologyHSUPA] ||
                   [radioType isEqualToString:CTRadioAccessTechnologyCDMA1x] ||
                   [radioType isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
                   [radioType isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
                   [radioType isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
                   [radioType isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            return @"3";
        } else if ([radioType isEqualToString:CTRadioAccessTechnologyEdge] ||
                   [radioType isEqualToString:CTRadioAccessTechnologyGPRS]) {
            return @"2";
        }

        return @"0";
}
+ (NSString *)isProxyOn {
    CFDictionaryRef cfDict = CFNetworkCopySystemProxySettings();
    if (!cfDict) return @"0";

    NSDictionary *dict = (__bridge_transfer NSDictionary *)cfDict;

    // 有 HTTP 代理或 HTTPS 代理
    BOOL hasHTTP  = [dict[@"HTTPEnable"] boolValue];
    BOOL hasHTTPS = [dict[@"HTTPSEnable"] boolValue];

    return (hasHTTP || hasHTTPS) ? @"1":@"0";
}

+ (NSString *)simState:(CTCarrier *)c {//SIM状态 1 就绪 2 未插卡 3 锁定 4 服务受限制(欠费，停机...)
    NSString *status = @"";
    if (c.mobileCountryCode == nil || c.mobileNetworkCode == nil) {
        return @"2";
    }else if (c.carrierName != nil) {
        return @"1";
    }else {
        return @"3";
    }
}
@end
