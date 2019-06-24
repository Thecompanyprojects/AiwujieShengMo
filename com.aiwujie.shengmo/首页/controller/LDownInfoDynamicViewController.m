//
//  LDownInfoDynamicViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/9/28.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDownInfoDynamicViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDDynamicDetailViewController.h"
#import "LDMyWalletPageViewController.h"
#import "LDAttentionListViewController.h"
#import "LDAttentOtherViewController.h"
#import "LDBindingPhoneNumViewController.h"
#import "LDMyTopicViewController.h"
#import "HeaderTabViewController.h"
#import "LDMemberViewController.h"
#import "LDCertificateViewController.h"
#import "LDPublishDynamicViewController.h"
#import "LDStampChatView.h"
#import "DynamicCell.h"
#import "DynamicModel.h"


@interface LDownInfoDynamicViewController ()<UITableViewDelegate,UITableViewDataSource,DynamicDelegate,YBAttributeTapActionDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) DynamicModel *model;
@property (nonatomic,strong) DynamicCell *cell;
@property(nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) NSInteger integer;

//存储动态的图片
@property (nonatomic,strong) NSArray *dynamicpicArray;

//是否可以发布动态
@property (nonatomic,copy) NSString *publishComment;

//礼物界面
@property (nonatomic,strong) GifView *gif;

//聊天邮票界面
@property (nonatomic,strong) LDStampChatView *stampView;

//发布的话题
@property (nonatomic,strong) NSMutableArray *plublishArray;
@property (nonatomic,strong) UILabel *plublishLabel;
@property (nonatomic,copy) NSString *c_topic;
//参与的话题
@property (nonatomic,strong) NSMutableArray *joinArray;
@property (nonatomic,strong) UILabel *joinLabel;
@property (nonatomic,copy) NSString *j_topic;

//加好友接口
@property (nonatomic,copy) NSString *url;

//好友状态
@property (nonatomic,assign) NSString *followState;

//提示的view
@property (nonatomic,strong) UIView *warnView;
@property (nonatomic,strong) UIImageView *rocketsView;

@end

@implementation LDownInfoDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _plublishArray = [NSMutableArray array];
    _joinArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _dynamicpicArray = [NSArray array];
    _sectionArray = [NSMutableArray array];
    
    [self createTableView];
    
    [self createTopicAndDynamicNum];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([self.personUid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            
            _page = 0;
            
            [self createDataType:@"1"];
            
        }else{

                _page = 0;
                [self createDataType:@"1"];

        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    
      _page++;
    
      [self createDataType:@"2"];
    
    }];
    
    //监听打赏的状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardSuccess:) name:@"个人主页打赏成功" object:nil];

}

-(void)rewardSuccess:(NSNotification *)user{
    
    if (_dataArray.count >= [user.userInfo[@"section"] integerValue] + 1 && [self isKindOfClass:[LDownInfoDynamicViewController class]]) {
        
        DynamicModel *model = _dataArray[[user.userInfo[@"section"] integerValue]];
        
        model.rewardnum = [NSString stringWithFormat:@"%d",[model.rewardnum intValue] + 1];
        
        [_dataArray replaceObjectAtIndex:[user.userInfo[@"section"] integerValue] withObject:model];
        
        _cell.rewardLabel.text = [NSString stringWithFormat:@"%@",model.rewardnum];
    }
    
}

