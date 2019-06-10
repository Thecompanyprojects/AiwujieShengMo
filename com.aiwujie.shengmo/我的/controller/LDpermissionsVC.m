//
//  LDpermissionsVC.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDpermissionsVC.h"
#import "LDpermissionsVCCell.h"

@interface LDpermissionsVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@end

static NSString *ldpermissidendfity = @"ldpermissidendfity";

@implementation LDpermissionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (_InActionType) {
        case ENUM_PERMISSIONPHOTO_ActionType:
            self.title = @"相册查看";
            break;
        case ENUM_PERMISSIONDYNAMIC_ActionType:
            self.title = @"主页动态查看";
            break;
        case ENUM_PERMISSIONCOMMENTS_ActionType:
            self.title = @"主页评论查看";
            break;
        default:
            break;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.table];
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDpermissionsVCCell *cell = [tableView dequeueReusableCellWithIdentifier:ldpermissidendfity];
    if (!cell) {
        cell= [[LDpermissionsVCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldpermissidendfity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        if (!self.isChoose) {
            cell.leftImg.image = [UIImage imageNamed:@"shiguanzhu"];
        }
        else
        {
            cell.leftImg.image = [UIImage imageNamed:@"kongguanzhu"];
        }
        
        cell.nameLab.text = @"所有人可见";
    }
    if (indexPath.row==1) {
        if (self.isChoose) {
            cell.leftImg.image = [UIImage imageNamed:@"shiguanzhu"];
        }
        else
        {
            cell.leftImg.image = [UIImage imageNamed:@"kongguanzhu"];
        }
        cell.nameLab.text = @"好友/会员可见";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        self.isChoose = NO;
    }
    else
    {
        self.isChoose = YES;
    }
    [self.table reloadData];
}

-(void)backButtonOnClick
{
    if (self.returnValueBlock) {
        //将自己的值传出去，完成传值
        self.returnValueBlock(self.isChoose);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
