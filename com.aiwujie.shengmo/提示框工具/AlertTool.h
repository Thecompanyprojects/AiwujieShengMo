//
//  AlertTool.h
//  圣魔无界
//
//  Created by 爱无界 on 2017/11/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertTool : NSObject
/**
 * 一般的正面弹框提示
 */
+ (void)alertWithViewController:(UIViewController *)controller andTitle:(NSString *)title andMessage:(NSString *)message;

/**
 * 兑换会员的弹框提示
 */
+(void)alertWithViewController:(UIViewController *)controller type:(NSString *)type num:(NSString *)numStr andAlertDidSelectItem:(void(^)(int index, NSString *viptype))selectBlock;

/**
 * 兑换邮票的弹框提示
 */
+ (void)alertWithViewController:(UIViewController *)controller type:(NSString *)type andAlertInputStampsNumber:(void (^)(NSString *stampNumbers, NSString *channel))stampNumBlock;

@end
