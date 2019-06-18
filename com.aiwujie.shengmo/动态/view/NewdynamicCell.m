//
//  NewdynamicCell.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/18.
//  Copyright © 2019 a. All rights reserved.
//

#import "NewdynamicCell.h"

@interface NewdynamicCell()
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UIImageView *vipImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIView *onlineView;
@property (nonatomic,strong) UIImageView *certificationImg;
@property (nonatomic,strong) UIImageView *rightImg;
@property (nonatomic,strong) UILabel *readnumberLab;
@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UILabel *contentLab;

@property (nonatomic,strong) UIView *lineView0;
@property (nonatomic,strong) UIButton *zanBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *rewardBtn;
@property (nonatomic,strong) UIButton *topcardBtn;

@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;
@property (nonatomic,strong) UIView *lineView3;
@end

@implementation NewdynamicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.headImg];
        [self.contentView addSubview:self.vipImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.onlineView];
        [self.contentView addSubview:self.certificationImg];
        [self.contentView addSubview:self.rightImg];
        [self.contentView addSubview:self.readnumberLab];
        [self.contentView addSubview:self.timeLab];
        
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.lineView0];
        [self.contentView addSubview:self.zanBtn];
        [self.contentView addSubview:self.rewardBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.topcardBtn];
        
        [self.contentView addSubview:self.lineView1];
        [self.contentView addSubview:self.lineView2];
        [self.contentView addSubview:self.lineView3];
        
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
}

#pragma mark - getters


@end
