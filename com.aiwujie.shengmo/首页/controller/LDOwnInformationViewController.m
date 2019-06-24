//
//  LDOwnInformationViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/27.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDOwnInformationViewController.h"
#import "LDBindingPhoneNumViewController.h"
#import "LDAttentionListViewController.h"
#import "LDEditViewController.h"
#import "LDAttentOtherViewController.h"
#import "PersonChatViewController.h"
#import "LDGroupNumberViewController.h"
#import "LDGroupSpuareViewController.h"
#import "LDBulletinViewController.h"
#import "LDPublishDynamicViewController.h"
#import "LDReportViewController.h"
#import "RecordViewController.h"
#import "LDCertificateViewController.h"
#import "LDCertificateBeforeViewController.h"
#import "LDMemberViewController.h"
#import "LDShengMoViewController.h"
#import "LDMemberViewController.h"
#import "LDStampViewController.h"
#import "LDMyWalletPageViewController.h"
#import "LDEditViewController.h"
#import "LDStampChatView.h"
#import "LDShareView.h"
#import "GifView.h"
#import "LDownInfoDynamicViewController.h"
#import "LDOwnInfoDynamicCommentViewController.h"
#import "LDChargeCenterViewController.h"
#import "LDLookGifListViewController.h"
#import <Accelerate/Accelerate.h>
#import "UIButton+ImageTitleSpace.h"
#import "SSCopyLabel.h"
#import "LDhistorynameViewController.h"
#import "LDAlertNameandIntroduceViewController.h"

@interface LDOwnInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,StampChatDelete,YBAttributeTapActionDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) AVPlayer *audioPlayer;//音频播放器，用于播放录音文件

//保存tableview的偏移量
@property (nonatomic,assign) CGFloat lastScrollOffset;

//获取头像下vip标识的状态
@property (nonatomic,copy) NSString *vipTypeString;

@property (nonatomic,copy) NSString *lock;
@property (nonatomic,strong) UIView *backgroundView;

//个人主页的tableView头视图
@property (weak, nonatomic) IBOutlet UIView *headBackView;

//头像的url
@property (nonatomic,copy) NSString *headUrl;

//是会员查看时间
@property (nonatomic,copy) NSString  *lastTime;

//个人主页的tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopY;

//个人主页上方背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backGroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backGroundViewH;

//个人主页上方的透明遮挡
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backAlhpaH;

//个人主页的录音按钮
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

//个人主页播放按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playButtonY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playButtonX;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

//个人主页的时间展示label
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondW;

//上方图片展示的信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageButtonX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageButtonY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageButtonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageButtonH;

//个人主页姓名
@property (weak, nonatomic) IBOutlet SSCopyLabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameX;

//个人主页的认证状态
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idviewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idViewY;

//个人主页在线状态
@property (weak, nonatomic) IBOutlet UIView *onlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onlineViewY;

//个人主页VIP图片
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipViewY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipButtonX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipButtonY;

//个人主页展示姓名性别的View
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewY;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
//个人主页的性取向
@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;

//个人主页查看时间的按钮
@property (weak, nonatomic) IBOutlet UIButton *lookTimeButton;

//个人主页的登录时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeViewY;
@property (weak, nonatomic) IBOutlet UIView *timeView;

//个人主页的位置信息
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationW;
@property (weak, nonatomic) IBOutlet UIView *locationView;

//个人主页的城市信息
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityW;

//个人主页展示关注，粉丝，群组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentionViewH;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fansViewH;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UIButton *fansButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupViewH;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupButton;

//个人主页展示照片
@property (weak, nonatomic) IBOutlet UIView *picBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picH;
@property (strong, nonatomic)  UIScrollView *scrollView;

//个人主页展示个人介绍
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceTopLineH;
@property (weak, nonatomic) IBOutlet UILabel *introduceTopLineLabel;

//个人主页的个人资料填写
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *psexualLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *experenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *wantLabel;
@property (weak, nonatomic) IBOutlet UILabel *cultureLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

//存储个人相册的图片
@property (nonatomic,strong) NSArray *picArray;

//下方按钮

//赠送给某人礼物
@property (weak, nonatomic) IBOutlet UIButton *giveGifButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giveGifW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giveGifH;

//关注
@property (weak, nonatomic) IBOutlet UIButton *attentButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentH;

//聊天
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatH;

//发布动态
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishH;

//是否可以发布动态
@property (nonatomic,copy) NSString *publishComment;

//是否关注对方
@property (nonatomic,assign) BOOL attentStatus;

//好友状态
@property (nonatomic,copy) NSString *followState;

//可疑用户状态
@property (nonatomic,copy) NSString *is_likeliar;

//可疑用户上方展示的view
@property (nonatomic,strong) UIView *likeliarView;

//管理员备足展示view
@property (nonatomic,strong) UIView *adminnoteView;

@property (nonatomic,strong) UIButton * shareButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UITextField *passwordField;

@property (nonatomic,copy) NSString *blackState;

@property (nonatomic,copy) NSString *url;

//认证照片的展示按钮
@property (weak, nonatomic) IBOutlet UIButton *picPublicButton;

//认证照片的展示状态
@property (nonatomic,copy) NSString *realpicstate;

//录音的路径
@property (nonatomic,copy) NSString *mediaStrng;

//添加个性签名button
@property (nonatomic,strong) UIButton *addSignButton;

//访客显示
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateShowLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateY;

//标签显示的颜色
@property (nonatomic,strong) UIColor *signColor;

//动态的相关数目显示
@property (weak, nonatomic) IBOutlet UIView *totalNumView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalNumH;
@property (weak, nonatomic) IBOutlet UILabel *dynamicNumLabel;

//动态评论数的显示
@property (weak, nonatomic) IBOutlet UIView *dynamicCommentNumView;
@property (weak, nonatomic) IBOutlet UILabel *dynamicCommentNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicCommentNumH;

//提示语的展示
@property (weak, nonatomic) IBOutlet UILabel *introduceWarnLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceWarnH;

//添加财富和魅力值的显示
@property (weak, nonatomic) IBOutlet UIView *wealthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthSpace;
@property (weak, nonatomic) IBOutlet UILabel *wealthLabel;
@property (weak, nonatomic) IBOutlet UIView *charmView;
@property (weak, nonatomic) IBOutlet UILabel *charmLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charmW;

//分享视图
@property (nonatomic,strong) LDShareView *shareView;

//礼物界面
@property (nonatomic,strong) GifView *gif;

//聊天邮票界面
@property (nonatomic,strong) LDStampChatView *stampView;

//我的礼物
@property (weak, nonatomic) IBOutlet UIView *gifView;
@property (weak, nonatomic) IBOutlet UILabel *gifNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gifNumW;

//个人主页拉黑
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UILabel *blackLabel;

@property (nonatomic,strong) UIButton *blackButton;

//记录状态
@property (nonatomic,assign) BOOL isRecord;

//图片是否可见
@property (nonatomic,assign) BOOL islockPhoto;

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;


//权限限制 0 默认不做限制 1 做限制
@property (nonatomic,copy) NSString *photo_rule;
@property (nonatomic,copy) NSString *dynamic_rule;
@property (nonatomic,copy) NSString *comment_rule;


//修改资料判断是否是admin用户修改
@property (nonatomic,assign) BOOL isAdminchange;

//备注
@property (nonatomic,copy) NSString *markname;
//管理员备注
@property (nonatomic,copy) NSString *admin_mark;

@property (nonatomic,strong) UILabel *oldnameLab;
@end

@implementation LDOwnInformationViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        //获取判断是否可以发布动态的状态
        [self createPublishCommentData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人主页";
    self.view.backgroundColor = [UIColor whiteColor];
    if (ISIPHONEPLUS) {
        
        self.giveGifW.constant = (self.giveGifButton.frame.size.width / 375) * WIDTH;
        self.giveGifH.constant = (self.giveGifButton.frame.size.height / 667) * HEIGHT;
        
        self.chatW.constant = (self.chatButton.frame.size.width / 375) * WIDTH;
        self.chatH.constant = (self.chatButton.frame.size.height / 667) * HEIGHT;
        
        self.attentW.constant = (self.attentButton.frame.size.width / 375) * WIDTH;
        self.attentH.constant = (self.attentButton.frame.size.height / 667) * HEIGHT;
        
        self.publishW.constant = (self.publishButton.frame.size.width / 375) * WIDTH;
        self.publishH.constant = (self.publishButton.frame.size.height / 667) * HEIGHT;
        
        //背景的高度改变
        self.backAlhpaH.constant = 300;
        self.backGroundViewH.constant = 300;
        
        //头像的x,y的改变
        self.headImageViewX.constant = 26;
        self.headImageViewY.constant = 35;
        self.headImageViewH.constant = 100;
        self.headImageViewW.constant = 100;
        self.headImageView.layer.cornerRadius = 50;
        self.headImageView.clipsToBounds = YES;
        
        self.headImageButtonX.constant = 26;
        self.headImageButtonY.constant = 35;
        self.headImageButtonH.constant = 100;
        self.headImageButtonW.constant = 100;
        
        //vip的x,y的改变
        self.vipViewX.constant = 98;
        self.vipViewY.constant = 112;
        self.vipButtonX.constant = 97;
        self.vipButtonY.constant = 104;
        self.vipViewH.constant = 25;
        self.vipViewW.constant = 25;
        
        //姓名的x,y的改变
        self.nameX.constant = 27;
        self.nameY.constant = 40;
        
        //认证的y的改变
        self.idViewY.constant = 44;
        
        //在线的y的改变
        self.onlineViewY.constant = 47;
        
        //姓名性别x,y的改变
        self.backViewX.constant = 27;
        self.backViewY.constant = 26;
        
        //录音相关x,y的改变
        self.playButtonX.constant = 27;
        self.playButtonY.constant = 26;
        
        //显示登录时间的x的改变
        self.timeViewX.constant = 48;
        self.timeViewY.constant = 26;
        self.dateX.constant = 48;
        self.dateY.constant = 26;
        
        //关注,粉丝,群组的高度改变
        self.attentionViewH.constant = 60;
        self.fansViewH.constant = 60;
        self.groupViewH.constant = 60;
        
        
    }else{
        
        self.headImageView.layer.cornerRadius = 40;
        self.headImageView.clipsToBounds = YES;
    }
    

    
    self.backView.layer.cornerRadius = 2;
    self.backView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.onlineView.layer.cornerRadius = 4;
    self.onlineView.clipsToBounds = YES;
    
    self.timeView.layer.cornerRadius = 2;
    self.timeView.clipsToBounds = YES;
    
    self.locationView.layer.cornerRadius = 2;
    self.locationView.clipsToBounds = YES;
    
    self.cityView.layer.cornerRadius = 2;
    self.cityView.clipsToBounds = YES;
    [self createRightButton];
    _dataArray = [[NSMutableArray alloc] init];
    _picArray = [NSArray array];
    _isRecord = NO;
    [self creageoldnameLab];
    [self createTableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self createOwnInformationData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.lastScrollOffset = 0;
    
    //监听修改了个人资料
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertOwnInformation) name:@"修改了个人资料" object:nil];

    //监听绑定手机号成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindPhoneNumSuccess) name:@"绑定手机号码成功" object:nil];
    
    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headBackView addSubview:timeBtn];
    [timeBtn setImage:[UIImage imageNamed:@"历史昵称"] forState:normal];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onlineView.mas_right).with.offset(4);
        make.centerY.equalTo(self.onlineView);
        make.width.mas_offset(13);
        make.height.mas_offset(13);
    }];
    [timeBtn addTarget:self action:@selector(timeBtnclick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)creageoldnameLab
{
    self.oldnameLab = [UILabel new];
    [self.headBackView addSubview:self.oldnameLab];
    self.oldnameLab.backgroundColor = [UIColor clearColor];
    self.oldnameLab.textColor = TextCOLOR;
    self.oldnameLab.font = [UIFont systemFontOfSize:14];
    [self.oldnameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(6);
        make.height.mas_offset(18);
        make.width.mas_offset(150);
    }];
}

