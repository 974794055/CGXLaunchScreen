//
//  CGXLaunchScreenManager.h
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2018/3/10.
//  Copyright © 2019 CGX. All rights reserved.
// 


#import <Foundation/Foundation.h>

#import "CGXLaunchScreenOC.h"

#import "CGXLaunchScreenManagerModel.h"

@interface CGXLaunchScreenManager : NSObject

+(CGXLaunchScreenManager *)shareManager;
#pragma mark - 图片开屏广告-网络数据-示例
//图片开屏广告 - 网络数据
-(void)updateSourceType:(CGXLaunchImageViewLaunchType)sourceType;

@end
