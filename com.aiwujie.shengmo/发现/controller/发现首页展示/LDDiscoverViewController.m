//
//  LDDiscoverViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDDiscoverViewController.h"
#import "LDAlwaysQuestionH5ViewController.h"
#import "LDModalH5ViewController.h"
#import "LDStandardViewController.h"
#import "LDHelpCenterViewController.h"
#import "LDBindingPhoneNumViewController.h"
#import "LDCertificateBeforeViewController.h"
#import "PersonChatViewController.h"
#import "LDCertificateViewController.h"
#import "LDBulletinViewController.h"
#import "LDMapViewController.h"
#import "LDGroupSpuareViewController.h"
#import "LDShengMoViewController.h"
#import "ShowBadgeCell.h"
#import "LDMatchmakerViewController.h"
#import "LDAboutShengMoViewController.h"
#import "LDSoundControlViewController.h"
#import "HeaderTabViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDDynamicDetailViewController.h"


@interface LDDiscoverViewController ()<SDCycleScrollViewDelegate>

//九宫格的图片名称数组
@property (nonatomic,strong) NSArray *dataArray;

//话题的数组
@property (nonatomic,strong) NSMutableArray *topicArray;

//广告展示的数组数据
@property (nonatomic,strong) UIView *advView;
@property (nonatomic,strong) NSMutableArray *slideArray;

//定位
@property (nonatomic,strong) CLLocationManager *locationManager;

//底部滚动的scrollView
@property (nonatomic,strong) UIScrollView * scrollView;

//客服的数组
@property (nonatomic,strong) NSMutableArray *serviceArray;

//官方公告的数组
@property (nonatomic,strong) NSMutableArray *viewTitleArray;

//常见问题的数组
@property (nonatomic,strong) NSMutableArray *viewTitleArray1;

@end

@implementation LDDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[@"绿色斯慕",@"志愿者",@"全职招聘",@"关于圣魔",@"圣魔文化节",@"创始人"];
    _topicArray = [NSMutableArray array];
    _serviceArray = [NSMutableArray array];
    _slideArray = [NSMutableArray array];
    //判断视图顶部是否有广告栏
    [self createHeadData];
}

/**
 * 判断视图顶部是否有广告栏
 */
-(void)createHeadData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getSlideMore"];
    NSDictionary *parameters = @{@"type":@"3"};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            [_slideArray addObjectsFromArray:responseObj[@"data"]];
        }
        //获取客服的数据
        [self createServiceData];
    } failed:^(NSString *errorMsg) {
        //获取客服的数据
        [self createServiceData];
    }];
}



/**
 * 获取客服的数据
 */
-(void)createServiceData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Index/getServiceInfo"];
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            [_serviceArray addObjectsFromArray:responseObj[@"data"]];
            [self createPublishGood];
        }else{
            [self createPublishGood];
        }
    } failed:^(NSString *errorMsg) {
         [self createPublishGood];
    }];
}

/**
 * 搭建首页展示的视图
 */
-(void)createPublishGood{
    
    if (_scrollView != nil) {
        
        [_scrollView removeFromSuperview];
        
        _scrollView = nil;
    }

    //创建底层的滑动视图
   _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
    
    _scrollView.showsVerticalScrollIndicator = NO;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (@available(iOS 11.0, *)) {
        
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:_scrollView];
    
    if (_slideArray.count == 0) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
        [_scrollView addSubview:headView];
        
        //创建9宫格
        [self createGridView:headView];
        
    }else{
        
        CGFloat headRatio = 0.4;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH * headRatio)];
        [_scrollView addSubview:headView];
        
        NSMutableArray *pathArray = [NSMutableArray array];
        
        for (NSDictionary *dic in _slideArray) {
            
            [pathArray addObject:dic[@"path"]];
            
        }
        
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, headView.frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.imageURLStringsGroup = pathArray;
        cycleScrollView.autoScrollTimeInterval = 3.0;
        [headView addSubview:cycleScrollView];
        
        //创建9宫格
        [self createGridView:headView];
    }
    
}

/** 点击图片回调 */
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
 * 创建九宫格
 */