-(void)timeBtnclick
{
    NSString *newUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue] == 1||[self.userID  isEqualToString:newUid]) {
        LDhistorynameViewController *VC = [LDhistorynameViewController new];
        VC.uid = self.userID;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"查看历史昵称限SVIP可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            
            [self.navigationController pushViewController:mvc animated:YES];
            
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:nil];
    }
}

/**
 * 绑定手机号码成功的监听方法
 */

-(void)bindPhoneNumSuccess{
    
    _publishComment = @"YES";
}

//修改了个人资料后得到监听修改资料
-(void)alertOwnInformation{

    [self createOwnInformationData];
}


//移除通知
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                
                if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                    
                    _publishButton.hidden = YES;
                    
                }else{
                    
                    self.chatButton.hidden = YES;
                    
                    self.attentButton.hidden = YES;
                    
                    self.giveGifButton.hidden = YES;
                }
                
            } else if(y < self.lastScrollOffset){
                //用户往下拖动，也就是屏幕内容向上滚动
                
                if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                    
                    _publishButton.hidden = NO;
                    
                }else{
                    
                    self.chatButton.hidden = NO;
                    
                    self.attentButton.hidden = NO;
                    
                    self.giveGifButton.hidden = NO;
                }
            }
            
        }
    }
}

-(void)createTableView{
    if (ISIPHONEX) {
        self.tableViewBottomY.constant = 34;
    }else{
        self.tableViewBottomY.constant = 0;
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (IBAction)attentionButtonClick:(id)sender {
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        LDAttentionListViewController *avc = [[LDAttentionListViewController alloc] init];
        
        avc.type = @"0";
        
        avc.userID = self.userID;
        
        [self.navigationController pushViewController:avc animated:YES];
        
    }else if ([self.userID intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]){
    
        LDAttentOtherViewController *ovc = [[LDAttentOtherViewController alloc] init];
        
        ovc.type = @"0";
        
        ovc.userID = self.userID;
        
        [self.navigationController pushViewController:ovc animated:YES];
    }
    
    
}

- (IBAction)fansButtonClick:(id)sender {
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        LDAttentionListViewController *avc = [[LDAttentionListViewController alloc] init];
        avc.type = @"1";
        avc.userID = self.userID;
        [self.navigationController pushViewController:avc animated:YES];
    }else if ([self.userID intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]){
        LDAttentOtherViewController *ovc = [[LDAttentOtherViewController alloc] init];
        ovc.type = @"1";
        ovc.userID = self.userID;
        [self.navigationController pushViewController:ovc animated:YES];
    }
}

/**
 * 获取判断是否可以发布动态的状态
 */

-(void)createPublishCommentData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/judgeDynamicNewrd"];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer == 4003  || integer == 4004) {
            _publishComment = [NSString stringWithFormat:@"%@",[responseObj objectForKey:@"retcode"]];
        }else  if(integer == 2000){
            _publishComment = @"YES";
            
        }else if(integer == 3001){
            _publishComment = @"";
        }
    } failed:^(NSString *errorMsg) {
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
        
        if ([_publishComment intValue] == 4003) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您好,您因违规暂时不能发布动态,具体解封时间请查看系统通知或与客服联系~"];
            
        }else if ([_publishComment intValue] == 4004) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您好,普通用户每日发布动态限10条,VIP会员每日发布动态限30条~"];
            
        }else if ([_publishComment isEqualToString:@"YES"]){
          
            LDPublishDynamicViewController *dvc = [[LDPublishDynamicViewController alloc] init];
            
            [self.navigationController pushViewController:dvc animated:YES];

        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请退出软件后重试~"];
        }
    }

}

#pragma mark - RightBtn

