//
//  YTSDKStartManager.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/10.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTSDKStartManager.h"
#import "EasySNetWorkUtil.h"
#import "EasySSDKStartConfiguration.h"
#import "EasySNetWorkPath.h"
#import "YTSDKConst.h"
#import "EasySNetWorkManager.h"
#import "EasySSDKStartModel.h"
#import "EasySSDKtrackMagager.h"
#import "UIDevice+EasyS.h"
#import "YTSDKAPIConfiguration.h"

// 接口类型常量，消除魔法数字
typedef NS_ENUM(NSInteger, EasySSDKRequestType) {
    EasySSDKRequestType_Init    = 2,  // 初始化接口
    EasySSDKRequestType_Start   = 3   // 启动接口
};

@interface YTSDKStartManager ()
@property (nonatomic, assign) BOOL isStart;                // SDK 整体启动状态
@property (nonatomic, assign) BOOL isRequesting;           // 防重入：是否正在请求
@property (nonatomic, assign) EasySSDKStartType type;

@end

@implementation YTSDKStartManager

#pragma mark - 单例
+ (instancetype)shared {
    static YTSDKStartManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.isStart = NO;
        instance.isRequesting = NO;
        instance.type = EasySSDKStartType_Begin;
    });
    return instance;
}

#pragma mark - 对外同步
- (void)startWithAppID:(NSString *)appID appKey:(NSString *)appKey completionHandler:(EasySCompletionHandler)completionHandler {
   //获取idfa 权限
    [UIDevice requestTrackingAuthorization];
    
    // 1. 判空回调，防止野指针
    self.type = EasySSDKStartType_Begin;
//    if (!completionHandler) {
//        MySDKLog(@"警告：completionHandler 为空");
//        return;
//    }
    
    // 2. 防重入校验
    if (self.isRequesting) {
        MySDKLog(@"SDK 正在初始化，请勿重复调用");
        NSError *err = [NSError errorWithDomain:@"EasySSDK" code:-999 userInfo:@{NSLocalizedDescriptionKey:@"SDK 正在请求中"}];
        completionHandler(NO, err);
        return;
    }
    
    
    // 3. 赋值账号信息
    EasySSDKStartConfiguration *config = EasySSDKStartConfiguration.shared;
    config.appId = appID ?: @"";
    config.appKey = appKey ?: @"";
    
    // 4. 标记正在请求，锁定状态
    self.isRequesting = YES;
    
    // 5. 弱引用 self，防止 Block 循环引用
    __weak typeof(self) weakSelf = self;
    [self initWithSyncCompletionHandler:^(BOOL success, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        // 6. 请求结束，解除请求锁定
        strongSelf.isRequesting = NO;
        
        // 7. 优先执行外部传入的回调（核心修复）
        completionHandler(success, error);
        
        // 8. 执行代理回调（保留原有逻辑）
//        if ([strongSelf.delegate respondsToSelector:@selector(easySSDKStartStatus:)]) {
//            NSLog(@"====easySSDKStartStatus====");
//            [strongSelf.delegate easySSDKStartStatus:success];
//        }
    }];
}

#pragma mark - 第一步：初始化接口（获取 sessionId）
- (void)initWithSyncCompletionHandler:(EasySCompletionHandler)completionHandler {

    // 判空回调
//    if (!completionHandler) return;
    if (!EasySSDKStartConfiguration.shared.appId || !EasySSDKStartConfiguration.shared.appKey) {
        if (YTSDKAPIConfiguration.shared.debugLog) {
            MySDKLog(@"初始化接口返回：请配置appid和appkey");
        }
        completionHandler(NO,[NSError errorWithDomain:@"star" code:20000 userInfo:@{NSLocalizedDescriptionKey:@"初始化失败：请配置appid和appkey"}]);
        return;
    }
    // 已有 sessionId 直接走第二步
    NSString *appid = EasySSDKStartConfiguration.shared.appId ?:@"";
    NSString *appkey = EasySSDKStartConfiguration.shared.appKey ?:@"";
    NSString *sessionId = EasySSDKStartConfiguration.shared.sessionDic[[NSString stringWithFormat:@"%@+%@",appid,appkey]] ?:@"";
    if (sessionId && sessionId.length > 0) {
        [self startWithSyncCompletionHandler:completionHandler];

        return;
    }
    
    self.isRequesting = YES;
    EasySNetWorkPath *initPath = [[EasySNetWorkPath alloc] initWithType:EasySSDKRequestType_Init withParam:@{}];
    
    [self reportInitStar];
    [EasySNetWorkUtil request:initPath success:^(NSDictionary * _Nonnull respDict) {
        if (YTSDKAPIConfiguration.shared.debugLog) {
            MySDKLog(@"初始化接口返回：%@", respDict);
        }
        
        EasySSDKStartModel *initModel = [[EasySSDKStartModel alloc] initWithDic:respDict];
        // 修复：字符串标准比较 + 判空data
        if ([initModel.code isEqualToString:@"200"] && initModel.data) {
            NSString *sessionId = initModel.data[@"sessionId"];
            if (sessionId && sessionId.length > 0) {
//                NSMutableDictionary * allDic = [[NSMutableDictionary alloc] init];
//                allDic[@"appId"] = EasySSDKStartConfiguration.shared.appId ?:@"";
//                allDic[@"appKey"] = EasySSDKStartConfiguration.shared.appKey ?:@"";
//                allDic[@"sessionId"] = sessionId ?:@"";
                EasySSDKStartConfiguration.shared.sessionDic[[NSString stringWithFormat:@"%@+%@",appid,appkey]] = sessionId;
                // 执行第二步启动接口
                [self startWithSyncCompletionHandler:completionHandler];
            } else {
                // sessionId 为空，业务异常
                NSError *err = [NSError errorWithDomain:@"init-verify" code:20001 userInfo:@{NSLocalizedDescriptionKey:@"初始化失败：sessionId 为空"}];
                self.isRequesting = NO;
                completionHandler(NO, err);
                [self reportInitResult:1];//init结果失败埋点
            }
        } else {

            // 接口返回非200
            NSString *msg = [NSString stringWithFormat:@"初始化接口异常，code = %@", initModel.code ?: @""];
            NSError *err = [NSError errorWithDomain:@"init-verify" code:-1002 userInfo:@{NSLocalizedDescriptionKey:msg}];
            self.isRequesting = NO;
            completionHandler(NO, err);
            [self reportInitResult:1];//init结果失败埋点
        }
        
    } fail:^(NSError * _Nonnull error) {
        MySDKLog(@"初始化接口网络失败：%@", error.localizedDescription);
        self.isRequesting = NO;
        completionHandler(NO, error);
        [self reportInitResult:1];//init结果失败埋点

    }];
}