-(void)createGridView:(UIView *)headImageView{

    //大间距
    CGFloat bigSpace = 4;
    //方块总数
    CGFloat totleNum = 9;
    //每行的个数
    int number = 3;
    //每个小块的间距
    CGFloat space = 1;
    //每个小块的宽
    CGFloat itemW = (WIDTH - 2)/3;
    //每个小块的高
    CGFloat itemH = (WIDTH - 2)/3 - 20;
    
    //存储最后一个item的最大y值
    CGFloat lastItemY;
    
    NSArray *itemArray = @[@"公益绿色斯慕",@"公益志愿者",@"公益全职招聘",@"公益关于圣魔斯慕",@"公益圣魔文化节",@"公益创始人",@"公益图文规范",@"公益绑定手机",@"公益自拍认证"];
    
    for (int i = 0; i < totleNum; i++) {
        
        //每个模块的在第几列
        int itemX = i%number;
        //每个模块在第几行
        int itemY = i/number;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(itemX * space + itemX * itemW, CGRectGetMaxY(headImageView.frame) + bigSpace + itemY * itemH + itemY *space, itemW, itemH)];
        backView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:backView];
        
        //展示9宫格的图片
        UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake((itemW - itemH)/2, 0, itemH, itemH)];
        itemImageView.image = [UIImage imageNamed:itemArray[i]];
        [backView addSubview:itemImageView];
        
        //添加按钮使其可点击
        UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH)];
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = 10 + i;
        [backView addSubview:itemButton];
        
        if (i == totleNum - 1) {
            
            lastItemY = CGRectGetMaxY(backView.frame);
            
            //创建话题的view
            [self createTopicView:lastItemY andBigSpace:bigSpace];
            
        }
    }
}

/**
 * 创建话题的view
 */
