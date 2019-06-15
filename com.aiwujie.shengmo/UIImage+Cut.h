//
//  UIImage+Cut.h
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/14.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Cut)
/*
 *  圆形图片
 */
@property (nonatomic,strong,readonly) UIImage *roundImage;



/**
 *  从给定UIView中截图：UIView转UIImage
 */
+(UIImage *)cutFromView:(UIView *)view;



/**
 *  直接截屏
 */
+(UIImage *)cutScreen;



/**
 *  从给定UIImage和指定Frame截图：
 */
-(UIImage *)cutWithFrame:(CGRect)frame;




/**
 获取圆角图片
 
 @return 圆角图片
 */
- (UIImage *)cutCircleImage;


@end

NS_ASSUME_NONNULL_END
