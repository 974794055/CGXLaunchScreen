//
//  CGXLaunchScreenController.m
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2019/11/11
//  Copyright © 2019年 CGX. All rights reserved.
// 

#import "CGXLaunchScreenController.h"
#import "CGXLaunchScreenConst.h"

@interface CGXLaunchScreenController ()

@end

@implementation CGXLaunchScreenController

-(BOOL)shouldAutorotate{
    
    return NO;
}

-(BOOL)prefersHomeIndicatorAutoHidden{
    
    return CGXLaunchScreenPrefersHomeIndicatorAutoHidden;
}

@end
