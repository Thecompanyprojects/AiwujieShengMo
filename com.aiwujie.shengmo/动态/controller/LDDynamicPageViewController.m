//
//  LDDynamicPageViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/4/28.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDDynamicPageViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "LDOwnInformationViewController.h"
#import "LDDynamicDetailViewController.h"
#import "LDBulletinViewController.h"
#import "LDChargeCenterViewController.h"
#import "LDMyWalletPageViewController.h"
#import "LDMemberViewController.h"
#import "LDCertificateViewController.h"
#import "TopicCell.h"
#import "TopicModel.h"
#import "DynamicModel.h"
#import "DynamicCell.h"
#import "LDRewardRankingViewController.h"
#import "LDMoreTopicViewController.h"
#import "LDGetListViewController.h"
#import "LDPopularityRankingViewController.h"
#import "HeaderTabViewController.h"
#import "LDStandardViewController.h"
#import "ThinkVerb.h"

#define DYNAMICWARNH 26
#define NewUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.5]

@interface LDDynamicPageViewController ()<UITableViewDelegate,UITableViewDataSource,DynamicDelegate,UIScrollViewDelegate,YBAttributeTapActionDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;
@property (nonatomic,assign) NSInteger integer;

@property (nonatomic,strong) NSArray *picArray;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) DynamicModel *model;
@property (nonatomic,strong) DynamicCell *cell;
@property(nonatomic,strong) NSMutableArray *sectionArray;

//动态未读消息
@property (strong, nonatomic) UILabel *unreadLabel;

//动态没有查看权限的view
@property (strong, nonatomic) UIView *noLookView;

//动态好友没有动态的view
@property (strong, nonatomic) UIView *friendNoLookView;

//广告展示的数组数据
@property (nonatomic,strong) NSMutableArray *slideArray;

//话题数组
@property (strong, nonatomic) NSMutableArray *topicArray;

//保存tableview的偏移量
@property (nonatomic,assign) CGFloat lastScrollOffset;

//礼物界面
@property (nonatomic,strong) GifView *gif;

@property (nonatomic,strong) UIImageView *rocketsView;

@property (nonatomic,assign) BOOL isLeftchoose;
@end

@implementation LDDynamicPageViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if ([self.content intValue] == 0) {
        //获取动态有几条未读消息
        [self createUnreadData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveClick) name:@"消息接收" object:nil];
    }
    if (_tableView.contentOffset.y == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶按钮" object:nil];
    }else if(_tableView.contentOffset.y > 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"显示置顶按钮" object:nil];
    }
}

//获取动态有几条未读消息
-(void)createUnreadData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/getUnreadNum"];
    NSDictionary *parameters;
    NSString *uid;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] length] == 0) {
        uid = @"";
    }else{
    
        uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    }
    parameters = @{@"uid":uid,@"type":@"1"};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]) {
            NSInteger badge = [responseObj[@"data"][@"allnum"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"atPerson"] count];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (badge <= 0) {
                    self.unreadLabel.hidden = YES;
                }else{
                    self.unreadLabel.hidden = NO;
                }
            });
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

//消息接受监听
-(void)recieveClick{
    
    [self createUnreadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.isLeftchoose = YES;
    _dataArray = [NSMutableArray array];
    _sectionArray = [NSMutableArray array];
    _topicArray = [NSMutableArray array];
    _slideArray = [NSMutableArray array];
    
    if ([self.content intValue] == 0) {
        [self createTopicData];
    }
    
    if ([self.content intValue] >= 3) {
        [self createTableView];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 0;
            [self createDatatype:@"1"];
        }];
        [self.tableView.mj_header beginRefreshing];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self createDatatype:@"2"];
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topButtonClick:) name:@"置顶动态" object:nil];
        self.lastScrollOffset = 0;
    }else{
        //请求数据
        [self compeleteDataRepuest];
    }

}

/**
 * 创建话题页的数据请求
 */
