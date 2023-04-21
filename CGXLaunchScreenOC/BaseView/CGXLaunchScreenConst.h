//
//  CGXLaunchScreenConst.h
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

#import <UIKit/UIKit.h>

#define CGXLaunchScreenDeprecated(instead) __attribute__((deprecated(instead)))

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define GXLaunchScreenW ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define GXLaunchScreenH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#else
#define GXLaunchScreenW   [UIScreen mainScreen].bounds.size.width
#define GXLaunchScreenH  [UIScreen mainScreen].bounds.size.height
#endif

#define GXLaunchFullScreen ({\
    BOOL iPhoneXSeries = NO; \
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {\
       iPhoneXSeries = YES;\
    }\
    if (@available(iOS 11.0, *)) { \
       UIWindow *window = [[[UIApplication sharedApplication] delegate] window]; \
       iPhoneXSeries = window.safeAreaInsets.bottom > 0; \
    } \
      iPhoneXSeries; \
})

#define GXLaunchIsURLString(string)  ([string hasPrefix:@"https://"] || [string hasPrefix:@"http://"]) ? YES:NO
#define GXLaunchStringContainsSubString(string,subString)  ([string rangeOfString:subString].location == NSNotFound) ? NO:YES

#ifdef DEBUG
#define CGXLaunchScreenLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define CGXLaunchScreenLog(...)
#endif

#define GXLaunchISGIFTypeWithData(data)\
({\
BOOL result = NO;\
if(!data) result = NO;\
uint8_t c;\
[data getBytes:&c length:1];\
if(c == 0x47) result = YES;\
(result);\
})

#define GXLaunchISVideoTypeWithPath(path)\
({\
BOOL result = NO;\
if([path hasSuffix:@".mp4"])  result =  YES;\
(result);\
})

#define GXLaunchDataWithFileName(name)\
({\
NSData *data = nil;\
NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];\
if([[NSFileManager defaultManager] fileExistsAtPath:path]){\
    data = [NSData dataWithContentsOfFile:path];\
}\
(data);\
})

#define GXLaunchDISPATCH_SOURCE_CANCEL_SAFE(time) if(time)\
{\
dispatch_source_cancel(time);\
time = nil;\
}

#define GXLaunchREMOVE_FROM_SUPERVIEW_SAFE(view) if(view)\
{\
[view removeFromSuperview];\
view = nil;\
}

UIKIT_EXTERN NSString *const GXLaunchCacheImageUrlStringKey;
UIKIT_EXTERN NSString *const GXLaunchCacheVideoUrlStringKey;

UIKIT_EXTERN NSString *const CGXLaunchScreenWaitDataDurationArriveNotification;
UIKIT_EXTERN NSString *const CGXLaunchScreenDetailPageWillShowNotification;
UIKIT_EXTERN NSString *const CGXLaunchScreenDetailPageShowFinishNotification;
/** GIFImageCycleOnce = YES(GIF不循环)时, GIF动图播放完成通知 */
UIKIT_EXTERN NSString *const CGXLaunchScreenGIFImageCycleOnceFinishNotification;
/** videoCycleOnce = YES(视频不循环时) ,video播放完成通知 */
UIKIT_EXTERN NSString *const CGXLaunchScreenVideoCycleOnceFinishNotification;
/** 视频播放失败通知 */
UIKIT_EXTERN NSString *const CGXLaunchScreenVideoPlayFailedNotification;
UIKIT_EXTERN BOOL CGXLaunchScreenPrefersHomeIndicatorAutoHidden;



