//
//  LDEmailRegisterViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/15.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDEmailRegisterViewController.h"
#import "LDProtocolViewController.h"
#import "LDResigerNextViewController.h"

@interface LDEmailRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic,assign) BOOL isAgree;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

//发送验证码计时器
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) int second;

@end

@implementation LDEmailRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"邮箱注册";
    
    _isAgree = NO;
    
    self.phoneView.layer.cornerRadius = 2;
    self.phoneView.clipsToBounds = YES;
    
    self.passwordView.layer.cornerRadius = 2;
    self.passwordView.clipsToBounds = YES;
    
    self.registerButton.layer.cornerRadius = 2;
    self.registerButton.clipsToBounds = YES;

    self.codeButton.layer.cornerRadius = 2;
    self.codeButton.clipsToBounds = YES;
    
    self.codeView.layer.cornerRadius = 2;
    self.codeView.clipsToBounds = YES;
    
    [self createButton];
    
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    [self status];
}

- (IBAction)circleButtonClick:(id)sender {
    
    if (_isAgree) {
        
        _isAgree = NO;
        
        [self.circleButton setBackgroundImage:[UIImage imageNamed:@"kongguanzhu"] forState:UIControlStateNormal];
        
        [self.view endEditing:YES];
        
        [self status];
        
        
        
    }else{
        
        _isAgree = YES;
        
        [self.circleButton setBackgroundImage:[UIImage imageNamed:@"shiguanzhu"] forState:UIControlStateNormal];
        
        [self.view endEditing:YES];
        
        [self status];
    }
}

- (IBAction)codeButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/api/sendMailCode_reg"];
    
    NSDictionary *parameters = @{@"email":_phoneField.text};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                        NSLog(@"%@",responseObject);
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            _second = 60;
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            
            self.codeButton.userInteractionEnabled = NO;
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"验证码发送失败~"];
        
    }];
}

-(void)timeFireMethod{
    
    if (_second == 0) {
        // 设置IDCountDownButton的title为开始倒计时前的title
        [self.codeButton setTitle:@"点击获取验证码" forState:UIControlStateNormal];
        
        // 恢复IDCountDownButton开始倒计时的能力
        _second = 60;
        
        self.codeButton.userInteractionEnabled = YES;
        
        [_timer invalidate];
        
    } else {
        
        _second --;
        
        self.codeButton.userInteractionEnabled = NO;
        
        // 设置IDCountDownButton的title为当前倒计时剩余的时间
        [self.codeButton setTitle:[NSString stringWithFormat:@"%d秒后可重新发送", _second] forState:UIControlStateNormal];
    }
    
    
}

- (void)dealloc {
    
    [_timer invalidate];
}

//协议查看
- (IBAction)protocolButtonClick:(id)sender {
    
    [self.view endEditing:YES];
    
    LDProtocolViewController *pvc = [[LDProtocolViewController alloc] init];
    
    [self.navigationController pushViewController:pvc animated:YES];

}

//注册按钮
- (IBAction)registerButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/users/chargeFristnew"];
    
    NSString *device;
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.aiwujie.shengmoApp"];
    
    if ([keychain[@"device_token"] length] == 0) {
        
        device = @"";
        
    }else{
        
        device = keychain[@"device_token"];
    }
    
    NSDictionary *parameters = @{@"email":self.phoneField.text,@"password":self.passwordField.text,@"code":self.codeField.text,@"device_token":device};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
//        NSLog(@"%@",responseObject);
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            LDResigerNextViewController *ivc = [[LDResigerNextViewController alloc] init];
            
            NSDictionary* dict = @{
                                   @"email" :self.phoneField.text,
                                   @"password": self.passwordField.text,
                                   @"code":self.codeField.text
                                   };
            
            ivc.basicDic = dict;
            
            [self.navigationController pushViewController:ivc animated:YES];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求超时,请稍后重试~"];
        
    }];
    
}

//textField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


-(void)status{
    
    if (self.phoneField.text.length != 0 &&self.passwordField.text.length != 0 && _isAgree == YES && self.codeField.text.length != 0) {
        
        [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.registerButton setBackgroundColor:MainColor];
        
        self.registerButton.userInteractionEnabled = YES;
        
    }else{
        
        [self.registerButton setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
        
        [self.registerButton setBackgroundColor:[UIColor colorWithRed:239/255.0 green:240/255.0 blue:242/255.0 alpha:1]];
        
        self.registerButton.userInteractionEnabled = NO;
    }
    
}


- (void)createButton {
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
        
    }else{
        
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [areaButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}


-(void)backButtonOnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
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
