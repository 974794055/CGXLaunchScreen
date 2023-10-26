//
//  CGXLaunchScreenManager.m
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2018/3/10.
//  Copyright © 2019 CGX. All rights reserved.
//

#import "CGXLaunchScreenManager.h"

/** 静态图 */
#define imageURL1 @"https://img0.baidu.com/it/u=176275740,151222649&fm=253&fmt=auto&app=138&f=JPEG?w=281&h=500"

/** 动态图 */
#define imageURL3 @"https://n1.itc.cn/img8/wb/recom/2016/08/04/147027203986250000.GIF"

/** 视频链接 */
#define videoURL1 @"https://www.bilibili.com/video/BV1NP4y1Y7Ds?t=3.2"

static inline BOOL CGXLaunchisIPhoneX() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

@interface CGXLaunchScreenManager()<CGXLaunchScreenDelegate>

@end

@implementation CGXLaunchScreenManager

+(void)load{
    [self shareManager];
}

+(CGXLaunchScreenManager *)shareManager
{
    static CGXLaunchScreenManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[CGXLaunchScreenManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //在UIApplicationDidFinishLaunching时初始化开屏广告,做到对业务层无干扰,
        //也可以直接在AppDelegate didFinishLaunchingWithOptions方法中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            //初始化开屏广告
            [self setupCGXLaunchScreen];
        }];
    }
    return self;
}

-(void)setupCGXLaunchScreen{
    
    NSInteger inter = arc4random() % 8;
    inter = 0;
    if (inter == 0) {
        /** 1.图片开屏广告 - 网络数据 */
        [self example01];
    }
    if (inter == 1) {
        //2.******图片开屏广告 - 本地数据******
        [self example02];
    }
    if (inter == 2) {
        //3.******视频开屏广告 - 网络数据(网络视频只支持缓存OK后下次显示,看效果请二次运行)******
        [self example03];
    }
    if (inter == 3) {
        /** 4.视频开屏广告 - 本地数据 */
        [self example04];
    }
    if (inter == 4) {
        /** 5.如需自定义跳过按钮,请看这个示例 */
        [self example05];
    }
    if (inter == 5) {
        /** 6.使用默认配置快速初始化,请看下面两个示例 */
        [self example06];//图片
    }
    if (inter == 6) {
        [self example07];//视频
    }
    if (inter == 7) {
        /** 7.如果你想提前批量缓存图片/视频请看下面两个示例 */
        [self batchDownloadImageAndCache]; //批量下载并缓存图片
    }
    if (inter == 8) {
        [self batchDownloadVideoAndCache]; //批量下载并缓存视频
    }
}

#pragma mark - 图片开屏广告-网络数据-示例
//图片开屏广告 - 网络数据
-(void)example01{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [CGXLaunchScreen setLaunchSourceType:CGXLaunchImageViewLaunchTypeLaunchScreen];
    
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [CGXLaunchScreen setWaitDataDuration:3];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGXLaunchScreenManagerModel *model = [[CGXLaunchScreenManagerModel alloc] initWithDict:@{}];
        model.content = @"https://img0.baidu.com/it/u=4159999942,3483073488&fm=253&fmt=auto&app=120&f=JPEG?w=354&h=500";
        model.openUrl = @"https://baidu.com/";
        model.contentSize = @"1242*1786";
        model.duration = 5;
        //配置广告数据
        CGXLaunchScreenImageAdConfiguration *imageAdconfiguration = [CGXLaunchScreenImageAdConfiguration new];
        //广告停留时间
        imageAdconfiguration.duration = model.duration;
        //广告frame
        imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.8);
        //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
        imageAdconfiguration.imageNameOrURLString = model.content;
        //设置GIF动图是否只循环播放一次(仅对动图设置有效)
        imageAdconfiguration.GIFImageCycleOnce = NO;
        //缓存机制(仅对网络图片有效)
        //为告展示效果更好,可设置为CGXLaunchScreenImageCacheInBackground,先缓存,下次显示
        imageAdconfiguration.imageOption = CGXLaunchScreenImageDefault;
        //图片填充模式
        imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
        imageAdconfiguration.openModel = model.openUrl;
        //广告显示完成动画
        imageAdconfiguration.CGXLaunchShowFinishAnimate =CGXLaunchShowFinishAnimateLite;
        //广告显示完成动画时间
        imageAdconfiguration.CGXLaunchShowFinishAnimateTime = 0.8;
        //跳过按钮类型
        imageAdconfiguration.skipButtonType = CGXLaunchSkipTypeTimeText;
        //后台返回时,是否显示广告
        imageAdconfiguration.showEnterForeground = NO;
        
        //图片已缓存 - 显示一个 "已预载" 视图 (可选)
        if([CGXLaunchScreen checkImageInCacheWithURL:[NSURL URLWithString:model.content]]){
            //设置要添加的自定义视图(可选)
            imageAdconfiguration.subViews = [self launchAdSubViews_alreadyView];
        }
        //显示开屏广告
        [CGXLaunchScreen imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    });
}

