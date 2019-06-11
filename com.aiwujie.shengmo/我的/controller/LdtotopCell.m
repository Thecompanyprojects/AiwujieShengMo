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
@end


@implementation LdtotopCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.numberLab];
        [self.contentView addSubview:self.priceLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(18);
    }];
    [weakSelf.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.numberLab.mas_bottom).with.offset(12);
    }];
}

#pragma mark - getters

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.font = [UIFont systemFontOfSize:15];
        _numberLab.text = @"10张";
    }
    return _numberLab;
}

-(UILabel *)priceLab
{
    if(!_priceLab)
    {
        _priceLab = [[UILabel alloc] init];
        _priceLab.textAlignment = NSTextAlignmentCenter;
        _priceLab.font = [UIFont systemFontOfSize:11];
        _priceLab.text = @"$6";
    }
    return _priceLab;
}



@end
