//
//  LDDynamicDetailViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/14.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDDynamicDetailViewController.h"
#import "LDBindingPhoneNumViewController.h"
#import "LDAlertOtherDynamicViewController.h"
#import "HeaderTabViewController.h"
#import "ImageBrowserViewController.h"
#import "LDMemberViewController.h"
#import "attentionCell.h"
#import "TableModel.h"
#import "LDOwnInformationViewController.h"
#import "commentModel.h"
#import "CommentCell.h"
#import "LDReportResonViewController.h"
#import "LDMyWalletPageViewController.h"
#import "LDShareView.h"
#import "GifView.h"
#import "LDChargeCenterViewController.h"

@interface LDDynamicDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,YBAttributeTapActionDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomY;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) CGFloat cellH;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *replyUid;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backH;
@property (weak, nonatomic) IBOutlet UIImageView *recommendView;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *onlineView;
@property (weak, nonatomic) IBOutlet UIImageView *idView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idViewW;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceY;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIView *aSexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTopH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backW;

@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picTopH;

@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *rewardButton;
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;

//发送评论
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomY;

//点赞数和点赞状态
@property(nonatomic,copy) NSString *zanNum;
@property(nonatomic,copy) NSString *zanState;

//评论数
@property(nonatomic,copy) NSString *commentNum;

//打赏数
@property(nonatomic,copy) NSString *rewordNum;

//是不是志愿者
@property(nonatomic,copy) NSString *volunteer;

//收藏的状态
@property(nonatomic,copy) NSString *collectstate;

//举报动态的状态
@property(nonatomic,copy) NSString *reportstate;

//置顶的状态
@property(nonatomic,copy) NSString *stickstate;

//动态的隐藏状态
@property (nonatomic,copy) NSString *is_hidden;

//推荐的状态
@property(nonatomic,copy) NSString *recommendstate;

//黑V推荐的状态
@property(nonatomic,copy) NSString *recommend;

//黑V置顶的状态
@property(nonatomic,copy) NSString *recommendall;

//添加财富和魅力值的显示
@property (weak, nonatomic) IBOutlet UIView *wealthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthSpace;
@property (weak, nonatomic) IBOutlet UILabel *wealthLabel;
@property (weak, nonatomic) IBOutlet UIView *charmView;
@property (weak, nonatomic) IBOutlet UILabel *charmLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charmW;

//图片数组
@property(nonatomic,copy) NSArray *picArray;

//存储话题的id
@property (nonatomic,copy) NSString *tid;

//是否可以评论
@property (nonatomic,copy) NSString *publishComment;

//分享视图
@property (nonatomic,strong) LDShareView *shareView;

//礼物界面
@property (nonatomic,strong) GifView *gif;

//动态数与推荐动态数
@property (weak, nonatomic) IBOutlet UILabel *dyAndRdNumLabel;

@end

@implementation LDDynamicDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"动态详情";
    [self.tableView addSubview:self.sendView];

    _dataArray = [NSMutableArray array];
    //点赞,评论,打赏状态
    _status = @"2";
    [self createTableView];
    _backView.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self createData:@"1"];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createData:@"2"];
    }];
    
    [self createScanData];
    
    [self createPublishCommentData];
    
    self.sendView.hidden = YES;
    
    self.headView.layer.cornerRadius = 20;
    self.headView.clipsToBounds = YES;
    
    self.onlineView.layer.cornerRadius = 4;
    self.onlineView.clipsToBounds = YES;
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.sendButton.layer.cornerRadius = 2;
    self.sendButton.clipsToBounds = YES;
    
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius = 2;
    self.textView.clipsToBounds = YES;
    
    [self createButton];
    if ([_clickState isEqualToString:@"comment"]) {
        [self.textView becomeFirstResponder];
    }
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardSuccess) name:@"动态详情打赏成功" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindPhoneNumSuccess) name:@"绑定手机号码成功" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editDynamicSuccess) name:@"编辑动态成功" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    
 
}

#pragma mark - 禁用IQKeyboardManager

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    IQKeyboardManager *keyboardManager =  [IQKeyboardManager sharedManager];
    keyboardManager.enable = NO;
    keyboardManager.enableAutoToolbar = NO;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    IQKeyboardManager *keyboardManager =  [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = YES;
    
    if (_gif) {
        
        [_gif removeView];
    }
}

/**
 * 编辑动态成功的监听方法
 */
-(void)editDynamicSuccess{
    
    [self createScanData];
}

/**
 * 绑定手机号码成功的监听方法
 */

-(void)bindPhoneNumSuccess{

    _publishComment = @"YES";
}

/**
 * 打赏成功的监听方法
 */

-(void)rewardSuccess{
    
    [self.rewardButton setTitle:[NSString stringWithFormat:@"打赏 %@",[NSString stringWithFormat:@"%d",[_rewordNum intValue] + 1]] forState:UIControlStateNormal];
    
    _rewordNum = [NSString stringWithFormat:@"%d",[_rewordNum intValue] + 1];
    
    if (_rewordBlock) {
    
        self.rewordBlock([NSString stringWithFormat:@"%d",[_rewordNum intValue]]);
        
    }
}

/**
 * 获取判断是否可以评论的状态
 */

