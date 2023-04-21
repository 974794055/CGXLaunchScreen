//
//  CGXLaunchScreenImageView.h
//  CGXLaunchScreen-OC
//
//  Created by 曹贵鑫 on 2019/11/9.
//  Copyright © 2019 CGX. All rights reserved.
//

#import "CGXLaunchAnimatedImageView.h"
#import "CGXLaunchScreenImageManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGXLaunchScreenImageView : CGXLaunchAnimatedImageView
@property (nonatomic, copy) void(^click)(CGPoint point);
@end

@interface CGXLaunchScreenImageView (CGXLaunchScreenCache)

/**
 设置url图片

 @param url 图片url
 */
- (void)gx_setImageWithURL:(nonnull NSURL *)url;

/**
 设置url图片

 @param url 图片url
 @param placeholder 占位图
 */
- (void)gx_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder;

/**
 设置url图片

 @param url 图片url
 @param placeholder 占位图
 @param options CGXLaunchScreenImageOptions
 */
- (void)gx_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(CGXLaunchScreenImageOptions)options;

/**
 设置url图片

 @param url 图片url
 @param placeholder 占位图
 @param completedBlock CGXLaunchExternalCompletionBlock
 */
- (void)gx_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable CGXLaunchExternalCompletionBlock)completedBlock;

/**
 设置url图片

 @param url 图片url
 @param completedBlock CGXLaunchExternalCompletionBlock
 */
- (void)gx_setImageWithURL:(nonnull NSURL *)url completed:(nullable CGXLaunchExternalCompletionBlock)completedBlock;


/**
 设置url图片

 @param url 图片url
 @param placeholder 占位图
 @param options CGXLaunchScreenImageOptions
 @param completedBlock CGXLaunchExternalCompletionBlock
 */
- (void)gx_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(CGXLaunchScreenImageOptions)options completed:(nullable CGXLaunchExternalCompletionBlock)completedBlock;

/**
 设置url图片

 @param url 图片url
 @param placeholder 占位图
 @param GIFImageCycleOnce gif是否只循环播放一次
 @param options CGXLaunchScreenImageOptions
 @param cycleOnceFinishBlock gif播放完回调(GIFImageCycleOnce = YES 有效)
 @param completedBlock CGXLaunchExternalCompletionBlock
 */
- (void)gx_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder GIFImageCycleOnce:(BOOL)GIFImageCycleOnce options:(CGXLaunchScreenImageOptions)options GIFImageCycleOnceFinish:(void(^_Nullable)(void))cycleOnceFinishBlock completed:(nullable CGXLaunchExternalCompletionBlock)completedBlock ;

@end

NS_ASSUME_NONNULL_END
