//
//  CGXLaunchScreen.m
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

#import "CGXLaunchScreen.h"
#import "CGXLaunchScreenConst.h"
#import "CGXLaunchAnimatedImage.h"

typedef NS_ENUM(NSInteger, CGXLaunchScreenType) {
    CGXLaunchScreenTypeImage,
    CGXLaunchScreenTypeVideo
};

static NSInteger defaultWaitDataDuration = 3;
static  CGXLaunchImageViewLaunchType _sourceType = CGXLaunchImageViewLaunchTypeLaunchImage;
@interface CGXLaunchScreen()

@property(nonatomic,assign)CGXLaunchScreenType launchAdType;
@property(nonatomic,assign)NSInteger waitDataDuration;
@property(nonatomic,strong)CGXLaunchScreenImageAdConfiguration * imageAdConfiguration;
@property(nonatomic,strong)CGXLaunchScreenVideoAdConfiguration * videoAdConfiguration;
@property(nonatomic,strong)CGXLaunchScreenButton * skipButton;
@property(nonatomic,strong)CGXLaunchScreenVideoView * adVideoView;
@property(nonatomic,strong)UIWindow * window;
@property(nonatomic,copy)dispatch_source_t waitDataTimer;
@property(nonatomic,copy)dispatch_source_t skipTimer;
@property (nonatomic, assign) BOOL detailPageShowing;
@property(nonatomic,assign) CGPoint clickPoint;
@end

@implementation CGXLaunchScreen
+(void)setLaunchSourceType:(CGXLaunchImageViewLaunchType)sourceType{
    _sourceType = sourceType;
}
+(void)setWaitDataDuration:(NSInteger )waitDataDuration{
    CGXLaunchScreen *launchAd = [CGXLaunchScreen shareLaunchAd];
    launchAd.waitDataDuration = waitDataDuration;
}
+(CGXLaunchScreen *)imageAdWithImageAdConfiguration:(CGXLaunchScreenImageAdConfiguration *)imageAdconfiguration{
    return [CGXLaunchScreen imageAdWithImageAdConfiguration:imageAdconfiguration delegate:nil];
}

+(CGXLaunchScreen *)imageAdWithImageAdConfiguration:(CGXLaunchScreenImageAdConfiguration *)imageAdconfiguration delegate:(id)delegate{
    CGXLaunchScreen *launchAd = [CGXLaunchScreen shareLaunchAd];
    if(delegate) launchAd.delegate = delegate;
    launchAd.imageAdConfiguration = imageAdconfiguration;
    return launchAd;
}

+(CGXLaunchScreen *)videoAdWithVideoAdConfiguration:(CGXLaunchScreenVideoAdConfiguration *)videoAdconfiguration{
    return [CGXLaunchScreen videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:nil];
}

+(CGXLaunchScreen *)videoAdWithVideoAdConfiguration:(CGXLaunchScreenVideoAdConfiguration *)videoAdconfiguration delegate:(nullable id)delegate{
    CGXLaunchScreen *launchAd = [CGXLaunchScreen shareLaunchAd];
    if(delegate) launchAd.delegate = delegate;
    launchAd.videoAdConfiguration = videoAdconfiguration;
    return launchAd;
}

+(void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray{
    [self downLoadImageAndCacheWithURLArray:urlArray completed:nil];
}

+ (void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable CGXLaunchScreenBatchDownLoadAndCacheCompletedBlock)completedBlock{
    if(urlArray.count==0) return;
    [[CGXLaunchScreenDownloader sharedDownloader] downLoadImageAndCacheWithURLArray:urlArray completed:completedBlock];
}

+(void)downLoadVideoAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray{
    [self downLoadVideoAndCacheWithURLArray:urlArray completed:nil];
}

+(void)downLoadVideoAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable CGXLaunchScreenBatchDownLoadAndCacheCompletedBlock)completedBlock{
    if(urlArray.count==0) return;
    [[CGXLaunchScreenDownloader sharedDownloader] downLoadVideoAndCacheWithURLArray:urlArray completed:completedBlock];
}
+(void)removeAndAnimated:(BOOL)animated{
    [[CGXLaunchScreen shareLaunchAd] removeAndAnimated:animated];
}