- (void)createDatatype:(NSString *)type {
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getTopicList"];
    NSDictionary *parameters;
    if ([self.content intValue] == 3) {
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }else{
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"0",@"pid":[NSString stringWithFormat:@"%d",[self.content intValue] - 3],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            if (integer == 3000) {
                if ([type intValue] == 1) {
                    [_dataArray removeAllObjects];
                    [_tableView reloadData];
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求发生错误~"];
            }
        }else{
            if ([type intValue] == 1) {
                [_dataArray removeAllObjects];
            }
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[TopicModel class] json:responseObj[@"data"]]];
            [self.dataArray addObjectsFromArray:data];
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//热帖和广场判断本人不是认证会员和会员的时候展示提示开通或认证的界面搭建
-(void)createVipAndRealnameView{

    _noLookView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 108)];
    _noLookView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:_noLookView];
    
    UIImageView *lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - WIDTH/8)/2, (HEIGHT - WIDTH/8 - 230)/2, WIDTH/8, WIDTH/8 + 5)];
    lockImageView.image = [UIImage imageNamed:@"动态锁"];
    [_noLookView addSubview:lockImageView];
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"仅限VIP会员可见"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [@"仅限VIP会员可见" length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(2, 5)];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(7, 5)];
    
    UILabel *warnLabel = [[UILabel alloc] init];
    warnLabel.attributedText = attributedString;
    [warnLabel sizeToFit];
    warnLabel.frame = CGRectMake((WIDTH -  warnLabel.frame.size.width - 40)/2, CGRectGetMaxY(lockImageView.frame) + 20, warnLabel.frame.size.width + 40, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    warnLabel.layer.cornerRadius = 15;
    warnLabel.clipsToBounds = YES;
     [_noLookView addSubview:warnLabel];
    [warnLabel yb_addAttributeTapActionWithStrings:@[@"VIP会员"] delegate:self];
    warnLabel.enabledTapEffect = NO;
}

//点击文字跳转的代理
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    if ([string isEqualToString:@"认证会员"]) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"realname"] intValue] == 1) {
            LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
            cvc.type = @"2";
            [self.navigationController pushViewController:cvc animated:YES];
            
        }else{
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getidstate"];
            NSDictionary *parameters;
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
                if (integer == 2000) {
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    cvc.type = @"2";
                    [self.navigationController pushViewController:cvc animated:YES];
                    
                }else if(integer == 2001){
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"正在审核,请耐心等待~"];
                }else if (integer == 2002){
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    cvc.where = @"4";
                    [self.navigationController pushViewController:cvc animated:YES];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
        }
    }else if([string isEqualToString:@"VIP会员"]){
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        [self.navigationController pushViewController:mvc animated:YES];
    }
}

//用于请求数据,添加监听
-(void)compeleteDataRepuest{
    
    if ([self.content intValue] == 0) {
        [self createHeaderViewData];
    }else{
        [self createTableViewAndRefresh];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topButtonClick:) name:@"置顶动态" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicScreenButtonClick) name:@"确定动态筛选" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardSuccess:) name:@"打赏成功" object:nil];
    //起始偏移量为0
    self.lastScrollOffset = 0;
}

/**
 * 获取推荐页的话题
 */
-(void)createTopicData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getTopicDyHead"];
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 4000) {
            [_topicArray removeAllObjects];
        }else{
            if (_topicArray.count != 0) {
                [_topicArray removeAllObjects];
            }
            for (NSDictionary *dic in responseObj[@"data"]) {
                [_topicArray addObject:dic];
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

//监听打赏成功
-(void)rewardSuccess:(NSNotification *)user{
    
    if (_dataArray.count >= [user.userInfo[@"section"] integerValue] + 1){
        DynamicModel *model = _dataArray[[user.userInfo[@"section"] integerValue]];
        model.rewardnum = [NSString stringWithFormat:@"%d",[model.rewardnum intValue] + 1];
        [_dataArray replaceObjectAtIndex:[user.userInfo[@"section"] integerValue] withObject:model];
        _cell.rewardLabel.text = [NSString stringWithFormat:@"%@",model.rewardnum];
        [self.tableView reloadData];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    self.lastScrollOffset = self.tableView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y + HEIGHT < self.tableView.contentSize.height) {
            CGFloat y = scrollView.contentOffset.y;
            if (y >= self.lastScrollOffset) {
                //用户往上拖动，也就是屏幕内容向下滚动
                [[NSNotificationCenter defaultCenter] postNotificationName:@"发布动态按钮隐藏" object:nil];
            } else if(y < self.lastScrollOffset){
                //用户往下拖动，也就是屏幕内容向上滚动
                [[NSNotificationCenter defaultCenter] postNotificationName:@"发布动态按钮显示" object:nil];
            }
        }else{
            if (self.lastScrollOffset == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"发布动态按钮显示" object:nil];
            }
        }
    }
}