#pragma mark - 图片开屏广告-本地数据-示例
//图片开屏广告 - 本地数据
-(void)example02{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [CGXLaunchScreen setLaunchSourceType:CGXLaunchImageViewLaunchTypeLaunchScreen];
    
    //配置广告数据
    CGXLaunchScreenImageAdConfiguration *imageAdconfiguration = [CGXLaunchScreenImageAdConfiguration new];
    
    //广告停留时间
    imageAdconfiguration.duration = 5;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.8);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"image2.jpg";
    //设置GIF动图是否只循环播放一次(仅对动图设置有效)
    imageAdconfiguration.GIFImageCycleOnce = NO;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    imageAdconfiguration.openModel = @"http://www.CGX";
    //广告显示完成动画
    imageAdconfiguration.CGXLaunchShowFinishAnimate =CGXLaunchShowFinishAnimateNone;
    //广告显示完成动画时间
    imageAdconfiguration.CGXLaunchShowFinishAnimateTime = 0.8;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = CGXLaunchSkipTypeRoundProgressText;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //设置要添加的子视图(可选)
    //imageAdconfiguration.subViews = [self launchAdSubViews];
    //显示开屏广告
    [CGXLaunchScreen imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
}

#pragma mark - 视频开屏广告-网络数据-示例
//视频开屏广告 - 网络数据
-(void)example03{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [CGXLaunchScreen setLaunchSourceType:CGXLaunchImageViewLaunchTypeLaunchScreen];
    
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [CGXLaunchScreen setWaitDataDuration:3];
    
    //广告数据请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //广告数据转模型
        CGXLaunchScreenManagerModel *model = [[CGXLaunchScreenManagerModel alloc] initWithDict:@{}];
        model.content = @"http://yun.it7090.com/video/CGXLaunchScreen/video_test01.mp4";
        model.openUrl = @"http://www.it7090.com";
        model.contentSize = @"750*1336";
        model.duration = 5;
        //配置广告数据
        CGXLaunchScreenVideoAdConfiguration *videoAdconfiguration = [CGXLaunchScreenVideoAdConfiguration new];
        //广告停留时间
        videoAdconfiguration.duration = model.duration;
        //广告frame
        videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //广告视频URLString/或本地视频名(请带上后缀)
        //注意:视频广告只支持先缓存,下次显示(看效果请二次运行)
        videoAdconfiguration.videoNameOrURLString = model.content;
        //是否关闭音频
        videoAdconfiguration.muted = NO;
        //视频缩放模式
        videoAdconfiguration.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //是否只循环播放一次
        videoAdconfiguration.videoCycleOnce = NO;
        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
        videoAdconfiguration.openModel = model.openUrl;
        //广告显示完成动画
        videoAdconfiguration.CGXLaunchShowFinishAnimate =CGXLaunchShowFinishAnimateFadein;
        //广告显示完成动画时间
        videoAdconfiguration.CGXLaunchShowFinishAnimateTime = 0.8;
        //后台返回时,是否显示广告
        videoAdconfiguration.showEnterForeground = NO;
        //跳过按钮类型
        videoAdconfiguration.skipButtonType = CGXLaunchSkipTypeTimeText;
        //视频已缓存 - 显示一个 "已预载" 视图 (可选)
        if([CGXLaunchScreen checkVideoInCacheWithURL:[NSURL URLWithString:model.content]]){
            //设置要添加的自定义视图(可选)
            videoAdconfiguration.subViews = [self launchAdSubViews_alreadyView];
            
        }
        
        [CGXLaunchScreen videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
        
    });
    
}

