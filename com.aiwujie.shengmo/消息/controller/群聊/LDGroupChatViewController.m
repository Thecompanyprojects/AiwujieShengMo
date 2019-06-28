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
#import "SendNav.h"
#import "SendredsViewController.h"
#import "XYredMessageCell.h"
#import "XYredMessageContent.h"
#import "WSRedPacketView.h"
#import "WSRewardConfig.h"
#import "FlowFlower.h"

@interface LDGroupChatViewController ()<RCPluginBoardViewDelegate,RCIMReceiveMessageDelegate>
//礼物界面
@property (nonatomic,strong) GifView *gif;
@property (nonatomic,assign) BOOL isgif;

/**
 创建礼物掉落的效果
 */
//创建礼物下落的定时器
@property (nonatomic,strong) NSTimer * gifTimer;
//掉落礼物的view
@property (nonatomic,strong) FlowFlower *flowFlower;
//存储选中的礼物
@property (nonatomic,strong) UIImage *gifImage;
//掉落的时间
@property (nonatomic,assign) int second;

@end

@implementation LDGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册自定义消息Cell
    [self registerClass:[XYgiftgroupMessageCell class] forMessageClass:[XYgiftMessageContent class]];
    [self registerClass:[XYredMessageCell class] forMessageClass:[XYredMessageContent class]];
    [self createRefreshUserData:self.groupId];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createButton];
    [self addredEnvelope];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
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
        
        self.isgif = YES;
        
        _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:NO :^{
            LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
            cvc.type = @"0";
            [self.navigationController pushViewController:cvc animated:YES];
            
        }];
        [_gif getPersonUid:self.groupId andSign:@"赠送给某人"andUIViewController:self];
        
        __weak typeof (self) weakSelf = self;
        
        _gif.sendmessageBlock = ^(NSDictionary *dic) {
            NSString *imagename = [dic objectForKey:@"image"];

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
    if (tag==2002) {
        
        self.isgif = NO;
        
        SendredsViewController * allTicketVC = [[SendredsViewController alloc] init];// 包装一个导航栏控制器
        SendNav * nav = [[SendNav alloc]initWithRootViewController:allTicketVC];
        allTicketVC.myBlock = ^(NSDictionary * _Nonnull dic) {
            __weak typeof (self) weakSelf = self;
            
            NSString *message = [dic objectForKey:@"message"];
            if (message.length==0) {
                message = @"恭喜发财，大吉大利";
            }
            NSDictionary *paras = @{@"message":message,@"extra":@"0"};
            
            XYredMessageContent *addcontent = [[XYredMessageContent alloc] init];
            addcontent.message = message;
            addcontent.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
            addcontent.extra = @"0";
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paras options:0 error:0];
            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [weakSelf sendMessage:addcontent pushContent:dataStr];

        };
        [self presentViewController:nav animated:YES completion:nil];
    }
}

/**
 * 重写方法，过滤消息或者修改消息
 *
 * @param messageCotent 消息内容
 *
 * @return 返回消息内容
 */
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
    [super willSendMessage:messageCotent];
    if (!self.isgif) {
        RCTextMessage *message = (RCTextMessage *)messageCotent;
        message.extra = @"0";
        return message;
    }
    return messageCotent;
}

- (void)didTapMessageCell:(RCMessageModel *)model
{
    [super didTapMessageCell:model];
    
    if (self.isgif) {
        _gifTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        //face
        
        XYgiftMessageContent *oldHongBao = (XYgiftMessageContent *)model.content;
        
        UIImage *faceImage = [UIImage imageNamed:oldHongBao.imageName];
        [[NSRunLoop currentRunLoop] addTimer:_gifTimer forMode:NSRunLoopCommonModes];
        //飞行
        _flowFlower = [FlowFlower flowerFLow:@[faceImage]];
        [_flowFlower startFlyFlowerOnView:self.view];
    }
    else
    {
        XYredMessageContent *mes = [[XYredMessageContent alloc] init];
        mes.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
        mes.extra = @"1";

        mes.extra = [NSString stringWithFormat:@"1/%@",model.messageUId];
        
        RCMessage *oldMess = [[RCIMClient sharedRCIMClient] getMessageByUId:model.messageUId];
        [[RCIMClient sharedRCIMClient] setMessageExtra:oldMess.messageId value:mes.extra];
        
        for (RCMessageModel *model in self.conversationDataRepository) {
            
            if (model.messageId == oldMess.messageId) {
                if (model.messageId == oldMess.messageId) {
                    XYredMessageContent *oldHongBao = (XYredMessageContent *)model.content;
                    oldHongBao.extra = mes.extra;
                    model.content = oldHongBao;
                }
            }
        }
        
        [self.conversationMessageCollectionView reloadData];
        
        XYredMessageContent *cons = (XYredMessageContent*)model.content;
        NSString *messge = cons.message;
        
        WSRewardConfig *info = ({
            WSRewardConfig *info = [[WSRewardConfig alloc] init];
            info.money = 100.0;
            info.headImgurl = model.userInfo.portraitUri;
            info.content = messge;
            info.userName = model.userInfo.name;
            info;
        });
        
        [WSRedPacketView showRedPackerWithData:info cancelBlock:^{
            NSLog(@"取消领取");
        } finishBlock:^(float money) {
            NSLog(@"领取金额：%f",money);
        }];
    }
    
   
    
}

/**
 礼物定时器release
 */
-(void)timeFireMethod{
    _second ++;
    if (_second >= 3) {
        [_flowFlower endFlyFlower];
        [_gifTimer invalidate];
        _flowFlower = nil;
        _gifTimer = nil;
    }
}


- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content isKindOfClass:[XYredMessageContent class]]) {
        
        
//        XYredMessageContent *mes = (XYredMessageContent *)message.content;
//        NSString *ex = mes.isopen;
//
//        NSString *sta = [ex componentsSeparatedByString:@"/"][0];
//        NSString *oldMessID = [ex componentsSeparatedByString:@"/"][1];
//        if ([sta isEqualToString:@"1"])  {//已接收
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                RCMessage *oldMess = [[RCIMClient sharedRCIMClient] getMessageByUId:oldMessID];
//
//                for (RCMessageModel *model in self.conversationDataRepository) {
//                    if (model.messageId == oldMess.messageId) {
//                        XYredMessageContent *oldHongBao = (XYredMessageContent *)model.content;
//                        oldHongBao.isopen = ex;
//                        model.content = oldHongBao;
//                    }
//                }
//
//                //[[RCIMClient sharedRCIMClient] setMessageExtra:oldMess.messageId value:mes.isopen];
//
//                [self.conversationMessageCollectionView reloadData];
//            });
//
//        }
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