//确定动态筛选的按钮
-(void)dynamicScreenButtonClick{
    if ([self.content intValue] == 1||[self.content intValue] == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

//点击置顶按钮的监听
-(void)topButtonClick:(NSNotification *)user{
    if ([user.userInfo[@"index"] isEqualToString:self.content]) {
        [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶按钮" object:nil];
    }
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{

    return YES;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"显示置顶按钮" object:nil];
    }
    
    if (_tableView.contentOffset.y == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶按钮" object:nil];
    }
}

/**
 获取广告信息
 */
-(void)createHeaderViewData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getSlideMore"];
    NSDictionary *parameters = @{@"type":@"2"};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [self createTableViewAndRefresh];
        }else{
            [_slideArray addObjectsFromArray:responseObj[@"data"]];
            [self createTableViewAndRefresh];
        }
    } failed:^(NSString *errorMsg) {
         [self createTableViewAndRefresh];
    }];
}

-(void)createTableViewAndRefresh{

    [self createTableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self.content intValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"清除最新红点" object:nil];
        }else if ([self.content intValue] == 2){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"清除关注红点" object:nil];
        }else if ([self.content intValue] == 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"清除推荐红点" object:nil];
        }
        if ([self.content intValue] == 0) {
            //获取推荐页的话题
            [self createTopicData];
        }
        if ([self.content intValue] == 1||[self.content intValue]==0) {
                _page = 0;
                [self createDataType:@"1"];
        }else{
            _page = 0;
            [self createDataType:@"1"];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createDataType:@"2"];
    }];
}


