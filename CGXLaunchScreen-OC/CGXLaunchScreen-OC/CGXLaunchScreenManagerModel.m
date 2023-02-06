//
//  CGXLaunchScreenManagerModel.m
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2018/3/10
//  Copyright © 2019年 CGX.com. All rights reserved.
// 
//  广告数据模型
#import "CGXLaunchScreenManagerModel.h"

@implementation CGXLaunchScreenManagerModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.content = dict[@"content"];
        self.openUrl = dict[@"openUrl"];
        self.duration = [dict[@"duration"] integerValue];
        self.contentSize = dict[@"contentSize"];
    }
    return self;
}
-(CGFloat)width
{
    return [[[self.contentSize componentsSeparatedByString:@"*"] firstObject] floatValue];
}
-(CGFloat)height
{
    return [[[self.contentSize componentsSeparatedByString:@"*"] lastObject] floatValue];
}
@end
