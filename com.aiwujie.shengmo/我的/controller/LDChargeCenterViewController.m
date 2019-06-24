//
//  LDChargeCenterViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDChargeCenterViewController.h"
#import <StoreKit/StoreKit.h>
#import <AFNetworkReachabilityManager.h>
#import "AppDelegate.h"
#import "YQInAppPurchaseTool.h"

@interface LDChargeCenterViewController ()<YQInAppPurchaseToolDelegate>
{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

//12元
@property (weak, nonatomic) IBOutlet UIView *oneView;
//30元
@property (weak, nonatomic) IBOutlet UIView *twoView;
//50元
@property (weak, nonatomic) IBOutlet UIView *threeView;
//98元
@property (weak, nonatomic) IBOutlet UIView *fourView;
//298元
@property (weak, nonatomic) IBOutlet UIView *fiveView;
//588元
@property (weak, nonatomic) IBOutlet UIView *sixView;
//998元
@property (weak, nonatomic) IBOutlet UIView *sevenView;
//3998元
@property (weak, nonatomic) IBOutlet UIView *eightView;
//5898元
@property (weak, nonatomic) IBOutlet UIView *nineView;

//选择了哪个充值选项
@property (nonatomic,copy) NSString *subject;

//存储充值魔豆的内购id
@property (nonatomic,strong) NSArray *shopArray;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBeansButton;

//选择了哪个充值选项
@property (nonatomic,copy) NSString *exchangeString;
@property (nonatomic,copy) NSString *walletNumber;
@end

@implementation LDChargeCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self createData];
}

-(void)createData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getmywallet"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            
            self.accountLabel.text = [NSString stringWithFormat:@"余额 %@ 魔豆",responseObj[@"data"][@"wallet"]];
            self.walletNumber = responseObj[@"data"][@"wallet"];
            if (self.returnValueBlock) {
                self.returnValueBlock(self.walletNumber);
            }
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.accountLabel.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(3,[responseObj[@"data"][@"wallet"] length])];
            self.accountLabel.attributedText = str;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值";
    
    self.scrollView.contentSize = CGSizeMake(WIDTH, self.changeButton.frame.origin.y + 120);
    
    self.shopArray = @[@"bean1",@"bean2",@"bean3",@"bean4",@"bean5",@"bean6",@"pay6",@"bean7",@"bean8"];
    
    self.changeButton.layer.cornerRadius = 2;
    self.changeButton.clipsToBounds = YES;
    
    self.exchangeBeansButton.layer.cornerRadius = 2;
    self.exchangeBeansButton.clipsToBounds = YES;
    
    //获取单例
    YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
    //设置代理
    IAPTool.delegate = self;
    //购买后，向苹果服务器验证一下购买结果。默认为YES。不建议关闭
    IAPTool.CheckAfterPay = NO;
    //向苹果询问哪些商品能够购买
    [IAPTool requestProductsWithProductArray:self.shopArray];

    for (int i = 0; i < 9; i++) {
        
        UIButton *button = (UIButton *)[self.view viewWithTag:30 + i];
        
        if (i == 0) {
            
            _subject = _shopArray[0];
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = MainColor.CGColor;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            UILabel *priceLabel = (UILabel *)[self.view viewWithTag:i + 10];
            priceLabel.textColor = MainColor;
            UILabel *label = (UILabel *)[self.view viewWithTag:i + 20];
            label.textColor = MainColor;
        }else{
        
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1].CGColor;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            
            UILabel *priceLabel = (UILabel *)[self.view viewWithTag:i + 10];
            priceLabel.textColor = [UIColor blackColor];
            UILabel *label = (UILabel *)[self.view viewWithTag:i + 20];
            label.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
        }
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}



-(void)buttonClick:(UIButton *)button{

    for (int i = 0; i < 9; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:30 + i];
        
        if (btn.tag == button.tag) {
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = MainColor.CGColor;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            
            UILabel *priceLabel = (UILabel *)[self.view viewWithTag:button.tag - 20];
            priceLabel.textColor = MainColor;
            UILabel *label = (UILabel *)[self.view viewWithTag:button.tag - 10];
            label.textColor = MainColor;
            _subject = _shopArray[i];

        }else{
            
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1].CGColor;
            btn.layer.cornerRadius = 2;
            btn.clipsToBounds = YES;
            UILabel *priceLabel = (UILabel *)[self.view viewWithTag:i + 10];
            priceLabel.textColor = [UIColor blackColor];
            UILabel *label = (UILabel *)[self.view viewWithTag:i + 20];
            label.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
        }
    }

}


#pragma mark --------YQInAppPurchaseToolDelegate
//IAP工具已获得可购买的商品
-(void)IAPToolGotProducts:(NSMutableArray *)products {
    NSLog(@"GotProducts:%@",products);
    
}

//支付失败/取消
-(void)IAPToolCanceldWithProductID:(NSString *)productID {
    NSLog(@"canceld:%@",productID);
    [HUD hide:YES];
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
    NSString *url = [PICHEADURL stringByAppendingString:@"Api/Ping/cz_ioshooks"];
    
    NSDictionary *parameters = @{@"receipt":receipt?:@"",@"order_no":order?:@"",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [HUD hide:YES];
            [MBProgressHUD showMessage:@"购买失败"];
        }else{
            [HUD hide:YES];
            [MBProgressHUD showMessage:@"购买成功"];
            [self createData];
        }
    } failed:^(NSString *errorMsg) {
        [HUD hide:YES];
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
    
    [HUD hide:YES];
    [MBProgressHUD showMessage:@"服务器验证失败"];
}

//恢复了已购买的商品（仅限永久有效商品）
-(void)IAPToolRestoredProductID:(NSString *)productID {
    NSLog(@"Restored:%@",productID);
}

//内购系统错误了
-(void)IAPToolSysWrong {
    NSLog(@"SysWrong");
    
    [HUD hide:YES];
    [MBProgressHUD showMessage:@"系统出错了"];
}


- (IBAction)chargeButtonClick:(id)sender {
    [[YQInAppPurchaseTool defaultTool]buyProduct:_subject];
    HUD = [MBProgressHUD showActivityMessage:@"购买中..."];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
