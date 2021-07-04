//
//  HomepersonViewModel.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/29.
//  Copyright © 2019 a. All rights reserved.
//

#import "HomepersonViewModel.h"

@implementation HomepersonViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.infoObj = [[NSObject alloc] init];
    }
    return self;
}

- (void)getinfodataFromweb
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getUserInfo"];
    NSDictionary *parameters;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        parameters = @{@"uid":weakSelf.uid?:@"",@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }else{
        parameters = @{@"uid":weakSelf.uid?:@"",@"lat":@"",@"lng":@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        weakSelf.infoObj = responseObj;
        if (weakSelf.personInfoBlock) {
            weakSelf.personInfoBlock();
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