//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createTopicAndDynamicNum{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/friend/getDynamicAndTopicCount"];
    
    NSDictionary *parameters = @{@"uid":self.personUid};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        [self.tableView.mj_header beginRefreshing];
        
        if (integer != 2000) {
            
            UIView *headView = [[UIView alloc] init];
            
            headView.frame = CGRectMake(0, 0, WIDTH, 0);
            
            self.tableView.tableHeaderView = headView;

        }else{
            
            [_plublishArray addObjectsFromArray:responseObject[@"data"][@"c_topic"]];
            
            if ([responseObject[@"data"][@"c_topic"] count] == 0) {
                
                _c_topic = @"";
                
            }else{
                
                if ([responseObject[@"data"][@"c_topic"] count] == 1) {
                    
                    _c_topic = [NSString stringWithFormat:@"#%@#",responseObject[@"data"][@"c_topic"][0][@"title"]];
                    
                }else{
                    
                    for (int i = 0; i < [responseObject[@"data"][@"c_topic"] count]; i++) {
                        
                        if (i == 0) {
                            
                            _c_topic = [NSString stringWithFormat:@"#%@#",responseObject[@"data"][@"c_topic"][0][@"title"]];
                            
                        }else{
                            
                            _c_topic = [NSString stringWithFormat:@"%@ #%@#",_c_topic,responseObject[@"data"][@"c_topic"][i][@"title"]];
                        }
                        
                    }
                }
            }
            
            [_joinArray addObjectsFromArray:responseObject[@"data"][@"j_topic"]];
            
            if ([responseObject[@"data"][@"j_topic"] count] == 0) {
                
                _j_topic = @"";
                
            }else{
                
                if ([responseObject[@"data"][@"j_topic"] count] == 1) {
                    
                    _j_topic = [NSString stringWithFormat:@"#%@#",responseObject[@"data"][@"j_topic"][0][@"title"]];
                    
                }else{
                    
                    for (int i = 0; i < [responseObject[@"data"][@"j_topic"] count]; i++) {
                        
                        if (i == 0) {
                            
                            _j_topic = [NSString stringWithFormat:@"#%@#",responseObject[@"data"][@"j_topic"][0][@"title"]];
                            
                        }else{
                            
                            _j_topic = [NSString stringWithFormat:@"%@ #%@#",_j_topic,responseObject[@"data"][@"j_topic"][i][@"title"]];
                        }
                    }
                }
            }
            
            NSArray *dynamicCountArray = @[@"动态数",@"推荐数",@"评论数",@"点赞数"];
            NSArray *CountArray = @[[NSString stringWithFormat:@"%@",responseObject[@"data"][@"dynamiccount"][@"dynamicnum"]],[NSString stringWithFormat:@"%@",responseObject[@"data"][@"dynamiccount"][@"recommend"]],[NSString stringWithFormat:@"%@",responseObject[@"data"][@"dynamiccount"][@"comnum"]],[NSString stringWithFormat:@"%@",responseObject[@"data"][@"dynamiccount"][@"laudnum"]]];
            
            int num = 4;
            CGFloat buttonW = WIDTH/num;
            CGFloat dynamicCountH = 50;
            
            UIView *headView = [[UIView alloc] init];
            
            UIView *dynamicCountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, dynamicCountH)];
            
            [headView addSubview:dynamicCountView];
            
            for (int i = 0; i < num; i++) {
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * buttonW, 0, buttonW, dynamicCountH)];
                button.enabled = NO;
                [button setImage:[UIImage imageNamed:dynamicCountArray[i]] forState:UIControlStateNormal];
                [button setTitle:CountArray[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                [dynamicCountView addSubview:button];
            }
            
            UIView *topicView = [[UIView alloc] init];
            
            topicView.backgroundColor = [UIColor whiteColor];
            
            [headView addSubview:topicView];
            
            CGFloat topicLine = 30;
            CGFloat topicSpace = 15;
            CGFloat topicInSpace = 10;
            CGFloat topicInLine = 25;
            
            if (_c_topic.length != 0 && _j_topic.length != 0) {
                
                topicView.frame =  CGRectMake(0, dynamicCountH, WIDTH, 2 * topicLine + 3 * topicSpace);
                
                UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, topicSpace, WIDTH, topicLine)];
                
                UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, topicLine - topicInLine, 70, topicInLine)];
                backImageView.image = [UIImage imageNamed:@"话题背景"];
                [oneView addSubview:backImageView];
                
                UILabel *plublishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, topicInLine)];
                plublishLabel.textAlignment = NSTextAlignmentCenter;
                plublishLabel.text = @"发布话题";
                plublishLabel.font = [UIFont systemFontOfSize:13];
                plublishLabel.textColor = [UIColor whiteColor];
                plublishLabel.textAlignment = NSTextAlignmentCenter;
                [backImageView addSubview:plublishLabel];
                
                UILabel *oneShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backImageView.frame) + 5, topicLine - topicInLine, WIDTH - 110, topicInLine)];
                oneShowLabel.layer.cornerRadius = 2;
                oneShowLabel.clipsToBounds = YES;
                oneShowLabel.text = _c_topic;
                oneShowLabel.font = [UIFont systemFontOfSize:14];
                oneShowLabel.textColor = [UIColor blackColor];
                [oneView addSubview:oneShowLabel];
                
                oneShowLabel.attributedText = [self changeTopicColor:_c_topic andArray:_plublishArray andType:@"1"];
                
                UIImageView *oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 21, topicLine - topicInLine + (topicInLine - 11)/2, 7, 11)];
                oneImageView.image = [UIImage imageNamed:@"youjiantou"];
                [oneView addSubview:oneImageView];
                
                UIButton *oneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, topicLine)];
                [oneButton addTarget:self action:@selector(oneButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [oneView addSubview:oneButton];
                
                [topicView addSubview:oneView];
                
                
                UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(oneView.frame) + topicInSpace, WIDTH, 25)];
                
                UIImageView *backImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, topicLine - topicInLine, 70, topicInLine)];
                backImageView1.image = [UIImage imageNamed:@"话题背景"];
                [twoView addSubview:backImageView1];
                
                UILabel *joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, topicInLine)];
                joinLabel.textAlignment = NSTextAlignmentCenter;
                joinLabel.text = @"参与话题";
                joinLabel.font = [UIFont systemFontOfSize:13];
                joinLabel.textColor = [UIColor whiteColor];
                joinLabel.textAlignment = NSTextAlignmentCenter;
                [backImageView1 addSubview:joinLabel];
                
                UILabel *twoShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backImageView.frame) + 5, topicLine - topicInLine, WIDTH - 110, topicInLine)];
                twoShowLabel.layer.cornerRadius = 2;
                twoShowLabel.clipsToBounds = YES;
                twoShowLabel.text = _j_topic;
                twoShowLabel.font = [UIFont systemFontOfSize:14];
                twoShowLabel.textColor = [UIColor blackColor];
                [twoView addSubview:twoShowLabel];
                
                twoShowLabel.attributedText = [self changeTopicColor:_j_topic andArray:_joinArray andType:@"2"];
                
                UIButton *twoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, topicLine)];
                [twoButton addTarget:self action:@selector(twoButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [twoView addSubview:twoButton];
                
                UIImageView *twoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 21, topicLine - topicInLine + (topicInLine - 11)/2, 7, 11)];
                twoImageView.image = [UIImage imageNamed:@"youjiantou"];
                [twoView addSubview:twoImageView];
                
                [topicView addSubview:twoView];
                
            }else if (_c_topic.length == 0 && _j_topic.length != 0){
                
                topicView.frame =  CGRectMake(0, dynamicCountH, WIDTH,topicLine + 2 * topicSpace);
                
                UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, topicSpace, WIDTH, topicLine)];
                
                UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, topicLine - topicInLine, 70, topicInLine)];
                backImageView.image = [UIImage imageNamed:@"话题背景"];
                [oneView addSubview:backImageView];
                
                UILabel *joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, topicInLine)];
                joinLabel.textAlignment = NSTextAlignmentCenter;
                joinLabel.text = @"参与话题";
                joinLabel.font = [UIFont systemFontOfSize:13];
                joinLabel.textColor = [UIColor whiteColor];
                joinLabel.textAlignment = NSTextAlignmentCenter;
                [backImageView addSubview:joinLabel];
                
                UILabel *oneShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backImageView.frame) + 5, topicLine - topicInLine, WIDTH - 110, topicInLine)];
                oneShowLabel.layer.cornerRadius = 2;
                oneShowLabel.clipsToBounds = YES;
                oneShowLabel.text = _j_topic;
                oneShowLabel.font = [UIFont systemFontOfSize:14];
                oneShowLabel.textColor = [UIColor blackColor];
                [oneView addSubview:oneShowLabel];
                
                oneShowLabel.attributedText = [self changeTopicColor:_j_topic andArray:_joinArray andType:@"2"];
                
                UIImageView *oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 21, topicLine - topicInLine + (topicInLine - 11)/2, 7, 11)];
                oneImageView.image = [UIImage imageNamed:@"youjiantou"];
                [oneView addSubview:oneImageView];
                
                UIButton *oneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, topicLine)];
                [oneButton addTarget:self action:@selector(twoButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [oneView addSubview:oneButton];
                
                [topicView addSubview:oneView];
                
            }else if (_c_topic.length != 0 && _j_topic.length == 0){
                
                topicView.frame =  CGRectMake(0, dynamicCountH, WIDTH,topicLine + 2 * topicSpace);
                
                UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, topicSpace, WIDTH, topicLine)];
                UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, topicLine - topicInLine, 70, topicInLine)];
                backImageView.image = [UIImage imageNamed:@"话题背景"];
                [oneView addSubview:backImageView];
                
                UILabel *plublishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, topicInLine)];
                plublishLabel.textAlignment = NSTextAlignmentCenter;
                plublishLabel.text = @"发布话题";
                plublishLabel.font = [UIFont systemFontOfSize:13];
                plublishLabel.textColor = [UIColor whiteColor];
                plublishLabel.textAlignment = NSTextAlignmentCenter;
                [backImageView addSubview:plublishLabel];
                
                UILabel *oneShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backImageView.frame) + 5, topicLine - topicInLine, WIDTH - 110, topicInLine)];
                oneShowLabel.layer.cornerRadius = 2;
                oneShowLabel.clipsToBounds = YES;
                oneShowLabel.text = _c_topic;
                oneShowLabel.font = [UIFont systemFontOfSize:14];
                oneShowLabel.textColor = [UIColor blackColor];
                [oneView addSubview:oneShowLabel];
                
                oneShowLabel.attributedText = [self changeTopicColor:_c_topic andArray:_plublishArray andType:@"1"];
                
                UIImageView *oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 21, topicLine - topicInLine + (topicInLine - 11)/2, 7, 11)];
                oneImageView.image = [UIImage imageNamed:@"youjiantou"];
                [oneView addSubview:oneImageView];
                
                UIButton *oneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, topicLine)];
                [oneButton addTarget:self action:@selector(oneButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [oneView addSubview:oneButton];
                
                [topicView addSubview:oneView];
                
            }else{
            
                 topicView.frame = CGRectMake(0, dynamicCountH, WIDTH, 0);
            }
            
            headView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(topicView.frame));
            
            self.tableView.tableHeaderView = headView;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header beginRefreshing];
        
        UIView *headView = [[UIView alloc] init];
        
        headView.frame = CGRectMake(0, 0, WIDTH, 0);
        
        self.tableView.tableHeaderView = headView;
        
    }];

}