#pragma mark - 第二步：启动接口
- (void)startWithSyncCompletionHandler:(EasySCompletionHandler)completionHandler {
//    if (!completionHandler) return;
    [self reportInitResult:0]; //init结果成功埋点
    // 已启动成功，直接回调
    NSString *appid = EasySSDKStartConfiguration.shared.appId ?:@"";
    NSString *appkey = EasySSDKStartConfiguration.shared.appKey ?:@"";
    BOOL starType = EasySSDKStartConfiguration.shared.startDic[[NSString stringWithFormat:@"%@+%@",appid,appkey]] ?:NO;
    if (starType) {
        self.isRequesting = NO;
        completionHandler(YES, nil);
//        [self reportStartStartResult:0];//start结果成功埋点
        return;
    }
    
    [self reportStartStart];//start开始埋点
    EasySNetWorkPath *startPath = [[EasySNetWorkPath alloc] initWithType:EasySSDKRequestType_Start withParam:@{}];
    [EasySNetWorkUtil request:startPath success:^(NSDictionary * _Nonnull respDict) {
        if (YTSDKAPIConfiguration.shared.debugLog) {
            MySDKLog(@"启动接口返回：%@", respDict);
        }
        
        EasySSDKStartModel *startModel = [[EasySSDKStartModel alloc] initWithDic:respDict];
        if ([startModel.code isEqualToString:@"200"] && startModel.data) {
            // 修复：字典对象转BOOL，做空保护
            id isStartObj = startModel.data[@"start"];
            BOOL isStart = [isStartObj boolValue];
            self.isStart = isStart;
            
            self.isRequesting = NO;
            completionHandler(isStart, nil);
            
            if (isStart) { //成功
                [self reportStartStartResult:0];//start结果成功埋点
            }else {
                [self reportStartStartResult:1];//start结果失败埋点
            }
        } else {
            
            if (YTSDKAPIConfiguration.shared.debugLog) {
                MySDKLog(@"启动接口返回：%@", respDict);
            }
            NSString *msg = [NSString stringWithFormat:@"启动接口异常，code = %@", startModel.code ?: @""];
            NSError *err = [NSError errorWithDomain:@"start-check" code:-2001 userInfo:@{NSLocalizedDescriptionKey:msg}];
            self.isRequesting = NO;
            completionHandler(NO, err);
            [self reportStartStartResult:1];//start结果失败埋点

        }
        
    } fail:^(NSError * _Nonnull error) {
        MySDKLog(@"启动接口网络失败：%@", error.localizedDescription);
        self.isRequesting = NO;
        completionHandler(NO, error);
        [self reportStartStartResult:1];//start结果失败埋点

    }];
}


#pragma mark - APP调用初始化时
- (void)reportInitStar {
    [EasySSDKtrackMagager reportLog:@"init" withRequestId:nil withPlacementId:nil withPlacementType:nil withAdId:nil withResult:nil withAdModelType:nil withBtnName:nil withNextStep:nil];

}
#pragma mark - APP调用初始化的结果
//处理结果：0-成功、1-失败
- (void)reportInitResult:(NSInteger)result {
    [EasySSDKtrackMagager reportLog:@"init_result" withRequestId:nil withPlacementId:nil withPlacementType:nil withAdId:nil withResult:[NSString stringWithFormat:@"%d",result] withAdModelType:nil withBtnName:nil withNextStep:nil];
}


#pragma mark - APP调用启动时
- (void)reportStartStart {
    [EasySSDKtrackMagager reportLog:@"start" withRequestId:nil withPlacementId:nil withPlacementType:nil withAdId:nil withResult:nil withAdModelType:nil withBtnName:nil withNextStep:nil];

}

#pragma mark - APP调用启动的结果
- (void)reportStartStartResult:(NSInteger)result {
    [EasySSDKtrackMagager reportLog:@"start_result" withRequestId:nil withPlacementId:nil withPlacementType:nil withAdId:nil withResult:[NSString stringWithFormat:@"%d",result] withAdModelType:nil withBtnName:nil withNextStep:nil];

}


@end
