//
//  changeAlertView.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/22.
//  Copyright © 2019 a. All rights reserved.
//

#import "changeAlertView.h"

@interface changeAlertView()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *leftLab0;
@property (nonatomic,strong) UILabel *leftLab1;
@property (nonatomic,strong) UITextField *numberTextFiled;
@property (nonatomic,strong) UILabel *numLab;
@property (nonatomic,strong) UIButton *submitBtn;

@end


@implementation changeAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*下面代码的作用让视图没关闭之前只创建一次*/
        BOOL isHas = NO;
        for (UIView * view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[changeAlertView class]]) {
                isHas = YES;
                break;
            }
        }
        if (isHas) {
            return nil;
        }
        [self showAnimationwith];
        self.frame = [UIScreen mainScreen].bounds;
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(48, HEIGHT/2-130, WIDTH-48*2, 180)];
        self.userInteractionEnabled = YES;
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius=5.0;
        self.alertView.layer.masksToBounds=YES;
        self.alertView.userInteractionEnabled=YES;
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.titleLab];
        [self.alertView addSubview:self.leftLab0];
        [self.alertView addSubview:self.leftLab1];
        [self.alertView addSubview:self.numberTextFiled];
        [self.alertView addSubview:self.numLab];
        [self.alertView addSubview:self.submitBtn];
        [self.alertView addSubview:self.messageLab];
        [self setuplayout];
        
        
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.alertView).with.offset(14);
        make.right.equalTo(weakSelf.alertView).with.offset(-14);
        make.top.equalTo(weakSelf.alertView).with.offset(20);
        
    }];
    
    [weakSelf.numberTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(44);
        make.width.mas_offset(65);
        make.left.equalTo(weakSelf.titleLab).with.offset(35);
    }];
    
    [weakSelf.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.numberTextFiled.mas_bottom).with.offset(16);
        make.width.mas_offset(65);
        make.left.equalTo(weakSelf.numberTextFiled).with.offset(15);
    }];
    
    [weakSelf.leftLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.numLab.mas_right).with.offset(6);
        make.width.mas_offset(45);
        make.centerY.equalTo(weakSelf.numberTextFiled);
    }];
    
    [weakSelf.leftLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftLab0);
        make.centerY.equalTo(weakSelf.numLab);
        make.width.mas_offset(45);
    }];
    
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(46);
        make.height.mas_offset(25);
        make.top.equalTo(weakSelf.numberTextFiled).with.offset(18);
        make.right.equalTo(weakSelf.titleLab.mas_right).with.offset(-30);
    }];
    
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(12);
    }];
}

#pragma mark - getters

-(UIView *)alertView
{
    if(!_alertView)
    {
        _alertView = [UIView new];
        
    }
    return _alertView;
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.textColor = TextCOLOR;
        _messageLab.font = [UIFont systemFontOfSize:12];
        
    }
    return _messageLab;
}


-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [UILabel new];
        _titleLab.text = @"银魔豆兑换金魔豆(2:1)";
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = MainColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

-(UILabel *)leftLab0
{
    if(!_leftLab0)
    {
        _leftLab0 = [UILabel new];
        _leftLab0.font = [UIFont systemFontOfSize:12];
        _leftLab0.textColor = TextCOLOR;
        _leftLab0.text = @"银魔豆";
    }
    return _leftLab0;
}

-(UILabel *)leftLab1
{
    if(!_leftLab1)
    {
        _leftLab1 = [UILabel new];
        _leftLab1.font = [UIFont systemFontOfSize:12];
        _leftLab1.textColor = TextCOLOR;
        _leftLab1.text = @"金魔豆";
    }
    return _leftLab1;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [UIButton new];
        _submitBtn.backgroundColor = MainColor;
        [_submitBtn setTitle:@"兑换" forState:normal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [_submitBtn addTarget:self action:@selector(submitBtnclick) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _submitBtn.layer.cornerRadius = 5;
    }
    return _submitBtn;
}

-(UILabel *)numLab
{
    if(!_numLab)
    {
        _numLab = [UILabel new];
        _numLab.textColor = TextCOLOR;
        _numLab.font = [UIFont systemFontOfSize:12];
//        _numLab.text = @"499";
        
    }
    return _numLab;
}

-(UITextField *)numberTextFiled
{
    if(!_numberTextFiled)
    {
        _numberTextFiled = [[UITextField alloc] init];
        _numberTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _numberTextFiled.borderStyle = UITextBorderStyleRoundedRect;//圆角
        _numberTextFiled.delegate = self;
        [_numberTextFiled addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];

    }
    return _numberTextFiled;
}

-(void)changedTextField:(UITextField *)textField
{
    if (textField.text.length==0) {
        self.numLab.text = @"";
    }
    else
    {
        int num0 = [textField.text intValue];
        int num1 = num0/2;
        self.numLab.text = [NSString stringWithFormat:@"%d",num1];
    }
}

- ( BOOL )textField:( UITextField  *)textField shouldChangeCharactersInRange:(NSRange )range replacementString:( NSString  *)string
{
   
    return YES;
}

-(void)showAnimationwith{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.0f];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        self.alertView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)submitBtnclick
{
    if (self.returnClick) {
        [UIView animateWithDuration:0.3 animations:^{
            [self removeFromSuperview];
        }];
        NSString *beans_receive = [NSString new]; //礼物魔豆数量
        NSString *beans = [NSString new]; //充值魔豆数量
        NSString *str0 = self.numLab.text;
        beans = str0.copy;
        int num1 = [str0 intValue]*2;
        beans_receive = [NSString stringWithFormat:@"%d",num1];
        NSDictionary *data = @{@"beans_receive":beans_receive?:@"",@"beans":beans?:@""};
        self.returnClick(data);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = touches.anyObject;
    
    if ([touch.view isMemberOfClass:[self.alertView class]]||[touch.view isMemberOfClass:[self.numberTextFiled class]]||[touch.view isMemberOfClass:[self.titleLab class]]||[touch.view isMemberOfClass:[self.numLab class]]||[touch.view isMemberOfClass:[self.leftLab0 class]]||[touch.view isMemberOfClass:[self.leftLab1 class]]) {
    }
    else
    {
  
        [UIView animateWithDuration:0.3 animations:^{
            [self removeFromSuperview];
        }];
    }
    
}

-(void)withReturnClick:(returnBlock)block
{
    _returnClick = block;
}



@end
