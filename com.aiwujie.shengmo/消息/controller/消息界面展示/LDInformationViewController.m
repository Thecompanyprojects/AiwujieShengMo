//
//  LDInformationViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDInformationViewController.h"
#import "LDStampViewController.h"
#import "PersonChatViewController.h"
#import "LDMyWalletPageViewController.h"
#import "LDGroupSpuareViewController.h"
#import "LDApplyAddGroupViewController.h"
#import "LDGroupChatViewController.h"
#import "LDKFViewController.h"
#import "LDSystemViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDGroupInformationViewController.h"
#import "LDMemberViewController.h"
#import "LDCertificateBeforeViewController.h"
#import "LDStampChatView.h"
#import "LDStampViewController.h"
#import "UITabBar+badge.h"

@interface LDInformationViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,StampChatDelete>
@property (nonatomic,strong) UIView *groupDogView;
@property (nonatomic,strong) RCConversationModel* model;
@property (nonatomic,strong) LDStampChatView *stampView;
@end

@implementation LDInformationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self createDataLat:[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] andLng:[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]];
    //获取消息列表未读消息数
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
    NSInteger badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (badge <= 0) {
            item.badgeValue = 0;
        }else{
            item.badgeValue = [NSString stringWithFormat:@"%ld",(long)badge];
        }
    });
    //判断是不是有新建的群
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"groupBadge"] length] == 0) {
        _groupDogView.hidden = YES;
    }else{
        _groupDogView.hidden = NO;
    }
}

//上传实时位置
-(void)createDataLat:(NSString *)lat andLng:(NSString *)lng{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/setLogintimeAndLocation"];
    NSDictionary *parameters;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"province"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"province"];
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"city"];
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"addr"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addr"];
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"latitude"];
            
            lat = @"";
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"longitude"];
            
            lng = @"";
            
        }
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":lat,@"lng":lng,@"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"city"],@"addr":[[NSUserDefaults standardUserDefaults] objectForKey:@"addr"],@"province":[[NSUserDefaults standardUserDefaults] objectForKey:@"province"]};
        
    }else{
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"city":@"",@"addr":@"",@"province":@""};
    }
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_SYSTEM),@(ConversationType_PUSHSERVICE),@(ConversationType_CUSTOMERSERVICE)]];
//    //设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_GROUP)]];
    
//    [RCIM sharedRCIM].portraitImageViewCornerRadius = 23;
    
    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    
    [[RCIM sharedRCIM] setGroupMemberDataSource:self];
    
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    
    self.emptyConversationView = [[UIView alloc]  initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    imageView.image = [UIImage imageNamed:@""];
    [self.emptyConversationView addSubview:imageView];
    
    self.navigationItem.title = @"消息";
    
    self.navigationItem.hidesBackButton = YES;
    
    self.showConnectingStatusOnNavigatorBar = YES;
    
    [self createButton];
    
    //监听是否清空了聊天记录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChatCache) name:@"清空聊天记录" object:nil];
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    NSString *topString;
    if (model.isTop) {
        
        topString = @"取消置顶";
        
    }else{
        
        topString = @"置顶";
    }
    
    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:topString handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        if ([[RCIMClient sharedRCIMClient] setConversationToTop:model.conversationType targetId:model.targetId isTop:!model.isTop]) {
            
            [self refreshConversationTableViewIfNeeded];
        } ;
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if ([[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId]) {
            
            [self refreshConversationTableViewIfNeeded];
        }
    }];
    
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction,topAction];
}

-(void)didTapCellPortrait:(RCConversationModel *)model{

    if(model.conversationType == ConversationType_PRIVATE){
        
        LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
        avc.userID = model.targetId;
        [self.navigationController pushViewController:avc animated:YES];
        
    }else if (model.conversationType == ConversationType_GROUP){
        
        LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];
        fvc.gid = model.targetId;
        [self.navigationController pushViewController:fvc animated:YES];
        
    }
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}