-(void)createPublishCommentData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/judgeDynamicNewrd"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        if (integer == 4003) {
            
            _publishComment = @"NO";
            
            
        }else  if(integer == 2000 || integer == 4004){
            
            _publishComment = @"YES";
            
        }else if(integer == 3001){
        
            _publishComment = @"";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        _publishComment = @"NO";
        
    }];

}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        
        [self.introduceLabel setHidden:NO];
        
    }else{
        
        [self.introduceLabel setHidden:YES];
    }

    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        
        if(textView.text.length > 256){
            
            textView.text = [textView.text substringToIndex:256];
            
        }
    }
}

-(void)createScanData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/getDynamicdetailFive"];
    
    NSDictionary *parameters;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"did":_did,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]};
        
    }else{
        
        parameters = @{@"did":_did,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@""};
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        if (integer != 2000 && integer != 2001) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];

            self.tableView.mj_footer.hidden = YES;
            self.tableView.mj_header.hidden = YES;
            
        }else{
            
            [self createUI:responseObject[@"data"] andInteger:integer];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.tableView.mj_footer.hidden = YES;
        self.tableView.mj_header.hidden = YES;
        
    }];
    
}


//请求赞，评论，打赏数据
-(void)createData:(NSString *)str{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
    
    if ([_status intValue] == 1) {
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/getLaudListNew"];
        
    }else if ([_status intValue] == 2){
    
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/getCommentListNew"];
        
    }else if ([_status intValue] == 3){
    
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/getRewardListNew"];
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//       NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            if (integer == 4002) {
                
                if ([str intValue] == 1) {
                    
                    [_dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                    self.tableView.mj_footer.hidden = YES;
                    
                }else{
                
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }

            }else{
                
                [self.tableView.mj_footer endRefreshing];
            
               [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            }
            
        }else{
            
            if ([str intValue] == 1) {
                
                [_dataArray removeAllObjects];
                
            }
            
            if ([_status intValue] == 2) {
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    commentModel *model = [[commentModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [_dataArray addObject:model];
                }

            }else{
            
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    TableModel *model = [[TableModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [_dataArray addObject:model];
                }
            }
            
            self.tableView.mj_footer.hidden = NO;
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}

-(void)createTableView{
    
    if (ISIPHONEX) {
        
        self.bottomY.constant = IPHONEXBOTTOMH;
        
        self.tableViewBottomY.constant = self.tableViewBottomY.constant + IPHONEXBOTTOMH;
        
    }
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    
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
    
    if ([_status intValue] == 1 || [_status intValue] == 3) {
        
        attentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attention"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"attentionCell" owner:self options:nil].lastObject;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        TableModel *model;
        
        if (_dataArray.count > 0) {
            
            model = _dataArray[indexPath.section];
            
            cell.otherType = @"0";
            
            cell.model = model;
        }

       [cell.attentButton addTarget:self action:@selector(attentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }else if([_status intValue] == 2){
    
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comment"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil].lastObject;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        commentModel *model = [[commentModel alloc] init];
        
        if (_dataArray.count > 0) {
            
            model = _dataArray[indexPath.section];
            
            cell.model = model;
            
        }
        
        [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
            
            cell.deleteButton.hidden = NO;
            
            [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
        
            if ([_ownUid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] || [model.uid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                
                cell.deleteButton.hidden = NO;
                
                [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                
                cell.deleteButton.hidden = YES;
                
            }

        }

        _cellH = cell.contentView.frame.size.height;
        
        return cell;
    }
    
    return nil;
    
}

//删除评论
-(void)deleteButtonClick:(UIButton *)button{

    CommentCell *cell = (CommentCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    commentModel *model = _dataArray[indexPath.section];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/delComment"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did,@"cmid":model.cmid};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //                NSLog(@"%@",responseObject);
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];

        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            [_dataArray removeObjectAtIndex:indexPath.section];
        
            [self.commentButton setTitle:[NSString stringWithFormat:@"评论 %@",[NSString stringWithFormat:@"%d",[_commentNum intValue] - 1]] forState:UIControlStateNormal];
            
            _commentNum = [NSString stringWithFormat:@"%d",[_commentNum intValue] - 1];
            
            if (_commentBlock) {
                
                 self.commentBlock([NSString stringWithFormat:@"%d",[_commentNum intValue]]);
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];

}

-(void)headButtonClick:(UIButton *)button{

    CommentCell *cell = (CommentCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    commentModel *model = _dataArray[indexPath.section];

    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    ivc.userID = model.uid;
    
    [self.navigationController pushViewController:ivc animated:YES];
}

-(void)attentButtonClick:(UIButton *)button{
    
    attentionCell *cell = (attentionCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    TableModel *model = _dataArray[indexPath.section];
    
    if ([model.state intValue] == 0 || [model.state intValue] == 2) {
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/followOneBox"];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
        
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            //        NSLog(@"%@",responseObject);
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
            }else{
                
                if ([model.state intValue] == 0) {
                    
                    model.state = @"1";
                    
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    
                    [self.tableView reloadData];
                    
                }else if ([model.state intValue] == 2){
                    
                    model.state = @"3";
                    
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    
                    [self.tableView reloadData];
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            
        }];
        
    }else if([model.state intValue] == 1 || [model.state intValue] == 3){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定不再关注此人"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/overfollow"];
            
            NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
            
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                
//                        NSLog(@"%@",responseObject);
                
                if (integer != 2000) {
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                    
                }else{
                    
                    if ([model.state intValue] == 1) {
                        
                        model.state = @"0";
                        
                        [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                        
                        [self.tableView reloadData];
                        
                    }else if ([model.state intValue] == 3){
                        
                        model.state = @"2";
                        
                        [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                        
                        [self.tableView reloadData];
                    }
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        
        [alert addAction:action];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_status intValue] == 2) {
        
        return _cellH;
    }
    
    return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_status intValue] == 1 || [_status intValue] == 3) {
        
        LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
        
        TableModel *model = _dataArray[indexPath.section];
        
        ivc.userID = model.uid;
        
        [self.navigationController pushViewController:ivc animated:YES];
        
    }else if ([_status intValue] == 2){
        
        commentModel *model = _dataArray[indexPath.section];
        
        if ([model.uid intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            
            _replyUid = model.uid;
            
            [self.textView becomeFirstResponder];
            
            if (self.textView.text.length != 0) {
                
                self.textView.text = @"";
            }
            
            self.introduceLabel.hidden = NO;
            
            self.introduceLabel.text = [NSString stringWithFormat:@"回复 %@:",model.nickname];
            
            
        }else{
            
            self.introduceLabel.hidden = YES;
            
            self.introduceLabel.text = @"";
        
            _replyUid = @"";
        }
    }
}

-(void)createUI:(NSDictionary *)dic  andInteger:(NSInteger)integer{

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
        
        self.dyAndRdNumLabel.text = [NSString stringWithFormat:@"%@/%@",dic[@"dynamic_num"],dic[@"rdynamic_num"]];
    }
    
    _shareView = [[LDShareView alloc] init];
    //    //分享视图
    
    _reportstate = [NSString stringWithFormat:@"%@",dic[@"reportstate"]];
    
    _stickstate = [NSString stringWithFormat:@"%@",dic[@"stickstate"]];
    
    _is_hidden = [NSString stringWithFormat:@"%@",dic[@"is_hidden"]];

    _collectstate = [NSString stringWithFormat:@"%@",dic[@"collectstate"]];

    _recommendstate = [NSString stringWithFormat:@"%@",dic[@"recommend"]];
    
    _recommend = [NSString stringWithFormat:@"%@",dic[@"recommend"]];
    
    _recommendall = [NSString stringWithFormat:@"%@",dic[@"recommendall"]];
    
    _tid = dic[@"tid"];
    
    NSString *pic;

    if ([dic[@"head_pic"] length] == 0) {

        pic = [PICHEADURL stringByAppendingString:@"nopeople.png"];
    }else{
    
        pic = dic[@"head_pic"];
    }
    
    [self.navigationController.view addSubview:[_shareView createBottomView:@"Dynamic" andNickName:dic[@"nickname"] andPicture:pic andId:_did]];

    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    self.nameLabel.text = dic[@"nickname"];
    
    [self.nameLabel sizeToFit];
    
    if ([_ownUid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        if ([dic[@"stickstate"] intValue] == 1) {
            
            self.recommendView.image = [UIImage imageNamed:@"置顶动态图标"];
            
            self.recommendView.hidden = NO;
            
        }else if ([dic[@"is_hidden"] intValue] == 1){
        
            self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
            
            self.recommendView.hidden = NO;

        }else if([dic[@"recommend"] intValue] == 1){
        
            self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
            
            self.recommendView.hidden = NO;
            
        }else{
            
            self.recommendView.hidden = YES;
        }
        
        if ([dic[@"recommend"] intValue] == 0) {
            
            self.scanLabel.text = @"";
            
            self.distanceY.constant = 15;
            
        }else{
        
            self.scanLabel.text = [NSString stringWithFormat:@"浏览 %@",dic[@"readtimes"]];
            
            self.distanceY.constant = 38;
        }

    }else{
        
        if ([dic[@"is_hidden"] intValue] == 1){
            
            self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
            
            self.recommendView.hidden = NO;
            
            if ([dic[@"recommend"] intValue] == 0) {
                
                self.scanLabel.text = @"";
                
                self.distanceY.constant = 15;
                
            }else{
                
                self.scanLabel.text = [NSString stringWithFormat:@"浏览 %@",dic[@"readtimes"]];
                
                self.distanceY.constant = 38;
            }
            
        }else{
            
            if ([dic[@"recommend"] intValue] == 0) {
                
                self.recommendView.hidden = YES;
                
                self.scanLabel.text = @"";
                
                self.distanceY.constant = 15;
                
            }else{
                
                self.scanLabel.text = [NSString stringWithFormat:@"浏览 %@",dic[@"readtimes"]];
                
                self.distanceY.constant = 38;
                
                self.recommendView.hidden = NO;
                
                if ([dic[@"recommendall"] length] != 0) {
                    
                    if ([dic[@"recommendall"] intValue] > 0) {
                        
                        self.recommendView.image = [UIImage imageNamed:@"置顶动态图标"];
                        
                    }else{
                        
                        self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                    }
                    
                }else{
                    
                    self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                }
            }
        }
    }
    
    if ([dic[@"is_volunteer"] intValue] == 1) {
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
        
    }else if ([dic[@"is_admin"] intValue] == 1) {
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
        
    }else{
        
        if ([dic[@"svipannual"] intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年svip标识"];
            
        }else if ([dic[@"svip"] intValue] == 1){
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"svip标识"];
            
        }else if ([dic[@"vipannual"] intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年费会员"];
            
        }else{
            
            if ([dic[@"vip"] intValue] == 1) {
                
                self.vipView.hidden = NO;
                
                self.vipView.image = [UIImage imageNamed:@"高级紫"];
                
            }else{
                
                self.vipView.hidden = YES;
            }
        }
        
    }

    
    if ([dic[@"onlinestate"] intValue] == 1) {
        
        self.onlineView.hidden = NO;
        
    }else{
        
        self.onlineView.hidden = YES;
    }
    
    if ([dic[@"realname"] intValue] == 1) {
        
        self.idView.hidden = NO;
        
        self.idViewW.constant = 17;
        
    }else{
        
        self.idView.hidden = YES;
        
        self.idViewW.constant = 0;
    }
    
    if ([dic[@"distance"] floatValue] != 0) {
        
        if (integer == 2001) {
            
            self.distanceLabel.text = [NSString stringWithFormat:@"%@",dic[@"addtime"]];
            
        }else{
        
            self.distanceLabel.text = [NSString stringWithFormat:@"%@km %@",dic[@"distance"],dic[@"addtime"]];
        }
        
    }else{
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%@",dic[@"addtime"]];
    }
    
    self.commentLabel.isCopyable = YES;
    
    NSString *content;
    
    if ([dic[@"topictitle"] length] == 0) {
        
        content = dic[@"content"];
        
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [content length])];
        self.commentLabel.attributedText = attributedString;

    }else{
        
        content = [NSString stringWithFormat:@"#%@# %@",dic[@"topictitle"],dic[@"content"]];
    
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(0, [[NSString stringWithFormat:@"#%@#",dic[@"topictitle"]] length])];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [content length])];
        
        self.commentLabel.attributedText = attributedString;
        
        CGSize size = [[NSString stringWithFormat:@"#%@#",dic[@"topictitle"]] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        [button addTarget:self action:@selector(topicButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.commentLabel addSubview:button];
    }
    
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [self.commentLabel sizeThatFits:CGSizeMake(WIDTH - 24, 10)];
    
    if (size.height == 0) {
        
        self.backH.constant = 150 - 16 - 12;
        
        self.commentH.constant = 0;
        self.commentTopH.constant = 0;
        
    }else if(size.height > 0 && size.height < 30){
        
        self.backH.constant = 150 - 16;
        
        //一行的时候重新设置行间距
        NSMutableAttributedString *attributedString = [self.commentLabel.attributedText mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:0];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        self.commentLabel.attributedText = attributedString;
        
        self.commentTopH.constant = 12;
        self.commentH.constant = 16;
        
    }else{
        
        self.backH.constant = 150 - 16;
        
        self.commentTopH.constant = 12;
        self.commentH.constant = size.height;
    }
    
    
    if ([dic[@"sypic"] count] == 0) {
        
        _picArray = dic[@"pic"];
        
    }else{
    
        _picArray = dic[@"sypic"];
    }
    
    if (_picView.subviews.count != 0) {
        
        for (UIView *view in _picView.subviews) {
            
            [view removeFromSuperview];
        }
    }
    
    if ([dic[@"pic"] count] != 0) {
        
        self.picTopH.constant = 12;
        
        if ([dic[@"pic"] count] == 1) {
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"pic"][0]]]];
            
            imageV.userInteractionEnabled = YES;
            
            imageV.tag = 0;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            
            [imageV addGestureRecognizer:tap];
            
            [_picView addSubview:imageV];
            
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            
            imageV.clipsToBounds = YES;
            
            self.picH.constant = 240;
            
            self.backH.constant = self.backH.constant + self.picH.constant + self.commentH.constant;
            
            self.backW.constant = WIDTH;
            
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, 2, self.backW.constant, self.backH.constant);
            
        }else if ([dic[@"pic"] count] > 1){
            
            CGFloat imageH = (WIDTH - 24 - 8)/3;
            
            for (int i = 0; i < [dic[@"pic"] count]; i++) {
                
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i%3 * imageH + i%3 * 4, i/3 * imageH + i/3 * 4, imageH, imageH)];
                
                [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"pic"][i]]]];
                
                imageV.contentMode = UIViewContentModeScaleAspectFill;
                
                imageV.clipsToBounds = YES;
                
                imageV.userInteractionEnabled = YES;
                
                imageV.tag = i;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                
                [imageV addGestureRecognizer:tap];

                
                [_picView addSubview:imageV];
                
                if (i == [dic[@"pic"] count] - 1) {
                    
                    self.picH.constant = i/3 * imageH + i/3 * 4 + imageH;
                }
            }
            
            self.backH.constant = self.backH.constant + self.picH.constant + self.commentH.constant;
            
            self.backW.constant = WIDTH;
            
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, 2, self.backW.constant,self.backH.constant);
        }
        
    }else{
        
        self.picH.constant = 0;
        self.picTopH.constant = 0;
        self.backH.constant = self.backH.constant - 12 + self.commentH.constant;
        self.backW.constant = WIDTH;
        self.backView.frame = CGRectMake(self.backView.frame.origin.x, 2, self.backW.constant, self.backH.constant);
        
    }
    
    if ([dic[@"role"] isEqualToString:@"S"]) {
        
        self.sexualLabel.text = @"斯";
        self.sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([dic[@"role"] isEqualToString:@"M"]){
        
        self.sexualLabel.text = @"慕";
        self.sexualLabel.backgroundColor = GIRLECOLOR;
        
    }else if ([dic[@"role"] isEqualToString:@"SM"]){
        
        self.sexualLabel.text = @"双";
        self.sexualLabel.backgroundColor = DOUBLECOLOR;
        
    }else{
    
        self.sexualLabel.text = @"~";
        self.sexualLabel.backgroundColor = GREENCOLORS;
    }
    
    if ([dic[@"sex"] intValue] == 1) {
        
        self.sexLabel.image = [UIImage imageNamed:@"男"];
        self.aSexView.backgroundColor = BOYCOLOR;
        
    }else if ([dic[@"sex"] intValue] == 2){
        
        self.sexLabel.image = [UIImage imageNamed:@"女"];
        self.aSexView.backgroundColor = GIRLECOLOR;
        
    }else{
        
        self.sexLabel.image = [UIImage imageNamed:@"双性"];
        self.aSexView.backgroundColor = DOUBLECOLOR;
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",dic[@"age"]];
    
    if ([dic[@"laudstate"] intValue] == 0) {
        
        self.zanImageView.image = [UIImage imageNamed:@"赞灰"];
        self.zanLabel.textColor = [UIColor lightGrayColor];
        
    }else{
        
        self.zanImageView.image = [UIImage imageNamed:@"赞紫"];
        self.zanLabel.textColor = [UIColor colorWithHexString:@"#c450d6" alpha:1];
    }
    
    _zanNum = dic[@"laudnum"];
    _zanState = dic[@"laudstate"];
    _commentNum = dic[@"comnum"];
    _rewordNum = dic[@"rewardnum"];
    
    [self.zanButton setTitle:[NSString stringWithFormat:@"赞 %@",dic[@"laudnum"]] forState:UIControlStateNormal];
    [self.zanButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"评论 %@",dic[@"comnum"]] forState:UIControlStateNormal];
    [self.commentButton setTitleColor:MainColor forState:UIControlStateNormal];
    
    [self.rewardButton setTitle:[NSString stringWithFormat:@"打赏 %@",dic[@"rewardnum"]] forState:UIControlStateNormal];
    [self.rewardButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    //获取展示的财富值和魅力值
    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andText:dic[@"wealth_val"] andNSLayoutConstraint:_wealthW andType:@"财富"];
    
    [self getWealthAndCharmState:_charmLabel andView:_charmView andText:dic[@"charm_val"] andNSLayoutConstraint:_charmW andType:@"魅力"];
    
    _backView.hidden = NO;
    
    self.tableView.tableHeaderView = self.backView;
    
    [self.tableView.mj_header beginRefreshing];

}

