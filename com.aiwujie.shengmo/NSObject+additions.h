//
//  NSObject+additions.h
//  圣魔无界
//
//  Created by 王俊钢 on 2019/7/2.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (additions)
/**
 *  判断对象是否为空
 *  PS：nil、NSNil、@""、@0 以上4种返回YES
 *
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)dx_isNullOrNilWithObject:(id)object;
@end

NS_ASSUME_NONNULL_END