+(BOOL)checkImageInCacheWithURL:(NSURL *)url{
    return [CGXLaunchScreenCache checkImageInCacheWithURL:url];
}

+(BOOL)checkVideoInCacheWithURL:(NSURL *)url{
    return [CGXLaunchScreenCache checkVideoInCacheWithURL:url];
}
+(void)clearDiskCache{
    [CGXLaunchScreenCache clearDiskCache];
}

+(void)clearDiskCacheWithImageUrlArray:(NSArray<NSURL *> *)imageUrlArray{
    [CGXLaunchScreenCache clearDiskCacheWithImageUrlArray:imageUrlArray];
}

+(void)clearDiskCacheExceptImageUrlArray:(NSArray<NSURL *> *)exceptImageUrlArray{
    [CGXLaunchScreenCache clearDiskCacheExceptImageUrlArray:exceptImageUrlArray];
}

+(void)clearDiskCacheWithVideoUrlArray:(NSArray<NSURL *> *)videoUrlArray{
    [CGXLaunchScreenCache clearDiskCacheWithVideoUrlArray:videoUrlArray];
}

+(void)clearDiskCacheExceptVideoUrlArray:(NSArray<NSURL *> *)exceptVideoUrlArray{
    [CGXLaunchScreenCache clearDiskCacheExceptVideoUrlArray:exceptVideoUrlArray];
}

+(float)diskCacheSize{
    return [CGXLaunchScreenCache diskCacheSize];
}

+(NSString *)CGXLaunchScreenCachePath{
    return [CGXLaunchScreenCache CGXLaunchScreenCachePath];
}

+(NSString *)cacheImageURLString{
    return [CGXLaunchScreenCache getCacheImageUrl];
}

+(NSString *)cacheVideoURLString{
    return [CGXLaunchScreenCache getCacheVideoUrl];
}

#pragma mark - private
+(CGXLaunchScreen *)shareLaunchAd{
    static CGXLaunchScreen *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[CGXLaunchScreen alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [self setupLaunchAd];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self setupLaunchAdEnterForeground];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self removeOnly];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:CGXLaunchScreenDetailPageWillShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            weakSelf.detailPageShowing = YES;
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:CGXLaunchScreenDetailPageShowFinishNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            weakSelf.detailPageShowing = NO;
        }];
    }
    return self;
}

-(void)setupLaunchAdEnterForeground{
    switch (_launchAdType) {
        case CGXLaunchScreenTypeImage:{
            if(!_imageAdConfiguration.showEnterForeground || _detailPageShowing) return;
            [self setupLaunchAd];
            [self setupImageAdForConfiguration:_imageAdConfiguration];
        }
            break;
        case CGXLaunchScreenTypeVideo:{
            if(!_videoAdConfiguration.showEnterForeground || _detailPageShowing) return;
            [self setupLaunchAd];
            [self setupVideoAdForConfiguration:_videoAdConfiguration];
        }
            break;
        default:
            break;
    }
}

-(void)setupLaunchAd{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [[CGXLaunchScreenController alloc] init];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    window.windowLevel = UIWindowLevelStatusBar + 1;
    window.hidden = NO;
    window.alpha = 1;
    _window = window;
    /** 添加launchImageView */
    [_window addSubview:[[CGXLaunchImageView alloc] initWithSourceType:_sourceType]];
}

