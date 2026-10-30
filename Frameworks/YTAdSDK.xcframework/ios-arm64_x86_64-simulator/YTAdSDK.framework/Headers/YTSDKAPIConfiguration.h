//
//  YTSDKAPIConfiguration.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTSDKAPIConfiguration : NSObject
+ (instancetype)shared;

@property (nonatomic, assign) BOOL debugLog; //是否开启debug打印模式
@property (nonatomic, assign) NSInteger timeoutInterval; //
- (NSString *)getSDKVersion;

@end

NS_ASSUME_NONNULL_END