//富文本文字可点击delegate
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    
    if ([string isEqualToString:@"VIP会员"]){
        
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if ([string isEqualToString:@"互为好友"]){
        
        [self attentButtonClickState:_attentStatus];
    }
}

//关注按钮
-(void)attentButtonClickState:(BOOL)state{
    
    if (state) {
        _url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setoverfollow];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消关注此人"    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [self blackData];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        if (PHONEVERSION.doubleValue >= 8.3) {
            [action setValue:MainColor forKey:@"_titleTextColor"];
            [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
        }
        [alert addAction:action];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        _url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setfollowOne];
        [self blackData];
    }
}

/**
 关注好友 / 取消关注好友
 */
-(void)blackData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.personUid};
    
    [NetManager afPostRequest:_url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES];
            if (integer==8881||integer==8882) {
                NSString *msg = [responseObj objectForKey:@"msg"];
                UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"开会员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                    [self.navigationController pushViewController:mvc animated:YES];
                }];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    cvc.where = @"2";
                    [self.navigationController pushViewController:cvc animated:YES];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [control addAction:action1];
                [control addAction:action0];
                [control addAction:action2];
                [self presentViewController:control animated:YES completion:^{
                    
                }];
            }else
            {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
            
        }else{
            if (_attentStatus) {
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [responseObj objectForKey:@"msg"];
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
                
                _attentStatus = NO;
                
            }else{
                if ([responseObj[@"data"] intValue] == 1) {
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已互为好友，可以免费无限畅聊了~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                    
                }else{
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已关注成功！互为好友即可免费畅聊~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                }
                _attentStatus = YES;
            }
        }
    } failed:^(NSString *errorMsg) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
    }];
}