#pragma mark - 视频开屏广告-本地数据-示例
//视频开屏广告 - 本地数据
-(void)example04{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [CGXLaunchScreen setLaunchSourceType:CGXLaunchImageViewLaunchTypeLaunchScreen];
    
    //配置广告数据
    CGXLaunchScreenVideoAdConfiguration *videoAdconfiguration = [CGXLaunchScreenVideoAdConfiguration new];
    //广告停留时间
    videoAdconfiguration.duration = 5;
    //广告frame
    videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告视频URLString/或本地视频名(请带上后缀)
    videoAdconfiguration.videoNameOrURLString = @"video0.mp4";
    //是否关闭音频
    videoAdconfiguration.muted = NO;
    //视频填充模式
    videoAdconfiguration.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //是否只循环播放一次
    videoAdconfiguration.videoCycleOnce = NO;
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    videoAdconfiguration.openModel =  @"http://www.CGX";
    //跳过按钮类型
    videoAdconfiguration.skipButtonType = CGXLaunchSkipTypeRoundProgressTime;
    //广告显示完成动画
    videoAdconfiguration.CGXLaunchShowFinishAnimate = CGXLaunchShowFinishAnimateLite;
    //广告显示完成动画时间
    videoAdconfiguration.CGXLaunchShowFinishAnimateTime = 0.8;
    //后台返回时,是否显示广告
    videoAdconfiguration.showEnterForeground = NO;
    //设置要添加的子视图(可选)
    //videoAdconfiguration.subViews = [self launchAdSubViews];
    //显示开屏广告
    [CGXLaunchScreen videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
    
}
#pragma mark - 自定义跳过按钮-示例
-(void)example05{
    
    //注意:
    //1.自定义跳过按钮很简单,configuration有一个customSkipView属性.
    //2.自定义一个跳过的view 赋值给configuration.customSkipView属性便可替换默认跳过按钮,如下:
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [CGXLaunchScreen setLaunchSourceType:CGXLaunchImageViewLaunchTypeLaunchScreen];
    
    //配置广告数据
    CGXLaunchScreenImageAdConfiguration *imageAdconfiguration = [CGXLaunchScreenImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 5;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/1242*1786);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"image11.gif";
    //缓存机制(仅对网络图片有效)
    imageAdconfiguration.imageOption = CGXLaunchScreenImageDefault;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    imageAdconfiguration.openModel = @"http://www.CGX";
    //广告显示完成动画
    imageAdconfiguration.CGXLaunchShowFinishAnimate = CGXLaunchShowFinishAnimateFlipFromLeft;
    //广告显示完成动画时间
    imageAdconfiguration.CGXLaunchShowFinishAnimateTime = 0.8;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    
    //设置要添加的子视图(可选)
    imageAdconfiguration.subViews = [self launchAdSubViews];
    
    //start********************自定义跳过按钮**************************
    imageAdconfiguration.customSkipView = [self customSkipView];
    //********************自定义跳过按钮*****************************end
    
    //显示开屏广告
    [CGXLaunchScreen imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
}

#pragma mark - 使用默认配置快速初始化 - 示例
/**
 *  图片
 */
-(void)example06{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [CGXLaunchScreen setLaunchSourceType:CGXLaunchImageViewLaunchTypeLaunchScreen];
    
    //使用默认配置
    CGXLaunchScreenImageAdConfiguration *imageAdconfiguration = [CGXLaunchScreenImageAdConfiguration defaultConfiguration];
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = imageURL3;
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    imageAdconfiguration.openModel = @"http://www.baidu.com";
    [CGXLaunchScreen imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

/**
 *  视频
 */
-(void)example07{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [CGXLaunchScreen setLaunchSourceType:CGXLaunchImageViewLaunchTypeLaunchScreen];
    
    //使用默认配置
    CGXLaunchScreenVideoAdConfiguration *videoAdconfiguration = [CGXLaunchScreenVideoAdConfiguration defaultConfiguration];
    //广告视频URLString/或本地视频名(请带上后缀)
    videoAdconfiguration.videoNameOrURLString = @"video0.mp4";
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    videoAdconfiguration.openModel = @"http://www.CGX";
    [CGXLaunchScreen videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
}

#pragma mark - 批量下载并缓存
/**
 *  批量下载并缓存图片
 */
-(void)batchDownloadImageAndCache{
    
    [CGXLaunchScreen downLoadImageAndCacheWithURLArray:@[[NSURL URLWithString:imageURL1]] completed:^(NSArray * _Nonnull completedArray) {
        
        /** 打印批量下载缓存结果 */
        
        //url:图片的url字符串,
        //result:0表示该图片下载失败,1表示该图片下载并缓存完成或本地缓存中已有该图片
        NSLog(@"批量下载缓存图片结果 = %@" ,completedArray);
    }];
}

/**
 *  批量下载并缓存视频
 */
-(void)batchDownloadVideoAndCache{
    
    [CGXLaunchScreen downLoadVideoAndCacheWithURLArray:@[[NSURL URLWithString:videoURL1]] completed:^(NSArray * _Nonnull completedArray) {
        
        /** 打印批量下载缓存结果 */
        
        //url:视频的url字符串,
        //result:0表示该视频下载失败,1表示该视频下载并缓存完成或本地缓存中已有该视频
        NSLog(@"批量下载缓存视频结果 = %@" ,completedArray);
        
    }];
    
}

#pragma mark - subViews
-(NSArray<UIView *> *)launchAdSubViews_alreadyView{
    
    CGFloat y = CGXLaunchisIPhoneX() ? 46:22;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-140, y, 60, 30)];
    label.text  = @"已预载";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    return [NSArray arrayWithObject:label];
    
}

-(NSArray<UIView *> *)launchAdSubViews{
    
    CGFloat y = CGXLaunchisIPhoneX() ? 54 : 30;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-170, y, 60, 30)];
    label.text  = @"subViews";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    return [NSArray arrayWithObject:label];
    
}

#pragma mark - customSkipView
//自定义跳过按钮
-(UIView *)customSkipView{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor orangeColor];
    button.layer.cornerRadius = 5.0;
    button.layer.borderWidth = 1.5;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    CGFloat y = CGXLaunchisIPhoneX() ? 54 : 30;
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100,y, 85, 30);
    [button addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//跳过按钮点击事件
-(void)skipAction{
    
    //移除广告
    [CGXLaunchScreen removeAndAnimated:YES];
}

#pragma mark - CGXLaunchScreen delegate - 倒计时回调
/**
 *  倒计时回调
 *
 *  @param launchAd CGXLaunchScreen
 *  @param duration 倒计时时间
 */
-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration{
    //设置自定义跳过按钮时间
    if([customSkipView isKindOfClass:[UIButton class]]){
        UIButton *button = (UIButton *)customSkipView;//此处转换为你之前的类型
        //设置时间
        [button setTitle:[NSString stringWithFormat:@"自定义%lds",duration] forState:UIControlStateNormal];
    }
}

#pragma mark - CGXLaunchScreen delegate - 其他
/**
 广告点击事件回调
 */
-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    
    NSLog(@"广告点击事件");
    
    /** openModel即配置广告数据设置的点击广告时打开页面参数(configuration.openModel) */
    if(openModel==nil){
        return;
    }
    
}

