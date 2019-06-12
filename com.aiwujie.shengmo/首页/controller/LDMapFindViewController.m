//
//  LDMapFindViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/25.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDMapFindViewController.h"
#import "CollectCell.h"
#import "CollectModel.h"
#import "LDBulletinViewController.h"
#import "LDOwnInformationViewController.h"
#import "TableCell.h"

@interface LDMapFindViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) NSInteger integer;
@property (nonatomic,copy) NSString *pathString;
@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,copy) NSString *titleString;


@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationViewBottomY;

@property (nonatomic,strong) UIImageView *img;

@end

@implementation LDMapFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"地图找人";
    if (ISIPHONEX) {
        self.locationViewBottomY.constant = IPHONEXBOTTOMH;
    }
    self.locationLabel.text = self.location;
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.table];
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self createData:@"1"];
    }];
    [self.table.mj_header beginRefreshing];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createData:@"2"];
    }];
}

//地图找人
-(void)createData:(NSString *)str{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/index/searchByMapNew"];
        
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"lat":[NSString stringWithFormat:@"%lf",self.lat],@"lng":[NSString stringWithFormat:@"%lf",self.lng]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        _integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (_integer != 2000 && _integer != 2001) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            if ([str intValue] == 1) {
                [self.dataSource removeAllObjects];
            }
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[TableModel class] json:responseObj[@"data"]]];
            [self.dataSource addObjectsFromArray:data];
            [self.table reloadData];
        }

        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];

    } failed:^(NSString *errorMsg) {
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];

    }];
}

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc]  initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 44)];
        _table.dataSource = self;
        _table.delegate = self;
        _table.tableFooterView = [UIView new];
    }
    return _table;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Table"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > 0) {
        TableModel *model = self.dataSource[indexPath.row];
        cell.integer = _integer;
        //cell.content = [self.content intValue] > 2 ? self.content : nil;
        cell.model = model;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    CollectModel *model = self.dataSource[indexPath.row];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