-(void)createDataType:(NSString *)type{
    NSString *url;
    url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getDynamicListNewFive];
    NSDictionary *parameters;
    if ([self.content intValue] == 1||[self.content intValue]==0) {
        
        //判定动态筛选是否开启
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"动态筛选"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"动态筛选"] intValue] == 0) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
                
                if ([self.content intValue] != 1&&[self.content intValue] != 0) {
                    
                    NSString *firsttime;
                    
                    if (_page == 0) {
                        
                        firsttime = @"0";
                        
                    }else{
                        
                        if (_dataArray.count > 0) {
                            
                            firsttime = [_dataArray[0] commenttime];
                            
                        }else{
                            
                            firsttime = @"0";
                        }
                    }
                    
                  
                    parameters = @{@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"firsttime":firsttime,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                 
                    
                    
                    
                }else{
                    
                    if (!self.isLeftchoose) {
                        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"type":@"5",@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                    }
                    else
                    {
                        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"type":[NSString stringWithFormat:@"%d",[self.content intValue]],@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                        
                    }
        
                    
                }
                
            }else{
                
                if ([self.content intValue] != 1&&[self.content intValue] != 0) {
                    
                    NSString *firsttime;
                    
                    if (_page == 0) {
                        
                        firsttime = @"0";
                        
                    }else{
                        
                        if (_dataArray.count > 0) {
                            
                            firsttime = [_dataArray[0] commenttime];
                            
                        }else{
                            
                            firsttime = @"0";
                        }
                    }
                    
                    parameters = @{@"lat":@"",@"lng":@"",@"firsttime":firsttime,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                    
                }else{
                    
                    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"type":[NSString stringWithFormat:@"%d",[self.content intValue]],@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                }
                
            }
            
        }else{
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
                
                if ([self.content intValue] != 1&&[self.content intValue]!=0) {
                    
                    NSString *firsttime;
                    
                    if (_page == 0) {
                        
                        firsttime = @"0";
                        
                    }else{
                        
                        if (_dataArray.count > 0) {
                            
                            firsttime = [_dataArray[0] commenttime];
                            
                        }else{
                            
                            firsttime = @"0";
                        }
                    }

                    parameters = @{@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"firsttime":firsttime,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"sex":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"],@"sexual":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"]};
                    
                }else{
                    
                    if (!self.isLeftchoose) {
                             parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"type":@"5",@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"sex":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"],@"sexual":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"]};
                    }
                    else
                    {
                             parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"type":[NSString stringWithFormat:@"%d",[self.content intValue]],@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"sex":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"],@"sexual":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"]};
                    }
                    
               
                    
                    
                }
            }else{
                
                if ([self.content intValue] != 1&&[self.content intValue] != 0) {
                    
                    NSString *firsttime;
                    
                    if (_page == 0) {
                        
                        firsttime = @"0";
                        
                    }else{
                        
                        if (_dataArray.count > 0) {
                            
                            firsttime = [_dataArray[0] commenttime];
                            
                        }else{
                            
                            firsttime = @"0";
                        }
                    }
                    
                    parameters = @{@"lat":@"",@"lng":@"",@"firsttime":firsttime,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"sex":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"],@"sexual":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"]};
                    
                }else{
                    
                    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"type":[NSString stringWithFormat:@"%d",[self.content intValue]],@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"sex":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"],@"sexual":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"]};
                }
            }
        }
    }else{
        NSString *content;
        if ([self.content intValue] == 0) {
            content = @"0";
        }else{
            content = [NSString stringWithFormat:@"%d",[self.content intValue]];
        }
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"type":content,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"type":content,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        _integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (_integer != 2000 && _integer != 2001) {
            if (_integer == 4001) {
                if ([type intValue] == 1||[type intValue] == 5) {
                    [_dataArray removeAllObjects];
                    [self.tableView reloadData];
                }
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                
                if ([self.content intValue] == 2 && (_integer == 4344 || _integer == 4343)) {
                    [_dataArray removeAllObjects];
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    if (_friendNoLookView == nil) {
                        [self createFriendNoDynamicView];
                    }
                }else{
                    [self.tableView.mj_footer endRefreshing];
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                }
            }
        }else{
            if ([type intValue] == 1||[type intValue]==5||[type intValue]==0) {
                [_dataArray removeAllObjects];
            }
            if (_friendNoLookView != nil) {
                [_friendNoLookView removeFromSuperview];
            }
            if (_noLookView != nil) {
                [_noLookView removeFromSuperview];
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

//当好友没有动态的时候创建
-(void)createFriendNoDynamicView{

    _friendNoLookView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _friendNoLookView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:_friendNoLookView];
    
    UIImageView *lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - WIDTH/5)/2, (HEIGHT - WIDTH/5 - 230)/2, WIDTH/5, WIDTH/5)];
    lockImageView.image = [UIImage imageNamed:@"好友无动态"];
    [_friendNoLookView addSubview:lockImageView];
    
    UILabel *warnLabel = [[UILabel alloc] init];
    warnLabel.text = @"没有好友或好友未发布动态~";
    [warnLabel sizeToFit];
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.frame = CGRectMake((WIDTH -  warnLabel.frame.size.width - 40)/2, CGRectGetMaxY(lockImageView.frame) + 20, warnLabel.frame.size.width + 40, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    warnLabel.layer.cornerRadius = 15;
    warnLabel.clipsToBounds = YES;
    [_friendNoLookView addSubview:warnLabel];
}