-(void)createTopicView:(CGFloat)lastItemY andBigSpace:(CGFloat)bigSpace{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSDictionary *parameters = @{@"pid":@"7"};
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/getTopicEight"];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            //创建一些介绍的view
            [self createIntrofuceView:lastItemY andBigSpace:bigSpace];
            
        }else {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                [_topicArray addObject:dic];
            }
            
            CGFloat btnX = 5;
            
            NSArray *colorArray = @[@"0xff0000",@"0xb73acb",@"0x0000ff",@"0x18a153",@"0xf39700",@"0xff00ff",@"0x00a0e9"];
            
            UIScrollView *topicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lastItemY + bigSpace, WIDTH, 44)];
            
            topicScrollView.backgroundColor = [UIColor whiteColor];
            
            topicScrollView.showsHorizontalScrollIndicator = NO;
            
            [_scrollView addSubview:topicScrollView];
            
            UIImageView *recommendView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
            recommendView.image = [UIImage imageNamed:@"官方话题"];
            [topicScrollView addSubview:recommendView];
            
            for (int i = 0; i < [_topicArray count]; i++) {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
                
                [btn setTitle:[NSString stringWithFormat:@"#%@#",_topicArray[i][@"title"]] forState:UIControlStateNormal];
                [btn setTitleColor:UIColorFromRGB(strtoul([colorArray[i%7] UTF8String], 0, 0)) forState:UIControlStateNormal];
                btn.tag = 100 + i;
                
                [btn addTarget:self action:@selector(btnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                //重要的是下面这部分哦！
                CGSize titleSize = [[NSString stringWithFormat:@"#%@#",_topicArray[i][@"title"]] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
                
                titleSize.height = 44;
                titleSize.width += 20;
                
                btn.frame = CGRectMake(btnX + 40, 0, titleSize.width, titleSize.height);
                
                btnX = btnX + titleSize.width;
                
                if (i == [responseObject[@"data"] count] - 1) {
                    
                    topicScrollView.contentSize = CGSizeMake(btnX + 10 + 40, 44);
                    
                    //创建一些介绍的view
                    [self createIntrofuceView:CGRectGetMaxY(topicScrollView.frame) andBigSpace:bigSpace];
                }
                
                [topicScrollView addSubview:btn];
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //创建一些介绍的view
        [self createIntrofuceView:lastItemY andBigSpace:bigSpace];
        
    }];

}

/**
 * 创建官方公告,常见问题的view
 */
-(void)createIntrofuceView:(CGFloat)lastItemY andBigSpace:(CGFloat)bigSpace{

    UIView *introduceView = [[UIView alloc] init];
    introduceView.hidden = YES;
    [_scrollView addSubview:introduceView];
    
    CGFloat viewInSpaceX = 15;
    CGFloat viewInSpaceY = 8;
    CGFloat picH = 80;
    CGFloat picW = 120;
    CGFloat viewH = 2 * viewInSpaceY + picH;
    CGFloat viewSpace = 1;
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Index/getBasicNews"];
    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];

        if (integer != 2000) {
            
           [self createAlwaysQuestionWithView:introduceView andViewH:viewH andViewMaxY:0 andViewSpace:viewSpace andViewInSpaceX:viewInSpaceX andLastItemY:lastItemY andBigSpace:bigSpace andHaveData:NO];
            
        }else {
            
            _viewTitleArray = [NSMutableArray array];
            
            [_viewTitleArray addObjectsFromArray:responseObject[@"data"]];
            
            NSInteger num1 = _viewTitleArray.count;
            
            CGFloat viewMaxY = 0;
            
            for (int i = 0; i < num1; i++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i * viewH + i * viewSpace, WIDTH, viewH)];
                view.backgroundColor = [UIColor whiteColor];
                
                UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - picW - viewInSpaceX, viewInSpaceY, picW, picH)];
                [pic sd_setImageWithURL:[NSURL URLWithString:_viewTitleArray[i][@"pic"]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
                [view addSubview:pic];
                
                UILabel *dogLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewInSpaceX, 0, viewInSpaceX, viewH)];
                dogLabel.text = @"●";
                dogLabel.font = [UIFont systemFontOfSize:8];
                dogLabel.textColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
                [view addSubview:dogLabel];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2 * viewInSpaceX - 5, viewInSpaceY, WIDTH - 4 * viewInSpaceX + 5 - picW, viewH - 2 * viewInSpaceY)];
                label.text = _viewTitleArray[i][@"title"];
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = TextCOLOR;
                [view addSubview:label];
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                button.tag = 100 + i;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                
                [introduceView addSubview:view];
                
                if (i == num1 - 1) {
                    
                    viewMaxY = CGRectGetMaxY(view.frame);
                    
                    [self createAlwaysQuestionWithView:introduceView andViewH:viewH andViewMaxY:viewMaxY andViewSpace:viewSpace andViewInSpaceX:viewInSpaceX andLastItemY:lastItemY andBigSpace:bigSpace andHaveData:YES];
                    
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self createAlwaysQuestionWithView:introduceView andViewH:viewH andViewMaxY:0 andViewSpace:viewSpace andViewInSpaceX:viewInSpaceX andLastItemY:lastItemY andBigSpace:bigSpace andHaveData:NO];
        
    }];

}

/**
 * 创建常见问题
 */
