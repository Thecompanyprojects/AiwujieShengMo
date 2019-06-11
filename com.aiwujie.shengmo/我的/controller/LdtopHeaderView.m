//
//  LdtopHeaderView.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/11.
//  Copyright © 2019 a. All rights reserved.
//

#import "LdtopHeaderView.h"

@interface LdtopHeaderView()
@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) UILabel *contentLab;
@end

@implementation LdtopHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImg];
        [self addSubview:self.contentLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(24);
        make.width.mas_offset(93);
        make.height.mas_offset(73);
        make.centerX.equalTo(weakSelf);
    }];
    
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.topImg.mas_bottom).with.offset(30);
    }];
    
}

#pragma mark - getters

-(UIImageView *)topImg
{
    if(!_topImg)
    {
        _topImg = [[UIImageView alloc] init];
        _topImg.image = [UIImage imageNamed:@"通用邮票"];
    }
    return _topImg;
}


-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.text = @"◆邮票启用后24小时内有效";
        _contentLab.textColor = [UIColor colorWithHexString:@"AAAAAA" alpha:1];
    }
    return _contentLab;
}



@end