-(void)createTableView{
    if ([self.content intValue] >= 3) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 49 - 40) style:UITableViewStyleGrouped];
    }else{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 49) style:UITableViewStyleGrouped];
    }
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
    
    if ([self.content intValue] >= 3) {
        
        TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Topic"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TopicCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TopicModel *model = _dataArray[indexPath.section];
        cell.indexPath = indexPath;
        cell.model = model;
        cell.topicBlock = ^(UIImage *topicImage) {
            [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:0 imagesBlock:^NSArray *{
                NSArray *array = [NSArray arrayWithObject:topicImage];
                return array;
            }];
        };
        return cell;
    }
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.integer = _integer;
    cell.indexPath = indexPath;
    [_sectionArray addObject:indexPath];
    [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(DynamicCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    DynamicModel *model = _dataArray[indexPath.section];
    cell.model = model;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.content intValue] >= 3) {
        return 85;
    }
    return [tableView fd_heightForCellWithIdentifier:@"DynamicCell" cacheByIndexPath:indexPath configuration:^(DynamicCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

//点击动态头像
-(void)headButtonClick:(UIButton *)button{
    DynamicCell *cell = (DynamicCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DynamicModel *model = _dataArray[indexPath.section];
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
}

#pragma 点击文字的danamicDelegate
-(void)transmitClickModel:(DynamicModel *)model{
    HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
    tvc.tid = [NSString stringWithFormat:@"%@",model.tid];
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma 点击图片看大图danamicDelegate
-(void)tap:(UITapGestureRecognizer *)tap{
    UIImageView *img = (UIImageView *)tap.view;
    __weak typeof(self) weakSelf=self;
    [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:img.tag - img.tag/100 * 100 imagesBlock:^NSArray *{
        DynamicModel *model = _dataArray[img.tag/100];
        if (model.sypic.count == 0) {
            _picArray = model.pic;
        }else{
            _picArray = model.sypic;
        }
        return weakSelf.picArray;
    }];
}

#pragma mark - 点赞-动态-评论-推顶

-(void)zanTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    DynamicModel *model = _dataArray[index.section];
    if ([model.laudstate intValue] == 0) {
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,laudDynamicNewrd];
        NSDictionary *parameters;
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":model.did};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            
            if (integer != 2000) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }else{
                
                int oldstrs = [model.laudnum intValue]+1;
                model.laudnum = [NSString stringWithFormat:@"%d",oldstrs].mutableCopy;
                model.laudstate = @"1";
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
                [_dataArray replaceObjectAtIndex:index.section withObject:model];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
        
    }
}

-(void)commentTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    DynamicModel *model = _dataArray[index.section];
    LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
    dvc.did = model.did;
    dvc.ownUid = model.uid;
    _indexPath = index;
    dvc.clickState = @"comment";
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)replyTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    DynamicModel *model = _dataArray[index.section];
    BOOL ismines = NO;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[model.uid intValue]) {
        ismines = YES;
    }
    _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:ismines :^{
        LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
        cvc.type = @"0";
        [self.navigationController pushViewController:cvc animated:YES];

    }];
    
    [_gif getDynamicDid:model.did andIndexPath:index andSign:@"动态" andUIViewController:self];
    [self.tabBarController.view addSubview:_gif];

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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.content intValue] == 0 && section == 0) {
        if(_slideArray.count != 0){
            if (_topicArray.count == 0) {
                return DYANDNERHEIGHT + ADVERTISEMENT + DYNAMICWARNH;
            }
            return DYANDNERHEIGHT + ADVERTISEMENT + 50 + DYNAMICWARNH;
        }
        if (_topicArray.count == 0) {
            return DYANDNERHEIGHT + DYNAMICWARNH;
        }
        return DYANDNERHEIGHT + 50 + DYNAMICWARNH;
    }
    if (section == 0 && _slideArray.count == 0) {
        return 0.1;
    }
    if ([self.content intValue] >= 3) {
        return 1;
    }
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([self.content intValue] == 0  && section == 0) {
        
        NSArray *imageName = @[@"动态打赏榜",@"动态人气榜",@"动态活跃榜",@"动态消息"];
        NSArray *titleName = @[@"打赏榜",@"人气榜",@"活跃榜",@"动态消息"];
        
        CGFloat itemW = WIDTH/5;
        CGFloat itemH = DYANDNERHEIGHT;
        CGFloat plSpace = 5 * HEIGHTRADIO;
        CGFloat itemSpace = (WIDTH - itemW * imageName.count)/(imageName.count + 1);
        CGFloat lableH = 20;
        CGFloat topBottomSpace = (itemH - itemW/2 - lableH - plSpace)/2;
        
        if (_slideArray.count != 0) {
            
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, DYANDNERHEIGHT + ADVERTISEMENT + 40)];
            
            UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, ADVERTISEMENT, WIDTH, itemH)];
            showView.backgroundColor = [UIColor whiteColor];
            [headView addSubview:showView];
            
            for (int i = 0; i < imageName.count; i++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(itemSpace + i * itemW + i * itemSpace, 0, itemW, itemH)];
                view.backgroundColor = [UIColor whiteColor];
                [showView addSubview:view];
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((itemW - itemW/2)/2, topBottomSpace, itemW/2, itemW/2)];
                imgView.image = [UIImage imageNamed:imageName[i]];
                [view addSubview:imgView];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, topBottomSpace + itemW/2 + plSpace, itemW, lableH)];
                label.text = titleName[i];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                [view addSubview:label];
                
                if (i == imageName.count - 1) {
                    
                    _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemW/2 - 4, -2, 8, 8)];
                    _unreadLabel.backgroundColor = [UIColor redColor];
                    _unreadLabel.layer.cornerRadius = 4;
                    _unreadLabel.clipsToBounds = YES;
                    _unreadLabel.hidden = YES;
                    [imgView addSubview:_unreadLabel];
                    
                    [self createUnreadData];
                }
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH)];
                button.tag = 1000 + i;
                [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
            }
            
            if (_topicArray.count != 0) {
            
                [self createTopicView:headView andHeight:DYANDNERHEIGHT + ADVERTISEMENT];
                
                [self createWarnButtonWith:headView andOrignY:DYANDNERHEIGHT + ADVERTISEMENT + 50];
                
            }else{
            
                [self createWarnButtonWith:headView andOrignY:DYANDNERHEIGHT + ADVERTISEMENT];
            }
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT)];
            img.userInteractionEnabled = YES;
            [headView addSubview:img];
            
            NSMutableArray *pathArray = [NSMutableArray array];
            
            for (NSDictionary *dic in _slideArray) {
                
                [pathArray addObject:dic[@"path"]];
                
            }
            
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT) delegate:self placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            cycleScrollView.imageURLStringsGroup = pathArray;
            cycleScrollView.autoScrollTimeInterval = 3.0;
            [img addSubview:cycleScrollView];

            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 25, 5, 20, 20)];
            
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
            
            [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            [img addSubview:deleteButton];
            
            return headView;
            
        }else{
            
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, DYANDNERHEIGHT + 40)];
            
            UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, DYANDNERHEIGHT)];
            showView.backgroundColor = [UIColor whiteColor];
            [headView addSubview:showView];
            
            for (int i = 0; i < imageName.count; i++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(itemSpace + i * itemSpace + i * itemW, 0, DYANDNERHEIGHT, DYANDNERHEIGHT)];
                view.backgroundColor = [UIColor whiteColor];
                [showView addSubview:view];
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((itemW - itemW/2)/2, topBottomSpace, itemW/2, itemW/2)];
                imgView.image = [UIImage imageNamed:imageName[i]];
                [view addSubview:imgView];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, topBottomSpace + itemW/2 + plSpace, itemW, lableH)];
                label.text = titleName[i];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                [view addSubview:label];
                
                if (i == imageName.count - 1) {
                    
                    _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemW/2 - 4, -2, 8, 8)];
                    _unreadLabel.backgroundColor = [UIColor redColor];
                    _unreadLabel.layer.cornerRadius = 4;
                    _unreadLabel.layer.masksToBounds = YES;
                    _unreadLabel.hidden = YES;
                    [imgView addSubview:_unreadLabel];
                    
                    [self createUnreadData];
                }
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH)];
                button.tag = 1000 + i;
                [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
            }
            if (_topicArray.count != 0) {
                [self createTopicView:headView andHeight:DYANDNERHEIGHT];
                [self createWarnButtonWith:headView andOrignY:DYANDNERHEIGHT + 50];
            }else{
                [self createWarnButtonWith:headView andOrignY:DYANDNERHEIGHT];
            }

            return headView;
        }
    }
    return [[UIView alloc] init];
}

