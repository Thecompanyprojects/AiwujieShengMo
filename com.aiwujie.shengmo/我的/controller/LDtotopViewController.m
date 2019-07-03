//
//  LDtotopViewController.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDtotopViewController.h"
#import "LdtotopCell.h"
#import "LdtopHeaderView.h"
#import "LDDetailPageViewController.h"
#import "YQInAppPurchaseTool.h"
#import "LDBillPresenter.h"


@interface LDtotopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YQInAppPurchaseToolDelegate>
{
    MBProgressHUD *hud;
}
@property (nonatomic,strong)  UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *shopArray;
@property (nonatomic,copy) NSString *numberStr;
@property (nonatomic,strong) LdtopHeaderView *headView;
@property (nonatomic,strong) UILabel *messageLab;
@end

static NSString *ldtopidentfid = @"ldtopidentfid";

static float AD_height = 180;//头部高度

#define W_screen [UIScreen mainScreen].bounds.size.width/375.0

@implementation LDtotopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动态推顶";
//    self.shopArray = [NSMutableArray arrayWithObjects:@"topcard1",@"topcard2",@"topcard3",@"topcard4",@"topcard5",@"topcard6", nil];
     self.shopArray = [NSMutableArray arrayWithObjects:@"topcard11",@"topcard12",@"topcard13",@"topcard14",@"topcard15",@"topcard16", nil];
    //获取单例
    YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
    //设置代理
    IAPTool.delegate = self;
    //购买后，向苹果服务器验证一下购买结果。默认为YES。不建议关闭
    IAPTool.CheckAfterPay = NO;
    //向苹果询问哪些商品能够购买
    [IAPTool requestProductsWithProductArray:self.shopArray];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.messageLab];
    [self createRightButton];
    [self createData];
    
    [LDBillPresenter savewakketNum];
}

-(void)createData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *url = [PICHEADURL stringByAppendingString:getTopcardPageInfo];
    NSDictionary *para = @{@"uid":uid?:@""};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            self.numberStr = [data objectForKey:@"wallet_topcard"];
           
        }
        [self.headView setTextFromurl:self.numberStr?:@"0"];
        [self.collectionView reloadData];
 
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)createRightButton{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setTitle:@"明细" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonOnClic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - 创建collectionView并设置代理

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        CGFloat naviBottom = HEIGHT;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeMake(WIDTH, AD_height);//头部大小
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, naviBottom - 50) collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = YES;
        flowLayout.itemSize = CGSizeMake(106*W_screen, 100*W_screen); 
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumLineSpacing = 14;
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(12, 16*W_screen, 2, 16*W_screen);//上左下右
        //注册cell和ReusableView（相当于头部）
        [_collectionView registerClass:[LdtotopCell class] forCellWithReuseIdentifier:ldtopidentfid];
        [_collectionView registerClass:[LdtopHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LdtotopCell *cell = (LdtotopCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ldtopidentfid forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cell setDatafromIndex:indexPath.item];
    return cell;
}

#pragma mark 头部显示的内容

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                        UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    self.headView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
    return self.headView;
}

#pragma mark UICollectionView被选中时调用的方法

//点击选定
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LdtotopCell *cell = (LdtotopCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = MainColor.CGColor;
    NSLog(@"第%ld区，第%ld个",(long)indexPath.section,(long)indexPath.row);
    UIAlertController *control = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *shopId = [self.shopArray objectAtIndex:indexPath.item];
        
        [[YQInAppPurchaseTool defaultTool]buyProduct:shopId];

        hud = [MBProgressHUD showActivityMessage:@"购买中..."];
        
    }];
    [control addAction:action0];
    [control addAction:action1];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        [action0 setValue:MainColor forKey:@"_titleTextColor"];
        [action1 setValue:MainColor forKey:@"_titleTextColor"];
    }
    [self presentViewController:control animated:YES completion:nil];
}

