//
//  LdtotopCell.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/11.
//  Copyright © 2019 a. All rights reserved.
//

#import "LdtotopCell.h"

@interface LdtotopCell()
@property (nonatomic,strong) UILabel *numberLab;
@property (nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UILabel *messageLab;
@end


@implementation LdtotopCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.numberLab];
        [self.contentView addSubview:self.priceLab];
        [self.contentView addSubview:self.messageLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(12);
    }];
    [weakSelf.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.numberLab.mas_bottom).with.offset(11);
    }];
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.priceLab.mas_bottom).with.offset(11);
    }];
}

#pragma mark - getters

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.font = [UIFont systemFontOfSize:14];
     
    }
    return _numberLab;
}

-(UILabel *)priceLab
{
    if(!_priceLab)
    {
        _priceLab = [[UILabel alloc] init];
        _priceLab.textAlignment = NSTextAlignmentCenter;
        _priceLab.font = [UIFont systemFontOfSize:14];
       
    }
    return _priceLab;
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.font = [UIFont systemFontOfSize:11];
        _messageLab.textColor = TextCOLOR;
      
    }
    return _messageLab;
}

-(void)setDatafromIndex:(NSInteger )indexrow
{
    switch (indexrow) {
        case 0:
        {
            self.numberLab.text = @"3张";
            self.priceLab.text = @"￥40";
            self.messageLab.text = @"原价￥78";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原价￥78" attributes:attribtDic];
            _messageLab.attributedText = attribtStr;
        }
          
            break;
        case 1:
        {
            self.numberLab.text = @"10张";
            self.priceLab.text = @"￥128";
            self.messageLab.text = @"原价￥260";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原价￥260" attributes:attribtDic];
            _messageLab.attributedText = attribtStr;
        }
           
            
            break;
        case 2:
        {
            self.numberLab.text = @"30张";
            self.priceLab.text = @"￥388";
            self.messageLab.text = @"原价￥780";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原价￥780" attributes:attribtDic];
            _messageLab.attributedText = attribtStr;
        }
            
            break;
        case 3:
        {
            self.numberLab.text = @"50张";
            self.priceLab.text = @"￥648";
            self.messageLab.text = @"原价￥1300";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原价￥1300" attributes:attribtDic];
            _messageLab.attributedText = attribtStr;
        }
            
            break;
        case 4:
        {
            self.numberLab.text = @"100张";
            self.priceLab.text = @"￥1298";
            self.messageLab.text = @"原价￥2600";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原价￥2600" attributes:attribtDic];
            _messageLab.attributedText = attribtStr;
        }
            
            break;
        case 5:
        {
            self.numberLab.text = @"308张";
            self.priceLab.text = @"￥3998";
            self.messageLab.text = @"原价￥7800";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原价￥7800" attributes:attribtDic];
            _messageLab.attributedText = attribtStr;
        }
            
            break;
        default:
            break;
    }
}

@end