-(void)createRightButton{
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_shareButton setImage:[UIImage imageNamed:@"编辑个人资料"] forState:UIControlStateNormal];
        self.isAdminchange = NO;
        [_shareButton addTarget:self action:@selector(shareButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButton];

        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonShareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
        
        self.navigationItem.rightBarButtonItems = @[rightBarButtonItem,shareButtonItem];
        
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
            
            _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [_shareButton setImage:[UIImage imageNamed:@"编辑个人资料"] forState:UIControlStateNormal];
            self.isAdminchange = YES;
            [_shareButton addTarget:self action:@selector(shareButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButton];
            
            _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [_rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
            [_rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
            
            self.navigationItem.rightBarButtonItems = @[rightBarButtonItem,shareButtonItem];
            
          
        }else{
        
            _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [_rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
            [_rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
            
            self.navigationItem.rightBarButtonItems = @[rightBarButtonItem];
        }
    }
}

//修改资料
-(void)shareButtonOnClick{
    LDEditViewController *evc = [[LDEditViewController alloc] init];
    
    if (self.isAdminchange) {
        evc.InActionType = ENUM_FROMADMIN_ActionType;
    }
    else
    {
        evc.InActionType = ENUM_FROMUSER_ActionType;
    }
    evc.userID = self.userID;
    [self.navigationController pushViewController:evc animated:YES];
}

//进入个人主页时创建的分享按钮
-(void)rightButtonShareButtonClick{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *shareButton = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [_shareView controlViewShowAndHide:nil];
        
    }];
    
    UIAlertAction *nicknameButton = [UIAlertAction actionWithTitle:@"历史昵称" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LDhistorynameViewController *VC = [LDhistorynameViewController new];
        VC.uid = self.userID;
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
    UIAlertAction *noteAction = [UIAlertAction actionWithTitle:@"设置备注(好友/vip)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self.followState isEqualToString:@"3"]||[[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1) {
            //设置备注
            LDAlertNameandIntroduceViewController *VC = [LDAlertNameandIntroduceViewController new];
            VC.type = @"3";
            VC.content = self.markname;
            VC.block = ^(NSString *content) {
                NSString *url = [PICHEADURL stringByAppendingString:markName];
                NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
                NSString *fuid = self.userID;
                NSString *markname = content;
                NSDictionary *para = @{@"uid":uid?:@"",@"fuid":fuid?:@"",@"markname":markname?:@""};
                [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                    if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                        [MBProgressHUD showSuccess:@"备注成功"];
                        [self.tableView.mj_header beginRefreshing];
                    }
                } failed:^(NSString *errorMsg) {
                    
                }];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"仅限好友/VIP可用"    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * addFriendAction = [UIAlertAction actionWithTitle:@"加好友" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                [self attentButtonClickState:_attentStatus];
            }];
            UIAlertAction * vipAction = [UIAlertAction actionWithTitle:@"开通VIP" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
            }];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
            if (PHONEVERSION.doubleValue >= 8.3) {
                [action setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
                [vipAction setValue:MainColor forKey:@"_titleTextColor"];
                [addFriendAction setValue:MainColor forKey:@"_titleTextColor"];
            }
            [alert addAction:action];
            [alert addAction:addFriendAction];
            [alert addAction:vipAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
 
        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [shareButton setValue:MainColor forKey:@"_titleTextColor"];
        [nicknameButton setValue:MainColor forKey:@"_titleTextColor"];
        [noteAction setValue:MainColor forKey:@"_titleTextColor"];
        [cancel setValue:MainColor forKey:@"_titleTextColor"];
    }
    [alert addAction:cancel];
    
    [alert addAction:shareButton];
    
    [alert addAction:nicknameButton];
    if ([self.userID intValue]!=[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        [alert addAction:noteAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - //其他，拉黑等功能

//其他，拉黑等功能
-(void)rightButtonOnClick{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *blackTitle;
    
    if ([_blackState intValue] == 1) {
        
        blackTitle = @"取消拉黑";

    }else{
        
        blackTitle = @"拉黑";
    }
    
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:blackTitle style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self blackButtonClick];
        
    }];
    
    UIAlertAction * report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self reportButtonClick];
        
    }];
    
    UIAlertAction * shareButton = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [_shareView controlViewShowAndHide:nil];
        
    }];
    
    UIAlertAction *nicknameButton = [UIAlertAction actionWithTitle:@"历史昵称" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue] == 1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == [self.userID intValue]) {
            LDhistorynameViewController *VC = [LDhistorynameViewController new];
            VC.uid = self.userID;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"查看历史昵称限SVIP可用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                
                [self.navigationController pushViewController:mvc animated:YES];
                
            }];
            [control addAction:action0];
            [control addAction:action1];
            [self presentViewController:control animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *noteAction = [UIAlertAction actionWithTitle:@"设置备注(好友/vip)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //设置备注
        if ([self.followState isEqualToString:@"3"]||[[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1) {
            //设置备注
            LDAlertNameandIntroduceViewController *VC = [LDAlertNameandIntroduceViewController new];
            VC.type = @"3";
            VC.content = self.markname;
            VC.block = ^(NSString *content) {
                NSString *url = [PICHEADURL stringByAppendingString:markName];
                NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
                NSString *fuid = self.userID;
                NSString *markname = content;
                NSDictionary *para = @{@"uid":uid?:@"",@"fuid":fuid?:@"",@"markname":markname?:@""};
                [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                    if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                        [MBProgressHUD showSuccess:@"备注成功"];
                        [self.tableView.mj_header beginRefreshing];
                    }
                } failed:^(NSString *errorMsg) {
                    
                }];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"仅限好友/VIP可用"    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * addFriendAction = [UIAlertAction actionWithTitle:@"加好友" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                [self attentButtonClickState:_attentStatus];
            }];
            UIAlertAction * vipAction = [UIAlertAction actionWithTitle:@"开通VIP" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
            }];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
            if (PHONEVERSION.doubleValue >= 8.3) {
                [action setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
                [vipAction setValue:MainColor forKey:@"_titleTextColor"];
                [addFriendAction setValue:MainColor forKey:@"_titleTextColor"];
            }
            [alert addAction:action];
            [alert addAction:addFriendAction];
            [alert addAction:vipAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    
    UIAlertAction *adminnoteAction = [UIAlertAction actionWithTitle:@"管理备注" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // admin设置备注
        LDAlertNameandIntroduceViewController *VC = [LDAlertNameandIntroduceViewController new];
        VC.type = @"4";
        VC.content = self.admin_mark;
        VC.block = ^(NSString *content) {
            NSString *url = [PICHEADURL stringByAppendingString:editAdminmrak];
            NSString *uid = self.userID;
            NSString *loginid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSString *contents = content;
            NSDictionary *para = @{@"uid":uid?:@"",@"loginid":loginid?:@"",@"content":contents?:@""};
            [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    [MBProgressHUD showSuccess:@"备注成功"];
                    [self.tableView.mj_header beginRefreshing];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    [alert addAction:cancel];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
        
        UIAlertAction *titleAction = [UIAlertAction actionWithTitle:@"永久封号" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/getAllUserStatus"];
            
            NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (integer == 2000) {
                    
                    if ([responseObject[@"data"][@"status"] intValue] == 1) {
                        
                        [self unenableUse:@"1" andBlockingAlong:@"0"];
                        
                    }else{
                        
                        [self enableUse:@"1"];
                    }
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功~"];
                    
                }else{
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败~"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
            
        }];
        
        NSString *likeliar;
        
        if ([_is_likeliar intValue] == 0) {
            
            likeliar = @"可疑用户";
            
        }else{
            
            likeliar = @"取消可疑用户";
        }
        
        //Suspicious user
        UIAlertAction *SuspiciousUserAction = [UIAlertAction actionWithTitle:likeliar style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url;
            
            if ([_is_likeliar intValue] == 0) {
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setLikeLiarState/method/setone"];
                
            }else{
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setLikeLiarState/method/removeone"];
            }
            
            NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败"];
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    if ([_is_likeliar intValue] == 0) {
                        
                        _is_likeliar = @"1";
                        
                    }else{
                        
                        _is_likeliar = @"0";
                    }
                    
                    [self.tableView.mj_header beginRefreshing];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
        }];
        
        UIAlertAction *delHeadAction = [UIAlertAction actionWithTitle:@"违规头像" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteWeiGuiUser:@"1"];
        }];
        
        UIAlertAction *delNickNameAction = [UIAlertAction actionWithTitle:@"违规昵称" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteWeiGuiUser:@"2"];
        }];
        
        UIAlertAction *delSignAction = [UIAlertAction actionWithTitle:@"违规签名" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteWeiGuiUser:@"3"];
        }];
        
        UIAlertAction *delPicAction = [UIAlertAction actionWithTitle:@"违规相册" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteWeiGuiUser:@"4"];
        }];
        
        UIAlertAction *titleDynamicAction = [UIAlertAction actionWithTitle:@"★ 管理员权限" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/getAllUserStatus"];
            
            NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];

                if (integer == 2000) {
                    
                    [self createAdminOperationlertAction:responseObject[@"data"]];
                    
                }else{
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"获取失败~"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
            
        }];
        
     
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [titleAction setValue:MainColor forKey:@"_titleTextColor"];
            [SuspiciousUserAction setValue:MainColor forKey:@"_titleTextColor"];
            [delHeadAction setValue:MainColor forKey:@"_titleTextColor"];
            [delNickNameAction setValue:MainColor forKey:@"_titleTextColor"];
            [delSignAction setValue:MainColor forKey:@"_titleTextColor"];
            [delPicAction setValue:MainColor forKey:@"_titleTextColor"];
            [titleDynamicAction setValue:MainColor forKey:@"_titleTextColor"];
           
        }
        
        [alert addAction:titleAction];
        [alert addAction:SuspiciousUserAction];
        [alert addAction:delHeadAction];
        [alert addAction:delPicAction];
        [alert addAction:delNickNameAction];
        [alert addAction:delSignAction];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue]==1) {
            [alert addAction:adminnoteAction];
        }
        [alert addAction:titleDynamicAction];
    }
    if (PHONEVERSION.doubleValue >= 8.3) {
        [action setValue:MainColor forKey:@"_titleTextColor"];
        [report setValue:MainColor forKey:@"_titleTextColor"];
        [shareButton setValue:MainColor forKey:@"_titleTextColor"];
        [nicknameButton setValue:MainColor forKey:@"_titleTextColor"];
        [noteAction setValue:MainColor forKey:@"_titleTextColor"];
        [adminnoteAction setValue:MainColor forKey:@"_titleTextColor"];
        [cancel setValue:MainColor forKey:@"_titleTextColor"];
    }
    [alert addAction:shareButton];
    [alert addAction:nicknameButton];
    if ([self.userID intValue]!=[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        [alert addAction:noteAction];
    }
    [alert addAction:report];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 * 创建黑V的操作按钮
 */
-(void)createAdminOperationlertAction:(NSDictionary *)dic{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *titleAccount;
    
    if ([dic[@"status"] intValue] == 1) {
        
        titleAccount = @"封禁账号";
        
    }else{
        
        titleAccount = @"启用账号";
    }
    
    UIAlertAction *titleAccountAction = [UIAlertAction actionWithTitle:titleAccount style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([dic[@"status"] intValue] == 1) {
            
             [self setStopTime:@"1"];
            
        }else{
            
            [self enableUse:@"1"];
        }
    }];
    
    NSString *titleDynamic;
    
    if ([dic[@"dynamicstatus"] intValue] == 1) {
        
        titleDynamic = @"封禁动态";
        
    }else{
        
        titleDynamic = @"启用动态";
    }
    
    UIAlertAction *titleDynamicAction = [UIAlertAction actionWithTitle:titleDynamic style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([dic[@"dynamicstatus"] intValue] == 1) {
            
            [self setStopTime:@"2"];
            
        }else{
            
            [self enableUse:@"2"];
        }
    }];
    
    NSString *titleMessage;
    
    if ([dic[@"chatstatus"] intValue] == 1) {
        
        titleMessage = @"封禁消息";
        
    }else{
        
        titleMessage = @"启用消息";
    }
    
    UIAlertAction *titleMessageAction = [UIAlertAction actionWithTitle:titleMessage style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([dic[@"chatstatus"] intValue] == 1) {
           
            [self setStopTime:@"4"];
            
        }else{
            
            [self enableUse:@"4"];
        }
        
    }];
    
    NSString *titleInfo;
    
    if ([dic[@"infostatus"] intValue] == 1) {
        
        titleInfo = @"封禁资料";
        
    }else{
        
        titleInfo = @"启用资料";
    }
    
    UIAlertAction *titleInfomationAction = [UIAlertAction actionWithTitle:titleInfo style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([dic[@"infostatus"] intValue] == 1) {
            
            [self setStopTime:@"3"];
            
        }else{
            
            [self enableUse:@"3"];
        }
        
    }];
    
    NSString *titleDevice;
    
    if ([dic[@"devicestatus"] intValue] == 1) {
        
        titleDevice = @"封禁设备";
        
    }else{
        
        titleDevice = @"启用设备";
    }
    
    UIAlertAction *titleDeviceAction = [UIAlertAction actionWithTitle:titleDevice style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url;
        
        if ([dic[@"devicestatus"] intValue] == 1) {
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/changeDeviceStatus/method/forbid"];
            
        }else{
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/changeDeviceStatus/method/resume"];
            
        }
        
        NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            

            if (integer != 2000) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败"];
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
       
    }];
    
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    
    [alert addAction:cancel];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
         [titleAccountAction setValue:MainColor forKey:@"_titleTextColor"];
        [titleDynamicAction setValue:MainColor forKey:@"_titleTextColor"];
        [titleMessageAction setValue:MainColor forKey:@"_titleTextColor"];
        [titleInfomationAction setValue:MainColor forKey:@"_titleTextColor"];
        [titleDeviceAction setValue:MainColor forKey:@"_titleTextColor"];
        [cancel setValue:MainColor forKey:@"_titleTextColor"];
    }
    [alert addAction:titleAccountAction];
    [alert addAction:titleDynamicAction];
    [alert addAction:titleMessageAction];
    [alert addAction:titleInfomationAction];
    [alert addAction:titleDeviceAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 * 封禁时间的弹框提示
 */

-(void)setStopTime:(NSString *)type{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *titleOneDayAction = [UIAlertAction actionWithTitle:@"1天" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"1"];
        
    }];
    
    UIAlertAction *titleTwoDayAction = [UIAlertAction actionWithTitle:@"3天" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"3"];
        
    }];
    
    UIAlertAction *titleOneWeekAction = [UIAlertAction actionWithTitle:@"1周" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"7"];
        
    }];
    
    UIAlertAction *titleTwoWeekAction = [UIAlertAction actionWithTitle:@"2周" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"14"];
        
    }];
    
    UIAlertAction *titleOneMonthAction = [UIAlertAction actionWithTitle:@"1月" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"30"];
        
    }];
    
    UIAlertAction *titleForeverAction = [UIAlertAction actionWithTitle:@"永久" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"0"];
        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    
    [alert addAction:cancel];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [titleOneDayAction setValue:MainColor forKey:@"_titleTextColor"];
        [titleTwoDayAction setValue:MainColor forKey:@"_titleTextColor"];
        [titleOneWeekAction setValue:MainColor forKey:@"_titleTextColor"];
        [titleTwoWeekAction setValue:MainColor forKey:@"_titleTextColor"];
        [titleOneMonthAction setValue:MainColor forKey:@"_titleTextColor"];
        [titleForeverAction setValue:MainColor forKey:@"_titleTextColor"];
        [cancel setValue:MainColor forKey:@"_titleTextColor"];
    }
    [alert addAction:titleOneDayAction];
    [alert addAction:titleTwoDayAction];
    [alert addAction:titleOneWeekAction];
    [alert addAction:titleTwoWeekAction];
    [alert addAction:titleOneMonthAction];
    [alert addAction:titleForeverAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 * 封禁的用户相应的权限
 */

-(void)unenableUse:(NSString *)type andBlockingAlong:(NSString *)blockingalong{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Api/Power/changeAllUserStatus/method/",type];
    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID,@"blockingalong":blockingalong};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败"];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功"];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 * 启用封禁的用户相应的权限
 */

-(void)enableUse:(NSString *)type{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Api/Power/recoverAllUserStatus/method/",type];
    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败"];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功"];
        }
    } failed:^(NSString *errorMsg) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 * 删除违规的头像,昵称,签名,相册
 */
-(void)deleteWeiGuiUser:(NSString *)type{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Api/Power/delIllegallyUserInfo/type/",type];
    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败"];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功"];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark - 获取个人资料信息

/**
 * 获取个人资料信息
 */
