//
//  LDSetViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSetViewController.h"
#import "LDLoginViewController.h"
#import "LDBindingPhoneNumViewController.h"
#import "LDBindingEmailViewController.h"
#import "LDCertificateViewController.h"
#import "LDFeedbackViewController.h"
#import "LDRevisePasswordViewController.h"
#import "LDGeneralViewController.h"
#import "LDCertificateBeforeViewController.h"
#import "LDSetGenstureViewController.h"
#import "LDVoiceSetViewController.h"
#import "LDNoDisturbViewController.h"
#import "LDHelpCenterViewController.h"
#import "ShowBadgeCell.h"
#import "UITabBar+badge.h"
#import "AppDelegate.h"
#import "LDharassmentVC.h"
#import "NewldprovacyVC.h"

@interface LDSetViewController ()<UITableViewDelegate,UITableViewDataSource,TencentSessionDelegate>{
    
    TencentOAuth *_tencentOAuth;
}


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,copy) NSString *status;

//绑定的状态
@property (nonatomic,copy) NSString *bindPhoneState;
@property (nonatomic,copy) NSString *bindEmailState;
@property (nonatomic,copy) NSString *bindOpenidState;

//存储的手机号,邮箱
@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,copy) NSString *emailNum;
@property (nonatomic,assign) BOOL isSvip;

@end

@implementation LDSetViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getBindState];
}

-(void)getBindState{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getBindingState"];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            if ([responseObject[@"data"][@"mobile"] length] == 0) {
                
                _bindPhoneState = @"";
                
                _phoneNum = @"";
                
            }else{
                
                _phoneNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mobile"]];
            
                NSString *str = [responseObject[@"data"][@"mobile"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                
                _bindPhoneState = str;
                
            }
            
            if ([responseObject[@"data"][@"email"] length] == 0) {
                
                _bindEmailState = @"";
                
                _emailNum = @"";
                
            }else{
                
                _emailNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"email"]];
                
                NSArray *array = [responseObject[@"data"][@"email"] componentsSeparatedByString:@"@"];
                
                NSString *string = [NSString string];
                
                for (int i = 0; i < [array[0] length] - 2; i++) {
                    
                    string = [string stringByAppendingString:@"*"];
                }
                
                NSString *str = [responseObject[@"data"][@"email"] stringByReplacingCharactersInRange:NSMakeRange(1, [array[0] length] - 2) withString:string];
                
                _bindEmailState = str;
                
            }

            if ([responseObject[@"data"][@"openid"] length] == 0) {
                
                _bindOpenidState = @"";
                
            }else{
            
                if ([responseObject[@"data"][@"channel"] intValue] == 1) {
                    
                    _bindOpenidState = @"已绑定微信";
                    
                }else if([responseObject[@"data"][@"channel"] intValue] == 2){
                
                    _bindOpenidState = @"已绑定QQ";
                    
                }else if([responseObject[@"data"][@"channel"] intValue] == 3){
                
                    _bindOpenidState = @"已绑定微博";
                }
            }
            
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
      
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    self.tabBarController.tabBar.hidden = YES;

//    _dataArray = @[@[@"绑定手机"],@[@"绑定邮箱"],@[@"绑定第三方"],@[@"密码设置"],@[@"手势密码"],@[@"声音设置"],@[@"消息设置"],@[@"隐私"],@[@"通用"],@[@"意见反馈"],@[@"帮助中心"],@[@"关于圣魔APP"]];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue] == 1) {
        self.isSvip = YES;
    }
    
    if (self.isSvip) {
          _dataArray = @[@[@"绑定手机",@"绑定邮箱",@"绑定第三方"],@[@"密码设置",@"手势密码"],@[@"声音设置",@"隐私",@"防骚扰",@"通用"],@[@"意见反馈",@"帮助中心",@"版本号"]];
    }
    else
    {
          _dataArray = @[@[@"绑定手机",@"绑定邮箱",@"绑定第三方"],@[@"密码设置",@"手势密码"],@[@"声音设置",@"隐私",@"通用"],@[@"意见反馈",@"帮助中心",@"版本号"]];
    }
    [self createTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindWXOpendClick) name:@"绑定微信第三方" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindWBOpendClick) name:@"绑定微博第三方" object:nil];
}

//绑定微博第三方
-(void)bindWBOpendClick{

    [self bindOpenid:[[NSUserDefaults standardUserDefaults] objectForKey:@"bindOpenid"] andChannel:@"3"];
}

