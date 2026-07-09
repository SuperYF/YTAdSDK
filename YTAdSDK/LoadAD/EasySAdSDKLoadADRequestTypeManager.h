//
//  EasySAdSDKLoadADRequestTypeManager.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/13.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 接口类型常量，消除魔法数字
typedef NS_ENUM(NSInteger, EasySAdSDKLoadADRequestType) {
    EasySAdSDKLoadADRequestType_Begin    = 1,  // 初始化接口
    EasySAdSDKLoadADRequestType_Going    = 2,  // 初始化接口
    EasySAdSDKLoadADRequestType_Finish   = 3 ,  // 启动接口
    EasySAdSDKLoadADRequestType_Error   = 4  ,// 启动接口
    EasySAdSDKLoadADRequestType_Other   = 5   // 启动接口
};

@interface EasySAdSDKLoadADRequestTypeManager : NSObject
//@property (nonatomic, assign) EasySAdSDKLoadADRequestType type;
@property (nonatomic, strong) NSDictionary *requestTypeDic;

+ (instancetype)shared;

//更新请求状态
- (void)upDataSlotId:(NSString *)slotId withType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