/**图片*/
-(void)setupImageAdForConfiguration:(CGXLaunchScreenImageAdConfiguration *)configuration{
    if(_window == nil) return;
    [self removeSubViewsExceptLaunchAdImageView];
    CGXLaunchScreenImageView *adImageView = [[CGXLaunchScreenImageView alloc] init];
    [_window addSubview:adImageView];
    /** frame */
    if(configuration.frame.size.width>0 && configuration.frame.size.height>0) adImageView.frame = configuration.frame;
    if(configuration.contentMode) adImageView.contentMode = configuration.contentMode;
    /** webImage */
    if(configuration.imageNameOrURLString.length && GXLaunchIsURLString(configuration.imageNameOrURLString)){
        [CGXLaunchScreenCache async_saveImageUrl:configuration.imageNameOrURLString];
        /** 自设图片 */
        if ([self.delegate respondsToSelector:@selector(gxLaunchAd:launchAdImageView:URL:)]) {
            [self.delegate gxLaunchAd:self launchAdImageView:adImageView URL:[NSURL URLWithString:configuration.imageNameOrURLString]];
        }else{
            if(!configuration.imageOption) configuration.imageOption = CGXLaunchScreenImageDefault;
            __weak typeof(self) weakSelf = self;
            [adImageView gx_setImageWithURL:[NSURL URLWithString:configuration.imageNameOrURLString] placeholderImage:nil GIFImageCycleOnce:configuration.GIFImageCycleOnce options:configuration.imageOption GIFImageCycleOnceFinish:^{
                //GIF不循环,播放完成
                [[NSNotificationCenter defaultCenter] postNotificationName:CGXLaunchScreenGIFImageCycleOnceFinishNotification object:nil userInfo:@{@"imageNameOrURLString":configuration.imageNameOrURLString}];
                
            } completed:^(UIImage *image,NSData *imageData,NSError *error,NSURL *url){
                if(!error){
                    if ([weakSelf.delegate respondsToSelector:@selector(gxLaunchAd:imageDownLoadFinish:imageData:)]) {
                        [weakSelf.delegate gxLaunchAd:self imageDownLoadFinish:image imageData:imageData];
                    }
                }
            }];
            if(configuration.imageOption == CGXLaunchScreenImageCacheInBackground){
                /** 缓存中未有 */
                if(![CGXLaunchScreenCache checkImageInCacheWithURL:[NSURL URLWithString:configuration.imageNameOrURLString]]){
                    [self removeAndAnimateDefault]; return; /** 完成显示 */
                }
            }
        }
    }else{
        if(configuration.imageNameOrURLString.length){
            NSData *data = GXLaunchDataWithFileName(configuration.imageNameOrURLString);
            if(GXLaunchISGIFTypeWithData(data)){
                CGXLaunchAnimatedImage *image = [CGXLaunchAnimatedImage animatedImageWithGIFData:data];
                adImageView.animatedImage = image;
                adImageView.image = nil;
                __weak typeof(adImageView) w_adImageView = adImageView;
                adImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
                    if(configuration.GIFImageCycleOnce){
                        [w_adImageView stopAnimating];
                        CGXLaunchScreenLog(@"GIF不循环,播放完成");
                        [[NSNotificationCenter defaultCenter] postNotificationName:CGXLaunchScreenGIFImageCycleOnceFinishNotification object:@{@"imageNameOrURLString":configuration.imageNameOrURLString}];
                    }
                };
            }else{
                adImageView.animatedImage = nil;
                adImageView.image = [UIImage imageWithData:data];
            }
            if ([self.delegate respondsToSelector:@selector(gxLaunchAd:imageDownLoadFinish:imageData:)]) {
                [self.delegate gxLaunchAd:self imageDownLoadFinish:[UIImage imageWithData:data] imageData:data];
            }
        }else{
            CGXLaunchScreenLog(@"未设置广告图片");
        }
    }
    /** skipButton */
    [self addSkipButtonForConfiguration:configuration];
    [self startSkipDispathTimer];
    /** customView */
    if(configuration.subViews.count>0)  [self addSubViews:configuration.subViews];
    __weak typeof(self) weakSelf = self;
    adImageView.click = ^(CGPoint point) {
        [weakSelf clickAndPoint:point];
    };
}

