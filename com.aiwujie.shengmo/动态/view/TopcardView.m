//
//  TopcardView.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/19.
//  Copyright © 2019 a. All rights reserved.
//

#import "TopcardView.h"

@interface TopcardView()
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *topBtn;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIButton *buyBtn;
@property (nonatomic,copy) NSString *numberStr;
@end



@implementation TopcardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /*下面代码的作用让视图没关闭之前只创建一次*/
        BOOL isHas = NO;
        for (UIView * view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[TopcardView class]]) {
                isHas = YES;
                break;
            }
        }
        if (isHas) {
            return nil;
        }

        self.frame = [UIScreen mainScreen].bounds;
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(60, 160, WIDTH-120, 300)];
        self.userInteractionEnabled = YES;
        self.alertView.backgroundColor = [UIColor blackColor];
        self.alertView.alpha = 0.75;
        self.alertView.layer.cornerRadius = 4;
        self.alertView.clipsToBounds = YES;
        self.alertView.layer.cornerRadius=5.0;
        self.alertView.layer.masksToBounds=YES;
        self.alertView.userInteractionEnabled=YES;
        [self addSubview:self.alertView];
        [self showAnimationwith];
        [self.alertView addSubview:self.topBtn];
        [self.alertView addSubview:self.contentLab];
        [self.alertView addSubview:self.titleLab];
        [self.alertView addSubview:self.buyBtn];
        [self setuplayout];
        [self getData];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.alertView);
        make.right.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.alertView).with.offset(20);
    }];
    
    [weakSelf.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(25);
        make.width.mas_offset(100);
        make.height.mas_offset(100);
    }];
    
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.topBtn.mas_bottom).with.offset(25);
        
    }];
    
    [weakSelf.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(68);
        make.centerX.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(25);
        make.height.mas_offset(22);
        
    }];
}

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"推顶卡";
        _titleLab.textColor = [UIColor colorWithHexString:@"FF9D00" alpha:1];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
//        _contentLab.text = @"剩余0张推顶卡";
        _contentLab.font = [UIFont systemFontOfSize:18];
        _contentLab.textColor = [UIColor whiteColor];
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}

-(UIButton *)topBtn
{
    if(!_topBtn)
    {
        _topBtn = [[UIButton alloc] init];
        [_topBtn setImage:[UIImage imageNamed:@"推顶火箭"] forState:normal];
        [_topBtn addTarget:self action:@selector(singleTapAction) forControlEvents:UIControlEventTouchUpInside];
        _topBtn.alpha = 1;
    }
    return _topBtn;
}


-(UIButton *)buyBtn
{
    if(!_buyBtn)
    {
        _buyBtn = [[UIButton alloc] init];
        [_buyBtn setTitle:@"去购买" forState:normal];
        [_buyBtn setBackgroundColor:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1]];
        _buyBtn.layer.cornerRadius = 2;
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [_buyBtn addTarget:self action:@selector(buybtnClick) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.alpha = 1;
    }
    return _buyBtn;
}

-(void)buybtnClick
{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
    if (self.buyClick) {
        self.buyClick([NSString new]);
    }
}

-(void)singleTapAction
{
   
    if ([self.numberStr isEqualToString:@"0"]||self.numberStr.length==0) {
        if (self.alertClick) {
            self.alertClick([NSString new]);
        }
    }
    else
    {
        [self topcardclick];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}


-(void)topcardclick
{
    NSString *url = [PICHEADURL stringByAppendingString:useTopcard];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSDictionary *para = @{@"did":self.did?:@"",@"uid":uid?:@""};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            if (self.sureClick) {
                self.sureClick(self.numberStr);
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)getData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *url = [PICHEADURL stringByAppendingString:getTopcardPageInfo];
    NSDictionary *para = @{@"uid":uid?:@""};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {

        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            self.numberStr = [data objectForKey:@"wallet_topcard"];
        }
        self.contentLab.text = [NSString stringWithFormat:@"%@%@%@",@"共剩余",self.numberStr?:@"0",@"张推顶卡"];
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)withSureClick:(sureBlock)block{
    _sureClick = block;
}

-(void)withBuyClick:(buyBlock)block
{
    _buyClick = block;
}

-(void)withAlertClick:(alertBlock)block
{
    _alertClick = block;
}

#pragma mark - getteres

-(void)showAnimationwith{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch * touch = touches.anyObject;
    
    if ([touch.view isMemberOfClass:[self.alertView class]]||[touch.view isMemberOfClass:[self.titleLab class]]) {
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self removeFromSuperview];
        }];

    }
}



@end
