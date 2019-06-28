//
//  LDGroupChatViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/20.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupChatViewController.h"
#import "LDGroupAtPersonViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDGroupInformationViewController.h"
#import "LDLookOtherGroupInformationViewController.h"
#import "XYgiftgroupMessageCell.h"
#import "XYgiftMessageContent.h"
#import "LDMyWalletPageViewController.h"

@interface LDGroupChatViewController ()<RCPluginBoardViewDelegate>
//礼物界面
@property (nonatomic,strong) GifView *gif;
@end

@implementation LDGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册自定义消息Cell
    [self registerClass:[XYgiftgroupMessageCell class] forMessageClass:[XYgiftMessageContent class]];
    
    [self createRefreshUserData:self.groupId];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createButton];
    [self addredEnvelope];
}

/**
 聊天页面发红包
 */
-(void)addredEnvelope
{
    self.chatSessionInputBarControl.pluginBoardView.pluginBoardDelegate = self;
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-礼物"] title:@"礼物" atIndex:6 tag:2001];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-红包"] title:@"红包" atIndex:7 tag:2002];
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag
{
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    if (tag==2001) {
        //红包功能
        
        _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:NO :^{
            LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
            cvc.type = @"0";
            [self.navigationController pushViewController:cvc animated:YES];
            
        }];
        [_gif getPersonUid:self.groupId andSign:@"赠送给某人"andUIViewController:self];
        
        __weak typeof (self) weakSelf = self;
        
        _gif.sendmessageBlock = ^(NSDictionary *dic) {
            NSString *imagename = [dic objectForKey:@"image"];
            
            //            NSString *title = @"我是标题";
            //            NSArray *imgarray = [NSArray arrayWithObjects:[UIImage imageNamed:imagename], nil];
            
            NSDictionary *para = @{@"number":dic[@"num"],@"imageName":imagename};
            XYgiftMessageContent *addcontent = [XYgiftMessageContent messageWithDict:para];
            addcontent.number = dic[@"num"];
            addcontent.imageName = dic[@"image"];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:0 error:0];
            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [weakSelf sendMessage:addcontent pushContent:dataStr];
            
            
        };
        [self.tabBarController.view addSubview:_gif];
        
        
        
    }
}


- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model{

    if ([model.content isKindOfClass:[RCRichContentMessage class]]) {

        RCRichContentMessage *message = (RCRichContentMessage *)model.content;

        NSArray *array = [message.extra componentsSeparatedByString:@","];

        NSString *gidStr = [array[0] componentsSeparatedByString:@":"][1] ;

        NSString *gid = [gidStr substringWithRange:NSMakeRange(1, gidStr.length - 2)];

        NSString *state = [[array[1] componentsSeparatedByString:@":"][1] substringToIndex:1];

        AFHTTPSessionManager *manager = [LDAFManager sharedManager];

        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];

        NSDictionary *parameters = @{@"gid":gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};


        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];

            if (integer != 2000) {

                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];


            }else{

                if ([responseObject[@"data"][@"userpower"] intValue] < 1) {

                    if ([responseObject[@"data"][@"userpower"] intValue] == 0) {

                        LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];

                        ivc.gid = gid;

                        [self.navigationController pushViewController:ivc animated:YES];

                    }else if([responseObject[@"data"][@"userpower"] intValue] == -1){

                        LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];

                        ivc.state = state;

                        ivc.gid = gid;

                        [self.navigationController pushViewController:ivc animated:YES];

                    }

                }else{

                    LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];

                    fvc.gid = gid;

                    [self.navigationController pushViewController:fvc animated:YES];

                }

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            NSLog(@"%@",error);
        }];

    }else{

        [super didTapUrlInMessageCell:url model:model];
    }

}

- (void)showChooseUserViewController:(void (^)(RCUserInfo *selectedUserInfo))selectedBlock cancel:(void (^)())cancelBlock{

    LDGroupAtPersonViewController *atPerson = [[LDGroupAtPersonViewController alloc] init];

    atPerson.groupId = self.groupId;

    atPerson.block = ^(RCUserInfo *user) {

        selectedBlock(user);

    };

    [self.navigationController pushViewController:atPerson animated:YES];
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"群组图标"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];
    
    NSDictionary *parameters = @{@"gid":self.groupId,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];

        }else{
            
            if ([responseObject[@"data"][@"userpower"] intValue] < 1) {
                
                LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
                
                ivc.gid = self.groupId;
                
                [self.navigationController pushViewController:ivc animated:YES];
                
                
            }else{
                
                LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];
                
                fvc.gid = self.groupId;
                
                fvc.chatStsate = @"yes";
                
                [self.navigationController pushViewController:fvc animated:YES];
                
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        
    }];

}

//点击聊天头像查看个人信息
- (void)didTapCellPortrait:(NSString *)userId{
    //    NSLog(@"%@",userId);
    
    [self createData:userId];
    
}

-(void)createRefreshUserData:(NSString *)groupId{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    //    NSLog(@"%@",groupId);
    
    NSDictionary *parameters;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"gid":groupId,@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]};
        
    }else{
        
        parameters = @{@"gid":groupId,@"lat":@"",@"lng":@""};
    }

    
    //    NSLog(@"gsgggggdgdggdgsgssgdgs%@",groupId);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getGroupinfo"] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        //        NSLog(@"%@",responseObject);
        if (integer == 2000) {
            
            //此处为了演示写了一个用户信息
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = groupId;
            group.groupName = responseObject[@"data"][@"groupname"];
            group.portraitUri = responseObject[@"data"][@"group_pic"];
            [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:groupId];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"88888%@",error);
        
    }];

}


-(void)createData:(NSString *)userId{
    
    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    
    avc.userID = userId;
    
    [self.navigationController pushViewController:avc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
