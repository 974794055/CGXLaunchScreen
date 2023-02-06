//
//  CGXLaunchScreenImageManager.h
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CGXLaunchScreenDownloader.h"

typedef NS_OPTIONS(NSUInteger, CGXLaunchScreenImageOptions) {
    /** 有缓存,读取缓存,不重新下载,没缓存先下载,并缓存 */
    CGXLaunchScreenImageDefault = 1 << 0,
    /** 只下载,不缓存 */
    CGXLaunchScreenImageOnlyLoad = 1 << 1,
    /** 先读缓存,再下载刷新图片和缓存 */
    CGXLaunchScreenImageRefreshCached = 1 << 2 ,
    /** 后台缓存本次不显示,缓存OK后下次再显示(建议使用这种方式)*/
    CGXLaunchScreenImageCacheInBackground = 1 << 3
};

typedef void(^XHExternalCompletionBlock)(UIImage * _Nullable image,NSData * _Nullable imageData, NSError * _Nullable error, NSURL * _Nullable imageURL);

@interface CGXLaunchScreenImageManager : NSObject

+(nonnull instancetype )sharedManager;
- (void)loadImageWithURL:(nullable NSURL *)url options:(CGXLaunchScreenImageOptions)options progress:(nullable CGXLaunchScreenDownloadProgressBlock)progressBlock completed:(nullable XHExternalCompletionBlock)completedBlock;

@end