-(void)createAlwaysQuestionWithView:(UIView *)introduceView andViewH:(CGFloat)viewH andViewMaxY:(CGFloat)viewMaxY andViewSpace:(CGFloat)viewSpace andViewInSpaceX:(CGFloat)viewInSpaceX andLastItemY:(CGFloat)lastItemY andBigSpace:(CGFloat)bigSpace andHaveData:(BOOL)isHave{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Index/getQuestions"];
    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
  
        if (integer != 2000) {
            
            introduceView.hidden = NO;
            
            if (isHave) {
                
                introduceView.frame = CGRectMake(0, lastItemY + bigSpace, WIDTH, viewMaxY);
                
            }else{
            
                introduceView.frame = CGRectMake(0, lastItemY, WIDTH, 0);
                
            }
            
            //创建客服的view
            [self createServiceView:CGRectGetMaxY(introduceView.frame) andBigSpace:bigSpace];
            
        }else {
            
            introduceView.hidden = NO;
            
            _viewTitleArray1 = [NSMutableArray array];
            
            [_viewTitleArray1 addObjectsFromArray:responseObject[@"data"]];
            
            NSInteger num2 = _viewTitleArray1.count;
       
            CGFloat viewItemW = (WIDTH - 1)/2;
            CGFloat viewItemH = viewH/2 + 10;
            CGFloat view2MaxY = 0;
            
            for (int j = 0; j < num2; j++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(j%2 * viewItemW + j%2 * viewSpace, viewMaxY + viewSpace + j/2 * viewItemH + j/2 * viewSpace, viewItemW, viewItemH)];
                view.backgroundColor = [UIColor whiteColor];
                
                UILabel *dogLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewInSpaceX, 0, viewInSpaceX, viewItemH)];
                dogLabel.text = @"●";
                dogLabel.font = [UIFont systemFontOfSize:8];
                dogLabel.textColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
                [view addSubview:dogLabel];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2 * viewInSpaceX - 5, 0, viewItemW - 3 * viewInSpaceX + 5, viewItemH)];
                label.text = _viewTitleArray1[j][@"title"];
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = TextCOLOR;
                [view addSubview:label];
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                button.tag = 200 + j;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                
                [introduceView addSubview:view];
                
                if (j == num2 - 1) {
                    
                    view2MaxY = CGRectGetMaxY(view.frame);
                }
            }
            
            introduceView.frame = CGRectMake(0, lastItemY + bigSpace, WIDTH, view2MaxY);
            
            //创建客服的view
            [self createServiceView:CGRectGetMaxY(introduceView.frame) andBigSpace:bigSpace];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        introduceView.hidden = NO;
        
        if (isHave) {
            
            introduceView.frame = CGRectMake(0, lastItemY + bigSpace, WIDTH, viewMaxY);
            
        }else{
            
            introduceView.frame = CGRectMake(0, lastItemY, WIDTH, 0);

        }

        //创建客服的view
        [self createServiceView:CGRectGetMaxY(introduceView.frame) andBigSpace:bigSpace];
        
    }];
}

/**
 * 官方公告,常见问题点击
 */
-(void)buttonClick:(UIButton *)button{
    
    LDAlwaysQuestionH5ViewController *avc = [[LDAlwaysQuestionH5ViewController alloc] init];
    
    if (button.tag >= 100 && button.tag < 200) {
        
        if ([_viewTitleArray[button.tag - 100][@"url"] length] == 0) {
            
            
            avc.url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Info/news/id/",_viewTitleArray[button.tag - 100][@"id"]];
            
        }else{
            
            avc.url = _viewTitleArray[button.tag - 100][@"url"];
        }
        
    }else{
        
        if ([_viewTitleArray1[button.tag - 200][@"url"] length] == 0) {
            
    
             avc.url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Info/news/id/",_viewTitleArray1[button.tag - 200][@"id"]];
            
        }else{
            
            avc.url = _viewTitleArray1[button.tag - 200][@"url"];
        }
    }
    
    avc.title = @"圣魔斯慕";
    
    [self.navigationController pushViewController:avc animated:YES];
}

/**
 * 点击话题文字的响应事件
 */
-(void)btnButtonClick:(UIButton *)button{
    
    HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
    
    tvc.tid = [NSString stringWithFormat:@"%@",_topicArray[button.tag%100][@"tid"]];
    
    [self.navigationController pushViewController:tvc animated:YES];
}

/**
 * 点击九宫格按钮的响应事件
 */
