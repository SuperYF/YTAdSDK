//
//  EasySImageDownloader.m
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/15.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import "EasySImageDownloader.h"
#import "YTSDKConst.h"
#import "EasySSDKStartConfiguration.h"
#import "YTSDKAPIConfiguration.h"

@interface EasySImageDownloader ()
@property (nonatomic, strong) NSCache<NSString *, UIImage *> *imageCache;
@end

@implementation EasySImageDownloader

+ (instancetype)sharedDownloader {
    static EasySImageDownloader *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageCache = [[NSCache alloc] init];
        _imageCache.countLimit = 20; // 最多缓存100张
    }
    return self;
}
- (void)setImageWithUIImageView:(UIImageView *)imv withURL:(NSString *)url  {
    [self downloadImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (image) {
            imv.image = image;
        }
    }];
}

- (void)downloadImageWithURL:(NSString *)url completed:(MySDKImageDownloadCompleteBlock)completed {
    if (!url || url.length == 0) {
        NSError *err = [NSError errorWithDomain:MySDKErrorDomain code:MySDKErrorCodeInvalidParam userInfo:@{NSLocalizedDescriptionKey:@"图片URL为空"}];
        !completed ?: completed(nil, err);
        return;
    }

    // ✅ 修复：key 必须强转为 id<NSCopying>
    UIImage *cacheImage = [self.imageCache objectForKey:url];
    if (cacheImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completed ?: completed(cacheImage, nil);
        });
        return;
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:YTSDKAPIConfiguration.shared.timeoutInterval];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !completed ?: completed(nil, error);
            });
            return;
        }

        UIImage *image = [UIImage imageWithData:data];
        if (!image) {
            NSError *err = [NSError errorWithDomain:MySDKErrorDomain code:MySDKErrorCodeNetworkError userInfo:@{NSLocalizedDescriptionKey:@"图片数据无效"}];
            dispatch_async(dispatch_get_main_queue(), ^{
                !completed ?: completed(nil, err);
            });
            return;
        }

        // ✅ 修复：key 必须强转为 id<NSCopying>
        [self.imageCache setObject:image forKey:(id<NSCopying>)url];

        dispatch_async(dispatch_get_main_queue(), ^{
            !completed ?: completed(image, nil);
        });
    }];

    [task resume];
}

// 删除单张指定图片
- (void)removeImageCacheForKey:(NSString *)key {
    if (!key) return;
    [self.imageCache removeObjectForKey:key];
}
@end