-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
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
    self.tableView.fd_debugLogEnabled = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"DynamicCell" bundle:nil] forCellReuseIdentifier:@"DynamicCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.integer = _integer;
    cell.indexPath = indexPath;
    [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self configureCell:cell atIndexPath:indexPath];
    [_sectionArray addObject:indexPath];
    return cell;
}

- (void)configureCell:(DynamicCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    if (_dataArray.count > 0 && _dataArray.count - 1 >= indexPath.section) {
        
        DynamicModel *model = _dataArray[indexPath.section];
        
        cell.model = model;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView fd_heightForCellWithIdentifier:@"DynamicCell" cacheByIndexPath:indexPath configuration:^(DynamicCell *cell) {
        
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
}


-(void)headButtonClick:(UIButton *)button{
    
    DynamicCell *cell = (DynamicCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DynamicModel *model = _dataArray[indexPath.section];
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    ivc.userID = model.uid;
    
    [self.navigationController pushViewController:ivc animated:YES];
}

//点击文字的danamicDelegate
-(void)transmitClickModel:(DynamicModel *)model{
    
    HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
    
    tvc.tid = [NSString stringWithFormat:@"%@",model.tid];
    
    [self.navigationController pushViewController:tvc animated:YES];
}


-(void)tap:(UITapGestureRecognizer *)tap{
    
    UIImageView *img = (UIImageView *)tap.view;
    
    __weak typeof(self) weakSelf=self;
    
    [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:img.tag - img.tag/100 * 100 imagesBlock:^NSArray *{
        
        DynamicModel *model = _dataArray[img.tag/100];
        
        if (model.sypic.count == 0) {
            
            _dynamicpicArray = model.pic;
            
        }else{
            
            _dynamicpicArray = model.sypic;
        }
        
        return weakSelf.dynamicpicArray;
    }];
    
    
}

-(void)zanTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DynamicModel *model = _dataArray[indexPath.section];
    
    if ([model.laudstate intValue] == 0) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,laudDynamicNewrd];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":model.did};
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }else{
                int oldstrs = [model.laudnum intValue]+1;
                model.laudnum = [NSString stringWithFormat:@"%d",oldstrs].mutableCopy;
                model.laudstate = @"1";
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

-(void)commentTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DynamicModel *model = _dataArray[indexPath.section];
    LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
    dvc.did = model.did;
    dvc.ownUid = model.uid;
    _indexPath = indexPath;
    dvc.clickState = @"comment";
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)replyTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DynamicModel *model = _dataArray[indexPath.section];
    BOOL ismines = NO;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[model.uid intValue]) {
        ismines = YES;
    }
    _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:ismines :^{
        LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
        cvc.type = @"0";
        [self.navigationController pushViewController:cvc animated:YES];
        
    }];
    [_gif getDynamicDid:model.did andIndexPath:indexPath andSign:@"个人主页动态" andUIViewController:self];
    [self.tabBarController.view addSubview:_gif];
}

