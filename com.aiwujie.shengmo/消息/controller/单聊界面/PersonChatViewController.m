//
//  PersonChatViewController.m
//  yupaopao
//
//  Created by a on 16/8/14.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "PersonChatViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDLookOtherGroupInformationViewController.h"
#import "LDGroupInformationViewController.h"
#import "GifView.h"

#import "XYRichMessageCell.h"
#import "XYRichMessageContent.h"
#import "LDMyWalletPageViewController.h"

@interface PersonChatViewController ()<RCPluginBoardViewDelegate>
@property (strong, nonatomic) UIView *upView;
//礼物界面
@property (nonatomic,strong) GifView *gif;
@end

@implementation PersonChatViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    

    //注册自定义消息Cell
    [self registerClass:[XYRichMessageCell class] forMessageClass:[XYRichMessageContent class]];

    
    if (_type != personIsNormal) {
        
        //更改导航栏的标题文字
        [self changeNavigationTitle];
    }

    if ([self.state intValue] == 2) {
        
        if (ISIPHONEX) {
            
            self.conversationMessageCollectionView.frame = CGRectMake(0, 144, WIDTH, HEIGHT - 144);
            
            _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, WIDTH, 56)];
            
        }else{
            
            self.conversationMessageCollectionView.frame = CGRectMake(0, 120, WIDTH, HEIGHT - 120);
            
            _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 56)];
        }
        
        _upView.backgroundColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
        
        [self.view addSubview:_upView];
        
        UILabel *showLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 209, 20)];
        showLabel1.text = @"对方已关注你，是否关注对方?";
        showLabel1.textColor = [UIColor whiteColor];
        showLabel1.font = [UIFont systemFontOfSize:15];
        [_upView addSubview:showLabel1];
        
        UILabel *showLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 29, 209, 20)];
        showLabel2.text = @"互相关注即为好友";
        showLabel2.textColor = [UIColor whiteColor];
        showLabel2.font = [UIFont systemFontOfSize:11];
        [_upView addSubview:showLabel2];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 35, 21, 1, 17)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_upView addSubview:lineView];
        
        
        UIButton *attentButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 90, 17, 43, 23)];
        [attentButton setTitle:@"关注" forState:UIControlStateNormal];
        [attentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [attentButton addTarget:self action:@selector(attentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        attentButton.titleLabel.font = [UIFont systemFontOfSize:13];
        attentButton.layer.borderWidth = 1;
        attentButton.layer.borderColor = [UIColor whiteColor].CGColor;
        attentButton.layer.cornerRadius = 2;
        attentButton.clipsToBounds = YES;
        [_upView addSubview:attentButton];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 30, 16, 25, 25)];
        [deleteButton setTitle:@"×" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:22];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_upView addSubview:deleteButton];
        
    }
 
    [self createButton];
    
    //[self addredEnvelope];
}


/**
 聊天页面发红包
 */
-(void)addredEnvelope
{
    self.chatSessionInputBarControl.pluginBoardView.pluginBoardDelegate = self;
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"推顶火箭"] title:@"红包" atIndex:6 tag:2001];
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
        [_gif getPersonUid:self.mobile andSign:@"赠送给某人"andUIViewController:self];
        
        __weak typeof (self) weakSelf = self;
        
        _gif.sendmessageBlock = ^(NSDictionary *dic) {
            NSString *imagename = [dic objectForKey:@"image"];
            
//            NSString *title = @"我是标题";
//            NSArray *imgarray = [NSArray arrayWithObjects:[UIImage imageNamed:imagename], nil];
            
            NSDictionary *para = @{@"number":dic[@"num"],@"imageName":imagename};
            XYRichMessageContent *addcontent = [XYRichMessageContent messageWithDict:para];
            addcontent.number = dic[@"num"];
            addcontent.imageName = dic[@"image"];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:0 error:0];
            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [weakSelf sendMessage:addcontent pushContent:dataStr];

            
        };
        [self.tabBarController.view addSubview:_gif];
        
        
        
    }
}



/**
  * 更改导航栏的标题文字
 */
-(void)changeNavigationTitle{
    
    UIColor *navTitleColor = [[UIColor alloc] init];
    UIImage *navTitleImage = [[UIImage alloc] init];
    
    if (_type == personIsADMIN) {
        
        navTitleColor = [UIColor blackColor];
        navTitleImage = [UIImage imageNamed:@"官方认证"];
        
    }else if(_type == personIsVOLUNTEER) {
        
        navTitleColor = [UIColor greenColor];
        navTitleImage = [UIImage imageNamed:@"志愿者标识"];
        
    }else if (_type == personIsSVIPANNUAL) {
        
        navTitleColor = [UIColor redColor];
        navTitleImage = [UIImage imageNamed:@"年svip标识"];
        
    }else if (_type == personIsSVIP) {
        
        navTitleColor = [UIColor redColor];
        navTitleImage = [UIImage imageNamed:@"svip标识"];
        
    }else if (_type == personIsVIPANNUAL) {
        
        navTitleColor = MainColor;
        navTitleImage = [UIImage imageNamed:@"年费会员"];
        
    }else if (_type == personIsVIP) {
        
        navTitleColor = MainColor;
        navTitleImage = [UIImage imageNamed:@"高级紫"];
    }
    
    UILabel *textLabel = [[UILabel alloc] init];
    
    // 创建一个富文本
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",self.title]];
    // 修改富文本中的不同文字的样式
    [attri addAttribute:NSForegroundColorAttributeName value:navTitleColor range:NSMakeRange(0, attri.length)];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = navTitleImage;
    // 设置图片大小
    attch.bounds = CGRectMake(0, -3, 18, 18);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    
    // 用label的attributedText属性来使用富文本
    textLabel.attributedText = attri;
    
    [textLabel sizeToFit];
    
    textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(textLabel.frame), CGRectGetHeight(textLabel.frame));
    
    self.navigationItem.titleView = textLabel;
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
        
        NSDictionary *parameters;
        
        parameters = @{@"gid":gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

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
            
        }];
        
    }else{
        
        [super didTapUrlInMessageCell:url model:model];
    }
}

//关注成为好友
-(void)attentButtonClick{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.mobile};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:setfollowOne] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            NSString *msg = [responseObj objectForKey:@"msg"];
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"开会员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                cvc.where = @"8";
                [self.navigationController pushViewController:cvc animated:YES];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [control addAction:action1];
            [control addAction:action0];
            [control addAction:action2];
            [self presentViewController:control animated:YES completion:^{
                
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self deleteButtonClick];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//删除上方view
-(void)deleteButtonClick{
    
    if (ISIPHONEX) {
        
        self.conversationMessageCollectionView.frame = CGRectMake(0, 88, WIDTH, HEIGHT - 172);
        
    }else{
        
        self.conversationMessageCollectionView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 114);
    }

    [_upView removeFromSuperview];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell

                   atIndexPath:(NSIndexPath *)indexPath{

    RCMessageCell *messageCell = (RCMessageCell *)cell;
    
    if ([messageCell respondsToSelector:@selector(messageHasReadStatusView)]) {
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"已读"]];
        
        img.frame = CGRectMake(-2, 2, 17, 10);
        
        [messageCell.messageHasReadStatusView addSubview:img];
    }
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"个人图标"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    
    avc.userID = self.mobile;
    
    [self.navigationController pushViewController:avc animated:YES];
}

//点击聊天头像查看个人信息

- (void)didTapCellPortrait:(NSString *)userId{
    
    [self createData:userId];
    
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