-(void)topicButtonClick{

    if (_tid.length != 0) {
        
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        
        tvc.tid = [NSString stringWithFormat:@"%@",_tid];
        
        [self.navigationController pushViewController:tvc animated:YES];
    }

}

-(void)getWealthAndCharmState:(UILabel *)label andView:(UIView *)backView  andText:(NSString *)text andNSLayoutConstraint:(NSLayoutConstraint *)constraint andType:(NSString *)type{
    
    if ([type isEqualToString:@"财富"]) {
        
        if ([text intValue] == 0) {
            
            self.wealthSpace.constant = 0;
            backView.hidden = YES;
            constraint.constant = 0;
            
        }else{
            
            self.wealthSpace.constant = 5;
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            label.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
        
    }else{
        
        if ([text intValue] == 0) {
            
            backView.hidden = YES;
            
        }else{
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            label.textColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
    }
    
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 2;
    backView.clipsToBounds = YES;
}

-(CGSize)fitLabelWidth:(NSString *)string{
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return labelSize;
    
}


-(void)tap:(UITapGestureRecognizer *)tap{
    
    UIImageView *img = (UIImageView *)tap.view;
    
    __weak typeof(self) weakSelf=self;
    
    [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:img.tag imagesBlock:^NSArray *{
        
        return weakSelf.picArray;
    }];
    
    
}

//切换查看点赞列表
- (IBAction)zanButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _status = @"1";
    
    [self.zanButton setTitle:[NSString stringWithFormat:@"赞 %@",_zanNum] forState:UIControlStateNormal];
    
    [self.zanButton setTitleColor:MainColor forState:UIControlStateNormal];
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"评论 %@",_commentNum] forState:UIControlStateNormal];
    
    [self.commentButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.rewardButton setTitle:[NSString stringWithFormat:@"打赏 %@",_rewordNum] forState:UIControlStateNormal];
    
    [self.rewardButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _page = 0;
    
    [self createData:@"1"];
}

