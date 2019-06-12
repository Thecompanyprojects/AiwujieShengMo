//
//  LDProvacyCell0.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDProvacyCell0.h"

@interface LDProvacyCell0()

@end

@implementation LDProvacyCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.switchBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(20);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(200);
    }];
    [weakSelf.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-16);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [UILabel new];
        _leftLab.textColor = TextCOLOR;
        _leftLab.font = [UIFont systemFontOfSize:15];
    }
    return _leftLab;
}

-(UISwitch *)switchBtn
{
    if(!_switchBtn)
    {
        _switchBtn = [UISwitch new];
        
    }
    return _switchBtn;
}


@end
