//
//  LDharassmentVC.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/6.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDharassmentVC.h"
#import "LDharassmentCell.h"

@interface LDharassmentVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,assign) BOOL isChoose;
@end

static NSString *LDharassmentIdentfity = @"LDharassmentIdentfity";

@implementation LDharassmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"防骚扰";
    self.isChoose = YES;
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDharassmentCell *cell = [tableView dequeueReusableCellWithIdentifier:LDharassmentIdentfity];
    if (!cell) {
        cell = [[LDharassmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LDharassmentIdentfity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        if (self.isChoose) {
            cell.leftImg.image = [UIImage imageNamed:@"shiguanzhu"];
        }
        else
        {
             cell.leftImg.image = [UIImage imageNamed:@"kongguanzhu"];
        }
        
        cell.nameLab.text = @"所有人可给我发信息";
    }
    if (indexPath.row==1) {
        if (!self.isChoose) {
            cell.leftImg.image = [UIImage imageNamed:@"shiguanzhu"];
        }
        else
        {
            cell.leftImg.image = [UIImage imageNamed:@"kongguanzhu"];
        }
        cell.nameLab.text = @"好友/邮票/SVIP可给我发信息";
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        self.isChoose = YES;
    }
    else
    {
        self.isChoose = NO;
    }
    [self.table reloadData];
}

@end