//切换查看评论列表
- (IBAction)commentButtonCllick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _status = @"2";
    
    [self.zanButton setTitle:[NSString stringWithFormat:@"赞 %@",_zanNum] forState:UIControlStateNormal];
    
    [self.zanButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"评论 %@",_commentNum] forState:UIControlStateNormal];
    
    [self.commentButton setTitleColor:MainColor forState:UIControlStateNormal];
    
    [self.rewardButton setTitle:[NSString stringWithFormat:@"打赏 %@",_rewordNum] forState:UIControlStateNormal];
    
    [self.rewardButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _page = 0;
    
    [self createData:@"1"];
}

//切换查看打赏列表
- (IBAction)rewardButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _status = @"3";
    
    [self.zanButton setTitle:[NSString stringWithFormat:@"赞 %@",_zanNum] forState:UIControlStateNormal];
    
    [self.zanButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"评论 %@",_commentNum] forState:UIControlStateNormal];
    
    [self.commentButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.rewardButton setTitle:[NSString stringWithFormat:@"打赏 %@",_rewordNum] forState:UIControlStateNormal];
    
    [self.rewardButton setTitleColor:MainColor forState:UIControlStateNormal];
    
    _page = 0;
    
    [self createData:@"1"];
}
- (IBAction)rewardClick:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == [_ownUid intValue]) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"不能对自己打赏~"];
        
    }else{
        
        _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) :^{
            
            LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
            
            cvc.type = @"0";
            
            [self.navigationController pushViewController:cvc animated:YES];
            
        }];
        
        [_gif getDynamicDid:self.did andIndexPath:nil andSign:@"动态详情" andUIViewController:self];
        
        [self.tabBarController.view addSubview:_gif];

    }

}
//动态详情页点赞
- (IBAction)dianzanButtonClick:(id)sender {
    
    if ([_zanState intValue] == 0) {
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/laudDynamicNewrd"];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
        //    NSLog(@"%@",role);
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
            
            //        NSLog(@"%@",responseObject);
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
                
            }else{
                
                self.zanLabel.textColor = MainColor;
                
                self.zanImageView.image = [UIImage imageNamed:@"赞紫"];
                
                _zanState = @"1";
                
                [self.zanButton setTitle:[NSString stringWithFormat:@"赞 %@",[NSString stringWithFormat:@"%d",[_zanNum intValue] + 1]] forState:UIControlStateNormal];
                
                _zanNum = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%d",[_zanNum intValue] + 1]];
                
                if (_block) {
                    
                    self.block([NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%d",[_zanNum intValue]]],_zanState);
                }
  
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
        }];
        
    }

}