-(void)deleteChatCache{
    
    NSArray *listArray = @[[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6]];

    [[RCIMClient sharedRCIMClient] clearConversations:listArray];
    
    [self.conversationListTableView reloadData];
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath{

    RCConversationCell *messageCell = (RCConversationCell *)cell;
    messageCell.lastSendMessageStatusView.image = [UIImage imageNamed:@"已读"];
    
//    UIImageView *vipImg = [UIImageView new];
//    vipImg.backgroundColor = [UIColor redColor];
//    [messageCell addSubview:vipImg];
//    [vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(messageCell.headerImageView);
//        make.bottom.equalTo(messageCell.headerImageView);
//        make.width.mas_offset(20);
//        make.height.mas_offset(20);
//    }];
    
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    if (model.conversationType == ConversationType_SYSTEM) {
        
        if ([model.targetId isEqualToString:@"4"] || [model.targetId isEqualToString:@"9"]) {
            
            LDApplyAddGroupViewController *gvc = [[LDApplyAddGroupViewController alloc] init];
            
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:model.targetId];
            
            if ([model.targetId isEqualToString:@"4"]) {
                
                gvc.chatSystemType = chatSystemTypeApply;
                
            }else if ([model.targetId isEqualToString:@"9"]){
            
                gvc.chatSystemType = chatSystemTypeFollowMessage;
            }
            
            [self.navigationController pushViewController:gvc animated:YES];

        }else if ([model.targetId isEqualToString:@"1"]){
        
            LDSystemViewController *svc = [[LDSystemViewController alloc] init];
            svc.conversationType = model.conversationType;
            svc.targetId = model.targetId;
            svc.title = @"系统消息";
            [self.navigationController pushViewController:svc animated:YES];
            
        }else if([model.targetId isEqualToString:@"2"]){
        
            LDSystemViewController *svc = [[LDSystemViewController alloc] init];
            svc.conversationType = model.conversationType;
            svc.targetId = model.targetId;
            svc.title = @"活动消息";
            [self.navigationController pushViewController:svc animated:YES];

        }
        
    }else if(model.conversationType == ConversationType_PRIVATE){
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] length] != 0) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您因违规被系统禁用聊天功能,解封时间请查看系统通知,如有疑问请与客服联系!"];
            
        }else{
            
            //存储聊天对象的数据
            _model = model;
        
            [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getOpenChatRestrictAndInfoUrl];
            NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"otheruid":model.targetId};
            
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
                
                if (integer == 2000 || integer == 2001) {
                    
                    [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
                    
                    PersonChatViewController *conversationVC = [[PersonChatViewController alloc]init];
                    conversationVC.conversationType = model.conversationType;
                    conversationVC.targetId = model.targetId;
                    conversationVC.mobile = model.targetId;
                    
                    if (integer == 2000) {
                        
                        conversationVC.state = [NSString stringWithFormat:@"%d",[responseObj[@"data"][@"filiation"] intValue]];
                    }
                    
                    if ([responseObj[@"data"][@"info"][@"is_admin"] integerValue] == 1) {
                        
                        conversationVC.type = personIsADMIN;
                        
                    }else if ([responseObj[@"data"][@"info"][@"is_volunteer"] integerValue] == 1){
                        
                        conversationVC.type = personIsVOLUNTEER;
                        
                    }else if ([responseObj[@"data"][@"info"][@"svipannual"] integerValue] == 1){
                        
                        conversationVC.type = personIsSVIPANNUAL;
                        
                    }else if ([responseObj[@"data"][@"info"][@"svip"] integerValue] == 1) {
                        
                        conversationVC.type = personIsSVIP;
                        
                    }else if ([responseObj[@"data"][@"info"][@"vipannual"] integerValue] == 1) {
                        
                        conversationVC.type = personIsVIPANNUAL;
                        
                    }else if ([responseObj[@"data"][@"info"][@"vip"] integerValue] == 1){
                        
                        conversationVC.type = personIsVIP;
                        
                    }else{
                        
                        conversationVC.type = personIsNormal;
                    }
                    
                    conversationVC.title = model.conversationTitle;
                    //conversationVC.unReadMessage = model.unreadMessageCount;
                    conversationVC.enableUnreadMessageIcon = YES;
                    [self.navigationController pushViewController:conversationVC animated:YES];
                    
                }else if(integer == 3001){
                    
                    [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
                    
                    _stampView = [[LDStampChatView alloc] initWithFrame:CGRectMake(0, 0 , WIDTH, HEIGHT)];
                    _stampView.viewController = self;
                    _stampView.data = responseObj[@"data"];
                    _stampView.delegate = self;
                    [self.tabBarController.view addSubview:_stampView];
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
                    
                }
            } failed:^(NSString *errorMsg) {
                [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络请求超时,请重试~"];
            }];
        }
    }else if (model.conversationType == ConversationType_GROUP){
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] length] != 0) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您因违规被系统禁用聊天功能,解封时间请查看系统通知,如有疑问请与客服联系!"];
            
        }else{
        
            LDGroupChatViewController *cvc = [[LDGroupChatViewController alloc] init];
            cvc.conversationType = model.conversationType;
            cvc.targetId = model.targetId;
            cvc.title = model.conversationTitle;
            cvc.groupId = model.targetId;
            cvc.enableUnreadMessageIcon = YES;
            //chatView.enableNewComingMessageIcon=YES;//开启消息提醒
            [self.navigationController pushViewController:cvc animated:YES];
        }
        
    }else if(model.conversationType == ConversationType_CUSTOMERSERVICE){
    
        LDKFViewController *chatService = [[LDKFViewController alloc] init];
        //    chatService.userName = @"客服";
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = SERVICE_ID;
        chatService.title = @"圣魔官方客服";
        
        RCCustomerServiceInfo *csInfo = [[RCCustomerServiceInfo alloc] init];
        csInfo.userId = [RCIMClient sharedRCIMClient].currentUserInfo.userId;
        csInfo.nickName = [RCIMClient sharedRCIMClient].currentUserInfo.name;
        csInfo.portraitUrl =
        [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri;
        
        [self.navigationController pushViewController :chatService animated:YES];
    }
    
    
}

