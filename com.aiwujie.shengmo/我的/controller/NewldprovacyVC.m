//
//  NewldprovacyVC.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "NewldprovacyVC.h"
#import "LDProvacyCell0.h"
#import "LDProvacyCell1.h"
#import "LDPrivacyPhotoViewController.h"
#import "LDBlackListViewController.h"
#import "LDpermissionsVC.h"

@interface NewldprovacyVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,assign) BOOL isFocuson;// 允许关注
@property (nonatomic,assign) BOOL isShowgroup;//允许查看群组
@property (nonatomic,assign) BOOL isPositioning; //允许定位
@property (nonatomic,assign) BOOL isLogintime;//登录时间
@property (nonatomic,assign) BOOL isshowPhoto;//是否开放相册
@property (nonatomic,assign) BOOL isshowalbum; //相册查看权限  true-好友/会员可见 false-所有人可见
@property (nonatomic,assign) BOOL isshowdynamic;// 主页动态查看 true-好友/会员可见 false-所有人可见
@property (nonatomic,assign) BOOL isshowcomments;// 主页评论查看 true-好友/会员可见 false-所有人可见

@property (nonatomic,copy) NSString *blackNumStr;
@end

static NSString *ldprovacyidentfity0 = @"ldprovacyidentfity0";
static NSString *ldprovacyidentfity1 = @"ldprovacyidentfity1";
static NSString *ldprovacyidentfity2 = @"ldprovacyidentfity2";
static NSString *ldprovacyidentfity3 = @"ldprovacyidentfity3";
static NSString *ldprovacyidentfity4 = @"ldprovacyidentfity4";
static NSString *ldprovacyidentfity5 = @"ldprovacyidentfity5";
static NSString *ldprovacyidentfity6 = @"ldprovacyidentfity6";
static NSString *ldprovacyidentfity7 = @"ldprovacyidentfity7";
static NSString *ldprovacyidentfity8 = @"ldprovacyidentfity8";

@implementation NewldprovacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"隐私";
    [self.view addSubview:self.table];
    [self addressManager];
    [self createStatusData];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self afterstaticData];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        [self backButtonOnClick];
    }
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
        _table.dataSource = self;
        _table.delegate = self;
        _table.tableFooterView = [UIView new];
    }
    return _table;
}

#pragma mark - getData

-(void)createStatusData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/getSecretSit"];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }
        else
        {
            if ([responseObj[@"data"][@"follow_list_switch"] intValue] == 0)
            {
                self.isFocuson = YES;
                
            }
            else
            {
                self.isFocuson = NO;
                
            }
            if ([responseObj[@"data"][@"group_list_switch"] intValue] == 0) {
                self.isShowgroup = YES;
            }else{
                
                self.isShowgroup = NO;
            }
            
            if ([responseObj[@"data"][@"login_time_switch"] intValue] == 0) {
                self.isLogintime = YES;
            }else{
                self.isLogintime = NO;
            }
            
            if ([responseObj[@"data"][@"photo_lock"] intValue] == 1) {
                
                self.isshowPhoto = YES;
            }else{
                
                self.isshowPhoto = NO;
            }
            
            //相册查看权限 0 所有人可见 1 好友/会员可见
            if ([responseObj[@"data"][@"photo_rule"] intValue] == 1) {
                
                self.isshowalbum = YES;
            }
            else
            {
                self.isshowalbum = NO;
            }
            
            //主页动态查看 0 所有人可见 1 好友/会员可见
            if ([responseObj[@"data"][@"dynamic_rule"] intValue] == 1) {
                
                self.isshowdynamic = YES;
            }
            else
            {
                self.isshowdynamic = NO;
            }

            //主页评论查看 0 所有人可见 1 好友/会员可见
            if ([responseObj[@"data"][@"comment_rule"] intValue] == 1) {
                
                self.isshowcomments = YES;
            }
            else
            {
                self.isshowcomments = NO;
            }
            
            self.blackNumStr = responseObj[@"data"][@"black_limit"];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",errorMsg);
    }];
}

-(void)afterstaticData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/getSecretSit"];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        if ([responseObj[@"data"][@"photo_lock"] intValue] == 1) {

            self.isshowPhoto = YES;
        }else{

            self.isshowPhoto = NO;
        }
        
         self.blackNumStr = responseObj[@"data"][@"black_limit"];
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - address

