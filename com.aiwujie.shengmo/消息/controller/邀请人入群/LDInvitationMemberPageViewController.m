//
//  LDInvitationMemberPageViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/6/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDInvitationMemberPageViewController.h"
#import "InvitationMemberCell.h"
#import "TableModel.h"
#import "chatListModel.h"

@interface LDInvitationMemberPageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;

@end

@implementation LDInvitationMemberPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataArray = [NSMutableArray array];
    
    _storageArray = [NSMutableArray array];
    
    _storageGroupArray = [NSMutableArray array];
    
    [self createTableView];
        
    _page = 0;
    
    if ([self.content integerValue] != 0) {
       
        [self createData:self.content];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            _page++;
            
            [self createData:self.content];
            
        }];
        
    }else{
            
        NSArray *array =  [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
        
        if (array.count > 0) {
            
            for (int i = 0; i < array.count; i++) {
                
                chatListModel *model = [[chatListModel alloc] init];
                RCConversation *conversation = array[i];
                model.uid = conversation.targetId;
                model.type = [NSString stringWithFormat:@"%lu",(unsigned long)conversation.conversationType];
                model.select = NO;
                
                [_dataArray addObject:model];
                
            }
            
            [self.tableView reloadData];
        }
    }
    
//    [self.tableView.mj_header beginRefreshing];

}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 50) style:UITableViewStylePlain];
    
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
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.content integerValue] != 0) {
        
        InvitationMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationMember"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"InvitationMemberCell" owner:self options:nil][1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        TableModel *model = _dataArray[indexPath.row];
        
        cell.content = self.content;
        
        cell.model = model;
        
        if (model.select) {
            
            cell.selectView.image = [UIImage imageNamed:@"shiguanzhu"];
            
        }else{
            
            cell.selectView.image = [UIImage imageNamed:@"kongguanzhu"];
            
        }
        
        return cell;

    }else{
        
        InvitationMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationMember"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"InvitationMemberCell" owner:self options:nil][0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       chatListModel *model = _dataArray[indexPath.row];
        
        if ([model.type integerValue] == ConversationType_PRIVATE) {
            
            RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:model.uid];
            
            [cell.chatHeadView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",user.portraitUri]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            
            cell.chatNameLabel.text = user.name;
            
        }else{
            
            RCGroup *group = [[RCIM sharedRCIM] getGroupInfoCache:model.uid];
        
            [cell.chatHeadView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",group.portraitUri]] placeholderImage:[UIImage imageNamed:@"群默认头像"]];
            
            cell.chatNameLabel.text = group.groupName;
        }

        if (model.select) {
            
            cell.chatSelectView.image = [UIImage imageNamed:@"shiguanzhu"];
            
        }else{
            
            cell.chatSelectView.image = [UIImage imageNamed:@"kongguanzhu"];
            
        }
//        
//        cell.chatLastLabel.text = model.lastMessage;
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.content integerValue] == 0) {
        
        return 70;
    }
    
    return 88;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger count = 0;
    
    LDInvitationMemberPageViewController *contentVC0 = self.pageContentArray[0];
    LDInvitationMemberPageViewController *contentVC1 = self.pageContentArray[1];
    LDInvitationMemberPageViewController *contentVC2 = self.pageContentArray[2];
    LDInvitationMemberPageViewController *contentVC3 = self.pageContentArray[3];
    
    count = contentVC0.storageArray.count + contentVC0.storageGroupArray.count +  contentVC1.storageArray.count + contentVC2.storageArray.count + contentVC3.storageArray.count;
    
    NSMutableArray *allArray = [NSMutableArray array];
    [allArray addObjectsFromArray:contentVC0.storageArray];
    [allArray addObjectsFromArray:contentVC1.storageArray];
    [allArray addObjectsFromArray:contentVC2.storageArray];
    [allArray addObjectsFromArray:contentVC3.storageArray];
    
    if ([self.content integerValue] != 0) {
        
        InvitationMemberCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        TableModel *model = _dataArray[indexPath.row];
        
        if ([model.uid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            
            cell.selected = NO;
            
        }else{
        
            NSString *uid = model.uid;
            
            if (model.select) {
                
                [_storageArray removeObject:uid];
                
                cell.selectView.image = [UIImage imageNamed:@"kongguanzhu"];
                
                model.select = NO;
                
            }else{
                
                if (count < 20) {
                    
                    BOOL __block selectState = NO;
                    
                    [allArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                        if ([obj intValue] == [uid intValue]) {
                            
                            selectState = YES;
                            
                            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"已选择该用户,不可重复选择~"];
                            
                            *stop = YES;
                        }
                    }];
                    
                    if (!selectState) {
                        
                        [_storageArray addObject:uid];
                        
                        cell.selectView.image = [UIImage imageNamed:@"shiguanzhu"];
                        
                        model.select = YES;
                        
                    }
                    
                }else if (count >= 20) {
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"最多发送20个邀请"];
                }
            }
        }
 
    }else{
    
        InvitationMemberCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        chatListModel *model = _dataArray[indexPath.row];
        
        NSString *uid = model.uid;
        
        if (model.select) {
            
            if ([model.type isEqualToString:@"1"]) {
                
                [_storageArray removeObject:uid];
                
            }else{
            
                [_storageGroupArray removeObject:uid];
            }
            
            cell.chatSelectView.image = [UIImage imageNamed:@"kongguanzhu"];
            
            model.select = NO;
            
        }else{
            
            if ([model.type isEqualToString:@"1"]) {
                
                if (count < 20) {
                    
                    BOOL __block selectState = NO;
                    
                    [allArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if ([obj intValue] == [uid intValue]) {
                            
                            selectState = YES;
                            
                            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"已选择该用户,不可重复选择~"];
                            
                            *stop = YES;
                            
                        }
                        
                    }];
                    
                    if (!selectState) {
                        
                        [_storageArray addObject:uid];
                        
                        cell.chatSelectView.image = [UIImage imageNamed:@"shiguanzhu"];
                        
                        model.select = YES;
                        
                    }
                    
                }else if (count >= 20) {
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"最多发送20个邀请"];
                }
                
            }else{
                
                if (count < 20) {
                    
                    [_storageGroupArray addObject:uid];
                    
                    cell.chatSelectView.image = [UIImage imageNamed:@"shiguanzhu"];
                    
                    model.select = YES;
                    
                }else if (count >= 20){
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"最多发送20个邀请"];
                }
            }
        }
    }
}

-(void)createData:(NSString *)content{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([content integerValue] == 1) {
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,userListNewth];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"layout":@"1",@"type":content,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"onlinestate":@"",@"realname":@"",@"age":@"",@"sex":@"",@"sexual":@"",@"role":@"",@"culture":@"",@"monthly":@""};
        }else{
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"layout":@"1",@"type":content,@"lat":@"",@"lng":@"",@"onlinestate":@"",@"realname":@"",@"age":@"",@"sex":@"",@"sexual":@"",@"role":@"",@"culture":@"",@"monthly":@""};
        }
        
    }else if ([content integerValue] == 2){
    
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getReadList"];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"1",@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"1",@"lat":@"",@"lng":@"",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }

    }else if ([content integerValue] == 3){
    
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getFollewingList"];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
            
             parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"2",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]};
            
            
        }else{
            
             parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"2",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@""};
            
        }

    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer == 2000) {
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                TableModel *model = [[TableModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                model.select = NO;
                
                [_dataArray addObject:model];
                
            }
            
            self.tableView.mj_footer.hidden = NO;
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
        }else if (integer == 4001) {
        
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            self.tableView.mj_footer.hidden = YES;
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
            [self.tableView.mj_footer endRefreshing];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];

        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