//评论动态
- (IBAction)commentDynamicClick:(id)sender {
    
//    _replyUid = @"";
    
    
    [self.textView becomeFirstResponder];
}

- (IBAction)sendButtonClick:(id)sender {
    
    [self.textView resignFirstResponder];
    
    if (_publishComment.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"根据国家网信部《互联网跟帖评论服务管理规定》要求，需要绑定手机号后才可以发表评论~"    preferredStyle:UIAlertControllerStyleAlert];
        
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
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"暂时不能评论,如有问题请联系客服~"];
            
        }else if ([_publishComment isEqualToString:@"YES"]){
            
            if (self.textView.text.length == 0) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请输入评论内容~"];
                
                
            }else{
                
                AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                
                [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                
                manager.requestSerializer.timeoutInterval = 10.f;
                
                [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                
                NSString *url;
                
                NSDictionary *parameters;
                
                if (_dataArray.count != 0 ) {
                    
                    if (_replyUid.length == 0) {
                        
                        parameters = @{@"content":self.textView.text,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
                        
                    }else{
                        
                        parameters = @{@"content":self.textView.text,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did,@"otheruid":_replyUid};
                    }
                    
                }else{
                    
                    parameters = @{@"content":self.textView.text,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
                }
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/sendCommentNewred"];
                
                [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                    
                    //NSLog(@"%@",responseObject[@"msg"]);
                    
                    if (integer != 2000) {
                        
                        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                        
                    }else{
                        
                        self.textView.text = @"";
                        
                        _replyUid = @"";
                        
                        _introduceLabel.text = @"";
                        
                        _introduceLabel.hidden = YES;
                        
                        _page = 0;
                        
                        [_dataArray removeAllObjects];
                        
                        [self createData:@"1"];
                        
                        [self.commentButton setTitle:[NSString stringWithFormat:@"评论 %@",[NSString stringWithFormat:@"%d",[_commentNum intValue] + 1]] forState:UIControlStateNormal];
                        
                        _commentNum = [NSString stringWithFormat:@"%d",[_commentNum intValue] + 1];
                        
                        if (_commentBlock) {
                            
                            self.commentBlock([NSString stringWithFormat:@"%d",[_commentNum intValue]]);
                        }
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"评论失败,请稍后重试~"];
                    
                }];
            }
        }
     }
    
}
#pragma mark - 监听事件
- (void) keyboardWillChangeFrame:(NSNotification *) note {
    
    // 1.取得弹出后的键盘frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.键盘弹出的耗时时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 3.键盘变化时，view的位移，包括了上移/恢复下移
    CGFloat transformY = keyboardFrame.size.height;
    //    NSLog(@"%f",_transformY);
    
    [UIView animateWithDuration:duration animations:^{
        
        self.sendView.hidden = NO;
        
        self.sendView.transform = CGAffineTransformMakeTranslation(0, -transformY);
    }];
    
}

