//
//  LDProvacyCell1.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDProvacyCell1.h"

@interface LDProvacyCell1()

@end

@implementation LDProvacyCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.contentLab];
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
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-26);
        make.width.mas_offset(200);
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

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textAlignment = NSTextAlignmentRight;
        _contentLab.textColor = [UIColor colorWithHexString:@"999999" alpha:1];
    }
    return _contentLab;
}


@end
