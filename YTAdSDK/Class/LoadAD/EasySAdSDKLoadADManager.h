//
//  EasySAdSDKLoadADManager.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/11.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class EasySAdSDKLoadADModel;
typedef void (^EasySAdSDKLoadCompletionHandler)(BOOL success,EasySAdSDKLoadADModel * _Nullable model, NSError * _Nullable error);
@interface EasySAdSDKLoadADManager : NSObject

- (void)loadAdData:(NSString *)adType withSlotId:(NSString *)slotId withHandler:(EasySAdSDKLoadCompletionHandler)comple;

@end

NS_ASSUME_NONNULL_END