//取消选定
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    LdtotopCell *cell = (LdtotopCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    NSLog(@"1第%ld区，1第%ld个",(long)indexPath.section,(long)indexPath.row);
}

#pragma mark - RightBtn

-(void)rightButtonOnClic
{
    LDDetailPageViewController *VC = [LDDetailPageViewController new];
    VC.index = 3;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark --------YQInAppPurchaseToolDelegate
//IAP工具已获得可购买的商品
-(void)IAPToolGotProducts:(NSMutableArray *)products {
    NSLog(@"GotProducts:%@",products);
    
}

//支付失败/取消
-(void)IAPToolCanceldWithProductID:(NSString *)productID {
    NSLog(@"canceld:%@",productID);
    [hud hide:YES];
    [MBProgressHUD showMessage:@"取消购买"];
   
}

//支付成功了，并开始向苹果服务器进行验证（若CheckAfterPay为NO，则不会经过此步骤）
-(void)IAPToolBeginCheckingdWithProductID:(NSString *)productID {
    NSLog(@"BeginChecking:%@",productID);
    
    //[SVProgressHUD showWithStatus:@"购买成功，正在验证购买"];
    
    
}
//商品被重复验证了
-(void)IAPToolCheckRedundantWithProductID:(NSString *)productID {
    NSLog(@"CheckRedundant:%@",productID);
    
}
//商品完全购买成功且验证成功了。（若CheckAfterPay为NO，则会在购买成功后直接触发此方法）
-(void)IAPToolBoughtProductSuccessedWithProductID:(NSString *)productID
                                          andInfo:(NSDictionary *)infoDic {
    NSLog(@"BoughtSuccessed:%@",productID);
    NSLog(@"successedInfo:%@",infoDic);

    NSString *receipt = [infoDic objectForKey:@"receipe"];
    NSString *order = [infoDic objectForKey:@"order"];
    NSString *url = [PICHEADURL stringByAppendingString:topcard_ioshooks];

    NSDictionary *parameters = @{@"receipt":receipt?:@"",@"order_no":order?:@"",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [hud hide:YES];
            [MBProgressHUD showMessage:@"购买失败"];
        }else{
            [hud hide:YES];
            [MBProgressHUD showMessage:@"购买成功"];
            [self createData];
        }
    } failed:^(NSString *errorMsg) {
        [hud hide:YES];
        [MBProgressHUD showMessage:@"服务器验证失败"];
    }];
}

//商品购买成功了，但向苹果服务器验证失败了
//2种可能：
//1，设备越狱了，使用了插件，在虚假购买。
//2，验证的时候网络突然中断了。（一般极少出现，因为购买的时候是需要网络的）
-(void)IAPToolCheckFailedWithProductID:(NSString *)productID
                               andInfo:(NSData *)infoData {
    NSLog(@"CheckFailed:%@",productID);

    [hud hide:YES];
    [MBProgressHUD showMessage:@"服务器验证失败"];
}

//恢复了已购买的商品（仅限永久有效商品）
-(void)IAPToolRestoredProductID:(NSString *)productID {
    NSLog(@"Restored:%@",productID);
}

//内购系统错误了
-(void)IAPToolSysWrong {
    NSLog(@"SysWrong");

    [hud hide:YES];
    [MBProgressHUD showMessage:@"系统出错了"];
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        if (ISIPHONEX) {
            _messageLab.frame = CGRectMake(20, HEIGHT-34-240-IPHONEXTOPH, WIDTH-40, 32);
        }
        else
        {
            _messageLab.frame = CGRectMake(20, HEIGHT-64-200*W_screen, WIDTH-40, 32);
        }
        _messageLab.textColor = TextCOLOR;
        _messageLab.font = [UIFont systemFontOfSize:13];
        _messageLab.numberOfLines = 0;
        _messageLab.text = @"“推顶卡”可将动态推至最顶部，获得更多浏览、评论、点赞。同时还可以增加相应的魅力值~";
        [_messageLab sizeToFit];
    }
    return _messageLab;
}


@end
