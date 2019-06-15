//
//  LDhistorynameViewController.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/15.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDhistorynameViewController.h"
#import "LDhistorynameModel.h"

@interface LDhistorynameViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *table;
@end

@implementation LDhistorynameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史昵称";
    self.dataSource = [NSMutableArray array];
    [self createData];
    [self.view addSubview:self.table];
}

-(void)createData
{
    NSString *url = [PICHEADURL stringByAppendingString:getEditnicknameList];
    NSDictionary *para = @{@"uid":self.uid};
    
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[LDhistorynameModel class] json:responseObj[@"data"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
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



#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyname"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"historyname"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LDhistorynameModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.nickname;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = TextCOLOR;
    cell.detailTextLabel.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStampWithMin:model.addtime];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
