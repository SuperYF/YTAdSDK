//
//  EasySSDKGeneralTool.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/15.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface EasySSDKGeneralTool : NSObject
/// 校验是否为合法 http/https 网址
+ (BOOL)isValidWebURL:(NSString *)urlStr;

+ (NSDictionary *)removeDictionaryNullObject:(NSDictionary *)resultDic;

+ (NSArray *)removeArrayNullObject:(NSArray *)resultArr;

//+ (UIImage *)imageNamed:(NSString *)name;

+ (UIImage *)imageNamed:(NSString *)name withClass:(Class)aClass;


//超时判断
+ (BOOL)isRequestTimeoutError:(NSError *)error;

+ (BOOL)isNumberValid:(NSNumber *)num;
@end

NS_ASSUME_NONNULL_END
