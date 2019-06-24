//
//  LDhistoryViewModel.h
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/24.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDhistoryViewModel.h"
#import "LDhistorynameModel.h"
//
//@protocol historydelegate <NSObject>
//
////@optional
//-(void)setDatafromModel:(NSMutableArray *)dataArray;
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface LDhistoryViewModel : NSObject
@property (nonatomic,copy) NSString *uid;
//@property (nonatomic,weak) id <historydelegate> delegate;

@property (nonatomic, copy, readonly) __block NSMutableArray *news;
@property (nonatomic, copy) __block void (^newsListBlock)(void);

- (void)getNewsList;
@end

NS_ASSUME_NONNULL_END
