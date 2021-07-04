//
//  LDMyReceiveGifViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/6/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMyReceiveGifViewController.h"
#import "MyWalletCell.h"
#import "MyWalletModel.h"

@interface LDMyReceiveGifViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//首页tableview和collectView及数据源
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *collectArray;

@property (weak, nonatomic) IBOutlet UIView *headView;

//收到礼物数的展示label
@property (nonatomic,strong) UILabel *numLabel;

//收到礼物的总价值label
@property (nonatomic,strong) UILabel *accountLabel;

//兑换邮票按钮
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;

//选择了哪个充值选项
@property (nonatomic,copy) NSString *exchangeString;

//礼物数量
@property (nonatomic,copy) NSString *num;

//礼物魔豆数
@property (nonatomic,copy) NSString *amount;

//礼物可用魔豆数
@property (nonatomic,copy) NSString *useAmount;

@end

@implementation LDMyReceiveGifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.exchangeButton.layer.cornerRadius = 2;
    self.exchangeButton.clipsToBounds = YES;
    
    [self createCollectionView];
    
    _collectArray = [NSMutableArray array];
        
    [self createData];
        
}

//创建collectionView
-(void)createCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) collectionViewLayout:layout];
    
    if (@available(iOS 11.0, *)) {
        
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.collectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 2, 1, 2);
    
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
     layout.headerReferenceSize=CGSizeMake(WIDTH, 161);
    
    if (HEIGHT == 667){
        
        //设置每个item的大小
        layout.itemSize = CGSizeMake((int)(WIDTH - 8)/3,120);
        
        // 设置最小行间距
        layout.minimumLineSpacing = 2;
        
        // 设置垂直间距
        layout.minimumInteritemSpacing = 2;
        
    }else{
        
        //设置每个item的大小
        layout.itemSize = CGSizeMake((WIDTH - 8)/3,120);
        
        // 设置最小行间距
        layout.minimumLineSpacing = 2;
        
        // 设置垂直间距
        layout.minimumInteritemSpacing = 2;
        
    }
    
    self.collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.delegate =  self;
    
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyWalletCell" bundle:nil] forCellWithReuseIdentifier:@"MyWallet"];
    
    [self.view addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_collectArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyWalletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyWallet" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyWalletCell" owner:self options:nil].lastObject;
    }
    if (_collectArray.count > 0) {
        MyWalletModel *model = _collectArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
 
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        if (headerView.subviews.count != 0) {
            
            for (UIView *view in headerView.subviews) {
                
                [view removeFromSuperview];
            }
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 161)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - 84)/2, 15, 84, 90)];
        
        imageView.image = [UIImage imageNamed:@"我的礼物"];
        
        [view addSubview:imageView];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, WIDTH, 21)];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:_numLabel];
        
        _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 133, WIDTH, 21)];
        _accountLabel.textAlignment = NSTextAlignmentCenter;
        _accountLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:_accountLabel];
        
        if (_num.length == 0) {
            
            _num = @"0";
        }
        
        if (_amount.length == 0) {
            
            _amount = @"0";
        }
        
        if (_useAmount.length == 0) {
            
            _useAmount = @"0";
        }
        
        _numLabel.text = [NSString stringWithFormat:@"共%@份",_num];
        
        _accountLabel.text = [NSString stringWithFormat:@"总价值 %@ 魔豆(可用 %@ 魔豆)",_amount,_useAmount];
        if (self.returnValueBlock) {
            self.returnValueBlock(self.useAmount);
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_numLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(1,_num.length)];
        _numLabel.attributedText = str;
        
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:_accountLabel.text];
        [str1 addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(4,_amount.length)];
        [str1 addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(11 + _amount.length,_useAmount.length)];
        _accountLabel.attributedText = str1;
        
        [headerView addSubview:view];
        reusableview = headerView;
    }
    
    return reusableview;
}

//请求首页数据源
-(void)createData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getMyPresent"];
    NSDictionary *parameters;
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            
            if (integer == 4001) {
                
                _num = @"0";
                
                _amount = @"0";
                
                _useAmount = @"0";
                
                [_collectArray removeAllObjects];
                
                [_collectionView reloadData];
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
            
        }else{
            
            _num = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"allnum"]];
            _amount = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"allamount"]];
            
            _useAmount = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"useableBeans"]];
            
            NSArray *amountArray = @[@"7",@"35",@"70",@"350",@"520",@"700",@"1888",@"2888",@"3888",@"2",@"6",@"10",@"38",@"99",@"88",@"123",@"166",@"199",@"520",@"666",@"250",@"777",@"888",@"999",@"1314",@"1666",@"1999",@"666",@"999",@"1888",@"2899",@"3899",@"6888",@"9888",@"52000",@"99999",@"1",@"3",@"5",@"10",@"8"];
            
            //对数组进行排序
            NSArray *result = [responseObj[@"data"][@"giftArr"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                int number1;
                int number2;
                
                if (amountArray.count >= [obj1[@"type"] intValue]) {
                    
                    number1 = [amountArray[[obj1[@"type"] intValue] - 1] intValue];
                    
                }else{
                    
                    number1 = 0;
                }
                
                if (amountArray.count >= [obj2[@"type"] intValue]) {
                    
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
            
            for (NSDictionary *dic in result) {
                MyWalletModel *model = [[MyWalletModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_collectArray addObject:model];
            }
            
            [self.collectionView reloadData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