-(void)addSkipButtonForConfiguration:(CGXLaunchScreenConfiguration *)configuration{
    if(!configuration.duration) configuration.duration = 5;
    if(!configuration.skipButtonType) configuration.skipButtonType = CGXLaunchSkipTypeTimeText;
    if(configuration.customSkipView){
        [_window addSubview:configuration.customSkipView];
    }else{
        if(_skipButton == nil){
            _skipButton = [[CGXLaunchScreenButton alloc] initWithSkipType:configuration.skipButtonType];
            _skipButton.hidden = YES;
            [_skipButton addTarget:self action:@selector(skipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        [_window addSubview:_skipButton];
        [_skipButton setTitleWithSkipType:configuration.skipButtonType duration:configuration.duration];
    }
}

/**视频*/
-(void)setupVideoAdForConfiguration:(CGXLaunchScreenVideoAdConfiguration *)configuration{
    if(_window ==nil) return;
    [self removeSubViewsExceptLaunchAdImageView];
    if(!_adVideoView){
        _adVideoView = [[CGXLaunchScreenVideoView alloc] init];
    }
    [_window addSubview:_adVideoView];
    /** frame */
    if(configuration.frame.size.width>0&&configuration.frame.size.height>0) _adVideoView.frame = configuration.frame;
    if(configuration.videoGravity) _adVideoView.videoGravity = configuration.videoGravity;
    _adVideoView.videoCycleOnce = configuration.videoCycleOnce;
    if(configuration.videoCycleOnce){
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            CGXLaunchScreenLog(@"video不循环,播放完成");
            [[NSNotificationCenter defaultCenter] postNotificationName:CGXLaunchScreenVideoCycleOnceFinishNotification object:nil userInfo:@{@"videoNameOrURLString":configuration.videoNameOrURLString}];
        }];
    }
    /** video 数据源 */
    if(configuration.videoNameOrURLString.length && GXLaunchIsURLString(configuration.videoNameOrURLString)){
        [CGXLaunchScreenCache async_saveVideoUrl:configuration.videoNameOrURLString];
        NSURL *pathURL = [CGXLaunchScreenCache getCacheVideoWithURL:[NSURL URLWithString:configuration.videoNameOrURLString]];
        if(pathURL){
            if ([self.delegate respondsToSelector:@selector(gxLaunchAd:videoDownLoadFinish:)]) {
                [self.delegate gxLaunchAd:self videoDownLoadFinish:pathURL];
            }
            _adVideoView.contentURL = pathURL;
            _adVideoView.muted = configuration.muted;
            [_adVideoView.videoPlayer.player play];
        }else{
            __weak typeof(self) weakSelf = self;
            [[CGXLaunchScreenDownloader sharedDownloader] downloadVideoWithURL:[NSURL URLWithString:configuration.videoNameOrURLString] progress:^(unsigned long long total, unsigned long long current) {
                if ([weakSelf.delegate respondsToSelector:@selector(gxLaunchAd:videoDownLoadProgress:total:current:)]) {
                    [weakSelf.delegate gxLaunchAd:self videoDownLoadProgress:current/(float)total total:total current:current];
                }
            }  completed:^(NSURL * _Nullable location, NSError * _Nullable error){
                if(!error){
                    if ([weakSelf.delegate respondsToSelector:@selector(gxLaunchAd:videoDownLoadFinish:)]){
                        [weakSelf.delegate gxLaunchAd:self videoDownLoadFinish:location];
                    }
                }
            }];
            /***视频缓存,提前显示完成 */
            [self removeAndAnimateDefault]; return;
        }
    }else{
        if(configuration.videoNameOrURLString.length){
            NSURL *pathURL = nil;
            NSURL *cachePathURL = [[NSURL alloc] initFileURLWithPath:[CGXLaunchScreenCache videoPathWithFileName:configuration.videoNameOrURLString]];
            //若本地视频未在沙盒缓存文件夹中
            if (![CGXLaunchScreenCache checkVideoInCacheWithFileName:configuration.videoNameOrURLString]) {
                /***如果不在沙盒文件夹中则将其复制一份到沙盒缓存文件夹中/下次直接取缓存文件夹文件,加快文件查找速度 */
                NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:configuration.videoNameOrURLString withExtension:nil];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSFileManager defaultManager] copyItemAtURL:bundleURL toURL:cachePathURL error:nil];
                });
                pathURL = bundleURL;
            }else{
                pathURL = cachePathURL;
            }
            
            if(pathURL){
                if ([self.delegate respondsToSelector:@selector(gxLaunchAd:videoDownLoadFinish:)]) {
                    [self.delegate gxLaunchAd:self videoDownLoadFinish:pathURL];
                }
                _adVideoView.contentURL = pathURL;
                _adVideoView.muted = configuration.muted;
                [_adVideoView.videoPlayer.player play];
                
            }else{
                CGXLaunchScreenLog(@"Error:广告视频未找到,请检查名称是否有误!");
            }
        }else{
            CGXLaunchScreenLog(@"未设置广告视频");
        }
    }
    /** skipButton */
    [self addSkipButtonForConfiguration:configuration];
    [self startSkipDispathTimer];
    /** customView */
    if(configuration.subViews.count>0) [self addSubViews:configuration.subViews];
    __weak typeof(self) weakSelf = self;
    _adVideoView.click = ^(CGPoint point) {
        [weakSelf clickAndPoint:point];
    };
}

