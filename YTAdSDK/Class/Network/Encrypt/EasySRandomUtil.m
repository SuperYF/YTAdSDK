//
//  EasySRandomUtil.m
//  YiTuiDemo
//
//  Created by renpin-ios on 2026/6/3.
//  Copyright © 2026 Taku. All rights reserved.
//

#import "EasySRandomUtil.h"

@implementation EasySRandomUtil
+ (NSString *)generate16BytesRandom {
    NSString *chars = @"abcdefghijklmnopqrstuvwxyz0123456789";
    NSMutableString *result = [NSMutableString stringWithCapacity:16];
    for (int i = 0; i < 16; i++) {
        int index = arc4random_uniform((uint32_t)chars.length);
        unichar c = [chars characterAtIndex:index];
        [result appendString:[NSString stringWithCharacters:&c length:1]];
    }
    return result;
}

+ (NSString *)timestamp {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%.0f", time];
}
//转化json
+ (NSString *)jsonStringFromDictionary:(NSDictionary *)dict {
    if (!dict) return nil;
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    if (error) return nil;
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
