//
//  EasySImageDownloader.h
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/15.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

NS_ASSUME_NONNULL_BEGIN
typedef void(^MySDKImageDownloadCompleteBlock)(UIImage * _Nullable image, NSError * _Nullable error);

@interface EasySImageDownloader : NSObject
/// 单例
+ (instancetype)sharedDownloader;

/// 异步下载网络图片
/// @param url 图片URL
/// @param completed 完成回调（主线程）
- (void)downloadImageWithURL:(NSString *)url completed:(MySDKImageDownloadCompleteBlock)completed;

- (void)removeImageCacheForKey:(NSString *)key;


- (void)setImageWithUIImageView:(UIImageView *)imv withURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