#pragma mark - add subViews
-(void)addSubViews:(NSArray *)subViews{
     __weak typeof(self) weakSelf = self;
    [subViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [weakSelf.window addSubview:view];
    }];
}

#pragma mark - set
-(void)setImageAdConfiguration:(CGXLaunchScreenImageAdConfiguration *)imageAdConfiguration{
    _imageAdConfiguration = imageAdConfiguration;
    _launchAdType = CGXLaunchScreenTypeImage;
    [self setupImageAdForConfiguration:imageAdConfiguration];
}

-(void)setVideoAdConfiguration:(CGXLaunchScreenVideoAdConfiguration *)videoAdConfiguration{
    _videoAdConfiguration = videoAdConfiguration;
    _launchAdType = CGXLaunchScreenTypeVideo;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupVideoAdForConfiguration:videoAdConfiguration];
    });
}

-(void)setWaitDataDuration:(NSInteger)waitDataDuration{
    _waitDataDuration = waitDataDuration;
    /** 数据等待 */
    [self startWaitDataDispathTiemr];
}

#pragma mark - Action
-(void)skipButtonClick{
    [self removeAndAnimated:YES];
}

-(void)removeAndAnimated:(BOOL)animated{
    if(animated){
        [self removeAndAnimate];
    }else{
        [self remove];
    }
}

-(void)clickAndPoint:(CGPoint)point{
    self.clickPoint = point;
    CGXLaunchScreenConfiguration * configuration = [self commonConfiguration];
    if ([self.delegate respondsToSelector:@selector(gxLaunchAd:clickAndOpenModel:clickPoint:)]) {
        [self.delegate gxLaunchAd:self clickAndOpenModel:configuration.openModel clickPoint:point];
        [self removeAndAnimateDefault];
    }
}

-(CGXLaunchScreenConfiguration *)commonConfiguration{
    CGXLaunchScreenConfiguration *configuration = nil;
    switch (_launchAdType) {
        case CGXLaunchScreenTypeVideo:
            configuration = _videoAdConfiguration;
            break;
        case CGXLaunchScreenTypeImage:
            configuration = _imageAdConfiguration;
            break;
        default:
            break;
    }
    return configuration;
}

-(void)startWaitDataDispathTiemr{
     __weak typeof(self) weakSelf = self;
    __block NSInteger duration = defaultWaitDataDuration;
    if(_waitDataDuration) duration = _waitDataDuration;
    _waitDataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    NSTimeInterval period = 1.0;
    dispatch_source_set_timer(_waitDataTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(weakSelf.waitDataTimer, ^{
        if(duration==0){
            GXLaunchDISPATCH_SOURCE_CANCEL_SAFE(weakSelf.waitDataTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:CGXLaunchScreenWaitDataDurationArriveNotification object:nil];
                [self remove];
                return ;
            });
        }
        duration--;
    });
    dispatch_resume(_waitDataTimer);
}