/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd  CGXLaunchScreen
 *  @param image 读取/下载的image
 *  @param imageData 读取/下载的imageData
 */
-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData{
    
    NSLog(@"图片下载完成/或本地图片读取完成回调");
}

/**
 *  视频本地读取/或下载完成回调
 *
 *  @param launchAd CGXLaunchScreen
 *  @param pathURL  视频保存在本地的path
 */
-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd videoDownLoadFinish:(NSURL *)pathURL{
    
    NSLog(@"video下载/加载完成 path = %@",pathURL.absoluteString);
}

/**
 *  视频下载进度回调
 */
-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current{
    
    NSLog(@"总大小=%lld,已下载大小=%lld,下载进度=%f",total,current,progress);
}

/**
 *  广告显示完成
 */
- (void)gxLaunchAdShowFinish:(CGXLaunchScreen *)launchAd
{
    NSLog(@"广告显示完成");
}

/**
 如果你想用SDWebImage等框架加载网络广告图片,请实现此代理(注意:实现此方法后,图片缓存将不受CGXLaunchScreen管理)
 
 @param launchAd          CGXLaunchScreen
 @param launchAdImageView launchAdImageView
 @param url               图片url
 */
//-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd launchAdImageView:(UIImageView *)launchAdImageView URL:(NSURL *)url
//{
//    [launchAdImageView sd_setImageWithURL:url];
//}