- (void) keyboardChangeFrame:(NSNotification *) note {
    
    // 1.取得弹出后的键盘frame
    //    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.键盘弹出的耗时时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 3.键盘变化时，view的位移，包括了上移/恢复下移
    //    CGFloat transformY = keyboardFrame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        
        self.sendView.transform = CGAffineTransformMakeTranslation(0,0);
        
        self.sendView.hidden = YES;
    }];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"动态详情打赏成功" object:nil];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    if ([text isEqualToString:@"\n"]) {
        
        self.textView.text = @"";
        
        _replyUid = @"";
        
        _introduceLabel.text = @"";
        
        _introduceLabel.hidden = YES;
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    return YES;
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    if ([_ownUid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction * shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [_shareView controlViewShowAndHide:nil];
            
        }];

        NSString *stick;
        
        if ([_stickstate intValue] == 0) {
            
            stick = @"置顶(vip)";
            
        }else{
        
            stick = @"取消置顶";
        }
        
        UIAlertAction * topAction = [UIAlertAction actionWithTitle:stick style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            
            if ([_stickstate intValue] == 0) {
                
                AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                
                
                NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
                
                NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setStickDynamic"];
                
                [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                    
                    //            NSLog(@"%@",responseObject);
                    
                    if (integer == 4001) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        [self createGoOpenMemberVip:@"动态置顶功能VIP会员可用哦~"];
                        
                    }else if(integer == 2000){
                        
                        hud.labelText = @"置顶成功";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                        self.recommendView.image = [UIImage imageNamed:@"置顶动态图标"];
                        
                        self.recommendView.hidden = NO;
                        
                        _stickstate = @"1";
                        
                    }else{
                        
                        hud.labelText = @"置顶失败";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [hud removeFromSuperview];
                    
                }];
   
            }else{
            
                AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                
                NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
                
                NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setUnStickDynamic"];
                
                [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                    
                    //            NSLog(@"%@",responseObject);
                    
                    if(integer == 2000){
                        
                        hud.labelText = @"取消置顶成功";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                        if ([_recommendstate intValue] == 0) {
                            
                            self.recommendView.hidden = YES;
                            
                        }else{
                            
                            self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                            self.recommendView.hidden = NO;
                        }

                        _stickstate = @"0";
                        
                    }else{
                        
                        hud.labelText = @"取消置顶失败";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [hud removeFromSuperview];
                    
                }];
            }
        }];

        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
            
            //创建黑V推荐置顶
            [self createAdminRecommendAndStick:alert];
            
            //黑V隐藏动态
            [self createAdminHidden:alert];
        }
        
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"编辑(svip)" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue] == 1) {
                
                LDAlertOtherDynamicViewController *dvc = [[LDAlertOtherDynamicViewController alloc] init];
                
                dvc.did = self.did;
                
                [self.navigationController pushViewController:dvc animated:YES];
                
            }else{
                
                [self createGoOpenMemberVip:@"编辑功能限SVIP会员可用~"];
            }
        }];
        
        [alert addAction:alertAction];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [alertAction setValue:MainColor forKey:@"_titleTextColor"];
        }
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
         [alert addAction:cancel];
        
    
        
        [alert addAction:topAction];
        
        [alert addAction:shareAction];
        
        //删除动态
        [self createDeleteDynamic:alert type:@"user"];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [shareAction setValue:MainColor forKey:@"_titleTextColor"];
            
            [topAction setValue:MainColor forKey:@"_titleTextColor"];
            
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
        }

        [self presentViewController:alert animated:YES completion:nil];
        
    }else if([_ownUid intValue] != [[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] intValue]) {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString *reportState;
        
        if ([_reportstate intValue] == 1) {
            
            reportState = @"已举报";
            
        }else{
        
            reportState = @"举报";
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:reportState style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            if ([_reportstate intValue] == 1) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您已举报过该动态,不能再次举报~"];
  
            }else{
            
                LDReportResonViewController *rvc = [[LDReportResonViewController alloc] init];
                
                rvc.type = @"dynamic";
                
                __weak typeof(self) weakself = self;
                
                rvc.block = ^(NSString *reason) {
                   
                    weakself.reportstate = reason;
                    
                };
                
                rvc.did = _did;
                
                [self.navigationController pushViewController:rvc animated:YES];
            }
            
        }];
        
        UIAlertAction * shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [_shareView controlViewShowAndHide:nil];
            
        }];
        
        NSString *collect;
        
        if ([_collectstate intValue] == 0) {
            
            collect = @"收藏";
            
        }else{
            
            collect = @"取消收藏";
        }
        
        UIAlertAction * collectAction = [UIAlertAction actionWithTitle:collect style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url;
            
            NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
            
            if ([_collectstate intValue] == 0) {
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/collectDynamic"];
            }else{
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/cancelCollectDynamic"];
            }

            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                
                if(integer == 2000){
                    
                    if ([_collectstate intValue] == 0) {
                        
                        hud.labelText = @"收藏成功";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                        _collectstate = @"1";
                        
                    }else{
                        
                        hud.labelText = @"取消收藏成功";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                        _collectstate = @"0";
                    }
                    
                }else{
                    
                    if ([_collectstate intValue] == 0) {
                        
                        hud.labelText = @"收藏失败";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                    }else{
                        
                        hud.labelText = @"取消收藏失败";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [hud removeFromSuperview];
            }];
        }];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
            
            //创建黑V推荐置顶
            [self createAdminRecommendAndStick:alert];
            
            //创建删除动态
           // [self createDeleteDynamic:alert type:@"is_admin"];
            
            UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"编辑(svip)" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                LDAlertOtherDynamicViewController *dvc = [[LDAlertOtherDynamicViewController alloc] init];
                
                dvc.did = self.did;
                
                [self.navigationController pushViewController:dvc animated:YES];
                
            }];
            
            if (PHONEVERSION.doubleValue >= 8.3) {
                
                [alertAction setValue:MainColor forKey:@"_titleTextColor"];
            }
            
            [alert addAction:alertAction];
            
            //黑V隐藏动态
            [self createAdminHidden:alert];
            
        }

        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        [alert addAction:cancel];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [action setValue:MainColor forKey:@"_titleTextColor"];
            
            [shareAction setValue:MainColor forKey:@"_titleTextColor"];
            
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
            
            [collectAction setValue:MainColor forKey:@"_titleTextColor"];
        }
        
     
        
        [alert addAction:shareAction];
        
        [alert addAction:collectAction];
        
        [alert addAction:action];
 
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/**
 黑V隐藏动态
 */
