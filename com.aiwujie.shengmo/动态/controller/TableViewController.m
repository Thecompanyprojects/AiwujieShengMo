//
//  TableViewController.m
//  HJTabViewControllerDemo
//
//  Created by haijiao on 2017/3/18.
//  Copyright © 2017年 olinone. All rights reserved.
//

#import "TableViewController.h"
#import "LDDynamicDetailViewController.h"
#import "LDBulletinViewController.h"
#import "DynamicModel.h"
#import "DynamicCell.h"
#import "GifView.h"
#import "LDMyWalletPageViewController.h"
#import "LDChargeCenterViewController.h"
#import "LDPublishDynamicViewController.h"
#import "ImageBrowserViewController.h"
#import "LDOwnInformationViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface TableViewController ()<DynamicDelegate>

@property (nonatomic,assign) int page;
@property (nonatomic,assign) NSInteger integer;

//打赏view
@property (nonatomic,strong) NSArray *picArray;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) DynamicModel *model;
@property (nonatomic,strong) DynamicCell *cell;
@property(nonatomic,strong) NSMutableArray *sectionArray;

@property (nonatomic,strong) NSMutableArray *dataArray;

//礼物界面
@property (nonatomic,strong) GifView *gif;

//保存tableview的偏移量
@property (nonatomic,assign) CGFloat lastScrollOffset;

@property (nonatomic,strong) UIImageView *rocketsView;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    _dataArray = [NSMutableArray array];
    _sectionArray = [NSMutableArray array];
    self.navigationItem.title = @"话题";
    [self createTableView];
    _page = 0;
    [self createDataType:@"1"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createDataType:@"2"];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardSuccess:) name:@"更多打赏成功" object:nil];
    //起始偏移量为0
    self.lastScrollOffset = 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
        
    // 获取开始拖拽时tableview偏移量
    self.lastScrollOffset = self.tableView.contentOffset.y + 40;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y + HEIGHT < self.tableView.contentSize.height + 104) {
            CGFloat y = scrollView.contentOffset.y + 40;
            if (y >= self.lastScrollOffset) {
                //用户往上拖动，也就是屏幕内容向下滚动
               [[NSNotificationCenter defaultCenter] postNotificationName:@"参与话题按钮隐藏" object:nil];
            } else if(y < self.lastScrollOffset){
                //用户往下拖动，也就是屏幕内容向上滚动
                [[NSNotificationCenter defaultCenter] postNotificationName:@"参与话题按钮显示" object:nil];
            }
        }else{
            if (self.lastScrollOffset == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"参与话题按钮显示" object:nil];
            }
        }
    }
}

-(void)rewardSuccess:(NSNotification *)user{
    
    if (_dataArray.count >= [user.userInfo[@"section"] integerValue] + 1){
        DynamicModel *model = _dataArray[[user.userInfo[@"section"] integerValue]];
        model.rewardnum = [NSString stringWithFormat:@"%d",[model.rewardnum intValue] + 1];
        [_dataArray replaceObjectAtIndex:[user.userInfo[@"section"] integerValue] withObject:model];
        _cell.rewardLabel.text = [NSString stringWithFormat:@"%@",model.rewardnum];
    }
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createDataType:(NSString *)type{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getDynamicListNewFiveUrl];
    NSDictionary *parameters;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        if (_index == 0) {
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"type":@"1",@"tid":self.tid,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"tid":self.tid,@"type":@"4",@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }

    }else{
        
        if (_index == 0) {
            
             parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"tid":self.tid,@"type":@"1",@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"tid":self.tid,@"type":@"4",@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }
        
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        _integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (_integer != 2000 && _integer != 2001) {
            if (_integer == 4001 || _integer == 4344) {
                if ([type intValue] == 1) {
                    [_dataArray removeAllObjects];
                    [self.tableView reloadData];
                    self.tableView.mj_footer.hidden = YES;
                    
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
        }else{
            
            if ([type intValue] == 1) {
                
                [_dataArray removeAllObjects];
            }
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[DynamicModel class] json:responseObj[@"data"]]];
            [self.dataArray addObjectsFromArray:data];
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            
        }
    } failed:^(NSString *errorMsg) {
         [self.tableView.mj_footer endRefreshing];
    }];

}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 104) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DynamicCell" bundle:nil] forCellReuseIdentifier:@"DynamicCell"];
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
    [_sectionArray addObject:indexPath];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(DynamicCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    DynamicModel *model = _dataArray[indexPath.section];
    cell.model = model;
}

-(void)headButtonClick:(UIButton *)button{
    DynamicCell *cell = (DynamicCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DynamicModel *model = _dataArray[indexPath.section];
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"DynamicCell" cacheByIndexPath:indexPath configuration:^(DynamicCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}


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

#pragma mark - 点赞 评论 打赏 推顶

-(void)zanTabVClick:(UITableViewCell *)cell
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DynamicModel *model = _dataArray[indexPath.section];
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
    dvc.ownUid = model.did;
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
    [_gif getDynamicDid:model.did andIndexPath:indexPath andSign:@"更多动态"  andUIViewController:self];
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
        
        return 0.1;
    }
    
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
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

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (_gif) {
        
        [_gif removeView];
    }
}

- (IBAction)backButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
