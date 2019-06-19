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

@interface LDtotopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YQInAppPurchaseToolDelegate>
@property (nonatomic,strong)  UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *shopArray;
@end

static NSString *ldtopidentfid = @"ldtopidentfid";

static float AD_height = 150;//头部高度

@implementation LDtotopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动态推顶";
    self.shopArray = [NSMutableArray arrayWithObjects:@"topcard1",@"topcard2",@"topcard3",@"topcard4",@"topcard5",@"topcard6", nil];
    //获取单例
    YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
    //设置代理
    IAPTool.delegate = self;
    //购买后，向苹果服务器验证一下购买结果。默认为YES。不建议关闭
    //IAPTool.CheckAfterPay = NO;
    //向苹果询问哪些商品能够购买
    [IAPTool requestProductsWithProductArray:self.shopArray];
    [self.view addSubview:self.collectionView];
    [self createRightButton];
}

-(void)createRightButton{
    
    //右侧下拉列表
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
        flowLayout.itemSize = CGSizeMake(110, 100);
        flowLayout.sectionInset = UIEdgeInsetsMake(12, 10, 2, 10);//上左下右
        //注册cell和ReusableView（相当于头部）
        [_collectionView registerClass:[LdtotopCell class] forCellWithReuseIdentifier:ldtopidentfid];
        [_collectionView registerClass:[LdtopHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
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
    LdtopHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                        UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
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
    VC.index = 1;
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
//    [SVProgressHUD showInfoWithStatus:@"购买失败"];
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
    
//    [SVProgressHUD showSuccessWithStatus:@"购买成功！(相关信息已打印)"];
}
//商品购买成功了，但向苹果服务器验证失败了
//2种可能：
//1，设备越狱了，使用了插件，在虚假购买。
//2，验证的时候网络突然中断了。（一般极少出现，因为购买的时候是需要网络的）
-(void)IAPToolCheckFailedWithProductID:(NSString *)productID
                               andInfo:(NSData *)infoData {
    NSLog(@"CheckFailed:%@",productID);

}
//恢复了已购买的商品（仅限永久有效商品）
-(void)IAPToolRestoredProductID:(NSString *)productID {
    NSLog(@"Restored:%@",productID);
    
}
//内购系统错误了
-(void)IAPToolSysWrong {
    NSLog(@"SysWrong");
   
}

@end
