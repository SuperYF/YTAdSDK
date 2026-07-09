//
//  YTSDKCustomBaseAdapter.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/26.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "YTSDKCustomBaseAdapter.h"
#import "YTSDKCustomInitAdapter.h"

@implementation YTSDKCustomBaseAdapter
#pragma mark - adapter init class name define
- (Class)initializeClassName {
    //返回文档 步骤一 中创建的初始化适配器类
    return [YTSDKCustomInitAdapter class];
}
@end
