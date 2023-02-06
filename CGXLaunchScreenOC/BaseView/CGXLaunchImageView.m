//
//  CGXLaunchImageView.m
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

#import "CGXLaunchImageView.h"
#import "CGXLaunchScreenConst.h"

@interface CGXLaunchImageView ()

@end

@implementation CGXLaunchImageView
#pragma mark - private
- (instancetype)initWithSourceType:(CGXLaunchImageViewLaunchType)sourceType{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        switch (sourceType) {
            case CGXLaunchImageViewLaunchTypeLaunchImage:{
                self.image = [self imageFromLaunchImage];
            }
                break;
            case CGXLaunchImageViewLaunchTypeLaunchScreen:{
                self.image = [self imageFromLaunchScreen];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

-(UIImage *)imageFromLaunchImage{
    UIImage *imageP = [self launchImageWithType:@"Portrait"];
    if(imageP) return imageP;
    UIImage *imageL = [self launchImageWithType:@"Landscape"];
    if(imageL)  return imageL;
    CGXLaunchScreenLog(@"获取LaunchImage失败!请检查是否添加启动图,或者规格是否有误.");
    return nil;
}

-(UIImage *)imageFromLaunchScreen{
    NSString *UILaunchStoryboardName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchStoryboardName"];
    if(UILaunchStoryboardName == nil){
        CGXLaunchScreenLog(@"从 LaunchScreen 中获取启动图失败!");
        return nil;
    }
    UIViewController *LaunchScreenSb = [[UIStoryboard storyboardWithName:UILaunchStoryboardName bundle:nil] instantiateInitialViewController];
    if(LaunchScreenSb){
        UIView * view = LaunchScreenSb.view;
        view.frame = [UIScreen mainScreen].bounds;
        UIImage *image = [self imageFromView:view];
        return image;
    }
    CGXLaunchScreenLog(@"从 LaunchScreen 中获取启动图失败!");
    return nil;
}

-(UIImage*)imageFromView:(UIView*)view{
    CGSize size = view.bounds.size;
    //参数1:表示区域大小 参数2:如果需要显示半透明效果,需要传NO,否则传YES 参数3:屏幕密度
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage *)launchImageWithType:(NSString *)type{
    //比对分辨率,获取启动图 fix #158:https://github.com/974794055/CGXLaunchScreen-OC/issues/158
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGSize screenDipSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * screenScale, [UIScreen mainScreen].bounds.size.height * screenScale);
    NSString *viewOrientation = type;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict){
        UIImage *image = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        CGSize imageDpiSize = CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"]){
                imageDpiSize = CGSizeMake(imageDpiSize.height, imageDpiSize.width);
            }
            if(CGSizeEqualToSize(screenDipSize, imageDpiSize)){
                return image;
            }
        }
    }
    return nil;
}

@end