-(void)addressManager
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        self.isPositioning = YES;
        [self.table reloadData];
    }else{
        self.isPositioning = NO;
        [self.table reloadData];
    }
}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    if (section==1) {
        return 2;
    }
    if (section==2) {
        return 4;
    }
    if (section==3) {
        return 1;
    }
    return 0;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            LDProvacyCell0 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity0];
            cell = [[LDProvacyCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"允许他人查看关注列表";
            [cell.switchBtn addTarget:self action:@selector(changeFocuson:) forControlEvents:UIControlEventValueChanged];
            if (self.isFocuson) {
                cell.switchBtn.on = YES;
            }
            else
            {
                cell.switchBtn.on = NO;
            }
            return cell;
        }
        if (indexPath.row==1) {
            LDProvacyCell0 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity1];
            cell = [[LDProvacyCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"允许他人查看群组列表";
            [cell.switchBtn addTarget:self action:@selector(changeGroup:) forControlEvents:UIControlEventValueChanged];
            if (self.isShowgroup) {
                cell.switchBtn.on = YES;
            }
            else
            {
                cell.switchBtn.on = NO;
            }
            return cell;
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            LDProvacyCell0 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity2];
            cell = [[LDProvacyCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"地理位置";
            [cell.switchBtn addTarget:self action:@selector(changePosition:) forControlEvents:UIControlEventValueChanged];
            if (self.isPositioning) {
                cell.switchBtn.on = YES;
            }
            else
            {
                cell.switchBtn.on = NO;
            }
            return cell;
        }
        if (indexPath.row==1) {
            LDProvacyCell0 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity3];
            cell = [[LDProvacyCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"登录时间";
            [cell.switchBtn addTarget:self action:@selector(changeLogintime:) forControlEvents:UIControlEventValueChanged];
            if (self.isLogintime) {
                cell.switchBtn.on = YES;
            }
            else
            {
                cell.switchBtn.on = NO;
            }
            return cell;
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity4];
            cell = [[LDProvacyCell1 alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity4];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"隐私相册";
            if (self.isshowPhoto) {
                cell.contentLab.text = @"已开放";
            }
            else
            {
                cell.contentLab.text = @"未开放";
            }
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        if (indexPath.row==1) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity5];
            cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity5];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"主页相册查看权限";
            if (!self.isshowalbum) {
                cell.contentLab.text = @"所有人可见";
            }
            else
            {
                cell.contentLab.text = @"好友/会员可见";
            }
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 50, 13)];
            newLabel.text = @"new";
            newLabel.font = [UIFont italicSystemFontOfSize:15];//设置字体为斜体
            newLabel.textColor = [UIColor redColor];
            [cell addSubview:newLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        if (indexPath.row==2) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity6];
            cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity6];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"主页动态查看权限";
            if (!self.isshowdynamic) {
                cell.contentLab.text = @"所有人可见";
            }
            else
            {
                cell.contentLab.text = @"好友/会员可见";
            }
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 50, 13)];
            newLabel.text = @"new";
            newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
            newLabel.textColor = [UIColor redColor];
            [cell addSubview:newLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        if (indexPath.row==3) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity7];
            cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity7];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"主页评论查看权限";
            if (!self.isshowcomments) {
                cell.contentLab.text = @"所有人可见";
            }
            else
            {
                cell.contentLab.text = @"好友/会员可见";
            }
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 50, 13)];
            newLabel.text = @"new";
            newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
            newLabel.textColor = [UIColor redColor];
            [cell addSubview:newLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity8];
            cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity8];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"黑名单";
            cell.contentLab.text = self.blackNumStr?:@"";
            cell.contentLab.font = [UIFont systemFontOfSize:13];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)privacyButtonClick{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您现在还不是会员,不能设置相册密码~"];
        
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1){
        
        LDPrivacyPhotoViewController *pvc = [[LDPrivacyPhotoViewController alloc] init];
        if (self.isshowPhoto) {
            pvc.privacyString = @"1";
        }
        else
        {
            pvc.privacyString = @"2";
        }
        
        if (self.isFocuson) {
            pvc.attentString = @"0";
        }
        else
        {
            pvc.attentString = @"1";
        }
        if (self.isShowgroup) {
            pvc.groupString = @"0";
        }
        else
        {
            pvc.groupString = @"1";
        }
        [self.navigationController pushViewController:pvc animated:YES];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==2) {
        if (indexPath.row==0) {
            [self privacyButtonClick];
        }
        if (indexPath.row==1) {
            LDpermissionsVC *VC = [LDpermissionsVC new];
            VC.InActionType = ENUM_PERMISSIONPHOTO_ActionType;
            VC.isChoose = self.isshowalbum;
            VC.returnValueBlock = ^(BOOL isChoose) {
                self.isshowalbum = isChoose;
                [self.table reloadData];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
        if (indexPath.row==2) {
            LDpermissionsVC *VC = [LDpermissionsVC new];
            VC.InActionType = ENUM_PERMISSIONDYNAMIC_ActionType;
            VC.isChoose = self.isshowdynamic;
            VC.returnValueBlock = ^(BOOL isChoose) {
                self.isshowdynamic = isChoose;
                [self.table reloadData];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
        if (indexPath.row==3) {
            LDpermissionsVC *VC = [LDpermissionsVC new];
            VC.InActionType = ENUM_PERMISSIONCOMMENTS_ActionType;
            VC.isChoose = self.isshowcomments;
            VC.returnValueBlock = ^(BOOL isChoose) {
                self.isshowcomments = isChoose;
                [self.table reloadData];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            LDBlackListViewController *bvc = [[LDBlackListViewController alloc] init];
            [self.navigationController pushViewController:bvc animated:YES];
        }
    }
}

#pragma mark - UISwitch-Click

-(void)changeFocuson:(UISwitch *)swi{
    self.isFocuson = !self.isFocuson;
    [self.table reloadData];
}

-(void)changeGroup:(UISwitch *)swi
{
    self.isShowgroup = !self.isShowgroup;
    [self.table reloadData];
}

-(void)changePosition:(UISwitch *)swi
{
    self.isPositioning = !self.isPositioning;
    [self.table reloadData];
    [self hideLocationSwitch];
}

-(void)changeLogintime:(UISwitch *)swi
{
    self.isLogintime = !self.isLogintime;
    [self.table reloadData];
}

- (void)hideLocationSwitch{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        self.isPositioning = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"hideLocation"];
        
    }else{

        self.isPositioning = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"hideLocation"];
    }
    
}

#pragma mark - back

-(void)backButtonOnClick{
    
    [self changeldprovacyClick];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)changeldprovacyClick
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/setSecretSit"];
    NSString *attentString = [NSString new];
    if (self.isFocuson) {
        attentString = @"0";
    }
    else
    {
        attentString = @"1";
    }
    NSString *groupString = [NSString new];
    if (self.isShowgroup) {
        groupString = @"0";
    }
    else
    {
        groupString = @"1";
    }
    NSString *loginTimeString = [NSString new];
    if (self.isLogintime) {
        loginTimeString = @"0";
    }
    else
    {
        loginTimeString = @"1";
    }
    
    NSString *photo_rule = [NSString new];
    if (!self.isshowalbum) {
        photo_rule = @"0";
    }
    else
    {
        photo_rule = @"1";
    }
    
    NSString *dynamic_rule = [NSString new];
    if (!self.isshowdynamic) {
        dynamic_rule = @"0";
    }
    else
    {
        dynamic_rule = @"1";
    }
    
    NSString *comment_rule = [NSString new];
    if (!self.isshowcomments) {
        comment_rule = @"0";
    }
    else
    {
        comment_rule = @"1";
    }
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"follow_list_switch":attentString,@"group_list_switch":groupString,@"login_time_switch":loginTimeString,@"photo_rule":photo_rule,@"dynamic_rule":dynamic_rule,@"comment_rule":comment_rule};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObj objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            //[self presentViewController:alert animated:YES completion:nil];
        }else{
           // [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"因网络等原因修改失败"    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action];
        //[self presentViewController:alert animated:YES completion:nil];
    }];
}

@end
