//
//  LDBindingEmailViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/5/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDBindingEmailViewController.h"
#import "LDLookChangeBindingEmailViewController.h"

@interface LDBindingEmailViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bindView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

//发送验证码计时器
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) int second;

//判定是绑定还是重新绑定的状态
@property (nonatomic, copy) NSString *bindState;

@end

@implementation LDBindingEmailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"绑定邮箱";
    
    _codeButton.layer.cornerRadius = 2;
    _codeButton.clipsToBounds = YES;
    
    _bindButton.layer.cornerRadius = 2;
    _bindButton.clipsToBounds = YES;
    
    _changeButton.layer.cornerRadius = 2;
    _changeButton.clipsToBounds = YES;
    
    if ([_emailNum length] == 0) {
        
        _bindView.hidden = YES;
        
    }else{
        
        _bindView.hidden = NO;
        
        NSArray *array = [_emailNum componentsSeparatedByString:@"@"];
        
        NSString *string = [NSString string];
        
        for (int i = 0; i < [array[0] length] - 2; i++) {
            
            string = [string stringByAppendingString:@"*"];
        }
        
        NSString *str = [_emailNum stringByReplacingCharactersInRange:NSMakeRange(1, [array[0] length] - 2) withString:string];
        
        self.emailLabel.text = [NSString stringWithFormat:@"您的邮箱: %@",str];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindEmail) name:@"绑定邮箱" object:nil];
    

}

-(void)bindEmail{

    _bindView.hidden = YES;
    
    _bindState = @"1";
}

- (IBAction)bindButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/bindingEmail"];
    
    if (_emailField.text.length == 0) {
        
        _emailField.text = @"";
    }
    
    if (_codeField.text.length == 0) {
        
        _codeField.text = @"";
    }
    
    NSDictionary *parameters;
    
    if ([_bindState intValue] == 1) {
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"email":_emailField.text,@"code":_codeField.text,@"change":@"1"};
        
    }else{
    
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"email":_emailField.text,@"code":_codeField.text};
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        //                NSLog(@"%@",responseObject);
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self getBindState];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

}

//获取绑定状态
-(void)getBindState{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getBindingState"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            if ([responseObject[@"data"][@"email"] length] == 0) {
                
                _bindView.hidden = YES;
                
            }else{
                
                _bindView.hidden = NO;
                
                _emailNum = responseObject[@"data"][@"email"];
                
                NSArray *array = [responseObject[@"data"][@"email"] componentsSeparatedByString:@"@"];
                
                NSString *string = [NSString string];
                
                for (int i = 0; i < [array[0] length] - 2; i++) {
                    
                    string = [string stringByAppendingString:@"*"];
                }
                
                NSString *str = [responseObject[@"data"][@"email"] stringByReplacingCharactersInRange:NSMakeRange(1, [array[0] length] - 2) withString:string];
                
                self.emailLabel.text = [NSString stringWithFormat:@"您的邮箱: %@",str];
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
    }];
    
}


- (IBAction)changeButtonClick:(id)sender {
    
    if (_emailNum.length != 0) {
        
        LDLookChangeBindingEmailViewController *evc = [[LDLookChangeBindingEmailViewController alloc] init];
        
        evc.emailNum = _emailNum;
        
        [self.navigationController pushViewController:evc animated:YES];;
    }else{
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"邮箱获取失败,请稍后重试~"];
        
    }

}
- (IBAction)codeButtonClick:(id)sender {
    
    [self getCode];
}

-(void)getCode{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/api/sendMailCode_reg"];
    
    if (_emailField.text.length == 0) {
        
        _emailField.text = @"";
    }
    
    NSDictionary *parameters = @{@"email":_emailField.text};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        //                NSLog(@"%@",responseObject);
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

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
