//
//  EasySNetWorkManager.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/8.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasySNetWorkManager : NSObject
+ (instancetype)sharedWork ;

@property (nonatomic, strong) NSString *timestamp;


//@property (nonatomic, strong) NSString *placementId; //代码位ID

//@property (nonatomic, strong) NSString *sessionId; //会话id

//@property (nonatomic, strong) NSString *appId; //会话id


//@property (nonatomic, strong) NSMutableDictionary *starDic; //会话信息保存

@end

NS_ASSUME_NONNULL_END
