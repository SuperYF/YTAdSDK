//
//  EasySSDKStartModel.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/10.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasySSDKStartModel : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *trackId;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSDictionary *data;

- (instancetype)initWithDic:(NSDictionary *)result;
@end

NS_ASSUME_NONNULL_END
