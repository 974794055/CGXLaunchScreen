//
//  CGXLaunchScreenSkipButton.h
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

#import <UIKit/UIKit.h>

/**
 *  倒计时类型
 */
typedef NS_ENUM(NSInteger,CGXLaunchSkipType) {
    CGXLaunchSkipTypeNone      = 1,//无
    /** 方形 */
    CGXLaunchSkipTypeTime      = 2,//方形:倒计时
    CGXLaunchSkipTypeText      = 3,//方形:跳过
    CGXLaunchSkipTypeTimeText  = 4,//方形:倒计时+跳过 (default)
    /** 圆形 */
    CGXLaunchSkipTypeRoundTime = 5,//圆形:倒计时
    CGXLaunchSkipTypeRoundText = 6,//圆形:跳过
    CGXLaunchSkipTypeRoundProgressTime = 7,//圆形:进度圈+倒计时
    CGXLaunchSkipTypeRoundProgressText = 8,//圆形:进度圈+跳过
};

@interface CGXLaunchScreenButton : UIButton

- (instancetype)initWithSkipType:(CGXLaunchSkipType)skipType;
- (void)startRoundDispathTimerWithDuration:(CGFloat )duration;
- (void)setTitleWithSkipType:(CGXLaunchSkipType)skipType duration:(NSInteger)duration;

@end