- (void)createAdminHidden:(UIAlertController *)alert{
    
    NSString *hidden;
    
    if ([_is_hidden intValue] == 0) {
        
        hidden = @"隐藏动态";
        
    }else{
        
        hidden = @"取消隐藏";
    }
    
    UIAlertAction * hiddenAction = [UIAlertAction actionWithTitle:hidden style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url;
        
        NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
        
        if ([_is_hidden intValue] == 0) {
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/editHiddenState/method/forbid"];
            
        }else{
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/editHiddenState/method/resume"];
        }
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
            
            if(integer == 2000){
                
                if ([_is_hidden intValue] == 0) {
                    
                    hud.labelText = @"隐藏动态成功";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                
                    self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
                    self.recommendView.hidden = NO;
                    _is_hidden = @"1";
                    
                }else{
                    
                    hud.labelText = @"取消隐藏成功";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    
                    if ([_recommendstate intValue] == 0) {
                        
                        self.recommendView.hidden = YES;
                        
                    }else{
                        
                        self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                        self.recommendView.hidden = NO;
                    }
                    
                    _is_hidden = @"0";
                }
                
                
            }else{
                
                if ([_is_hidden intValue] == 0) {
                    
                    hud.labelText = @"隐藏动态失败";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    
                }else{
                    
                    hud.labelText = @"取消隐藏失败";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [hud removeFromSuperview];
            
        }];
    }];
    if (PHONEVERSION.doubleValue >= 8.3) {
        [hiddenAction setValue:MainColor forKey:@"_titleTextColor"];
    }
    [alert addAction:hiddenAction];
}

