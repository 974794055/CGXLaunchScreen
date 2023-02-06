//
//  CGXLaunchScreenVideoView.h
//  CGXLaunchScreen-OC
//
//  Created by 曹贵鑫 on 2019/11/9.
//  Copyright © 2019 CGX. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#if __has_include(<CGXLaunchAnimatedImage/CGXLaunchAnimatedImage.h>)
#import <CGXLaunchAnimatedImage/CGXLaunchAnimatedImage.h>
#else
#import "CGXLaunchAnimatedImage.h"
#endif

#if __has_include(<CGXLaunchAnimatedImage/CGXLaunchAnimatedImageView.h>)
#import <CGXLaunchAnimatedImage/CGXLaunchAnimatedImageView.h>
#else
#import "CGXLaunchAnimatedImageView.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CGXLaunchScreenVideoView : UIView
@property (nonatomic, copy) void(^click)(CGPoint point);
@property (nonatomic, strong) AVPlayerViewController *videoPlayer;
@property (nonatomic, assign) MPMovieScalingMode videoScalingMode;
@property (nonatomic, assign) AVLayerVideoGravity videoGravity;
@property (nonatomic, assign) BOOL videoCycleOnce;
@property (nonatomic, assign) BOOL muted;
@property (nonatomic, strong) NSURL *contentURL;

-(void)stopVideoPlayer;
@end

NS_ASSUME_NONNULL_END