- (void)createWarnButtonWith:(UIView *)headView andOrignY:(CGFloat)y{
    
//    UIButton *warnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y - 1.5, WIDTH, DYNAMICWARNH)];
//    [warnButton setTitle:@"SVIP发布的动态将被自动推荐(点击查看)" forState:UIControlStateNormal];
//    warnButton.titleLabel.font = [UIFont systemFontOfSize:12];
//    [warnButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [warnButton addTarget:self action:@selector(warnButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:warnButton];
//
    UIButton *leftBtn = [UIButton new];
    leftBtn.frame = CGRectMake(0, y - 1.5, WIDTH/2, 24);
    [headView addSubview:leftBtn];
    [leftBtn setTitle:@"推荐" forState:normal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftBtn setTitleColor:MainColor forState:normal];
    leftBtn.tag = 2000;
    [leftBtn addTarget:self action:@selector(leftChooseclick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton new];
    rightBtn.frame = CGRectMake(WIDTH/2, y - 1.5, WIDTH/2, 24);
    [headView addSubview:rightBtn];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setTitle:@"推顶" forState:normal];
    [rightBtn setTitleColor:TextCOLOR forState:normal];
    rightBtn.tag = 2001;
    [rightBtn addTarget:self action:@selector(rightChooseclick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line0 = [UIView new];
    UIView *line1 = [UIView new];
    line0.backgroundColor = MainColor;
    line1.backgroundColor = MainColor;
    
    [leftBtn addSubview:line0];
    [rightBtn addSubview:line1];
    
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftBtn);
        make.bottom.equalTo(leftBtn);
        make.height.mas_offset(1);
        make.width.mas_offset(40);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightBtn);
        make.bottom.equalTo(rightBtn);
        make.height.mas_offset(1);
        make.width.mas_offset(40);
    }];
    
    line0.tag = 3000;
    line1.tag = 3001;
    
    if (self.isLeftchoose) {
        [leftBtn setTitleColor:MainColor forState:normal];
        [rightBtn setTitleColor:[UIColor darkGrayColor] forState:normal];
        [leftBtn setImage:[UIImage imageNamed:@"小推荐紫"] forState:normal];
        [rightBtn setImage:[UIImage imageNamed:@"小推顶灰"] forState:normal];
        [leftBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        [rightBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        [line0 setHidden:NO];
        [line1 setHidden:YES];
    }
    else
    {
        [rightBtn setTitleColor:MainColor forState:normal];
        [leftBtn setTitleColor:[UIColor darkGrayColor] forState:normal];
        [leftBtn setImage:[UIImage imageNamed:@"小推荐灰"] forState:normal];
        [rightBtn setImage:[UIImage imageNamed:@"小推顶紫"] forState:normal];
        [leftBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        [rightBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        [line0 setHidden:YES];
        [line1 setHidden:NO];
    }
}

-(void)leftChooseclick
{
    UIButton *btn0 = [self.tableView viewWithTag:2000];
    UIButton *btn1 = [self.tableView viewWithTag:2001];
    [btn0 setTitleColor:MainColor forState:normal];
    self.isLeftchoose = YES;
    [btn1 setTitleColor:TextCOLOR forState:normal];
    [self createDataType:@"1"];
    [btn0 setImage:[UIImage imageNamed:@"小推荐紫"] forState:normal];
    [btn1 setImage:[UIImage imageNamed:@"小推顶灰"] forState:normal];
    UIView *line0 = [self.tableView viewWithTag:3000];
    UIView *line1 = [self.tableView viewWithTag:3001];
    [line0 setHidden:NO];
    [line1 setHidden:YES];
}

-(void)rightChooseclick
{
    UIButton *btn0 = [self.tableView viewWithTag:2000];
    UIButton *btn1 = [self.tableView viewWithTag:2001];
    [btn1 setTitleColor:MainColor forState:normal];
    self.isLeftchoose = NO;
    [btn0 setTitleColor:TextCOLOR forState:normal];
    [self createDataType:@"1"];
    [btn0 setImage:[UIImage imageNamed:@"小推荐灰"] forState:normal];
    [btn1 setImage:[UIImage imageNamed:@"小推顶紫"] forState:normal];
    UIView *line0 = [self.tableView viewWithTag:3000];
    UIView *line1 = [self.tableView viewWithTag:3001];
    [line0 setHidden:YES];
    [line1 setHidden:NO];
}

- (void)warnButtonClick{
    
    LDStandardViewController *svc = [[LDStandardViewController alloc] init];
    svc.navigationItem.title = @"动态推荐";
    svc.state = @"动态推荐";
    [self.navigationController pushViewController:svc animated:YES];
}

//删除上面的广告
-(void)deleteButtonClick{
    
    [_slideArray removeAllObjects];
    
    [self.tableView reloadData];
}

#pragma mark 0 点击广告轮播的回调

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    //link_type 0:url,1:话题,2:动态,3:主页,
    
    if ([_slideArray[index][@"link_type"] intValue] == 0) {
        
        LDBulletinViewController *bvc = [[LDBulletinViewController alloc] init];
        bvc.url = _slideArray[index][@"url"];
        bvc.title = _slideArray[index][@"title"];
        [self.navigationController pushViewController:bvc animated:YES];
    }
    if ([_slideArray[index][@"link_type"] intValue] == 1) {
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        tvc.tid = [NSString stringWithFormat:@"%@",_slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:tvc animated:YES];
    }
    if ([_slideArray[index][@"link_type"] intValue] == 2) {
        LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
        vc.did = [NSString stringWithFormat:@"%@",_slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_slideArray[index][@"link_type"] intValue] == 3) {
        LDOwnInformationViewController *VC = [LDOwnInformationViewController new];
        VC.userID = [NSString stringWithFormat:@"%@",_slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

/**
 创建动态第一页的话题
 */
-(void)createTopicView:(UIView *)headView andHeight:(CGFloat)heightH{

    CGFloat btnX = 5;
    
    NSArray *colorArray = @[@"0xff0000",@"0xb73acb",@"0x0000ff",@"0x18a153",@"0xf39700",@"0xff00ff",@"0x00a0e9"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(3, heightH, WIDTH, 44)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    [headView addSubview:scrollView];
    UIImageView *recommendView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 30, 30)];
    recommendView.image = [UIImage imageNamed:@"推荐话题"];
    [scrollView addSubview:recommendView];
    
    for (int i = 0; i < _topicArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn setTitle:[NSString stringWithFormat:@"#%@#",_topicArray[i][@"title"]] forState:UIControlStateNormal];
        
       // [btn setTitleColor:UIColorFromRGB(strtoul([colorArray[i%7] UTF8String], 0, 0)) forState:UIControlStateNormal];
        
        btn.backgroundColor = NewUIColorFromRGB(strtoul([colorArray[i%7] UTF8String], 0, 0));
        [btn setTitleColor:[UIColor whiteColor] forState:normal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //重要的是下面这部分哦！
        CGSize titleSize = [[NSString stringWithFormat:@"#%@#",_topicArray[i][@"title"]] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        titleSize.height = 44;
        titleSize.width += 20;
        //btn.frame = CGRectMake(btnX + 40, 0, titleSize.width, titleSize.height);
        btn.frame = CGRectMake(btnX + 40, 3, titleSize.width, 30);
        btnX = btnX + titleSize.width+8;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 14;
        if (i == _topicArray.count - 1) {
            scrollView.contentSize = CGSizeMake(btnX + 10 + 40 , 44);
        }
        [scrollView addSubview:btn];
    }
}

-(void)btnButtonClick:(UIButton *)button{

    HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
    
    tvc.tid = [NSString stringWithFormat:@"%@",_topicArray[button.tag%100][@"tid"]];
    
    [self.navigationController pushViewController:tvc animated:YES];
}

-(void)titleButtonClick:(UIButton *)button{

    if (button.tag == 1000) {
        
        LDRewardRankingViewController *rvc = [[LDRewardRankingViewController alloc] init];
        
        [self.navigationController pushViewController:rvc animated:YES];
        
    }else if (button.tag == 1001){
    
        LDPopularityRankingViewController *rvc = [[LDPopularityRankingViewController alloc] init];
        
        rvc.rankType = @"popularity";
        
        [self.navigationController pushViewController:rvc animated:YES];
        
    }else if (button.tag == 1002){
    
        LDPopularityRankingViewController *rvc = [[LDPopularityRankingViewController alloc] init];
        
        rvc.rankType = @"diligence";
        
        [self.navigationController pushViewController:rvc animated:YES];
        
    }else if (button.tag == 1003){
        
        LDGetListViewController *lvc = [[LDGetListViewController alloc] init];
        
        lvc.hotDog = !self.unreadLabel.hidden;
        
        [self.navigationController pushViewController:lvc animated:YES];

    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([self.content intValue] >= 3) {
        
        if (_dataArray.count != 0 && _dataArray.count == section + 1) {
            
            return 1;
        }
        
        return 0.0001;
    }
    
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
    
    if ([self.content intValue] >= 3) {
        
        return [[UIView alloc] init];
    }
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.content intValue] >= 3) {
        
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        
        TopicModel *model = _dataArray[indexPath.section];
        
        tvc.tid = [NSString stringWithFormat:@"%@",model.tid];
        
        tvc.index = [self.content integerValue] - 3;
        
        [self.navigationController pushViewController:tvc animated:YES];
        
    }else{
        
        LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
        
        DynamicModel *model = _dataArray[indexPath.section];
        
        DynamicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        dvc.did = model.did;
        
        dvc.ownUid = model.uid;
        
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
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    if (_gif) {
        
        [_gif removeView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
