//
//  EasySCustomNavigationBarView.h
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/18.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol EasySCustomNavigationBarViewDelegate <NSObject>

- (void)navigationBarBack;


- (void)navigationBarClose;


@end
@interface EasySCustomNavigationBarView : UIView

@property (nonatomic, weak) id<EasySCustomNavigationBarViewDelegate> delegate;
@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
