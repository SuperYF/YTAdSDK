//
//  YTSDKNativeExpressView.h
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/9.
//  Copyright © 2026 Taku. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YTAdSDKLoadADModel,YTSDKNativeExpressView,YTSDKNavtiveAdModel;
//typedef NS_ENUM(NSInteger, EasySNativeExpressAdModelType) {
//    EasySNativeExpressType_LeftImg = 0,             // 左图 右文
//    EasySNativeExpressType_RightImg = 1,          //  右图 左文
//    EasySNativeExpressType_UpImg = 2,    // 上图 下文
////    EasySNativeExpressType_LeftImg = 3,            // click Ad 点击广告
//
//};
@protocol YTSDKNativeExpressDelegate <NSObject>

- (void)onAdCloseClick:(YTSDKNativeExpressView *)adView;

/// 点击广告跳转H5
- (void)onAdClick:(YTSDKNativeExpressView *)adView  withNextStep:(NSInteger)nextStep;

- (void)onAdWillMoveToWindow:(YTSDKNativeExpressView *)adView;

@end
@interface YTSDKNativeExpressView : UIView
@property(nonatomic, weak) id<YTSDKNativeExpressDelegate> delegate;
@property (nonatomic, assign) CGSize nativeSize;
@property (nonatomic, strong) YTSDKNavtiveAdModel *nativeModel;
- (void)setUpSubviews:(YTAdSDKLoadADModel *)model withAdImage:(UIImage *)image;

- (void)setUpSubviews:(YTAdSDKLoadADModel *)model withAdImage:(UIImage *)image withRootViewController:(UIViewController *)rootVC ;

@end

NS_ASSUME_NONNULL_END
