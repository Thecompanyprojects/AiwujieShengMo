//
//  LDChargeCenterViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnValueBlock) (NSString* numStr);
@interface LDChargeCenterViewController : UIViewController
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@end
