//
//  LDhistoryViewModel.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/24.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDhistoryViewModel.h"

@implementation LDhistoryViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _news = [NSMutableArray array];
        
    }
    return self;
}

- (void)getNewsList{
    __weak typeof(self) weakSelf = self;
    NSDictionary *para = @{@"uid":self.uid?:@""};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:getEditnicknameListUrl] parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[LDhistorynameModel class] json:responseObj[@"data"]]];
            [weakSelf.news addObjectsFromArray:data];
        }
        if (weakSelf.newsListBlock) {
            weakSelf.newsListBlock();
        }

    } failed:^(NSString *errorMsg) {
        
    }];

}
@end
