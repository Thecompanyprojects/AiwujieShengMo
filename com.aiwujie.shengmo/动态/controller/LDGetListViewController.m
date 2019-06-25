//
//  LDGetListViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGetListViewController.h"
#import "CommentedCell.h"
#import "CommentedModel.h"
#import "LDZanViewController.h"
#import "LDRewardViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDDynamicDetailViewController.h"
#import "LDAtViewController.h"
#import "LDtopViewController.h"

@interface LDGetListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;

@property (nonatomic,assign) CGFloat cellH;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *atLabel;
@property (weak, nonatomic) IBOutlet UIButton *topLab;

@end

@implementation LDGetListViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.atLabel.text = [NSString stringWithFormat:@"刚刚有%lu人@了你",[[[NSUserDefaults standardUserDefaults] objectForKey:@"atPerson"] count]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"动态信息";
    _dataArray = [NSMutableArray array];
    [self createButton];
    [self createUnreadData];
    [self createTableView];
    _page = 0;
    [self createCommentData];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createCommentData];
    }];
}

-(void)createUnreadData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/getUnreadNum"];
    NSDictionary *parameters;
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"type":@"0"};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer == 2000){
            self.zanLabel.text = [NSString stringWithFormat:@"刚刚有%d人赞过我",[responseObj[@"data"][@"laudnum"] intValue]];
            self.rewardLabel.text = [NSString stringWithFormat:@"刚刚有%d人打赏我",[responseObj[@"data"][@"rewardnum"] intValue]];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

-(void)createCommentData{
    
    NSString *url;
    NSDictionary *parameters;
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
    url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/getCommentedList"];
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer == 2000){
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[CommentedModel class] json:responseObj[@"data"]]];
            [self.dataArray addObjectsFromArray:data];
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else if (integer == 4002){
            self.tableView.mj_footer.hidden = YES;
        }
    } failed:^(NSString *errorMsg) {
         [self.tableView.mj_footer endRefreshing];
    }];

}

-(void)createTableView{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 258, WIDTH, [self getIsIphoneX:ISIPHONEX] - 258) style:UITableViewStyleGrouped];
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
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Commented"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CommentedCell" owner:self options:nil].lastObject;
    }
    CommentedModel *model = _dataArray[indexPath.section];
    cell.type = @"1";
    cell.model = model;
    _cellH = cell.contentView.frame.size.height;
    [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.lookDynamicButton addTarget:self action:@selector(lookDynamicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

-(void)lookDynamicButtonClick:(UIButton *)button{
    CommentedCell *cell = (CommentedCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CommentedModel *model = _dataArray[indexPath.section];
    LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
    dvc.did = model.did;
    dvc.ownUid = model.duid;
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)headButtonClick:(UIButton *)button{
    CommentedCell *cell = (CommentedCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CommentedModel *model = _dataArray[indexPath.section];
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return _cellH;
}


/**
 赞过我的

 @param sender 跳转赞过我的界面
 */
- (IBAction)zanButtonClick:(id)sender {
    LDZanViewController *zvc = [[LDZanViewController alloc] init];
    [self.navigationController pushViewController:zvc animated:YES];
}


/**
 打赏过我的

 @param sender 跳转打赏过我的界面
 */
- (IBAction)rewardButtonClick:(id)sender {
    LDRewardViewController *rvc = [[LDRewardViewController alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
}


/**
 @过我的

 @param sender 跳转@过我的界面
 */
- (IBAction)atButtonClick:(id)sender {
    LDAtViewController *avc = [[LDAtViewController alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
}


/**
 推顶过我的

 @param sender 跳转推顶过我的界面
 */
- (IBAction)totopButtonClick:(id)sender {
    
    LDtopViewController *VC = [LDtopViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)createButton{
    
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
    }else{
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [areaButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)backButtonOnClick{
    
    if (self.hotDog) {
        
        [self clearData];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)clearData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/clearUnreadNumAll"];
    NSDictionary *parameters;
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
