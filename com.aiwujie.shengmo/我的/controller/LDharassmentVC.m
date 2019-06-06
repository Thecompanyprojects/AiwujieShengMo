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

@end

static NSString *LDharassmentIdentfity = @"LDharassmentIdentfity";

@implementation LDharassmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"防骚扰";
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
    cell.textLabel.text = @"1234";
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

@end
