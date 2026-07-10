//
//  EasySNetWorkPath.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/9.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol EasySNetWorkType <NSObject>

- (NSString *)path;         // 接口路径
- (NSString *)method;       // 请求方式
- (NSDictionary *)params;   // 参数
//- (NSTimeInterval)timeout;  // 超时
//- (NSDictionary *)headers;  // 请求头

@end
NS_ASSUME_NONNULL_BEGIN

@interface EasySNetWorkPath : NSObject <EasySNetWorkType>
- (instancetype)initWithType:(NSInteger)type withParam:(NSDictionary *)param;


//错误数据埋点
- (instancetype)initErrorLog:(NSString *)requestId withSlotId:(NSString *)slotId withAdType:(NSInteger)adType withstep:(NSString *)step withErrorCode:(NSString *)errorCode withRawData:(NSDictionary *)rawData;
@end

NS_ASSUME_NONNULL_END