#pragma mark - 图片开屏广告-网络数据-示例
//图片开屏广告 - 网络数据
-(void)updateSourceType:(CGXLaunchImageViewLaunchType)sourceType
{
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [CGXLaunchScreen setLaunchSourceType:CGXLaunchImageViewLaunchTypeLaunchScreen];
    
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [CGXLaunchScreen setWaitDataDuration:3];
    
    //广告数据转模型
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGXLaunchScreenManagerModel *model = [[CGXLaunchScreenManagerModel alloc] initWithDict:@{}];
        model.content = @"https://img0.baidu.com/it/u=4159999942,3483073488&fm=253&fmt=auto&app=120&f=JPEG?w=354&h=500";
        model.openUrl = @"https://baidu.com/";
        model.contentSize = @"1242*1786";
        model.duration = 5;        //配置广告数据
        CGXLaunchScreenImageAdConfiguration *imageAdconfiguration = [CGXLaunchScreenImageAdConfiguration new];
        //广告停留时间
        imageAdconfiguration.duration = model.duration;
        //广告frame
        imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.8);
        //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
        imageAdconfiguration.imageNameOrURLString = model.content;
        //设置GIF动图是否只循环播放一次(仅对动图设置有效)
        imageAdconfiguration.GIFImageCycleOnce = NO;
        //缓存机制(仅对网络图片有效)
        //为告展示效果更好,可设置为CGXLaunchScreenImageCacheInBackground,先缓存,下次显示
        imageAdconfiguration.imageOption = CGXLaunchScreenImageDefault;
        //图片填充模式
        imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
        imageAdconfiguration.openModel = model.openUrl;
        //广告显示完成动画
        imageAdconfiguration.CGXLaunchShowFinishAnimate =CGXLaunchShowFinishAnimateLite;
        //广告显示完成动画时间
        imageAdconfiguration.CGXLaunchShowFinishAnimateTime = 0.8;
        //跳过按钮类型
        imageAdconfiguration.skipButtonType = CGXLaunchSkipTypeTimeText;
        //后台返回时,是否显示广告
        imageAdconfiguration.showEnterForeground = NO;
        
        //图片已缓存 - 显示一个 "已预载" 视图 (可选)
        if([CGXLaunchScreen checkImageInCacheWithURL:[NSURL URLWithString:model.content]]){
            //设置要添加的自定义视图(可选)
            imageAdconfiguration.subViews = [self launchAdSubViews_alreadyView];
            
        }
        //显示开屏广告
        [CGXLaunchScreen imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    });
}

@end
