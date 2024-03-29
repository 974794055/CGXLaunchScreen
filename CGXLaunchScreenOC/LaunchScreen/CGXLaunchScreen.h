//
//  CGXLaunchScreen.h
//  CGXLaunchScreen-OC
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

//  版本:1.0.0
//  发布:2018/3/10

//  如果你在使用过程中出现bug,请及时以下面任意一种方式联系我，我会及时修复bug并帮您解决问题。
//  QQ交流群:974794055
//  Email:974794055@qq.com
//  新浪微博:CGX_鑫
//  GitHub:https://github.com/974794055
//  简书:https://www.jianshu.com/u/3da7e077b7a8
//  掘金:https://juejin.im
//  使用说明:https://github.com/974794055/CGXLaunchScreen-OC/blob/master/README.md

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CGXLaunchScreenConfiguration.h"

#import "CGXLaunchImageView.h"

#import "CGXLaunchScreenDownloader.h"
#import "CGXLaunchScreenCache.h"

#import "CGXLaunchScreenController.h"

#import "CGXLaunchScreenVideoView.h"

#import "CGXLaunchScreenImageView.h"



NS_ASSUME_NONNULL_BEGIN
@class CGXLaunchScreen;
@protocol CGXLaunchScreenDelegate <NSObject>
@optional

/**
 广告点击回调

 @param launchAd launchAd
 @param openModel 打开页面参数(此参数即你配置广告数据设置的configuration.openModel)
 @param clickPoint 点击位置
 */