-(void)itemButtonClick:(UIButton *)button{
    
    if (button.tag == 10) {
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        mvc.name = _dataArray[button.tag - 10];
        mvc.type = @"3";
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if (button.tag == 11){
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        mvc.name = _dataArray[button.tag - 10];
        mvc.type = @"2";
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if (button.tag == 12){
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        mvc.name = _dataArray[button.tag - 10];
        mvc.type = @"1";
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if (button.tag == 13){
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        mvc.name = _dataArray[button.tag - 10];
        mvc.state = @"2";
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if (button.tag == 14){
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        mvc.name = _dataArray[button.tag - 10];
        mvc.state = @"3";
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if (button.tag == 15){
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        mvc.name = _dataArray[button.tag - 10];
        mvc.state = @"4";
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if (button.tag == 16){
        
//        LDStandardViewController *svc = [[LDStandardViewController alloc] init];
//        svc.navigationItem.title = @"图文规范";
//        svc.state = @"图文规范";
//        [self.navigationController pushViewController:svc animated:YES];
        
        LDHelpCenterViewController *hcvc = [[LDHelpCenterViewController alloc] init];
        
        [self.navigationController pushViewController:hcvc animated:YES];
        
    }else if (button.tag == 17){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getBindingState"];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            //NSLog(@"%@",responseObject);
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
            }else{
                
                NSString *phoneNum;
                
                if ([responseObject[@"data"][@"mobile"] length] == 0) {
                    
                    phoneNum = @"";
                    
                }else{
                    
                    phoneNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mobile"]];
                }
                
                LDBindingPhoneNumViewController * pvc = [[LDBindingPhoneNumViewController alloc] init];
                
                pvc.phoneNum = phoneNum;
                
                [self.navigationController pushViewController:pvc animated:YES];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
        
        
    }else if (button.tag == 18){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getidstate"];
        
        NSDictionary *parameters;
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (integer == 2000) {
                
                LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                
                cvc.type = @"2";
                
                [self.navigationController pushViewController:cvc animated:YES];
                
            }else if(integer == 2001){
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"正在审核中,请耐心等待~"];
                
            }else if (integer == 2002){
                
                LDCertificateBeforeViewController *cvc = [[LDCertificateBeforeViewController alloc] init];
                
                cvc.where = @"5";
                
                [self.navigationController pushViewController:cvc animated:YES];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"%@",error);
            
        }];
        
    }
}

/**
 * 创建客服模块
 */
-(void)createServiceView:(CGFloat)lastItemY andBigSpace:(CGFloat)bigSpace{

    UIView *serviceView = [[UIView alloc] init];
    serviceView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:serviceView];

    //客服个数
    int serviceNum = 4;
    //客服之间的间距
    CGFloat space = 20;
    //左边距
    CGFloat leftSpace = 30;
    //按钮大小
    CGFloat serviceW = (WIDTH - 2 * leftSpace - (serviceNum - 1) * space)/serviceNum;
    CGFloat serviceH = serviceW;
    //距离按钮的y值
    CGFloat serviceY = 13;
    
    for (int i = 0; i < serviceNum; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(leftSpace + serviceW * i + space * i, serviceY, serviceW, serviceH)];
        button.layer.cornerRadius = serviceW/2;
        button.clipsToBounds = YES;
        button.tag = 20 + i;
        [button addTarget:self action:@selector(serviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i + 1 <= _serviceArray.count) {
            
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:_serviceArray[i][@"head_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"红娘未知图片"]];
            
        }else{
            
            [button setBackgroundImage:[UIImage imageNamed:@"红娘未知图片"] forState:UIControlStateNormal];
            
        }
    
        [serviceView addSubview:button];
        
        UIImageView *vipView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x + serviceW - 20,button.frame.origin.y + serviceW - 20, 20, 20)];
        vipView.image = [UIImage imageNamed:@"官方认证"];
        [serviceView addSubview:vipView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + serviceW * i + space * i, CGRectGetMaxY(button.frame) + 2, serviceW, 16)];
        
        if (i + 1 <= _serviceArray.count) {
            
            label.text = _serviceArray[i][@"nickname"];
            
        }else{
            
            label.text = @"斯慕客服";
        }
        
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        
        label.textAlignment = NSTextAlignmentCenter;
        [serviceView addSubview:label];
        
        if (i == serviceNum - 1) {
            
            UIView *contactView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 13, WIDTH - 20, 30)];
            contactView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
            contactView.layer.cornerRadius = 2;
            contactView.clipsToBounds = YES;
            [serviceView addSubview:contactView];
            
            NSArray *contactArray = @[@"公益微信QQ",@"公益座机",@"公益手机号"];

            //图片的比例
            CGFloat contactP = 0.18;
            //联系方式view的width
            CGFloat contactW = contactView.frame.size.width;
            //联系方式view的height
            CGFloat contactH = contactView.frame.size.height;
            //距离左边界的距离
            CGFloat contactLeftX = 10;
            //每个联系方式的距离
            CGFloat contactSpace = 5;
            //每个联系方式的width
            CGFloat contactButtonW = (contactW - 2 * contactLeftX - (contactArray.count - 1) * contactSpace)/3;
            
            for (int j = 0; j < contactArray.count; j++) {
                
                UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(contactLeftX + j * contactSpace + j * contactButtonW, (contactH - contactButtonW * contactP)/2, contactButtonW, contactButtonW * contactP)];
                contactButton.tag = 100 + j;
                [contactButton setBackgroundImage:[UIImage imageNamed:contactArray[j]] forState:UIControlStateNormal];
                [contactButton addTarget:self action:@selector(contactButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [contactView addSubview:contactButton];
                
            }
            
            UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contactView.frame) + 13, WIDTH, 15)];
            warnLabel.alpha = 0.5;
            warnLabel.text = @"中国多元人群健康公益交流平台";
            warnLabel.textColor = UIColorFromRGB(strtoul([@"0x707070" UTF8String], 0, 0));
            warnLabel.textAlignment = NSTextAlignmentCenter;
            warnLabel.font = [UIFont systemFontOfSize:12];
            [serviceView addSubview:warnLabel];
            
            UILabel *warnLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(warnLabel.frame) + 10, WIDTH, 15)];
            warnLabel1.alpha = 0.5;
            warnLabel1.text = @"北京市通州区疾控中心合作单位";
            warnLabel1.textColor = UIColorFromRGB(strtoul([@"0x707070" UTF8String], 0, 0));
            warnLabel1.textAlignment = NSTextAlignmentCenter;
            warnLabel1.font = [UIFont systemFontOfSize:12];
            [serviceView addSubview:warnLabel1];
            
            UILabel *otherWarnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(warnLabel1.frame) + 8, WIDTH, 15)];
            otherWarnLabel.alpha = 0.5;
            otherWarnLabel.text = @"京ICP备:16047950号  京公网安备:11010502034234";
            otherWarnLabel.textColor = UIColorFromRGB(strtoul([@"0x707070" UTF8String], 0, 0));
            otherWarnLabel.textAlignment = NSTextAlignmentCenter;
            otherWarnLabel.font = [UIFont systemFontOfSize:12];
            [serviceView addSubview:otherWarnLabel];
            
            serviceView.frame = CGRectMake(0, lastItemY + bigSpace, WIDTH, CGRectGetMaxY(otherWarnLabel.frame) + 60);
            
            _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(serviceView.frame));
        }
        
    }

}