-(void)createOwnInformationData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getUserInfo"];
    NSDictionary *parameters;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        parameters = @{@"uid":self.userID?:@"",@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }else{
        parameters = @{@"uid":self.userID?:@"",@"lat":@"",@"lng":@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        self.photo_rule = [responseObj objectForKey:@"data"][@"photo_rule"];
        self.dynamic_rule = [responseObj objectForKey:@"data"][@"dynamic_rule"];
        self.comment_rule = [responseObj objectForKey:@"data"][@"comment_rule"];
        self.markname = @"";
        self.admin_mark = @"";
        if (integer == 2001) {
            
            self.tableView.scrollEnabled = NO;
            self.blackView.hidden = NO;
            self.blackLabel.layer.cornerRadius = 16;
            self.blackLabel.clipsToBounds = YES;
            self.markname = responseObj[@"data"][@"markname"]?:@"";
            self.admin_mark = responseObj[@"data"][@"admin_mark"]?:@"";
            [self showBasicData:responseObj[@"data"] andIsShow:YES];
            _headBackView.hidden = NO;
            [self.tableView.mj_header endRefreshing];
            UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backGroundViewH.constant, WIDTH, HEIGHT - self.backGroundViewH.constant)];
            showView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            [self.headBackView addSubview:showView];
            
            UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(20 * WIDTHRADIO, 20 * WIDTHRADIO, WIDTH - 2 * (20 * WIDTHRADIO), 40 * WIDTHRADIO)];
            reportButton.backgroundColor = [UIColor whiteColor];
            [reportButton addTarget:self action:@selector(reportButtonClick) forControlEvents:UIControlEventTouchUpInside];
            reportButton.layer.cornerRadius = reportButton.frame.size.height/2;
            reportButton.clipsToBounds = YES;
            [reportButton setTitle:@"举报" forState:UIControlStateNormal];
            [reportButton setTitleColor:MainColor forState:UIControlStateNormal];
            [showView addSubview:reportButton];
            
            _blackButton = [[UIButton alloc] initWithFrame:CGRectMake(20 * WIDTHRADIO, CGRectGetMaxY(reportButton.frame) + 20 * WIDTHRADIO, WIDTH - 2 * (20 * WIDTHRADIO), 40 * WIDTHRADIO)];
            _blackButton.backgroundColor = [UIColor whiteColor];
            [_blackButton addTarget:self action:@selector(blackButtonClick) forControlEvents:UIControlEventTouchUpInside];
            _blackButton.layer.cornerRadius = _blackButton.frame.size.height/2;
            _blackButton.clipsToBounds = YES;
            if ([_blackState intValue] == 1) {
                [_blackButton setTitle:@"取消拉黑" forState:UIControlStateNormal];
            }else{
                [_blackButton setTitle:@"拉黑" forState:UIControlStateNormal];
            }
            [_blackButton setTitleColor:MainColor forState:UIControlStateNormal];
            [showView addSubview:_blackButton];
            
        }else if (integer == 2000){
            
            self.blackView.hidden = YES;
            self.markname = responseObj[@"data"][@"markname"]?:@"";
            self.admin_mark = responseObj[@"data"][@"admin_mark"]?:@"";
            [self showBasicData:responseObj[@"data"] andIsShow:NO];
            if ([responseObj[@"data"][@"realname"] intValue] == 0) {
                self.picPublicButton.hidden = YES;
            }else{
                self.picPublicButton.hidden = NO;
            }
            
            //认证照的查看权限的设置
            _realpicstate = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"realpicstate"]];
            
            if ([_realpicstate intValue] == 1) {
                
                [self.picPublicButton setBackgroundImage:[UIImage imageNamed:@"个人主页认证照vip可见"] forState:UIControlStateNormal];
                
            }else{
                
                [self.picPublicButton setBackgroundImage:[UIImage imageNamed:@"个人主页认证照未公开"] forState:UIControlStateNormal];
            }
            
            self.attentionLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"follow_num"]];
            
            self.fansLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"fans_num"]];
            
            self.groupLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"group_num"]];
            
            _picArray = responseObj[@"data"][@"photo"];
            
            _followState = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"follow_state"]];
            
            //创建个人主页个性签名
            [self createOwnInfoSign:responseObj];
            
            //创建个人主页个人相册scroll
            [self createOwnInfoPic:responseObj];
            
            //标签显示
            [self createLabel:self.heightLabel andString:[NSString stringWithFormat:@" 身高: %@ ",responseObj[@"data"][@"tall"]]];
            
            [self createLabel:self.weightLabel andString:[NSString stringWithFormat:@" 体重: %@ ",responseObj[@"data"][@"weight"]]];
            
            [self createLabel:self.starLabel andString:[NSString stringWithFormat:@" 星座: %@ ",responseObj[@"data"][@"starchar"]]];
            
            [self createLabel:self.psexualLabel andString:[NSString stringWithFormat:@" 取向: %@ ",responseObj[@"data"][@"sexual"]]];
            
            [self createLabel:self.contactLabel andString:[NSString stringWithFormat:@" 接触: %@ ",responseObj[@"data"][@"along"]]];
            
            [self createLabel:self.experenceLabel andString:[NSString stringWithFormat:@" 实践: %@ ",responseObj[@"data"][@"experience"]]];
            
            [self createLabel:self.levelLabel andString:[NSString stringWithFormat:@" 程度: %@ ",responseObj[@"data"][@"level"]]];
            
            [self createLabel:self.wantLabel andString:[NSString stringWithFormat:@" 想找: %@ ",responseObj[@"data"][@"want"]]];
            
            [self createLabel:self.cultureLabel andString:[NSString stringWithFormat:@" 学历: %@ ",responseObj[@"data"][@"culture"]]];
            
            [self createLabel:self.monthLabel andString:[NSString stringWithFormat:@" 月薪: %@ ",responseObj[@"data"][@"monthly"]]];
            
            
            _mediaStrng = responseObj[@"data"][@"media"];
            
            if ([responseObj[@"data"][@"media"] length] == 0) {
                
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"录音灰"] forState:UIControlStateNormal];
                
                self.playButton.userInteractionEnabled = NO;
                
            }else{
                
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
                
                self.playButton.userInteractionEnabled = YES;
            }
            
            if ([responseObj[@"data"][@"uid"] intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                
                self.publishButton.hidden = NO;
                
                self.recordButton.hidden = NO;
                
            }else if ([responseObj[@"data"][@"uid"] intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]){
                
                self.chatButton.hidden = NO;
                
                self.attentButton.hidden = NO;
                
                self.giveGifButton.hidden = NO;
                
            }
            
            if ([responseObj[@"data"][@"mediaalong"] intValue] == 0) {
                
                self.secondLabel.text = @"";
                
                self.secondW.constant = 0;
                
            }else{
                
                self.secondLabel.text = [NSString stringWithFormat:@"\%@\"",responseObj[@"data"][@"mediaalong"]];
                
                self.secondW.constant = 24;
            }
            
            
            
            if ([responseObj[@"data"][@"follow_state"] intValue] == 2) {
                
                [self.attentButton setBackgroundImage:[UIImage imageNamed:@"关注好友"] forState:UIControlStateNormal];
                _attentStatus = NO;
                
            }else if([responseObj[@"data"][@"follow_state"] intValue] == 1){
                
                [self.attentButton setBackgroundImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
                
                _attentStatus = YES;
                
            }else if ([responseObj[@"data"][@"follow_state"] intValue] == 3){
                
                [self.attentButton setBackgroundImage:[UIImage imageNamed:@"互为好友"] forState:UIControlStateNormal];
                
                _attentStatus = YES;
                
            }else if ([responseObj[@"data"][@"follow_state"] intValue] == 4){
                
                [self.attentButton setBackgroundImage:[UIImage imageNamed:@"个人主页被关注"] forState:UIControlStateNormal];
                
                _attentStatus = NO;
            }
            
            self.dateLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"reg_time"]];
            
            [self.dateLabel sizeToFit];
            
            if ([responseObj[@"data"][@"dynamic_num"] intValue] == 0) {
                
                self.totalNumView.hidden = YES;
                
                self.totalNumH.constant = 0;
                
            }else{
                
                self.totalNumView.hidden = NO;
                
                self.totalNumH.constant = 40;
                
                self.dynamicNumLabel.text = [NSString stringWithFormat:@"发布的动态(%@)",responseObj[@"data"][@"dynamic_num"]];
                
                UILabel *messageLab = [UILabel new];
                [self.totalNumView addSubview:messageLab];
                [messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.totalNumView);
                    make.right.equalTo(self.totalNumView).with.offset(-30);
                    
                }];
                messageLab.textColor = [UIColor lightGrayColor];
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[self.userID intValue]) {
                    messageLab.text = @"更多";
                }
                else
                {
                    if ([self.dynamic_rule isEqualToString:@"0"]) {
                        messageLab.text = @"更多";
                    }
                    else
                    {
                        messageLab.text = @"好友/会员可见";
                    }
                }
                messageLab.font = [UIFont systemFontOfSize:14];
                messageLab.textAlignment = NSTextAlignmentRight;
            }
            
            if ([responseObj[@"data"][@"comment_num"] intValue] == 0) {
                
                self.dynamicCommentNumView.hidden = YES;
                
                self.dynamicCommentNumH.constant = 0;
                
                
            }else{
                
                self.dynamicCommentNumView.hidden = NO;
                
                self.dynamicCommentNumH.constant = 40;
                
                self.dynamicCommentNumLabel.text = [NSString stringWithFormat:@"参与的评论(%@)",responseObj[@"data"][@"comment_num"]];
                
                UILabel *messageLab = [UILabel new];
                [self.dynamicCommentNumView addSubview:messageLab];
                [messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.dynamicCommentNumView);
                    make.right.equalTo(self.dynamicCommentNumView).with.offset(-30);
                    
                }];
                messageLab.textColor = [UIColor lightGrayColor];
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[self.userID intValue]) {
                    messageLab.text = @"更多";
                }
                else
                {
                    if ([self.comment_rule isEqualToString:@"0"]) {
                        messageLab.text = @"更多";
                    }
                    else
                    {
                        messageLab.text = @"好友/会员可见";
                    }
                }
                
                messageLab.font = [UIFont systemFontOfSize:14];
                messageLab.textAlignment = NSTextAlignmentRight;
            }
            
     
            
            //获取礼物的接口
            [self getPersonReceiveGifData];
            
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求发生错误~"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 * 被拉黑时的拉黑某人的按钮点击事件
 */
- (void)blackButtonClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url;
    
    if ([_blackState intValue] == 1) {
        //取消拉黑
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/cancelBlackState"];
        
    }else{
        //拉黑
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/setOneToBlacklist"];
        if ([_vipTypeString isEqualToString:@"is_admin"]) {
            [MBProgressHUD showMessage:@"黑V无法被拉黑"];
            
            return;
        }
    }
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.userID};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([_blackState intValue] == 1) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"取消拉黑失败,请重试~"];
            }else{
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"拉黑失败,请重试~"];
            }
        }else{
            if ([_blackState intValue] == 1) {
                _blackState = @"0";
                if (_blackState != nil) {
                    [_blackButton setTitle:@"拉黑" forState:UIControlStateNormal];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weilahei" object:nil];
            }else{
                _blackState = @"1";
                if (_blackState != nil) {
                    [_blackButton setTitle:@"取消拉黑" forState:UIControlStateNormal];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"lahei" object:nil];
            }
            [MBProgressHUD showMessage:[responseObj objectForKey:@"msg"]];
            [MBProgressHUD hideHUDForView:self.view];
        }
    } failed:^(NSString *errorMsg) {
         [MBProgressHUD hideHUDForView:self.view];
    }];
}

/**
 * 被拉黑时的举报某人的按钮点击事件
 */
- (void)reportButtonClick{
    LDReportViewController *rvc = [[LDReportViewController alloc] init];
    rvc.reportId = self.userID;
    [self.navigationController pushViewController:rvc animated:YES];
}

/**
 * 顶部视图被拉黑与正常的情况均显示数据
 */