//stampChat的代理方法
-(void)didSelectStamp:(NSString *)stamptype{
    
    [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Restrict/useStampToChatNew"];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"otheruid":_model.targetId,@"stamptype":stamptype};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
            if (integer == 4001 || integer == 3000) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }else{
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请稍后再试~"];
            }
        }else if(integer == 2000){
            [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
            PersonChatViewController *conversationVC = [[PersonChatViewController alloc]init];
            [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
            [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
            conversationVC.conversationType = ConversationType_PRIVATE;
            conversationVC.targetId = _model.targetId;
            conversationVC.mobile = _model.targetId;
            conversationVC.state = [NSString stringWithFormat:@"%d",[responseObj[@"data"][@"filiation"] intValue]];
            if ([responseObj[@"data"][@"info"][@"is_admin"] integerValue] == 1) {

                conversationVC.type = personIsADMIN;
                
            }else if ([responseObj[@"data"][@"info"][@"is_volunteer"] integerValue] == 1){
                
                conversationVC.type = personIsVOLUNTEER;
                
            }else if ([responseObj[@"data"][@"info"][@"svipannual"] integerValue] == 1){
                
                conversationVC.type = personIsSVIPANNUAL;
                
            }else if ([responseObj[@"data"][@"info"][@"svip"] integerValue] == 1) {
                
                conversationVC.type = personIsSVIP;
                
            }else if ([responseObj[@"data"][@"info"][@"vipannual"] integerValue] == 1) {
                
                conversationVC.type = personIsVIPANNUAL;
                
            }else if ([responseObj[@"data"][@"info"][@"vip"] integerValue] == 1){
                
                conversationVC.type = personIsVIP;
                
            }else{
                
                conversationVC.type = personIsNormal;
            }
            conversationVC.title = _model.conversationTitle;
            
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
    }];
}

#pragma 选择邮票聊天页面代理
-(void)didSelectOtherButton{
    
    LDStampViewController *wvc = [[LDStampViewController alloc] init];
    
    [self.navigationController pushViewController:wvc animated:YES];
}

-(void)didSelectAttentButton:(UIView *)backView andButton:(UIButton *)button{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:backView animated:YES];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":_model.targetId};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:setfollowOne] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES];
            button.userInteractionEnabled = NO;
            if (integer == 4787 || integer == 4002) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"已关注对方,请不要重复操作~"];
            }
            else if (integer==8881||integer==8882)
            {
                NSString *msg = [responseObj objectForKey:@"msg"];
                UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"开会员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                    [self.navigationController pushViewController:mvc animated:YES];
                }];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    cvc.where = @"2";
                    [self.navigationController pushViewController:cvc animated:YES];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [control addAction:action1];
                [control addAction:action0];
                [control addAction:action2];
                [self presentViewController:control animated:YES completion:^{
                    
                }];
            }
            else{
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
        }else{
            if ([responseObj[@"data"] intValue] == 1) {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"已互为好友，可以免费无限畅聊了~";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
            }else{
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"已关注成功！互为好友即可免费畅聊~";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
            }
            [button setTitle:@"已关注" forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        }
    } failed:^(NSString *errorMsg) {
        button.userInteractionEnabled = NO;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
    }];
}

//点击去开通按钮跳转到会员页面
-(void)stampOpenSvipButtonClick{
    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:YES];
}