//绑定微信第三方
-(void)bindWXOpendClick{

    [self bindOpenid:[[NSUserDefaults standardUserDefaults] objectForKey:@"bindOpenid"] andChannel:@"1"];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createTableView{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    [self addTableViewFootView];
}

- (void)addTableViewFootView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.tableView.tableFooterView = view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3 && indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        cell.imageView.image = [UIImage imageNamed:_dataArray[indexPath.section][indexPath.row]];
        cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:12];//设置字体为斜体
        cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = TextCOLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ShowBadgeCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ShowBadgeCell" owner:self options:nil].lastObject;
        cell.headView.image = [UIImage imageNamed:_dataArray[indexPath.section][indexPath.row]];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                
                if (_bindPhoneState.length == 0) {
                    
                    cell.detailLabel.text = @"未绑定";
                    cell.detailLabel.textColor = [UIColor redColor];
                    
                }else{
                    
                    cell.detailLabel.text = _bindPhoneState;
                }
                
            }else if (indexPath.row == 1){
                
                if (_bindEmailState.length == 0) {
                    
                    cell.detailLabel.text = @"未绑定";
                    cell.detailLabel.textColor = [UIColor redColor];
                    
                }else{
                    
                    cell.detailLabel.text = _bindEmailState;
                }
                
            }else if (indexPath.row == 2){
                
                if (_bindOpenidState.length == 0) {
                    
                    cell.detailLabel.text = @"未绑定";
                    cell.detailLabel.textColor = [UIColor redColor];
                    
                }else{
                    
                    cell.detailLabel.text = _bindOpenidState;
                }
                
            }
            
        }
        
        
        if (indexPath.section==0) {
            if (indexPath.row==2) {
                cell.lineView.hidden = YES;
            }
            else
            {
                cell.lineView.hidden = NO;
            }
        }
        if (indexPath.section==1) {
            if (indexPath.row==1) {
                cell.lineView.hidden = YES;
            }
            else
            {
                cell.lineView.hidden = NO;
                
            }
        }
        if (indexPath.section==2) {
            if (self.isSvip) {
                if (indexPath.row==3) {
                    cell.lineView.hidden = YES;
                }
                else
                {
                    cell.lineView.hidden = NO;
                }
            }
            else
            {
                if (indexPath.row==2) {
                    cell.lineView.hidden = YES;
                }
                else
                {
                    cell.lineView.hidden = NO;
                }
            }
        }
        if (indexPath.section==3) {
            if (indexPath.row==2) {
                cell.lineView.hidden = YES;
            }
            else
            {
                cell.lineView.hidden = NO;
            }
        }
        cell.detailLabel.font = [UIFont italicSystemFontOfSize:12];//设置字体为斜体
        cell.nameLabel.text = _dataArray[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0){
            
            LDBindingPhoneNumViewController * pvc = [[LDBindingPhoneNumViewController alloc] init];
            
            pvc.phoneNum = _phoneNum;
            
            [self.navigationController pushViewController:pvc animated:YES];
            
        }else if (indexPath.row == 1){
            
            LDBindingEmailViewController *evc = [[LDBindingEmailViewController alloc] init];
            
            evc.emailNum = _emailNum;
            
            [self.navigationController pushViewController:evc animated:YES];
            
        }else if (indexPath.row == 2){
            
            if (_bindOpenidState.length == 0) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction * wechatAction = [UIAlertAction actionWithTitle:@"绑定微信" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    
                    //构造SendAuthReq结构体
                    SendAuthReq* req =[[SendAuthReq alloc ] init];
                    
                    req.scope = @"snsapi_userinfo" ;
                    
                    req.state = @"WXBind";
                    
                    //第三方向微信终端发送一个SendAuthReq消息结构
                    [WXApi sendReq:req];
                    
                }];
                
                UIAlertAction * qqAction = [UIAlertAction actionWithTitle:@"绑定QQ" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    
                    _tencentOAuth =
                    [[TencentOAuth alloc] initWithAppId:@"1105968084" andDelegate:self];
                    
                    NSArray* permissions = [NSArray arrayWithObjects:
                                            kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                            kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_ADD_SHARE ,                               nil];
                    
                    _tencentOAuth.sessionDelegate = self;
                    
                    [_tencentOAuth authorize:permissions inSafari:NO];
                    
                }];
                
                
                UIAlertAction * wbAction = [UIAlertAction actionWithTitle:@"绑定微博" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    
                    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
                    request.redirectURI = kRedirectURI;
                    request.scope = @"all";
                    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                                         @"Other_Info_1": @"bindWB",
                                         @"Other_Info_2": @[@"obj1", @"obj2"],
                                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
                    [WeiboSDK sendRequest:request];
                    
                }];
                
                
                UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
                
                if (PHONEVERSION.doubleValue >= 8.3) {
                
                    [wechatAction setValue:MainColor forKey:@"_titleTextColor"];
                    [qqAction setValue:MainColor forKey:@"_titleTextColor"];
                    [wbAction setValue:MainColor forKey:@"_titleTextColor"];
                    [cancel setValue:MainColor forKey:@"_titleTextColor"];
                }
                
                [alert addAction:cancel];
                
                [alert addAction:wechatAction];
                
                [alert addAction:qqAction];
                
                [alert addAction:wbAction];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                
                UIAlertController *alert = [[UIAlertController alloc] init];
                
                if ([_bindOpenidState isEqualToString:@"已绑定微信"]) {
                    
                    alert = [UIAlertController alertControllerWithTitle:@"解除微信绑定?" message:@"解除微信账号绑定后,你将不能通过该微信登录此账号"    preferredStyle:UIAlertControllerStyleAlert];
                    
                }else if ([_bindOpenidState isEqualToString:@"已绑定QQ"]){
                    
                    alert = [UIAlertController alertControllerWithTitle:@"解除QQ绑定?" message:@"解除QQ账号绑定后,你将不能通过该QQ登录此账号"    preferredStyle:UIAlertControllerStyleAlert];
                    
                }else if ([_bindOpenidState isEqualToString:@"已绑定微博"]){
                    
                    alert = [UIAlertController alertControllerWithTitle:@"解除微博绑定?" message:@"解除微博账号绑定后,你将不能通过该微博登录此账号"    preferredStyle:UIAlertControllerStyleAlert];
                }
                
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                    
                    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                    manager.requestSerializer.timeoutInterval = 10.f;
                    
                    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                    
                    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/removeOther"];
                    
                    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                    
                    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                        //                NSLog(@"%@",responseObject);
                        if (integer != 2000) {
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                            
                        }else{
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                            [self getBindState];
                            
                        }
                        
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                    }];
                    
                    
                }];
                
                UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
                
                if (PHONEVERSION.doubleValue >= 8.3) {
                
                    [sureAction setValue:MainColor forKey:@"_titleTextColor"];
                    [cancel setValue:MainColor forKey:@"_titleTextColor"];
                    
                }
                
                [alert addAction:cancel];
                
                [alert addAction:sureAction];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }else {
            
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            
            LDRevisePasswordViewController *pvc = [[LDRevisePasswordViewController alloc] init];
            
            [self.navigationController pushViewController:pvc animated:YES];
            
        }else if (indexPath.row == 1){
            
            LDSetGenstureViewController *gvc = [[LDSetGenstureViewController alloc] init];
            
            [self.navigationController pushViewController:gvc animated:YES];
            
        }
    }else if (indexPath.section == 2){
        
        if(indexPath.row == 0){
            
            LDVoiceSetViewController *svc = [[LDVoiceSetViewController alloc] init];
            
            [self.navigationController pushViewController:svc animated:YES];
            
            
        }else if(indexPath.row == 1){
            
          
//            LDProvacyViewController *pvc = [[LDProvacyViewController alloc] init];
//
//            [self.navigationController pushViewController:pvc animated:YES];
            
            NewldprovacyVC *vc = [NewldprovacyVC new];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(indexPath.row == 2){
            
            if (self.isSvip)
            {
                LDharassmentVC *vc = [LDharassmentVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                LDGeneralViewController *gvc = [[LDGeneralViewController alloc] init];
                [self.navigationController pushViewController:gvc animated:YES];
            }
        }else if (indexPath.row==3){
            LDGeneralViewController *gvc = [[LDGeneralViewController alloc] init];
            [self.navigationController pushViewController:gvc animated:YES];
        }
        
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0){
            
            LDFeedbackViewController *fvc = [[LDFeedbackViewController alloc] init];
            
            [self.navigationController pushViewController:fvc animated:YES];
            
        }else if(indexPath.row == 1){
            
            LDHelpCenterViewController *cvc = [[LDHelpCenterViewController alloc] init];
            
            [self.navigationController pushViewController:cvc animated:YES];
        }
    }
}

- (void)tencentDidLogin {
    
    if ([_tencentOAuth getUserInfo]) {
        
        [self bindOpenid:[_tencentOAuth getUserOpenID] andChannel:@"2"];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"message:@"获取个人信息失败" delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil)otherButtonTitles:nil];
        
        [alert show];
    }
    
}

-(void)bindOpenid:(NSString *)openid andChannel:(NSString *)channel{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/bindingOther"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"openid":openid,@"channel":channel};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
//                        NSLog(@"%@",responseObject);
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self getBindState];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
    if (cancelled == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消授权" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"授权失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)tencentDidNotNetWork {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误,授权失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

-(void)exitButtonClick{
    
    LDLoginViewController *push = [[LDLoginViewController alloc] initWithNibName:@"LDLoginViewController" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:push];

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"hideLocation"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"lookBadge"];
    
    [[RCIM sharedRCIM] disconnect:NO];
    
    [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
    [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
    [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
    [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
    [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = nav;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
