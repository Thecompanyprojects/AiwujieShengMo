//
//  NewdynamicCell.h
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/18.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol DynamicDelegate <NSObject>

@optional

-(void)tap:(UITapGestureRecognizer *)tap;

-(void)transmitClickModel:(DynamicModel *)model;

@end
@interface NewdynamicCell : UITableViewCell<YBAttributeTapActionDelegate>

@property (nonatomic,strong) DynamicModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger integer;

@property (nonatomic,strong) id <DynamicDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
