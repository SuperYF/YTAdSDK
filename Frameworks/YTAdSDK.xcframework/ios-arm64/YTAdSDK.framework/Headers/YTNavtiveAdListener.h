//
//  YTNavtiveAdListener.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/17.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "YTSDKNavtiveAdDelegete.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YTNavtiveAdDelegete;
//@class YTSDKNavtiveAdDelegete;
@interface YTNavtiveAdListener : NSObject
//+ (instancetype)shared;

@property(nonatomic) CGSize adSize;//设置宽高
@property(nonatomic, weak) UIViewController *rootViewController;
@property(nonatomic) BOOL sizeToFit;
@property(nonatomic, weak) id<YTNavtiveAdDelegete> delegate;
@property (nonatomic, strong) NSString *slotId;//信息流广告位ID

//初始化
- (instancetype)initWithSlot:(NSString * _Nullable)slot adSize:(CGSize)size;

- (BOOL)isAdReady:(NSString *)slotId;

- (void)setExpressViewAcceptedSize:(CGSize)size;

- (void)render;

//销毁广告
- (void)destroy;
- (void)load;


@end

NS_ASSUME_NONNULL_END