-(void)showBasicData:(NSDictionary *)dic andIsShow:(BOOL)show{
    
    //显示隐藏不必要的控件
    self.playButton.hidden = show;
    self.secondLabel.hidden = show;
    self.recordButton.hidden = show;
    self.timeView.hidden = show;
    self.locationView.hidden = show;
    self.cityView.hidden = show;
    self.dateShowLabel.hidden = show;
    self.dateLabel.hidden = show;
    self.picPublicButton.hidden = show;
    
    //分享视图
    _shareView = [[LDShareView alloc] init];
    
    NSString *pic;
    
    if ([dic[@"head_pic"] length] == 0) {

        pic = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"nopeople.png"];
        
    }else{
        
        pic = dic[@"head_pic"];
    }
    
    [self.navigationController.view addSubview:[_shareView createBottomView:@"Infomation" andNickName:dic[@"nickname"] andPicture:pic andId:self.userID]];
    
    //存储拉黑时的状态
     _blackState = dic[@"black_state"];
    
    //管理员备注展示
    
    UIFont *font;
    if (WIDTH >= 375) {
        font = [UIFont systemFontOfSize:15];
    }else{
        font = [UIFont systemFontOfSize:13];
    }
    
    
    CGFloat admin_markhei = 0.00f;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue]==1&&self.admin_mark.length!=0) {
        admin_markhei = [self.admin_mark boundingRectWithSize:CGSizeMake(WIDTH-28, 0) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
        
        self.tableViewTopY.constant = admin_markhei;
        if (self.adminnoteView==nil) {
            self.adminnoteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, admin_markhei+8)];
        }
        self.adminnoteView.backgroundColor = [UIColor colorWithHexString:@"A6A9B5" alpha:1];
        [self.view addSubview:self.adminnoteView];
        
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.admin_mark];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [self.admin_mark length])];
        UILabel *noteLabel = [[UILabel alloc] init];
        noteLabel.numberOfLines = 0;
        noteLabel.attributedText = attributedString;
        [noteLabel sizeToFit];
        noteLabel.frame = CGRectMake(14, 4, WIDTH-28, admin_markhei);
        noteLabel.textAlignment = NSTextAlignmentLeft;
        noteLabel.textColor = [UIColor whiteColor];
        [self.adminnoteView addSubview:noteLabel];
    }
    else
    {
        if (_adminnoteView != nil) {
            [_adminnoteView removeFromSuperview];
        }
        self.tableViewTopY.constant = admin_markhei;
    }
    
    //可以用户的设置
    _is_likeliar = [NSString stringWithFormat:@"%@",dic[@"is_likeliar"]];

    if ([dic[@"is_likeliar"] intValue] == 1) {
        self.tableViewTopY.constant = 40+admin_markhei;
        CGFloat tops = 0.00f;
        if (self.admin_mark.length!=0&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue]==1) {
            tops = admin_markhei+8;
        }
        if (_likeliarView == nil) {
            _likeliarView = [[UIView alloc] initWithFrame:CGRectMake(0, tops, WIDTH, 40)];
        }
        
        [self.view addSubview:_likeliarView];
        _likeliarView.backgroundColor = [UIColor colorWithHexString:@"#ff3434" alpha:1];
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"可疑用户!【自拍认证】后此提醒消失"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [@"可疑用户!【自拍认证】后此提醒消失" length])];
        UILabel *warnLabel = [[UILabel alloc] init];
        warnLabel.attributedText = attributedString;
        [warnLabel sizeToFit];
        warnLabel.frame = CGRectMake((WIDTH -  warnLabel.frame.size.width)/2, 0, warnLabel.frame.size.width, 40);
        warnLabel.textAlignment = NSTextAlignmentCenter;
        warnLabel.textColor = [UIColor whiteColor];
        [_likeliarView addSubview:warnLabel];
        [warnLabel yb_addAttributeTapActionWithStrings:@[@"【自拍认证】"] delegate:self];
        warnLabel.enabledTapEffect = NO;
        
    }else{
        if (_likeliarView != nil) {
            [_likeliarView removeFromSuperview];
        }
        self.tableViewTopY.constant = admin_markhei;
    }
    
    //展示用户信息的view的设置
    _headUrl = dic[@"head_pic"];
    [self.backGroundView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.backGroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backGroundView.clipsToBounds = YES;
    
    self.nameLabel.text = dic[@"nickname"];
    CGSize size = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    self.nameW.constant = labelSize.width;;
    
    if (self.markname.length!=0) {
        self.backViewY.constant = 38;
        self.nameLabel.text = self.markname;
        self.oldnameLab.text = [NSString stringWithFormat:@"%@%@%@",@"(",dic[@"nickname"],@")"];
    }

    if ([dic[@"realname"] intValue] == 0) {
        if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]){
            self.idImageView.image = [UIImage imageNamed:@"认证灰"];
            self.idImageView.hidden = NO;
            self.idviewW.constant = 19;
        }else{
            self.idImageView.hidden = YES;
            self.idviewW.constant = 0;
        }
    }else{
        self.idImageView.image = [UIImage imageNamed:@"认证"];
        self.idImageView.hidden = NO;
        self.idviewW.constant = 19;
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
        self.sexImageView.image = [UIImage imageNamed:@"男"];
        self.backView.backgroundColor = BOYCOLOR;
        _signColor = BOYCOLOR;
    }else if ([dic[@"sex"] intValue] == 2){
        self.sexImageView.image = [UIImage imageNamed:@"女"];
        self.backView.backgroundColor = GIRLECOLOR;
        _signColor = GIRLECOLOR;
    }else{
        self.sexImageView.image = [UIImage imageNamed:@"双性"];
        self.backView.backgroundColor = DOUBLECOLOR;
        _signColor = DOUBLECOLOR;
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",dic[@"age"]];
    
    //判断获取的时间是不是NSNull,如果是NSNull则显示隐身
    if ([dic[@"last_login_time"] isEqual:[NSNull null]]) {
        _lastTime = @"隐身";
    }else{
        _lastTime = dic[@"last_login_time"];
    }
    if ([dic[@"login_time_switch"] intValue] == 0) {
        if ([dic[@"timePoorState"] intValue] == 1) {
            self.timeLabel.text = _lastTime;
        }else{
            self.timeLabel.text = @"查看时间";
            [_lookTimeButton addTarget:self action:@selector(lookTimeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        self.timeLabel.text = @"隐身";
    }
    self.timeW.constant = 18 + [self fitLabelWidth:self.timeLabel.text].width;
    self.locationLabel.text = [NSString stringWithFormat:@"%@",dic[@"distance"]];
    self.locationW.constant = 18 + [self fitLabelWidth:self.locationLabel.text].width;
    
    if (show == NO) {
        if ([self.locationLabel.text isEqualToString:@"隐身"]) {
            self.cityView.hidden = YES;
        }else{
            
            if ([dic[@"city"] length] == 0) {
                
                if ([dic[@"province"] length] == 0) {
                    
                    self.cityView.hidden = YES;
                    
                }else{
                    
                    self.cityView.hidden = NO;
                    
                    self.cityLabel.text = [NSString stringWithFormat:@"%@",dic[@"province"]];
                }
                
            }else{
                
                self.cityView.hidden = NO;
                
                if ([dic[@"province"] length] == 0) {
                    
                    self.cityLabel.text = [NSString stringWithFormat:@"%@",dic[@"city"]];
                    
                }else{
                    
                    if ([dic[@"province"] isEqualToString:dic[@"city"]]) {
                        
                        self.cityLabel.text = [NSString stringWithFormat:@"%@",dic[@"province"]];
                        
                    }else{
                        
                        self.cityLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"province"],dic[@"city"]];
                    }
                }
            }
        }
        
        self.cityW.constant = 18 + [self fitLabelWidth:self.cityLabel.text].width;
    }
    
    if ([dic[@"is_volunteer"] intValue] == 1) {
        
        _vipTypeString = @"is_volunteer";
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
        
    }else if ([dic[@"is_admin"] intValue] == 1) {
        
        _vipTypeString = @"is_admin";
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
        
    }else{
        
        if ([dic[@"svipannual"] intValue] == 1) {
            
            _vipTypeString = @"";
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年svip标识"];
            
        }else if ([dic[@"svip"] intValue] == 1){
            
            _vipTypeString = @"";
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"svip标识"];
            
        }else if ([dic[@"vipannual"] intValue] == 1) {
            
            _vipTypeString = @"";
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年费会员"];
            
        }else{
            
            if ([dic[@"vip"] intValue] == 1) {
                
                _vipTypeString = @"";
                
                self.vipView.hidden = NO;
                
                self.vipView.image = [UIImage imageNamed:@"高级紫"];
                
            }else{
                
                _vipTypeString = @"";
                
                self.vipView.image = [UIImage imageNamed:@"高级灰"];
                
            }
        }
    }
    
    if ([dic[@"onlinestate"] intValue] == 0) {
        
        self.onlineView.hidden = YES;
        
    }else{
        
        self.onlineView.hidden = NO;
    }
    
    //获取展示的财富值和魅力值
    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andText:dic[@"wealth_val"] andNSLayoutConstraint:_wealthW andType:@"财富"];
    
    [self getWealthAndCharmState:_charmLabel andView:_charmView andText:dic[@"charm_val"] andNSLayoutConstraint:_charmW andType:@"魅力"];
}

/**
 * 点击认证照公开不公开按钮
 */
- (IBAction)picPublicButtonClick:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == [self.userID intValue]) {
        
        //获取用户认证头像
        [self getUserCodePic];
        
    }else{
        
        if ([_realpicstate intValue] == 1) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
                
                //获取用户认证头像
                [self getUserCodePic];
                
            }else{
                
                //提示用户去开通VIP
                [self createUpdateVIP:@"认证照限VIP会员可见"];
            }
            
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"该用户未公开认证照~"];
            
        }
    }
}


#pragma mark - 获取用户的认证头像

/**
 * 获取用户的认证头像
 */
-(void)getUserCodePic{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getidstate"];
    
    NSDictionary *parameters = @{@"uid":self.userID};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (integer == 2000) {
            
            [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:0 imagesBlock:^NSArray *{
                
                NSArray *array = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"card_face"]]];
                
                return array;
            }];
            
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请稍后再试~"];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",error);
        
    }];
}

/**
 * 创建个人主页个性签名
 */
