//
//  CGXLaunchScreenImageView.m
//  CGXLaunchScreen-OC
//
//  Created by 曹贵鑫 on 2019/11/9.
//  Copyright © 2019 CGX. All rights reserved.
//

#import "CGXLaunchScreenImageView.h"
#import "CGXLaunchAnimatedImage.h"

#import "CGXLaunchScreenConst.h"
@implementation CGXLaunchScreenImageView

- (id)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.frame = [UIScreen mainScreen].bounds;
        self.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)tap:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self];
    if(self.click) self.click(point);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation CGXLaunchScreenImageView (CGXLaunchScreenCache)
- (void)gx_setImageWithURL:(nonnull NSURL *)url{
    [self gx_setImageWithURL:url placeholderImage:nil];
}

- (void)gx_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder{
    [self gx_setImageWithURL:url placeholderImage:placeholder options:CGXLaunchScreenImageDefault];
}

-(void)gx_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(CGXLaunchScreenImageOptions)options{
    [self gx_setImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)gx_setImageWithURL:(nonnull NSURL *)url completed:(nullable CGXLaunchExternalCompletionBlock)completedBlock {
    
    [self gx_setImageWithURL:url placeholderImage:nil completed:completedBlock];
}

- (void)gx_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable CGXLaunchExternalCompletionBlock)completedBlock{
    [self gx_setImageWithURL:url placeholderImage:placeholder options:CGXLaunchScreenImageDefault completed:completedBlock];
}

-(void)gx_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(CGXLaunchScreenImageOptions)options completed:(nullable CGXLaunchExternalCompletionBlock)completedBlock{
    [self gx_setImageWithURL:url placeholderImage:placeholder GIFImageCycleOnce:NO options:options GIFImageCycleOnceFinish:nil completed:completedBlock ];
}

- (void)gx_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder GIFImageCycleOnce:(BOOL)GIFImageCycleOnce options:(CGXLaunchScreenImageOptions)options GIFImageCycleOnceFinish:(void(^_Nullable)(void))cycleOnceFinishBlock completed:(nullable CGXLaunchExternalCompletionBlock)completedBlock {
    if(placeholder) self.image = placeholder;
    if(!url) return;
    __weak typeof(self) weakSelf = self;
    [[CGXLaunchScreenImageManager sharedManager] loadImageWithURL:url options:options progress:nil completed:^(UIImage * _Nullable image,  NSData *_Nullable imageData, NSError * _Nullable error, NSURL * _Nullable imageURL) {
        if(!error){
            if(GXLaunchISGIFTypeWithData(imageData)){
                weakSelf.image = nil;
                weakSelf.animatedImage = [CGXLaunchAnimatedImage animatedImageWithGIFData:imageData];
                weakSelf.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
                    if(GIFImageCycleOnce){
                       [weakSelf stopAnimating];
                        CGXLaunchScreenLog(@"GIF不循环,播放完成");
                        if(cycleOnceFinishBlock) cycleOnceFinishBlock();
                    }
                };
            }else{
                weakSelf.image = image;
                weakSelf.animatedImage = nil;
            }
        }
        if(completedBlock) completedBlock(image,imageData,error,imageURL);
    }];
}

@end