-(void)startSkipDispathTimer{
     __weak typeof(self) weakSelf = self;
    CGXLaunchScreenConfiguration * configuration = [self commonConfiguration];
    GXLaunchDISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer);
    if(!configuration.skipButtonType) configuration.skipButtonType = CGXLaunchSkipTypeTimeText;//默认
    __block NSInteger duration = 5;//默认
    if(configuration.duration) duration = configuration.duration;
    if(configuration.skipButtonType == CGXLaunchSkipTypeRoundProgressTime || configuration.skipButtonType == CGXLaunchSkipTypeRoundProgressText){
        [_skipButton startRoundDispathTimerWithDuration:duration];
    }
    NSTimeInterval period = 1.0;
    _skipTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_skipTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_skipTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(gxLaunchAd:customSkipView:duration:)]) {
                [self.delegate gxLaunchAd:self customSkipView:configuration.customSkipView duration:duration];
            }
            if(!configuration.customSkipView){
                [weakSelf.skipButton setTitleWithSkipType:configuration.skipButtonType duration:duration];
            }
            if(duration==0){
                GXLaunchDISPATCH_SOURCE_CANCEL_SAFE(weakSelf.skipTimer);
                [self removeAndAnimate]; return ;
            }
            duration--;
        });
    });
    dispatch_resume(_skipTimer);
}

-(void)removeAndAnimate{
    
    __weak typeof(self) weakSelf = self;
    CGXLaunchScreenConfiguration * configuration = [self commonConfiguration];
    CGFloat duration = CGXLaunchShowFinishAnimateTimeDefault;
    if(configuration.CGXLaunchShowFinishAnimateTime>0) duration = configuration.CGXLaunchShowFinishAnimateTime;
    switch (configuration.CGXLaunchShowFinishAnimate) {
        case CGXLaunchShowFinishAnimateNone:{
            [self remove];
        }
            break;
        case CGXLaunchShowFinishAnimateFadein:{
            [self removeAndAnimateDefault];
        }
            break;
        case CGXLaunchShowFinishAnimateLite:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.window.transform = CGAffineTransformMakeScale(1.5, 1.5);
                weakSelf.window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case CGXLaunchShowFinishAnimateFlipFromLeft:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                weakSelf.window.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf remove];
            }];
        }
            break;
        case CGXLaunchShowFinishAnimateFlipFromBottom:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                weakSelf.window.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf remove];
            }];
        }
            break;
        case CGXLaunchShowFinishAnimateCurlUp:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionCurlUp animations:^{
                weakSelf.window.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf remove];
            }];
        }
            break;
        default:{
            [self removeAndAnimateDefault];
        }
            break;
    }
}

-(void)removeAndAnimateDefault{
    CGXLaunchScreenConfiguration * configuration = [self commonConfiguration];
    CGFloat duration = CGXLaunchShowFinishAnimateTimeDefault;
    if(configuration.CGXLaunchShowFinishAnimateTime>0) duration = configuration.CGXLaunchShowFinishAnimateTime;
__weak typeof(self) weakSelf = self;
    [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionNone animations:^{
        weakSelf.window.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf remove];
    }];
}
-(void)removeOnly{
    GXLaunchDISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer)
    GXLaunchDISPATCH_SOURCE_CANCEL_SAFE(_skipTimer)
    GXLaunchREMOVE_FROM_SUPERVIEW_SAFE(_skipButton)
    if(_launchAdType==CGXLaunchScreenTypeVideo){
        if(_adVideoView){
            [_adVideoView stopVideoPlayer];
            GXLaunchREMOVE_FROM_SUPERVIEW_SAFE(_adVideoView)
        }
    }
    if(_window){
        [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GXLaunchREMOVE_FROM_SUPERVIEW_SAFE(obj)
        }];
        _window.hidden = YES;
        _window = nil;
    }
}

-(void)remove{
    [self removeOnly];
    if ([self.delegate respondsToSelector:@selector(gxLaunchAdShowFinish:)]) {
        [self.delegate gxLaunchAdShowFinish:self];
    }
}

-(void)removeSubViewsExceptLaunchAdImageView{
    [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[CGXLaunchImageView class]]){
            GXLaunchREMOVE_FROM_SUPERVIEW_SAFE(obj)
        }
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
