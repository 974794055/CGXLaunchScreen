//
//  CGXLaunchScreenManagerModel.h
//  CGXLaunchScreen-OC
//
//  Created by CGX on 2018/3/10
//  Copyright © 2019年 CGX.com. All rights reserved.
// 
//  广告数据模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CGXLaunchScreenManagerModel : NSObject

/**
 *  广告URL
 */
@property (nonatomic, copy) NSString *content;

/**
 *  点击打开连接
 */
@property (nonatomic, copy) NSString *openUrl;

/**
 *  广告分辨率
 */
@property (nonatomic, copy) NSString *contentSize;

/**
 *  广告停留时间
 */
@property (nonatomic, assign) NSInteger duration;


/**
 *  分辨率宽
 */
@property(nonatomic,assign,readonly)CGFloat width;
/**
 *  分辨率高
 */
@property(nonatomic,assign,readonly)CGFloat height;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
