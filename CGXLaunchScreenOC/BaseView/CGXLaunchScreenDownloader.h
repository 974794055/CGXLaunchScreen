//
//  CGXLaunchScreenDownloaderManager.h
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - CGXLaunchScreenDownload

typedef void(^CGXLaunchScreenDownloadProgressBlock)(unsigned long long total, unsigned long long current);

typedef void(^CGXLaunchScreenDownloadImageCompletedBlock)(UIImage *_Nullable image, NSData * _Nullable data, NSError * _Nullable error);

typedef void(^CGXLaunchScreenDownloadVideoCompletedBlock)(NSURL * _Nullable location, NSError * _Nullable error);

typedef void(^CGXLaunchScreenBatchDownLoadAndCacheCompletedBlock) (NSArray * _Nonnull completedArray);

@protocol CGXLaunchScreenDownloadDelegate <NSObject>

- (void)downloadFinishWithURL:(nonnull NSURL *)url;

@end

@interface CGXLaunchScreenDownload : NSObject
@property (assign, nonatomic ,nonnull)id<CGXLaunchScreenDownloadDelegate> delegate;
@end

@interface CGXLaunchScreenImageDownload : CGXLaunchScreenDownload

@end

@interface CGXLaunchScreenVideoDownload : CGXLaunchScreenDownload

@end

#pragma mark - CGXLaunchScreenDownloader
@interface CGXLaunchScreenDownloader : NSObject

+(nonnull instancetype )sharedDownloader;

- (void)downloadImageWithURL:(nonnull NSURL *)url progress:(nullable CGXLaunchScreenDownloadProgressBlock)progressBlock completed:(nullable CGXLaunchScreenDownloadImageCompletedBlock)completedBlock;

- (void)downLoadImageAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray;
- (void)downLoadImageAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray completed:(nullable CGXLaunchScreenBatchDownLoadAndCacheCompletedBlock)completedBlock;

- (void)downloadVideoWithURL:(nonnull NSURL *)url progress:(nullable CGXLaunchScreenDownloadProgressBlock)progressBlock completed:(nullable CGXLaunchScreenDownloadVideoCompletedBlock)completedBlock;

- (void)downLoadVideoAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray;
- (void)downLoadVideoAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray completed:(nullable CGXLaunchScreenBatchDownLoadAndCacheCompletedBlock)completedBlock;

@end

