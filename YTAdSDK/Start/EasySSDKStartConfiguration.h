//
//  EasySSDKStartConfiguration.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/10.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasySSDKStartConfiguration : NSObject
@property (nonatomic, strong) NSString *appId; //宿主应用ID，在易推申请的应用ID
@property (nonatomic, strong) NSString *appKey; //应用key
//@property (nonatomic, assign) BOOL debugLog; //是否开启debug打印模式


@property (nonatomic, strong) NSString *sessionId; //应用key


@property (nonatomic, strong) NSMutableDictionary *sessionDic; //当前appid是否存在session
@property (nonatomic, strong) NSMutableDictionary *startDic; //当前appid是否初始化成功



+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END