/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 **/
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/getmineinfo"];

    NSDictionary *parameters = @{@"uid":userId};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            //此处为了演示写了一个用户信息
            RCUserInfo *user = [[RCUserInfo alloc] init];;
            user.userId = userId;
            user.name = responseObj[@"data"][@"nickname"];
            user.portraitUri = responseObj[@"data"][@"head_pic"];
            
            return completion(user);
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
    
    NSDictionary *parameters;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"gid":groupId,@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]};

        
    }else{
        
        parameters = @{@"gid":groupId,@"lat":@"",@"lng":@""};

    }
    
    [NetManager afPostRequest:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getGroupinfo"] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            //此处为了演示写了一个用户信息
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = groupId;
            group.groupName = responseObj[@"data"][@"groupname"];
            group.portraitUri = responseObj[@"data"][@"group_pic"];
            //            NSLog(@"%@",responseObject[@"data"][@"head_pic"]);
            return completion(group);
            
        }     
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

-(void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/other/getGroupMember"];
    
    NSDictionary *parameters = @{@"gid":groupId};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer == 2000) {
            
            NSArray *members = responseObj[@"data"];
            
            NSMutableArray *tempArr = [NSMutableArray new];
            
            for (int i = 0; i < members.count ; i++) {
                
                RCUserInfo *member = [[RCUserInfo alloc] init];
                
                member.userId = members[i];
                
                [tempArr addObject:member.userId];
            }
            
            resultBlock(tempArr);
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)createButton{
    
    //群广场按钮
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [areaButton setTitle:@"群广场" forState:UIControlStateNormal];
    [areaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    areaButton.titleLabel.font = [UIFont systemFontOfSize:14];
    areaButton.tag = 10;
    [areaButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //群广场右上方红点
    _groupDogView = [[UIView alloc] initWithFrame:CGRectMake(63, 30, 10, 10)];
    _groupDogView.backgroundColor = [UIColor redColor];
    _groupDogView.layer.cornerRadius = 5;
    _groupDogView.clipsToBounds = YES;
    _groupDogView.hidden = YES;
    [self.navigationController.view addSubview:_groupDogView];
    
    //清空聊天列表和忽略未读信息按钮
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        
        LDGroupSpuareViewController *svc = [[LDGroupSpuareViewController alloc] init];
        
        [self.navigationController pushViewController:svc animated:YES];
        
    }else{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
            
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"忽略未读消息" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {

            
            for (int i = 0; i < [self.conversationListDataSource count] ; i++) {
                
                RCConversationModel * model = self.conversationListDataSource[i];
                
                if (model.conversationType == ConversationType_GROUP) {
                    
                    if ([[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_GROUP
                        targetId:model.targetId] != 0) {
                        
                        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_GROUP targetId:model.targetId];
                        
                        model.unreadMessageCount = 0;
                        
                        [self.conversationListDataSource replaceObjectAtIndex:i withObject:model];
                    };

                
                }else if (model.conversationType == ConversationType_SYSTEM){
                    
                    if ([[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_SYSTEM
                        targetId:model.targetId] != 0) {
                        
                        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:model.targetId];
                        
                        model.unreadMessageCount = 0;
                        
                        [self.conversationListDataSource replaceObjectAtIndex:i withObject:model];
                    };
                    
                    
                }else if (model.conversationType == ConversationType_PRIVATE){
                        
                    
                    if ([[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE
                        targetId:model.targetId] != 0) {
                        
                        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:model.targetId];
                        
                        model.unreadMessageCount = 0;
                        
                        [self.conversationListDataSource replaceObjectAtIndex:i withObject:model];
                    };

                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.conversationListTableView reloadData];
                
            });

            UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:2];
            
            item.badgeValue = 0;
            
        }];
        
        UIAlertAction * report = [UIAlertAction actionWithTitle:@"清空聊天列表" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            __weak LDInformationViewController *weakSelf = self;
            
            [weakSelf.conversationListDataSource removeAllObjects];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray *listArray = @[[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6]];
                
                [[RCIMClient sharedRCIMClient] clearConversations:listArray];
                
                [weakSelf.conversationListTableView reloadData];
                
            });

        }];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
        
            [action setValue:MainColor forKey:@"_titleTextColor"];
            [report setValue:MainColor forKey:@"_titleTextColor"];
            
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
        }
        
        [alert addAction:cancel];
        
        [alert addAction:report];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    _groupDogView.hidden = YES;
    
    if (_stampView) {
        
         [_stampView removeView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