-(void)topTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];

    DynamicModel *model = self.dataArray[index.section];
    TopcardView *view = [TopcardView new];
    view.did = model.did;
    [view withBuyClick:^(NSString * _Nonnull string) {
        LDtotopViewController *VC = [LDtotopViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [view withAlertClick:^(NSString * _Nonnull string) {
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的推顶卡不足，请购买" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LDtotopViewController *VC = [LDtotopViewController new];
            [self.navigationController pushViewController:VC animated:YES];
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:^{
            
        }];
    }];
    [view withSureClick:^(NSString * _Nonnull string) {
        //推顶操作成功
        
        NSString *newStr = model.topnum;
        newStr = [NSString stringWithFormat:@"%d",[newStr intValue]+1].copy;
        model.topnum = newStr.copy;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.dataArray replaceObjectAtIndex:index.section withObject:model];
        self.rocketsView = [UIImageView new];
        self.rocketsView.frame = CGRectMake(WIDTH/2-150, HEIGHT-450, 300, 300);
        self.rocketsView.image = [UIImage imageNamed:@"推顶火箭"];
        [self.view addSubview:self.rocketsView];
        [self spring];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self move];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.rocketsView removeFromSuperview];
        });
    }];
}


// 移动
- (void)move
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.beginTime = CACurrentMediaTime();
    animation.duration = 1;
    animation.repeatCount = 0;
    animation.fromValue = [NSValue valueWithCGPoint:self.rocketsView.layer.position];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.rocketsView.layer.position.x, self.rocketsView.layer.position.y-HEIGHT)];
    [self.rocketsView.layer addAnimation:animation forKey:@"move"];
}

