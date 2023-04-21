//
//  CGXLaunchScreenImageManager.m
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

#import "CGXLaunchScreenImageManager.h"
#import "CGXLaunchScreenCache.h"

@interface CGXLaunchScreenImageManager()

@property(nonatomic,strong) CGXLaunchScreenDownloader *downloader;
@end

@implementation CGXLaunchScreenImageManager

+(nonnull instancetype )sharedManager{
    static CGXLaunchScreenImageManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[CGXLaunchScreenImageManager alloc] init];
        
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _downloader = [CGXLaunchScreenDownloader sharedDownloader];
    }
    return self;
}

- (void)loadImageWithURL:(nullable NSURL *)url options:(CGXLaunchScreenImageOptions)options progress:(nullable CGXLaunchScreenDownloadProgressBlock)progressBlock completed:(nullable CGXLaunchExternalCompletionBlock)completedBlock{
    if(!options) options = CGXLaunchScreenImageDefault;
    if(options & CGXLaunchScreenImageOnlyLoad){
        [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
            if(completedBlock) completedBlock(image,data,error,url);
        }];
    }else if (options & CGXLaunchScreenImageRefreshCached){
        NSData *imageData = [CGXLaunchScreenCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock) completedBlock(image,imageData,nil,url);
        [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
            if(completedBlock) completedBlock(image,data,error,url);
            [CGXLaunchScreenCache async_saveImageData:data imageURL:url completed:nil];
        }];
    }else if (options & CGXLaunchScreenImageCacheInBackground){
        NSData *imageData = [CGXLaunchScreenCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock){
            completedBlock(image,imageData,nil,url);
        }else{
            [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                [CGXLaunchScreenCache async_saveImageData:data imageURL:url completed:nil];
            }];
        }
    }else{//default
        NSData *imageData = [CGXLaunchScreenCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock){
            completedBlock(image,imageData,nil,url);
        }else{
            [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                if(completedBlock) completedBlock(image,data,error,url);
                [CGXLaunchScreenCache async_saveImageData:data imageURL:url completed:nil];
            }];
        }
    }
}

@end