-(void)createOwnInfoSign:(NSDictionary *)responseObject{
    
    CGFloat introduceLabelH = 50;
    CGFloat extraH = 25;
    //如果是查看自己的信息,无自我介绍时显示编辑签名
    if ([responseObject[@"data"][@"uid"] intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        if ([responseObject[@"data"][@"introduce"] length] == 0) {
            
            self.introduceLabel.text = @"";
            
            if (_addSignButton == nil) {
                
                _addSignButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.introduceLabel.frame.size.width, introduceLabelH)];
                
                [_addSignButton setTitle:@"编辑个性签名" forState:UIControlStateNormal];
                
                _addSignButton.titleLabel.font = [UIFont systemFontOfSize:13];
                
                [_addSignButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [_addSignButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(self.introduceLabel.frame.size.width/2 - 53, 20, 10, 10)];
                
                img.image = [UIImage imageNamed:@"编辑个性签名"];
                
                [_addSignButton addSubview:img];
                
                [_introduceLabel addSubview:_addSignButton];
                
            }else{
                
                _addSignButton.hidden = NO;
                
                self.introduceH.constant = introduceLabelH;
            }
            
        }else{
            
            if (_addSignButton != nil) {
                
                _addSignButton.hidden = YES;
            }
            
            self.introduceLabel.text = responseObject[@"data"][@"introduce"];
            
            [self.introduceLabel sizeToFit];
            
            if (self.introduceLabel.frame.size.height + extraH <= introduceLabelH) {
                
                self.introduceH.constant = introduceLabelH;
                
            }else{
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.introduceLabel.text];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:5];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.introduceLabel.text length])];
                self.introduceLabel.attributedText = attributedString;
                
                self.introduceLabel.isCopyable = YES;
                
                self.introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
                
                [self.introduceLabel sizeToFit];
                
                self.introduceH.constant = self.introduceLabel.frame.size.height + extraH + 20;
                
            }
        }
    }else{
        
        if (_addSignButton != nil) {
            
            _addSignButton.hidden = YES;
        }
        
        if ([responseObject[@"data"][@"introduce"] length] == 0){
            
            self.introduceH.constant = 0;
            
            self.introduceWarnH.constant = 0;
            
            self.introduceTopLineH.constant = 0;
            
            self.introduceTopLineLabel.hidden = YES;
            
        }else{
            
            self.introduceTopLineH.constant = 25;
            
            self.introduceTopLineLabel.hidden = NO;

            self.introduceWarnLabel.hidden = YES;
            
            self.introduceLabel.text = responseObject[@"data"][@"introduce"];
            
            [self.introduceLabel sizeToFit];
                
            if (self.introduceLabel.frame.size.height + extraH <= introduceLabelH) {
                
                self.introduceH.constant = introduceLabelH;
                
            }else{
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.introduceLabel.text];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:5];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.introduceLabel.text length])];
                self.introduceLabel.attributedText = attributedString;
                
                self.introduceLabel.isCopyable = YES;
                
                self.introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
                
                [self.introduceLabel sizeToFit];
                
                self.introduceH.constant = self.introduceLabel.frame.size.height + extraH + 20;
                
            }
        }
    }
    
    self.introduceLabel.frame = CGRectMake(self.introduceLabel.frame.origin.x, self.introduceLabel.frame.origin.y, self.introduceLabel.frame.size.width, self.introduceH.constant);
}

/**
 * 创建个人主页个人相册scroll
 */
-(void)createOwnInfoPic:(NSDictionary *)responseObject{
    
    CGFloat bothPicSpace = 6;
    int picScrollH = (WIDTH - 3 * bothPicSpace)/3.5;
    CGFloat picViewH = picScrollH + 4 * bothPicSpace;
    CGFloat picScrollY = (picViewH - picScrollH)/2;
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, picScrollY, WIDTH, picScrollH)];
        [_picBackView addSubview:_scrollView];
    }
    
    for (UIImageView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    //如果是自己查看自己的资料可以添加图片
    if ([responseObject[@"data"][@"uid"] intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        self.picH.constant = picViewH + self.introduceTopLineH.constant;
        
        if ([responseObject[@"data"][@"photo"] count] == 0) {
            
           // self.picH.constant = picViewH + self.introduceTopLineH.constant;
            UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, picScrollH, picScrollH)];
            [addButton setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:addButton];
            
            
        }else{
            
            _lock = responseObject[@"data"][@"photo_lock"];
           // self.picH.constant = picViewH + self.introduceTopLineH.constant;
            _scrollView.contentSize = CGSizeMake(picScrollH * [responseObject[@"data"][@"photo"] count] + bothPicSpace * ([responseObject[@"data"][@"photo"] count] - 1), picScrollH);
            [self createShowPicView:responseObject[@"data"][@"photo"] andPicScrollH:picScrollH andBothPicSpace:bothPicSpace andType:1];
        }
        
    }else{
        
        if ([responseObject[@"data"][@"photo"] count] == 0) {
            
            self.picH.constant = self.introduceTopLineH.constant;
            
        }else{
            
            _lock = responseObject[@"data"][@"photo_lock"];
            
            self.picH.constant = picViewH + self.introduceTopLineH.constant;
            
            _scrollView.contentSize = CGSizeMake(picScrollH * [responseObject[@"data"][@"photo"] count] + bothPicSpace * ([responseObject[@"data"][@"photo"] count] - 1), picScrollH);
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1||[self.followState intValue] == 3) {
                if ([self.lock isEqualToString:@"2"]) {
                       [self createShowPicView:responseObject[@"data"][@"photo"] andPicScrollH:picScrollH andBothPicSpace:bothPicSpace andType:2];
                }
                else
                {
                     [self createShowPicView:responseObject[@"data"][@"photo"] andPicScrollH:picScrollH andBothPicSpace:bothPicSpace andType:1];
                }
                
            }
            else
            {
                
                //所有人可见
                if ([self.photo_rule isEqualToString:@"0"]) {
                    //隐私相册
                    if ([self.lock isEqualToString:@"2"]) {
                        [self createShowPicView:responseObject[@"data"][@"photo"] andPicScrollH:picScrollH andBothPicSpace:bothPicSpace andType:2];
                    }
                    else
                    {
                        [self createShowPicView:responseObject[@"data"][@"photo"] andPicScrollH:picScrollH andBothPicSpace:bothPicSpace andType:1];
                    }
                    
                }
                else
                {
                    //好友会员可见
                    //隐私相册
                    if ([self.lock isEqualToString:@"2"]) {
                        [self createShowPicView:responseObject[@"data"][@"photo"] andPicScrollH:picScrollH andBothPicSpace:bothPicSpace andType:2];
                    }
                    else
                    {
                        [self createShowPicView:responseObject[@"data"][@"photo"] andPicScrollH:picScrollH andBothPicSpace:bothPicSpace andType:1];
                    }
                    
                }
                
            }
         
            
        }
    }
}
/**
 * 创建个人主页个人相册的展示
 */
-(void)createShowPicView:(NSArray *)picArray andPicScrollH:(int)picScrollH andBothPicSpace:(CGFloat)bothPicSpace andType:(int)type{
    
    for (int i = 0; i < picArray.count; i++) {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(picScrollH * i + bothPicSpace * i, 0, picScrollH, picScrollH)];
        
        [img sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"动态图片默认"] ];
        
        img.userInteractionEnabled = YES;
        
        img.tag = 10 + i;
        
        img.contentMode = UIViewContentModeScaleAspectFill;
        
        img.clipsToBounds = YES;
        
        if (type == 2) {
            
            /**
             *  创建需要的毛玻璃特效类型
             */
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            /**
             *  毛玻璃view 视图
             */
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            effectView.frame = img.bounds;
            [img addSubview:effectView];
            
            effectView.alpha = .92f;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPic:)];
        
        [img addGestureRecognizer:tap];
        
        [_scrollView addSubview:img];
    }
}

#pragma 富文本文字点击delegate
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    
    if ([string isEqualToString:@"VIP会员"]){
        
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if ([string isEqualToString:@"互为好友"]){
        
        [self attentButtonClickState:_attentStatus];
        
    }else if([string isEqualToString:@"认证用户"] || [string isEqualToString:@"【自拍认证】"]){
    
        //判断用户是否是认证用户
        [self createRealNameState];
        
    }else if ([string isEqualToString:@"【绑定手机】"]){
        
        LDBindingPhoneNumViewController *bpnc = [[LDBindingPhoneNumViewController alloc] init];
        
        [self.navigationController pushViewController:bpnc animated:YES];
        
    }
}

/**
 * 财富值/魅力值的自适应及展示
 */
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

/**
 * 获取个人收到的礼物列表,并计算头视图的高度
 */
-(void)getPersonReceiveGifData{
    
    NSArray *colorArray = @[@"握手紫",@"黄瓜紫",@"玫瑰紫",@"送吻紫",@"红酒紫",@"对戒紫",@"蛋糕紫",@"跑车紫",@"游轮紫" ,@"棒棒糖",@"狗粮",@"秋裤",@"黄瓜",@"心心相印",@"香蕉",@"口红",@"亲一个",@"玫瑰花",@"眼罩",@"心灵束缚",@"黄金",@"拍之印",@"鞭之痕",@"老司机",@"一生一世",@"水晶高跟",@"恒之光",@"666",@"红酒",@"蛋糕",@"钻戒",@"皇冠",@"跑车",@"直升机",@"游轮",@"城堡",@"幸运草",@"糖果",@"玩具狗",@"内内",@"TT"];
    
    NSArray *amountArray = @[@"7",@"35",@"70",@"350",@"520",@"700",@"1888",@"2888",@"3888",@"2",@"6",@"10",@"38",@"99",@"88",@"123",@"166",@"199",@"520",@"666",@"250",@"777",@"888",@"999",@"1314",@"1666",@"1999",@"666",@"999",@"1888",@"2899",@"3899",@"6888",@"9888",@"52000",@"99999",@"1",@"3",@"5",@"10",@"8"];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getMyPresent"];
    
    NSDictionary *parameters = @{@"uid":self.userID};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            
            if (integer == 4001) {
                
                self.gifView.hidden = YES;
                self.gifNumW.constant = 0;
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            }
            
        }else{
            
            if (_picArray.count == 0 && [self.userID intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                
                self.picH.constant = self.introduceTopLineH.constant + 10;
            }
            
            self.gifNumW.constant = 70;
            
            self.gifView.hidden = NO;
            
            self.gifNumLabel.text = [NSString stringWithFormat:@"%@份",responseObject[@"data"][@"allnum"]];
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.gifNumLabel.text];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(0,[responseObject[@"data"][@"allnum"] length])];
            _gifNumLabel.attributedText = attributedStr;
            
            //对数组进行排序
            NSArray *result = [responseObject[@"data"][@"giftArr"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                int number1;
                int number2;
                
                if (colorArray.count >= [obj1[@"type"] intValue]) {
                    
                    number1 = [amountArray[[obj1[@"type"] intValue] - 1] intValue];
                    
                }else{
                
                    number1 = 0;
                }
                
                if (colorArray.count >= [obj2[@"type"] intValue]) {
                    
                    number2 = [amountArray[[obj2[@"type"] intValue] - 1] intValue];
                    
                }else{
                
                    number2 = 0;
                }

                if (number1 > number2) {
                    
                    return (NSComparisonResult)NSOrderedAscending;
                    
                }else if (number1 < number2){
                    
                    return (NSComparisonResult)NSOrderedDescending
                    ;
                }else{
                    
                    return (NSComparisonResult)NSOrderedSame
                    ;
                }
            }];
            
            if ([result count] <= 4) {
                
                for (int i = 0; i < [result count]; i++) {
                    
                    UIImageView *gifImageView = (UIImageView *)[_gifView viewWithTag:1000 + i];
                    gifImageView.contentMode = UIViewContentModeScaleAspectFill;
                    if (colorArray.count >= [result[i][@"type"] intValue]) {
                        
                        gifImageView.image = [UIImage imageNamed:colorArray[[result[i][@"type"] intValue] - 1]];
                        
                    }else{
                        
                        gifImageView.image = [UIImage imageNamed:@"未知礼物"];
                    }
                }
            }else{
                for (int i = 0; i < 4; i++) {
                    UIImageView *gifImageView = (UIImageView *)[_gifView viewWithTag:1000 + i];
                    gifImageView.contentMode = UIViewContentModeScaleAspectFill;
                    if (colorArray.count >= [result[i][@"type"] intValue]) {
                        gifImageView.image = [UIImage imageNamed:colorArray[[result[i][@"type"] intValue] - 1]];
                    }else{
                        gifImageView.image = [UIImage imageNamed:@"未知礼物"];
                    }
                }
            }
        }
        
        _headBackView.hidden = NO;
        
        [self.tableView.mj_header endRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.headBackView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(self.dynamicCommentNumView.frame));
            
            self.tableView.tableHeaderView = self.headBackView;
            
        });
        
        if (!_isRecord) {
            
            //判定是否写入记录
            [self recordComerData];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/**
 * 写入浏览记录
 */
-(void)recordComerData{
    
    _isRecord = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"writeVisitRecord"] length] != 0){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSTimeInterval interval = - [[formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"writeVisitRecord"]] timeIntervalSinceNow];
        
        if (interval >= 5) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"writeVisitRecord"];
        }
        
    }else{
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/friend/writeVisitRecord"];
        NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            if (integer == 2000) {
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [[NSUserDefaults standardUserDefaults] setObject:[formatter stringFromDate:date] forKey:@"writeVisitRecord"];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

/**
 * 点击参与的评论跳转到相应的列表
 */
- (IBAction)dynamicCommentButtonClick:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1 || [_followState intValue] == 3||[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue] == 1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[self.userID intValue]) {
        LDOwnInfoDynamicCommentViewController *info = [[LDOwnInfoDynamicCommentViewController alloc] init];
        info.personUid = self.userID;
        info.attentStatus = _attentStatus;
        info.navigationItem.title = self.nameLabel.text;
        [self.navigationController pushViewController:info animated:YES];
    }else
    {
        if ([self.comment_rule isEqualToString:@"0"]) {
            LDOwnInfoDynamicCommentViewController *info = [[LDOwnInfoDynamicCommentViewController alloc] init];
            info.personUid = self.userID;
            info.attentStatus = _attentStatus;
            info.navigationItem.title = self.nameLabel.text;
            [self.navigationController pushViewController:info animated:YES];
        }
        else
        {
            [self toshowAlertwithtype:@"2"];
        }
    }
}
/**
 * 点击发布的动态跳转到相应的列表
 */