- (void)gxLaunchAd:(CGXLaunchScreen *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint;

/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd  CGXLaunchScreen
 *  @param image 读取/下载的image
 *  @param imageData 读取/下载的imageData
 */
-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData;

/**
 *  video本地读取/或下载完成回调
 *
 *  @param launchAd CGXLaunchScreen
 *  @param pathURL  本地保存路径
 */
-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd videoDownLoadFinish:(NSURL *)pathURL;

/**
 视频下载进度回调

 @param launchAd CGXLaunchScreen
 @param progress 下载进度
 @param total    总大小
 @param current  当前已下载大小
 */
-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current;

/**
 *  倒计时回调
 *
 *  @param launchAd CGXLaunchScreen
 *  @param duration 倒计时时间
 */
-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration;

/**
  广告显示完成

 @param launchAd CGXLaunchScreen
 */
-(void)gxLaunchAdShowFinish:(CGXLaunchScreen *)launchAd;

/**
 如果你想用SDWebImage等框架加载网络广告图片,请实现此代理,注意:实现此方法后,图片缓存将不受CGXLaunchScreen管理

 @param launchAd          CGXLaunchScreen
 @param launchAdImageView launchAdImageView
 @param url               图片url
 */
-(void)gxLaunchAd:(CGXLaunchScreen *)launchAd launchAdImageView:(UIImageView *)launchAdImageView URL:(NSURL *)url;

@end

@interface CGXLaunchScreen : NSObject

@property(nonatomic,assign) id<CGXLaunchScreenDelegate> delegate;

/**
 设置你工程的启动页使用的是LaunchImage还是LaunchScreen(default:SourceTypeLaunchImage)
 注意:请在设置等待数据及配置广告数据前调用此方法
 @param sourceType sourceType
 */
+(void)setLaunchSourceType:(CGXLaunchImageViewLaunchType)sourceType;

/**
 *  设置等待数据源时间(建议值:3)
 *
 *  @param waitDataDuration waitDataDuration
 */
+(void)setWaitDataDuration:(NSInteger )waitDataDuration;

/**
 *  图片开屏广告数据配置
 *
 *  @param imageAdconfiguration 数据配置
 *
 *  @return CGXLaunchScreen
 */
+(CGXLaunchScreen *)imageAdWithImageAdConfiguration:(CGXLaunchScreenImageAdConfiguration *)imageAdconfiguration;

/**
 *  图片开屏广告数据配置
 *
 *  @param imageAdconfiguration 数据配置
 *  @param delegate             delegate
 *
 *  @return CGXLaunchScreen
 */
+(CGXLaunchScreen *)imageAdWithImageAdConfiguration:(CGXLaunchScreenImageAdConfiguration *)imageAdconfiguration delegate:(nullable id)delegate;

/**
 *  视频开屏广告数据配置
 *
 *  @param videoAdconfiguration 数据配置
 *
 *  @return CGXLaunchScreen
 */
+(CGXLaunchScreen *)videoAdWithVideoAdConfiguration:(CGXLaunchScreenVideoAdConfiguration *)videoAdconfiguration;

/**
 *  视频开屏广告数据配置
 *
 *  @param videoAdconfiguration 数据配置
 *  @param delegate             delegate
 *
 *  @return CGXLaunchScreen
 */
+(CGXLaunchScreen *)videoAdWithVideoAdConfiguration:(CGXLaunchScreenVideoAdConfiguration *)videoAdconfiguration delegate:(nullable id)delegate;

#pragma mark -批量下载并缓存
/**
 *  批量下载并缓存image(异步) - 已缓存的image不会再次下载缓存
 *
 *  @param urlArray image URL Array
 */
+(void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray;

/**
 批量下载并缓存image,并回调结果(异步)- 已缓存的image不会再次下载缓存

 @param urlArray image URL Array
 @param completedBlock 回调结果为一个字典数组,url:图片的url字符串,result:0表示该图片下载缓存失败,1表示该图片下载并缓存完成或本地缓存中已有该图片
 */
+(void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable CGXLaunchScreenBatchDownLoadAndCacheCompletedBlock)completedBlock;

/**
 *  批量下载并缓存视频(异步) - 已缓存的视频不会再次下载缓存
 *
 *  @param urlArray 视频URL Array
 */
+(void)downLoadVideoAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray;

/**
 批量下载并缓存视频,并回调结果(异步) - 已缓存的视频不会再次下载缓存
 
 @param urlArray 视频URL Array
 @param completedBlock 回调结果为一个字典数组,url:视频的url字符串,result:0表示该视频下载缓存失败,1表示该视频下载并缓存完成或本地缓存中已有该视频
 */
+(void)downLoadVideoAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable CGXLaunchScreenBatchDownLoadAndCacheCompletedBlock)completedBlock;

#pragma mark - Action

/**
 手动移除广告

 @param animated 是否需要动画
 */
+(void)removeAndAnimated:(BOOL)animated;

#pragma mark - 是否已缓存
/**
 *  是否已缓存在该图片
 *
 *  @param url image url
 *
 *  @return BOOL
 */
+(BOOL)checkImageInCacheWithURL:(NSURL *)url;

/**
 *  是否已缓存该视频
 *
 *  @param url video url
 *
 *  @return BOOL
 */
+(BOOL)checkVideoInCacheWithURL:(NSURL *)url;

#pragma mark - 获取缓存url
/**
 从缓存中获取上一次的ImageURLString(CGXLaunchScreen 会默认缓存imageURLString)
 
 @return imageUrlString
 */
+(NSString *)cacheImageURLString;

/**
 从缓存中获取上一次的videoURLString(CGXLaunchScreen 会默认缓存VideoURLString)
 
 @return videoUrlString
 */
+(NSString *)cacheVideoURLString;

#pragma mark - 缓存/清理相关
/**
 *  清除CGXLaunchScreen本地所有缓存(异步)
 */
+(void)clearDiskCache;

/**
 清除指定Url的图片本地缓存(异步)

 @param imageUrlArray 需要清除缓存的图片Url数组
 */
+(void)clearDiskCacheWithImageUrlArray:(NSArray<NSURL *> *)imageUrlArray;

/**
 清除指定Url除外的图片本地缓存(异步)
 
 @param exceptImageUrlArray 此url数组的图片缓存将被保留
 */
+(void)clearDiskCacheExceptImageUrlArray:(NSArray<NSURL *> *)exceptImageUrlArray;

/**
 清除指定Url的视频本地缓存(异步)

 @param videoUrlArray 需要清除缓存的视频url数组
 */
+(void)clearDiskCacheWithVideoUrlArray:(NSArray<NSURL *> *)videoUrlArray;

/**
 清除指定Url除外的视频本地缓存(异步)
 
 @param exceptVideoUrlArray 此url数组的视频缓存将被保留
 */
+(void)clearDiskCacheExceptVideoUrlArray:(NSArray<NSURL *> *)exceptVideoUrlArray;

/**
 *  获取CGXLaunchScreen本地缓存大小(M)
 */
+(float)diskCacheSize;

/**
 *  缓存路径
 */
+(NSString *)CGXLaunchScreenCachePath;

@end
NS_ASSUME_NONNULL_END
