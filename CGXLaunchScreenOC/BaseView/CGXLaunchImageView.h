//
//  CGXLaunchImageView.h
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

#import <UIKit/UIKit.h>

/** 启动图来源 */
typedef NS_ENUM(NSInteger,CGXLaunchImageViewLaunchType) {
    /** LaunchImage(default) */
    CGXLaunchImageViewLaunchTypeLaunchImage = 1,
    /** LaunchScreen.storyboard */
    CGXLaunchImageViewLaunchTypeLaunchScreen = 2,
};

@interface CGXLaunchImageView : UIImageView

- (instancetype)initWithSourceType:(CGXLaunchImageViewLaunchType)sourceType;

@end