// 弹簧
- (void)spring
{
    CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"position"];
    animation.beginTime = CACurrentMediaTime();
    animation.damping = 2;
    animation.stiffness = 50;
    animation.mass = 1;
    animation.initialVelocity = 10;
    [animation setFromValue:[NSValue valueWithCGPoint:self.rocketsView.layer.position]];
    [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(self.rocketsView.layer.position.x, self.rocketsView.layer.position.y + 50)]];
    animation.duration = animation.settlingDuration;
    [self.rocketsView.layer addAnimation:animation forKey:@"spring"];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 2;
    }
    
    return 10;
}

/**
 
 更改发布话题和参与话题的话题颜色
 
 */

-(NSMutableAttributedString *)changeTopicColor:(NSString *)topicString andArray:(NSMutableArray *)topicArray andType:(NSString *)type{
    
    NSArray *colorArray;
    
    if ([type intValue] == 1) {
        
        colorArray = @[@"0xff0000",@"0xb73acb",@"0x0000ff",@"0x18a153",@"0xf39700",@"0xff00ff",@"0x00a0e9"];
        
    }else{
    
        colorArray = @[@"0xb73acb",@"0x0000ff",@"0x18a153",@"0xf39700",@"0xff00ff",@"0x00a0e9",@"0xff0000"];
    }
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:topicString];
    
    for (int i = 0; i <topicArray.count; i++) {
        
        NSRange range;
        
        range = [topicString rangeOfString:[NSString stringWithFormat:@"#%@#",topicArray[i][@"title"]]];
        
        if (range.location != NSNotFound) {
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(strtoul([colorArray[i%7] UTF8String], 0, 0)) range:range];
            
        }else{
            
            NSLog(@"Not Found");
            
        }
    }
    
    return attributedString;
}

-(void)oneButtonClick{
    
    LDMyTopicViewController *my = [[LDMyTopicViewController alloc] init];
    my.userId = self.personUid;
    my.state = @"发布的话题";
    [self.navigationController pushViewController:my animated:YES];
}