- (IBAction)ownInfoDynamicButtonClick:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1 || [_followState intValue] == 3||[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue] == 1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[self.userID intValue]) {
        LDownInfoDynamicViewController *dvc = [[LDownInfoDynamicViewController alloc] init];
        dvc.personUid = self.userID;
        dvc.attentStatus = _attentStatus;
        dvc.navigationItem.title = self.nameLabel.text;
        [self.navigationController pushViewController:dvc animated:YES];
    }else
    {
        if ([self.dynamic_rule isEqualToString:@"0"]) {
            LDownInfoDynamicViewController *dvc = [[LDownInfoDynamicViewController alloc] init];
            dvc.personUid = self.userID;
            dvc.attentStatus = _attentStatus;
            dvc.navigationItem.title = self.nameLabel.text;
            [self.navigationController pushViewController:dvc animated:YES];
            
        }
        else
        {
            [self toshowAlertwithtype:@"1"];
        }
    }
    


}

/**
 消息详情不可见AlertView

 @param typestr 消息类别  0 相册  1 动态  2 评论
 */
-(void)toshowAlertwithtype:(NSString *)typestr
{
    NSString *message = [NSString new];
    if ([typestr isEqualToString:@"0"]) {
        message = @"TA的相册限互为好友、VIP会员可见~";
    }
    if ([typestr isEqualToString:@"1"]) {
        message = @"TA的动态限互为好友、VIP会员可见~";
    }
    if ([typestr isEqualToString:@"0"]) {
         message = @"TA的评论限互为好友、VIP会员可见~";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"TA的动态限互为好友、VIP会员可见~"    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * addFriendAction = [UIAlertAction actionWithTitle:@"加好友" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self attentButtonClickState:_attentStatus];
        
    }];
    
    UIAlertAction * vipAction = [UIAlertAction actionWithTitle:@"开通VIP" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [action setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
        
        [vipAction setValue:MainColor forKey:@"_titleTextColor"];
        
        [addFriendAction setValue:MainColor forKey:@"_titleTextColor"];
    }
    
    
    [alert addAction:action];
    [alert addAction:addFriendAction];
    [alert addAction:vipAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//获取并剪裁标签
-(void)createLabel:(UILabel *)label andString:(NSString *)str{
    
    label.text = str;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = _signColor;
    [label sizeToFit];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, 24);
    label.layer.cornerRadius = 2;
    label.clipsToBounds = YES;
}

//查看个人资料时如果没有照片显示添加照片按钮
-(void)addButtonClick{

    LDEditViewController *evc = [[LDEditViewController alloc] init];
    
    evc.userID = self.userID;
    
    [self.navigationController pushViewController:evc animated:YES];
}

//判断是否是会员,是会员查看时间,不是提示
-(void)lookTimeButtonClick{

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
        
        self.timeLabel.text = _lastTime;
        
    }else{
        
        //提示用户去开通VIP
        [self createUpdateVIP:@"登录时间限VIP会员可见"];
    }
}

/**
 * 提示用户去开通Vip
 */
-(void)createUpdateVIP:(NSString *)titleString{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:titleString    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"开通VIP" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];
        
        
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
    
    [alert addAction:cancelAction];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];

}

//label的宽度自适应
-(CGSize)fitLabelWidth:(NSString *)string{

    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return labelSize;

}

#pragma 点击关注按钮
- (IBAction)attentButtonClick:(id)sender {

    [self attentButtonClickState:_attentStatus];
    
}

#pragma 点击认证图标
- (IBAction)idTapClick:(id)sender {
        
    //判断用户是否是认证用户
    [self createRealNameState];

}

/**
 * 判断用户是否是认证用户
 */
-(void)createRealNameState{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getidstate"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];

        if (integer == 2000) {
            
            LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
            
            cvc.type = @"2";
            
            [self.navigationController pushViewController:cvc animated:YES];
            
        }else if(integer == 2001){
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"正在审核,请耐心等待~"];
        
            
        }else if (integer == 2002){
            
            LDCertificateBeforeViewController *cvc = [[LDCertificateBeforeViewController alloc] init];
            
            cvc.where = @"2";
            
            [self.navigationController pushViewController:cvc animated:YES];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)vipButtonClick:(id)sender {
    
    if ([_vipTypeString isEqualToString:@"is_volunteer"]) {
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        
        mvc.name = @"志愿者";
        
        mvc.type = @"2";
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if ([_vipTypeString isEqualToString:@"is_admin"]){
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        
        mvc.name = @"全职招聘";
        
        mvc.type = @"1";
        
        [self.navigationController pushViewController:mvc animated:YES];
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == [self.userID intValue]) {
            
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            
            [self.navigationController pushViewController:mvc animated:YES];
            
        }else{
            
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            
            mvc.type = @"give";
            
            mvc.headUrl = self.headUrl;
            
            mvc.userID = self.userID;
            
            [self.navigationController pushViewController:mvc animated:YES];
        }
    }
}

//点击聊天
- (IBAction)chatButtonClick:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] length] != 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您因违规被系统禁用聊天功能,解封时间请查看系统通知,如有疑问请与客服联系~"];
        
    }else{
    
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getOpenChatRestrictAndInfo];
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"otheruid":self.userID};
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            if (integer == 2000 || integer == 2001) {
                
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                
                PersonChatViewController *conversationVC = [[PersonChatViewController alloc]init];
                [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
                [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = self.userID;
                conversationVC.mobile = self.userID;
                
                if (integer == 2000) {
                    
                    conversationVC.state = [NSString stringWithFormat:@"%d",[responseObject[@"data"][@"filiation"] intValue]];
                }
                
                if ([responseObject[@"data"][@"info"][@"is_admin"] integerValue] == 1) {
                    
                    conversationVC.type = personIsADMIN;
                    
                }else if ([responseObject[@"data"][@"info"][@"is_volunteer"] integerValue] == 1){
                    
                    conversationVC.type = personIsVOLUNTEER;
                    
                }else if ([responseObject[@"data"][@"info"][@"svipannual"] integerValue] == 1){
                    
                    conversationVC.type = personIsSVIPANNUAL;
                    
                }else if ([responseObject[@"data"][@"info"][@"svip"] integerValue] == 1) {
                    
                    conversationVC.type = personIsSVIP;
                    
                }else if ([responseObject[@"data"][@"info"][@"vipannual"] integerValue] == 1) {
                    
                    conversationVC.type = personIsVIPANNUAL;
                    
                }else if ([responseObject[@"data"][@"info"][@"vip"] integerValue] == 1){
                    
                    conversationVC.type = personIsVIP;
                    
                }else{
                    
                    conversationVC.type = personIsNormal;
                }
                
                conversationVC.title = self.nameLabel.text;
                [self.navigationController pushViewController:conversationVC animated:YES];
                
            }else if(integer == 3001){
                
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                
                _stampView = [[LDStampChatView alloc] initWithFrame:CGRectMake(0, 0 , WIDTH, HEIGHT)];
                
                _stampView.viewController = self;
                
                _stampView.data = responseObject[@"data"];
                
                _stampView.delegate = self;
                
                [self.navigationController.view addSubview:_stampView];
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }];
    }
}

