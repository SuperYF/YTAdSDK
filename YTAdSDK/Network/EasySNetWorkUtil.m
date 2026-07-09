//
//  EasySNetWorkUtil.m
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySNetWorkUtil.h"
#import "EasySAESUtil.h"
#import "EasySRSAUtil.h"
#import "EasySHashUtil.h"
#import "EasySRandomUtil.h"
#import "UIDevice+EasyS.h"
#import "EasySNetWorkManager.h"
#import "YTSDKSplashAdListener.h"
#import "EasySSDKGeneralTool.h"
#import "EasySSDKStartConfiguration.h"
#import "YTSDKAPIConfiguration.h"
#import "EasySSDKStartConfiguration.h"
#import "YTSDKAPIConfiguration.h"

static NSString *_globalPubKey = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAl+VXmcqSb6ofTyKidE/4Wdfoj8avfkW87rReMkBwi5WuNFXdh/E2IF6+nNvBS2wZDvGvOXCq66eEM80awC0aV3H5iSWoNdg6fWcvdRGo/AKOFIpe1sYHlZgD9iOhW4fWn/qpP/TeI8O/tknPlKE3k8emYdJBBR/6q7xIUXDlFjrEwIG6iITt6B6wHFfnfw0gsEzSP63AVv0ckRG7ms4yPQkSTufi4oVngD1lLvdK4UPzgpd7cq1i+CV9fDRhlB7QKwzJfCd8jEYy26JienSKKU2Njs/H0idlXjEPc5kd8/RaBseSChq9e6AH3YiDs5ENI+ullxRop9GnBD+EqLWOuwIDAQAB";
//static NSString *local_baseUrl = @"http:192.168.2.22:9801"; // 替换成你的正式域名
static NSString *_baseUrl = @"https://ssapi.ibtfx.cn"; // 替换成你的正式域名
// ==================== 接口域名 ====================
    // 测试环境
    //外网环境
//static NSString *test_baseUrl = @"http://223.72.157.125:39801";

@implementation EasySNetWorkUtil

+ (void)configRSAPublicKey:(NSString *)pubKey {
    _globalPubKey = pubKey.copy;
}
+ (void)request:(id<EasySNetWorkType>)target success:(ESNetSuccess)success fail:(ESNetFailure)fail {
    [EasySNetWorkUtil postEncrypt:[target path] params:[target params] success:success fail:fail];
}

+ (void)postEncrypt:(NSString *)api params:(NSDictionary *)params success:(ESNetSuccess)success fail:(ESNetFailure)fail {
    // 安全判断：公钥是否存在
    if (!_globalPubKey || _globalPubKey.length == 0) {
        NSError *error = [NSError errorWithDomain:@"YTSDK" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"未配置RSA公钥"}];
        if (fail) fail(error);
        return;
    }

    // 1. 生成 AES Key / IV / 时间戳
    NSString *aesKey = [EasySRandomUtil generate16BytesRandom];
    NSString *aesIV = [EasySRandomUtil generate16BytesRandom];
    NSString *ts = [EasySRandomUtil timestamp];
    
//    EasySNetWorkManager.sharedWork.timestamp = ts; //负值时间戳
    // 2. 业务参数 -> JSON
//    NSMutableDictionary *allDic = [NSMutableDictionary dictionaryWithDictionary:params];
//    allDic[@"timestamp"] = ts;
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params ?: @{} options:0 error:&jsonError];
    if (jsonError) {
        if (fail) fail(jsonError);
        return;
    }
    NSString *plainJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    // 3. RSA 加密 AES Key & IV
    NSString *encKey = [EasySRSAUtil encryptString:aesKey publicKey:_globalPubKey];
    NSString *encIv = [EasySRSAUtil encryptString:aesIV publicKey:_globalPubKey];

    // 4. AES 加密业务数据
    NSString *encData = [EasySAESUtil aesEncrypt:plainJson key:aesKey iv:aesIV];

    // 5. SHA256 签名
    NSString *signSource = [NSString stringWithFormat:@"%@%@", encData, ts];
    NSString *sign = [EasySHashUtil sha256:signSource];

    // 6. 组装请求体
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    body[@"encryptedKey"] = encKey ?: @"";
    body[@"encryptedIv"] = encIv ?: @"";
    body[@"encryptData"] = encData ?: @"";
    body[@"sign"] = sign ?: @"";
    body[@"timestamp"] = ts ?: @"";

    // 7. 网络请求
    
    NSString *fullUrl = [_baseUrl stringByAppendingString:api];