-(void)twoButtonClick{
    
    LDMyTopicViewController *my = [[LDMyTopicViewController alloc] init];
    my.userId = self.personUid;
    my.state = @"参与的话题";
    [self.navigationController pushViewController:my animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    DynamicModel *model = _dataArray[section];
    
    if (model.comArr.count != 0) {
        
        if (model.comArr.count == 2) {
            
            return 80;
            
        }else if (model.comArr.count == 1){
            
            return 60;
        }
    }
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    DynamicModel *model = _dataArray[section];
    
    if (model.comArr.count != 0) {
        
        if (model.comArr.count == 2) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
            
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, WIDTH - 24, 15)];
            oneLabel.textColor = TextCOLOR;
            if ([model.comArr[0][@"otheruid"] intValue] != 0) {
                
                oneLabel.text = [NSString stringWithFormat:@"%@回复%@: %@",model.comArr[0][@"nickname"],model.comArr[0][@"othernickname"],model.comArr[0][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:oneLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,[model.comArr[0][@"nickname"] length])];
                
                [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange([model.comArr[0][@"nickname"] length] + 2,[model.comArr[0][@"othernickname"] length])];
                
                oneLabel.attributedText = str;
                
            }else{
                
                oneLabel.text = [NSString stringWithFormat:@"%@: %@",model.comArr[0][@"nickname"],model.comArr[0][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:oneLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,[model.comArr[0][@"nickname"] length])];
                
                oneLabel.attributedText = str;
            }
            
            oneLabel.font = [UIFont systemFontOfSize:13];
            
            [view addSubview:oneLabel];
            
            UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 35, WIDTH - 24, 15)];
             twoLabel.textColor = TextCOLOR;
            if ([model.comArr[1][@"otheruid"] intValue] != 0) {
                
                twoLabel.text = [NSString stringWithFormat:@"%@回复%@: %@",model.comArr[1][@"nickname"],model.comArr[1][@"othernickname"],model.comArr[1][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:twoLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,[model.comArr[1][@"nickname"] length])];
                
                [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange([model.comArr[1][@"nickname"] length] + 2,[model.comArr[1][@"othernickname"] length])];
                
                twoLabel.attributedText = str;
                
            }else{
                
                twoLabel.text = [NSString stringWithFormat:@"%@: %@",model.comArr[1][@"nickname"],model.comArr[1][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:twoLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,[model.comArr[1][@"nickname"] length])];
                
                twoLabel.attributedText = str;
            }
            
            twoLabel.font = [UIFont systemFontOfSize:13];
            
            [view addSubview:twoLabel];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
            
            line.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            
            [view addSubview:line];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(12, 55, WIDTH - 24, 15)];
            
            [button setTitle:@"更多评论>" forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [view addSubview:button];
            
            UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
            
            [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            moreButton.tag = section;
            
            moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
            
            [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [view addSubview:moreButton];
            
            return view;
            
        }else if (model.comArr.count == 1){
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
            
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, WIDTH - 24, 15)];
             oneLabel.textColor = TextCOLOR;
            if ([model.comArr[0][@"otheruid"] intValue] != 0) {
                
                oneLabel.text = [NSString stringWithFormat:@"%@回复%@: %@",model.comArr[0][@"nickname"],model.comArr[0][@"othernickname"],model.comArr[0][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:oneLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,[model.comArr[0][@"nickname"] length])];
                
                [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange([model.comArr[0][@"nickname"] length] + 2,[model.comArr[0][@"othernickname"] length])];
                
                oneLabel.attributedText = str;
                
                
            }else{
                
                oneLabel.text = [NSString stringWithFormat:@"%@: %@",model.comArr[0][@"nickname"],model.comArr[0][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:oneLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,[model.comArr[0][@"nickname"] length])];
                
                oneLabel.attributedText = str;
            }
            
            oneLabel.font = [UIFont systemFontOfSize:13];
            
            [view addSubview:oneLabel];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
            
            line.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            
            [view addSubview:line];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(12, 35, WIDTH - 24, 15)];
            
            [button setTitle:@"更多评论>" forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [view addSubview:button];
            
            UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
            
            [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            moreButton.tag = section;
            
            moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
            
            [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [view addSubview:moreButton];
            
            return view;
            
        }
        
    }
    
    return nil;
}

