//
//  CGXLaunchScreenConfiguration.h
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CGXLaunchScreenButton.h"
#import <AVFoundation/AVFoundation.h>
#import "CGXLaunchScreenImageManager.h"


NS_ASSUME_NONNULL_BEGIN

/** 显示完成动画时间默认时间 */
static CGFloat const CGXLaunchShowFinishAnimateTimeDefault = 0.8;

/** 显示完成动画类型 */
typedef NS_ENUM(NSInteger , CGXLaunchShowFinishAnimate) {
    /** 无动画 */
    CGXLaunchShowFinishAnimateNone = 1,
    /** 普通淡入(default) */
    CGXLaunchShowFinishAnimateFadein = 2,
    /** 放大淡入 */
    CGXLaunchShowFinishAnimateLite = 3,
    /** 左右翻转(类似网易云音乐) */
    CGXLaunchShowFinishAnimateFlipFromLeft = 4,
    /** 下上翻转 */
    CGXLaunchShowFinishAnimateFlipFromBottom = 5,
    /** 向上翻页 */
    CGXLaunchShowFinishAnimateCurlUp = 6,
};

#pragma mark - 公共属性
@interface CGXLaunchScreenConfiguration : NSObject

/** 停留时间(default 5 ,单位:秒) */
@property(nonatomic,assign)NSInteger duration;

/** 跳过按钮类型(default CGXLaunchSkipTypeTimeText) */
@property(nonatomic,assign)CGXLaunchSkipType skipButtonType;

/** 显示完成动画(default CGXLaunchShowFinishAnimateFadein) */
@property(nonatomic,assign)CGXLaunchShowFinishAnimate CGXLaunchShowFinishAnimate;

/** 显示完成动画时间(default 0.8 , 单位:秒) */
@property(nonatomic,assign)CGFloat CGXLaunchShowFinishAnimateTime;

/** 设置开屏广告的frame(default [UIScreen mainScreen].bounds) */
@property (nonatomic,assign) CGRect frame;

/** 程序从后台恢复时,是否需要展示广告(defailt NO) */
@property (nonatomic,assign) BOOL showEnterForeground;

/** 点击打开页面参数 */
@property (nonatomic, strong) id openModel;

/** 自定义跳过按钮(若定义此视图,将会自定替换系统跳过按钮) */
@property(nonatomic,strong) UIView *customSkipView;

/** 子视图(若定义此属性,这些视图将会被自动添加在广告视图上,frame相对于window) */
@property(nonatomic,copy,nullable) NSArray<UIView *> *subViews;

@end

#pragma mark - 图片广告相关
@interface CGXLaunchScreenImageAdConfiguration : CGXLaunchScreenConfiguration

/** image本地图片名(jpg/gif图片请带上扩展名)或网络图片URL string */
@property(nonatomic,copy)NSString *imageNameOrURLString;

/** 图片广告缩放模式(default UIViewContentModeScaleToFill) */
@property(nonatomic,assign)UIViewContentMode contentMode;

/** 缓存机制(default CGXLaunchScreenImageDefault) */
@property(nonatomic,assign)CGXLaunchScreenImageOptions imageOption;

/** 设置GIF动图是否只循环播放一次(YES:只播放一次,NO:循环播放,default NO,仅对动图设置有效) */
@property (nonatomic, assign) BOOL GIFImageCycleOnce;

+(CGXLaunchScreenImageAdConfiguration *)defaultConfiguration;

@end

#pragma mark - 视频广告相关
@interface CGXLaunchScreenVideoAdConfiguration : CGXLaunchScreenConfiguration

/** video本地名或网络链接URL string */
@property(nonatomic,copy)NSString *videoNameOrURLString;

/** 视频缩放模式(default AVLayerVideoGravityResizeAspectFill) */
@property (nonatomic, copy) AVLayerVideoGravity videoGravity;

/** 设置视频是否只循环播放一次(YES:只播放一次,NO循环播放,default NO) */
@property (nonatomic, assign) BOOL videoCycleOnce;

/** 是否关闭音频(default NO) */
@property (nonatomic, assign) BOOL muted;

+(CGXLaunchScreenVideoAdConfiguration *)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