/**
 * 点击客服按钮与客服聊天
 */
-(void)serviceButtonClick:(UIButton *)button{

    if (button.tag - 19 <= _serviceArray.count) {
        
//        PersonChatViewController *conversationVC = [[PersonChatViewController alloc]init];
//        conversationVC.conversationType = ConversationType_PRIVATE;
//        conversationVC.targetId = [NSString stringWithFormat:@"%@",_serviceArray[button.tag - 20][@"uid"]];
//        conversationVC.mobile = [NSString stringWithFormat:@"%@",_serviceArray[button.tag - 20][@"uid"]];
//        conversationVC.title = [NSString stringWithFormat:@"%@",_serviceArray[button.tag - 20][@"nickname"]];
//        //conversationVC.unReadMessage = model.unreadMessageCount;
//        conversationVC.enableUnreadMessageIcon = YES;
//        [self.navigationController pushViewController:conversationVC animated:YES];
        
        LDOwnInformationViewController *InfoVC = [LDOwnInformationViewController new];
        InfoVC.userID = [NSString stringWithFormat:@"%@",_serviceArray[button.tag - 20][@"uid"]];
        [self.navigationController pushViewController:InfoVC animated:YES];
        
    }else{
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"客服未在线,请选择其他客服或电话联系我们~"];
        
    }
}

/**
 * 点击联系方式按钮的响应事件
 */
-(void)contactButtonClick:(UIButton *)button{
    
    if (button.tag == 101) {
        
        UIWebView *webView = [[UIWebView alloc]init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"010-56405100"]];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
        
    }else if (button.tag == 102){
    
        UIWebView *webView = [[UIWebView alloc]init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"13436537298"]];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
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