/**
 删除动态的方法
 */
-(void)createDeleteDynamic:(UIAlertController *)alert type:(NSString *)type{
    
    UIAlertAction * report = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
        
        NSString *url;
        
        if ([type isEqualToString:@"is_admin"]) {
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/delDynamic"];
            
        }else{
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/dynamic/delDynamic"];
        }
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
            
            //NSLog(@"%@",responseObject);
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
                
            }else{
                
                if (_deleteBlock) {
                    
                    self.deleteBlock();
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }];
    
    [alert addAction:report];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        [report setValue:MainColor forKey:@"_titleTextColor"];
    }
}

/**
 判断是否是会员
 */
-(void)createGoOpenMemberVip:(NSString *)title{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];

    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
    
    [alert addAction:cancelAction];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
   创建黑V推荐置顶
 */
-(void)createAdminRecommendAndStick:(UIAlertController *)alert{
    
    UIAlertAction * adminRecommendAction = [UIAlertAction actionWithTitle:@"推荐" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self createAdminRecommendData:@"1"];
        
    }];
    
    [alert addAction:adminRecommendAction];

    
    if([_recommend intValue] > 0){
        
        UIAlertAction * adminCancelRecommendAction = [UIAlertAction actionWithTitle:@"取消推荐" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self createAdminRecommendData:@"2"];
            
        }];
        
        [alert addAction:adminCancelRecommendAction];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [adminCancelRecommendAction setValue:MainColor forKey:@"_titleTextColor"];
        }
    }
    
    UIAlertAction * adminStickAction = [UIAlertAction actionWithTitle:@"置顶" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self createAdminStickData:@"1"];
        
    }];
    
    [alert addAction:adminStickAction];
    
    if ([_recommendall intValue] > 0) {
        
        UIAlertAction * adminCancelStickAction = [UIAlertAction actionWithTitle:@"取消置顶" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self createAdminStickData:@"2"];
            
        }];
        
        [alert addAction:adminCancelStickAction];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [adminCancelStickAction setValue:MainColor forKey:@"_titleTextColor"];
        
        }
    }
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [adminRecommendAction setValue:MainColor forKey:@"_titleTextColor"];
        [adminStickAction setValue:MainColor forKey:@"_titleTextColor"];
    }
}

/**
 黑V推荐的数据请求
 */
-(void)createAdminRecommendData:(NSString *)type{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url;
    
    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
    
    if ([type intValue] == 1){
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setDynamicRerommend/method/0"];
        
    }else{
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/cancelDynamicRerommend/method/0"];
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //            NSLog(@"%@",responseObject);
        
        if(integer == 2000){
            
            if ([type intValue] == 1) {
                
                hud.labelText = @"推荐成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                _recommend = @"1";
                
            }else{
                
                hud.labelText = @"取消推荐成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                _recommend = @"0";
            }
            
        }else{
            
            if ([type intValue] == 1) {
                
                hud.labelText = @"推荐失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
            }else{
                
                hud.labelText = @"取消推荐失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 黑V置顶的数据请求
 */
-(void)createAdminStickData:(NSString *)type{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url;
    
    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
    
    if ([type intValue] == 1) {
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setDynamicRerommend/method/1"];
        
    }else{
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/cancelDynamicRerommend/method/1"];
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //            NSLog(@"%@",responseObject);
        
        if(integer == 2000){
            
            if ([type intValue] == 1) {
                
                hud.labelText = @"置顶成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                _recommendall = @"1";
                
            }else{
                
                hud.labelText = @"取消置顶成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                _recommendall = @"0";
            }
            
        }else{
            
            if ([type intValue] == 1) {
                
                hud.labelText = @"置顶失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
            }else{
                
                hud.labelText = @"取消置顶失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}



- (IBAction)imageButtonClick:(id)sender {
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    ivc.userID = _ownUid;
    
    [self.navigationController pushViewController:ivc animated:YES];
}

//点击commentLabel收回键盘
- (IBAction)tapCommentClick:(id)sender {
    
    [self.textView resignFirstResponder];
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
