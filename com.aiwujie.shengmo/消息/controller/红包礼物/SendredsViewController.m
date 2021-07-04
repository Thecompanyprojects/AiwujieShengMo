//
//  SendredsViewController.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/28.
//  Copyright © 2019 a. All rights reserved.
//

#import "SendredsViewController.h"
#import "sendredsCell0.h"
#import "sendredsCell1.h"

@interface SendredsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end

static  NSString *sendidentfity0 = @"sendidentfity0";
static  NSString *sendidentfity1 = @"sendidentfity1";
static  NSString *sendidentfity2 = @"sendidentfity2";


@implementation SendredsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.title = @"发红包";
    [self createButton];
    [self createTableView];
    
}


-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 0) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
    [self.view addSubview:self.tableView];
    
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
    headView.frame = CGRectMake(0, 0, WIDTH, 50);
    self.tableView.tableHeaderView = headView;
    
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    footView.frame = CGRectMake(0, 0, WIDTH, 100);
    UIButton *submit = [[UIButton alloc] init];
    [footView addSubview:submit];
    submit.frame = CGRectMake(WIDTH/2-90, 36, 180, 40);
    [submit setTitle:@"塞魔豆进红包" forState:normal];
    submit.backgroundColor = [UIColor colorWithHexString:@"FE0400" alpha:1];
    submit.layer.masksToBounds = YES;
    submit.layer.cornerRadius = 8;
    [submit addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        sendredsCell0 *cell = [tableView dequeueReusableCellWithIdentifier:sendidentfity0];
        if (!cell) {
            cell = [[sendredsCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sendidentfity0];
            cell.numberText.tag = 101;
        }
        cell.leftLab.text = @"总金额";
        cell.rightLab.text = @"金魔豆";
        cell.numberText.placeholder = @"0";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==1) {
        sendredsCell0 *cell = [tableView dequeueReusableCellWithIdentifier:sendidentfity1];
        if (!cell) {
            cell = [[sendredsCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sendidentfity1];
            cell.numberText.tag = 102;
        }
        cell.leftLab.text = @"红包个数";
        cell.rightLab.text = @"个";
        cell.numberText.placeholder = @"0";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==2) {
        sendredsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:sendidentfity2];
        if (!cell) {
            cell = [[sendredsCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sendidentfity2];
            cell.messageText.tag = 103;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)submitBtnClick
{
    UITextField *text0 = [self.tableView viewWithTag:101];
    UITextField *text1 = [self.tableView viewWithTag:102];
    UITextField *text2 = [self.tableView viewWithTag:103];
    
    NSString *num0 = text0.text?:@"0";
    NSString *num1 = text1.text?:@"0";
    NSString *message = text2.text?:@"恭喜发财，大吉大利";
    
    NSDictionary *para = @{@"money":num0,@"number":num1,@"message":message};
    if (self.myBlock) {
        self.myBlock(para);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)createButton{
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    [areaButton setTitle:@"取消" forState:normal];
    areaButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [areaButton setTitleColor:TextCOLOR forState:normal];
    [areaButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 88, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)backButtonOnClick
{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}



@end
