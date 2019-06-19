//
//  TopcardView.h
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/19.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^sureBlock)(NSString *string);
typedef void(^buyBlock)(NSString *string);
@interface TopcardView : UIView

@property(nonatomic,copy)sureBlock sureClick;
@property(nonatomic,copy)buyBlock buyClick;
-(void)withSureClick:(sureBlock)block;
-(void)withBuyClick:(buyBlock)block;
@end

NS_ASSUME_NONNULL_END