#pragma  stampChat的代理方法
-(void)didSelectStamp:(NSString *)stamptype{

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Restrict/useStampToChatNew"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"otheruid":self.userID,@"stamptype":stamptype};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];

        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            if (integer == 4001 || integer == 3000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];

            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请稍后再试~"];
            }
            
        }else if(integer == 2000){
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            PersonChatViewController *conversationVC = [[PersonChatViewController alloc]init];
            [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
            [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
            conversationVC.conversationType = ConversationType_PRIVATE;
            conversationVC.targetId = self.userID;
            conversationVC.mobile = self.userID;
            conversationVC.state = [NSString stringWithFormat:@"%d",[responseObject[@"data"][@"filiation"] intValue]];
            
            if ([responseObject[@"data"][@"info"][@"is_admin"] integerValue] == 1) {
                
                conversationVC.type = personIsADMIN;
                
            }else if ([responseObject[@"data"][@"info"][@"is_volunteer"] integerValue] == 1){
                
                conversationVC.type = personIsVOLUNTEER;
                
            }else if ([responseObject[@"data"][@"info"][@"svipannual"] integerValue] == 1){
                
                conversationVC.type = personIsSVIPANNUAL;
                
            }else if ([responseObject[@"data"][@"info"][@"svip"] integerValue] == 1) {
                
                conversationVC.type = personIsSVIP;
                
            }else if ([responseObject[@"data"][@"info"][@"vipannual"] integerValue] == 1) {
                
                conversationVC.type = personIsVIPANNUAL;
                
            }else if ([responseObject[@"data"][@"info"][@"vip"] integerValue] == 1){
                
                conversationVC.type = personIsVIP;
                
            }else{
                
                conversationVC.type = personIsNormal;
            }
            conversationVC.title = self.nameLabel.text;
            [self.navigationController pushViewController:conversationVC animated:YES];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

#pragma 选择邮票聊天界面的代理
-(void)didSelectOtherButton{
    
    LDStampViewController *wvc = [[LDStampViewController alloc] init];
    [self.navigationController pushViewController:wvc animated:YES];
}

-(void)didSelectAttentButton:(UIView *)backView andButton:(UIButton *)button{

    _url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setfollowOne];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:backView animated:YES];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.userID};
    
    [NetManager afPostRequest:_url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        
        if (integer != 2000) {
            
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES];
            
            button.userInteractionEnabled = NO;
            
            if (integer == 4787 || integer == 4002) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"已关注对方,请不要重复操作~"];
                
            }else if (integer==8881||integer==8882)
            {
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
            }
            else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
            
        }else{
            
            if (_attentStatus) {
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [responseObj objectForKey:@"msg"];
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
                
                if ([responseObj[@"data"] intValue] == 0){
                    
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"关注好友"] forState:UIControlStateNormal];
                    
                }else{
                    
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"个人主页被关注"] forState:UIControlStateNormal];
                }
                
                self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.fansLabel.text intValue] - 1];
                
                _attentStatus = NO;
                
            }else{
                
                if ([responseObj[@"data"] intValue] == 1) {
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已互为好友，可以免费无限畅聊了~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                    
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"互为好友"] forState:UIControlStateNormal];
                    
                }else{
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已关注成功！互为好友即可免费畅聊~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
                }
                
                self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.fansLabel.text intValue] + 1];
                _attentStatus = YES;
                [button setTitle:@"已关注" forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            }
        }
    } failed:^(NSString *errorMsg) {
        button.userInteractionEnabled = NO;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
    }];
}

//点击去开通按钮跳转到会员页面
-(void)stampOpenSvipButtonClick{
    
    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
    
    [self.navigationController pushViewController:mvc animated:YES];
}

//关注按钮
-(void)attentButtonClickState:(BOOL)state{

    if (state) {
        _url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setoverfollow];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消关注此人"    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [self blackData];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
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

//查看加入的群组
- (IBAction)groupButtonClick:(id)sender {
    LDGroupNumberViewController *nvc = [[LDGroupNumberViewController alloc] init];
    nvc.userId = self.userID;
    [self.navigationController pushViewController:nvc animated:YES];
}

/**
 关注好友 / 取消关注好友
 */
-(void)blackData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.userID};
    
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
                if ([responseObj[@"data"] intValue] == 0){
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"关注好友"] forState:UIControlStateNormal];
                }else{
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"个人主页被关注"] forState:UIControlStateNormal];
                }
                self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.fansLabel.text intValue] - 1];
                _attentStatus = NO;
            }else{
                if ([responseObj[@"data"] intValue] == 1) {
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已互为好友，可以免费无限畅聊了~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                    self.followState = @"3";
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"互为好友"] forState:UIControlStateNormal];
                }else{
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已关注成功！互为好友即可免费畅聊~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
                }
                self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.fansLabel.text intValue] + 1];
                _attentStatus = YES;
            }
        }
    } failed:^(NSString *errorMsg) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
    }];
}

-(void)createPasswordView:(NSInteger)imgTag{

    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.layer.cornerRadius = 2;
    _backgroundView.clipsToBounds = YES;
    [self.navigationController.view addSubview:_backgroundView];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0.35;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    [shadowView addGestureRecognizer:tap];
    [_backgroundView addSubview:shadowView];
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(50, HEIGHT/2 - 60, WIDTH - 100, 120)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 2;
    alertView.clipsToBounds = YES;
    [_backgroundView addSubview:alertView];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, WIDTH - 120, 35)];
    _passwordField.placeholder = @"请输入相册密码";
    _passwordField.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    _passwordField.font = [UIFont systemFontOfSize:14];
    _passwordField.delegate = self;
    [alertView addSubview:_passwordField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, WIDTH - 100, 1)];
    
    lineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    
    [alertView addSubview:lineView];
    
    UIButton *alertButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, WIDTH - 100, 35)];
    
    [alertButton addTarget:self action:@selector(alertButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    alertButton.tag = imgTag;
    
    [alertButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [alertButton setTitleColor:MainColor forState:UIControlStateNormal];
    
    [alertView addSubview:alertButton];
}

//收回键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

-(void)alertButtonClick:(UIButton *)button{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/chargePhotoPwd"];
    
    NSDictionary *parameters = @{@"uid":self.userID,@"photo_pwd":_passwordField.text};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];

        if (integer != 2000) {
            
            [_backgroundView removeFromSuperview];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"密码错误"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [self createPasswordView:button.tag];
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
            [_backgroundView removeFromSuperview];
            __weak typeof(self) weakSelf=self;
            [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:button.tag - 10 imagesBlock:^NSArray *{
                return weakSelf.picArray;
            }];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"因网络等原因修改失败"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [_backgroundView removeFromSuperview];
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];

}

-(void)cancelClick{
    
    [_passwordField resignFirstResponder];

    [_backgroundView removeFromSuperview];
}

-(void)tapPic:(UITapGestureRecognizer *)tap{
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        UIImageView *img = (UIImageView *)tap.view;
        
        __weak typeof(self) weakSelf = self;
        
        [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:img.tag - 10 imagesBlock:^NSArray *{
            
            return weakSelf.picArray;
        }];

    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1 || [_followState intValue] == 3||[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue] == 1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[self.userID intValue]) {
            if ([_lock intValue] == 2) {
                UIImageView *img = (UIImageView *)tap.view;
                [self createPasswordView:img.tag];
            }else{
                UIImageView *img = (UIImageView *)tap.view;
                __weak typeof(self) weakSelf=self;
                [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:img.tag - 10 imagesBlock:^NSArray *{
                    return weakSelf.picArray;
                }];
            }
        }else{
            if ([self.photo_rule isEqualToString:@"1"]) {
               
                [self toshowAlertwithtype:@"0"];

            }
            else
            {
                //需要密码
                if ([_lock intValue] == 2) {
                    UIImageView *img = (UIImageView *)tap.view;
                    [self createPasswordView:img.tag];
                }else{
                    UIImageView *img = (UIImageView *)tap.view;
                    __weak typeof(self) weakSelf=self;
                    [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:img.tag - 10 imagesBlock:^NSArray *{
                        return weakSelf.picArray;
                    }];
                }
            }
            
        }
        
        
    }
}


- (IBAction)recordButtonClick:(id)sender {
    
    RecordViewController *rvc = [[RecordViewController alloc] init];
    
    rvc.mediaString = _mediaStrng;
    
    [self.navigationController pushViewController:rvc animated:YES];
}

- (IBAction)playButtonClick:(id)sender {
    
    if (_audioPlayer == nil) {
        
        self.audioPlayer = [self myAudioPlayer];
        
        [self addDistanceNotification];
        [self setAudioSessionPlay];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [_playButton setBackgroundImage:[UIImage imageNamed:@"正在播放"] forState:UIControlStateNormal];
        
        [self.audioPlayer play];
        
        //播放完毕发出通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }else{
    
        if (_audioPlayer.rate == 1) {
            
            [_playButton setBackgroundImage:[UIImage imageNamed:@"播放暂停"] forState:UIControlStateNormal];
            
            [_audioPlayer pause];
            
        }else if (_audioPlayer.rate == 0){
            
            [_playButton setBackgroundImage:[UIImage imageNamed:@"正在播放"] forState:UIControlStateNormal];
            
            [_audioPlayer play];
        }

    }
}

/**
 *  设置音频会话
 */
-(void)setAudioSessionPlay{
    
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

-(void)playDidFinish{
    
    _audioPlayer = nil;
    
    [_playButton setBackgroundImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
    
     [self removeDistanceNotification];
    
    NSLog(@"播放完毕");
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVPlayer *)myAudioPlayer{
    
    NSLog(@"AVPlayer初始化了");
    NSError *error = nil;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (error || _mediaStrng.length == 0) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.playButton.userInteractionEnabled = YES;
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"创建播放器过程中发生错误~"];
        
        NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
        return nil;
        
    }
    
    _audioPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_mediaStrng]]];
    
    return _audioPlayer;
}

/**
 *  添加距离通知
 */
- (void)addDistanceNotification{
    //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}

/**
 *  删除距离通知
 */
- (void)removeDistanceNotification{
    //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}


#pragma mark - 处理近距离监听触发事件
- (void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)//传感器已启动前提条件下，如果用户接近 近距离传感器，此时属性值为YES
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }else{
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (IBAction)giveGifButtonClick:(id)sender {

    BOOL ismines = NO;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[self.userID intValue]) {
        ismines = YES;
    }
    _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:ismines :^{
        LDChargeCenterViewController *cvc = [[LDChargeCenterViewController alloc] init];
        [self.navigationController pushViewController:cvc animated:YES];
    }];
    [_gif getPersonUid:self.userID andSign:@"赠送给某人"andUIViewController:self];
    [self.tabBarController.view addSubview:_gif];

}
- (IBAction)myGifListButtonClick:(id)sender {
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] intValue]) {
        
        LDMyWalletPageViewController *wvc = [[LDMyWalletPageViewController alloc] init];
        
        wvc.type = @"1";
        
        [self.navigationController pushViewController:wvc animated:YES];
        
    }else{
    
        LDLookGifListViewController *lvc = [[LDLookGifListViewController alloc] init];
        
        lvc.userId = self.userID;
        
        [self.navigationController pushViewController:lvc animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (_gif) {
        
        [_gif removeView];
    }
    
    if (_stampView) {
        
        [_stampView removeView];
    }
    
    if (_audioPlayer != nil) {
        
        [self playDidFinish];
        
    }
}

- (IBAction)inageButtonClick:(id)sender {
    
    [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:0 imagesBlock:^NSArray *{
        NSArray *array = [NSArray arrayWithObject:self.headImageView.image];
        return array;
    }];
}

#pragma mark - 是否展示图片
-(void)chooseshowphotoLeftClick
{
    self.islockPhoto = NO;
    UIButton *btn0 = [self.tableView viewWithTag:101];
    UIButton *btn1 = [self.tableView viewWithTag:102];
    [btn0 setImage:[UIImage imageNamed:@"照片认证实圈"] forState:normal];
    [btn1 setImage:[UIImage imageNamed:@"照片认证空圈"] forState:normal];
    [self.tableView reloadData];
}

-(void)chooseshowphotoRightClick
{
    self.islockPhoto = YES;
    UIButton *btn0 = [self.tableView viewWithTag:101];
    UIButton *btn1 = [self.tableView viewWithTag:102];
    [btn0 setImage:[UIImage imageNamed:@"照片认证空圈"] forState:normal];
    [btn1 setImage:[UIImage imageNamed:@"照片认证实圈"] forState:normal];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