//    NSString *fullUrl = [local_baseUrl stringByAppendingString:api];
//    NSString *fullUrl = [test_baseUrl stringByAppendingString:api];
//    if (YTSDKIsTest.shared.istest) {
//        fullUrl = [test_baseUrl stringByAppendingString:api];
//    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    // 🔥 设置请求超时时间（单位：秒）
    request.timeoutInterval = YTSDKAPIConfiguration.shared.timeoutInterval; // 10秒超时（最常用）
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [EasySNetWorkUtil requestForHeader:request withTime:ts];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];

    //TODO: 测试数据打印
//    if (EasySSDKStartConfiguration.shared.debugLog) {
//        NSLog(@"------------------------------");
//        NSLog(@"%@=header=%@",api,request.allHTTPHeaderFields);
//        NSLog(@"------------------------------");
//        NSLog(@"%@=body=%@",api,params);
//        NSLog(@"------------------------------");
//    }


    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 请求失败
            if (error) {
                if (fail) fail(error);
                return;
            }

            // 解析返回 JSON
            NSError *respError;
            NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&respError];
            if (respError || ![respDict isKindOfClass:[NSDictionary class]]) {
                NSError *err = [NSError errorWithDomain:@"YTSDK" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"数据解析失败"}];
                if (fail) fail(err);
                return;
            }

            // 判断 data 字段是否存在
            NSString *cipherData = respDict[@"encryptData"];
            if (!cipherData || ![cipherData isKindOfClass:[NSString class]] || cipherData.length == 0) {
                NSError *err = [NSError errorWithDomain:@"YTSDK" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"返回数据为空"}];
                if (fail) fail(err);
                return;
            }

            // AES 解密返回数据
            NSString *originStr = [EasySAESUtil aesDecrypt:cipherData key:aesKey iv:aesIV];
            if (!originStr || originStr.length == 0) {
                NSError *err = [NSError errorWithDomain:@"YTSDK" code:-4 userInfo:@{NSLocalizedDescriptionKey:@"解密失败"}];
                if (fail) fail(err);
                return;
            }

            // 转字典
            NSData *originData = [originStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *originDict = [NSJSONSerialization JSONObjectWithData:originData options:0 error:&respError];
            if (respError) {
                if (fail) fail(respError);
                return;
            }
            
            // 成功回调（明文）
            if (success) success([EasySSDKGeneralTool removeDictionaryNullObject:originDict]);
        });
    }];
    [task resume];
}
+ (void)requestForHeader:(NSMutableURLRequest *)request withTime:(NSString *)timestamp  {
//    NSString *encoded = [UIDevice.es_appName ?: @"" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSDictionary *headerDic = @{@"ip":UIDevice.es_wifiIP ?: @"",
                                @"deviceId":UIDevice.es_idfa ?: @"",
                                @"deviceModel":UIDevice.es_deviceModelName ?: @"",
                                @"osVersion":UIDevice.es_systemVersion ?: @"",
                                @"sdkVersion":YTSDKAPIConfiguration.shared.getSDKVersion ?: @"",
                                @"appName":UIDevice.es_appName ?: @"",
                                @"appPackage":UIDevice.es_appBundleId ?: @"",
                                @"appVersion":UIDevice.es_appVersion ?: @"",
                                @"os":@"1",//设备系统，如0:Android、1:iOS，2:鸿蒙，其他的都归于0安卓
                                @"brand":UIDevice.es_deviceBrand ?: @"",
                                @"timestamp":timestamp ?: @"",
                                @"installSource":@"AppStore",
                                @"sessionId":EasySSDKStartConfiguration.shared.sessionId ?: @""};//APP一次启动的会话ID,除了初始化接口之外，其他接口必传
   
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:headerDic];
    newDic[@"sessionId"] = EasySSDKStartConfiguration.shared.sessionId;
    NSString *headerStr = [EasySRandomUtil jsonStringFromDictionary:newDic];
    NSString *encoded = [headerStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [request setValue:encoded forHTTPHeaderField:@"x-device-agent"];
}




@end
