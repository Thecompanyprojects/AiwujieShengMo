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
    [self createAlertStatusData];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
            self.blackNumStr = responseObj[@"data"][@"black_limit"];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",errorMsg);
    }];
}

-(void)createAlertStatusData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/getSecretSit"];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer!=2000) {
             [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }
        else
        {
            if ([responseObj[@"data"][@"photo_lock"] intValue] == 1) {
                self.isshowPhoto = YES;
            }else{
                self.isshowPhoto = NO;
            }
            self.blackNumStr = responseObj[@"data"][@"black_limit"];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if (indexPath.row==2) {
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
    if (indexPath.row==3) {
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
    if (indexPath.row==4) {
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
    if (indexPath.row==5) {
        LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity5];
        cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity5];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLab.text = @"相册查看权限";
        if (!self.isshowalbum) {
            cell.contentLab.text = @"所有人可见";
        }
        else
        {
            cell.contentLab.text = @"好友/会员可见";
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.row==6) {
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
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.row==7) {
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
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.row==8) {
        LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity8];
        cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity8];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLab.text = @"黑名单";
        cell.contentLab.text = self.blackNumStr?:@"";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)privacyButtonClick{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您现在还不是会员,不能设置相册的开启~"];
        
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

    if (indexPath.row==4) {
        [self privacyButtonClick];
    }
    if (indexPath.row==5) {
        LDpermissionsVC *VC = [LDpermissionsVC new];
        VC.InActionType = ENUM_PERMISSIONPHOTO_ActionType;
        VC.isChoose = self.isshowalbum;
        VC.returnValueBlock = ^(BOOL isChoose) {
            self.isshowalbum = isChoose;
            [self.table reloadData];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.row==6) {
        LDpermissionsVC *VC = [LDpermissionsVC new];
        VC.InActionType = ENUM_PERMISSIONDYNAMIC_ActionType;
        VC.isChoose = self.isshowdynamic;
        VC.returnValueBlock = ^(BOOL isChoose) {
            self.isshowdynamic = isChoose;
            [self.table reloadData];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.row==7) {
        LDpermissionsVC *VC = [LDpermissionsVC new];
        VC.InActionType = ENUM_PERMISSIONCOMMENTS_ActionType;
        VC.isChoose = self.isshowcomments;
        VC.returnValueBlock = ^(BOOL isChoose) {
            self.isshowcomments = isChoose;
            [self.table reloadData];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.row==8) {
        LDBlackListViewController *bvc = [[LDBlackListViewController alloc] init];
        [self.navigationController pushViewController:bvc animated:YES];
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
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"follow_list_switch":attentString,@"group_list_switch":groupString,@"login_time_switch":loginTimeString};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObj objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failed:^(NSString *errorMsg) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"因网络等原因修改失败"    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}

@end