-(void)moreButtonClick:(UIButton *)button{
    
    DynamicModel *model = _dataArray[button.tag];
    
    LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
    
    dvc.did = model.did;
    
    dvc.ownUid = model.uid;
    
    _indexPath = _sectionArray[button.tag];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
    
    DynamicModel *model = _dataArray[indexPath.section];
    
    dvc.did = model.did;
    
    dvc.ownUid = model.uid;
    
    DynamicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    dvc.block = ^(NSString *zanNum,NSString *zanState){
        
        if ([zanState intValue] == 1) {
            
            model.laudstate = zanState;
            
            model.laudnum = [NSString stringWithFormat:@"%d",[zanNum intValue]];
            
            cell.zanImageView.image = [UIImage imageNamed:@"赞紫"];
            
            cell.zanLabel.text = [NSString stringWithFormat:@"%@",model.laudnum];
            
        }else{
            
            model.laudstate = zanState;
            
            model.laudnum = [NSString stringWithFormat:@"%d",[zanNum intValue]];
            
            cell.zanImageView.image = [UIImage imageNamed:@"赞灰"];
            
            cell.zanLabel.text = [NSString stringWithFormat:@"%@",model.laudnum];
        }
        
        
    };
    
    dvc.commentBlock = ^(NSString *commentNum){
        
        cell.contentLabel.text = commentNum;
    };
    
    dvc.rewordBlock = ^(NSString *rewordNum){
        
        cell.rewardLabel.text = rewordNum;
    };
    
    dvc.deleteBlock = ^(){
        
        [_dataArray removeObject:model];
        
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (IBAction)attentionButtonClick:(id)sender {
    
    if ([self.personUid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        LDAttentionListViewController *avc = [[LDAttentionListViewController alloc] init];
        
        avc.type = @"0";
        
        avc.userID = self.personUid;
        
        [self.navigationController pushViewController:avc animated:YES];
        
    }else if ([self.personUid intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]){
        
        LDAttentOtherViewController *ovc = [[LDAttentOtherViewController alloc] init];
        
        ovc.type = @"0";
        
        ovc.userID = self.personUid;
        
        [self.navigationController pushViewController:ovc animated:YES];
    }
    
    
}
- (IBAction)fansButtonClick:(id)sender {
    
    if ([self.personUid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        LDAttentionListViewController *avc = [[LDAttentionListViewController alloc] init];
        
        avc.type = @"1";
        
        avc.userID = self.personUid;
        
        [self.navigationController pushViewController:avc animated:YES];
        
        
    }else if ([self.personUid intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]){
        
        LDAttentOtherViewController *ovc = [[LDAttentOtherViewController alloc] init];
        
        ovc.type = @"1";
        
        ovc.userID = self.personUid;
        
        [self.navigationController pushViewController:ovc animated:YES];
    }
    
}

/**
 * 获取判断是否可以发布动态的状态
 */

-(void)createPublishCommentData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/judgeDynamicNewrd"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer == 4003  || integer == 4004) {
            
            _publishComment = @"NO";
            
        }else  if(integer == 2000){
            
            _publishComment = @"YES";
            
        }else if(integer == 3001){
            
            _publishComment = @"";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        _publishComment = @"NO";
        
    }];
    
}


- (IBAction)publishButtonClick:(id)sender {
    
    if (_publishComment.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"根据国家网信部《互联网跟帖评论服务管理规定》要求，需要绑定手机号后才可以发布动态~"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"立即绑定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            LDBindingPhoneNumViewController *bpnc = [[LDBindingPhoneNumViewController alloc] init];
            
            [self.navigationController pushViewController:bpnc animated:YES];
            
        }];
        
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [action setValue:MainColor forKey:@"_titleTextColor"];
            
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
        }
        
        [alert addAction:cancel];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{
        
        if ([_publishComment isEqualToString:@"NO"]) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"暂时不能发布动态,如有问题请联系客服~"];
            
        }else if ([_publishComment isEqualToString:@"YES"]){
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"publishDynamicTime"] length] != 0){
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSTimeInterval interval = - [[formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"publishDynamicTime"]] timeIntervalSinceNow];
                
                if (interval >= 180) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"publishDynamicTime"];
                }
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"publishDynamicTime"] length] == 0) {
                
                LDPublishDynamicViewController *dvc = [[LDPublishDynamicViewController alloc] init];
                
                [self.navigationController pushViewController:dvc animated:YES];
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您发帖太快了,请3分钟后再发布~"];
            }
        }
    }
    
}

-(void)createDataType:(NSString *)type{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getDynamicListNewFive];
    NSDictionary *parameters;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {

        parameters = @{@"uid":self.personUid,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"type":@"3",@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    }else{

        parameters = @{@"uid":self.personUid,@"lat":@"",@"lng":@"",@"type":@"3",@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        _integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (_integer != 2000 && _integer != 2001) {
            if (_integer == 4001) {
                if ([type intValue] == 1) {
                    [_dataArray removeAllObjects];
                    [self.tableView reloadData];
                }
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                if (_integer == 4344 || _integer == 4343) {
                    
                    [_dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                    [self.tableView.mj_header endRefreshing];
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [self.tableView.mj_footer endRefreshing];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                }
            }
            
        }else{
            if ([type intValue] == 1) {
                [_dataArray removeAllObjects];
            }
            
            if (_warnView != nil) {
                [_warnView removeFromSuperview];
            }
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[DynamicModel class] json:responseObj[@"data"]]];
            [self.dataArray addObjectsFromArray:data];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (_gif) {
        
        [_gif removeView];
    }
    
    if (_stampView) {
        
        [_stampView removeView];
    }
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
