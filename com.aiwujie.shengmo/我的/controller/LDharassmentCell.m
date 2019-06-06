
//
//  LDharassmentCell.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/6.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDharassmentCell.h"

@interface LDharassmentCell()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *nameLab;
@end

@implementation LDharassmentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.nameLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
   
    
}


#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        
    }
    return _leftImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:13];
        _nameLab.textColor = [UIColor lightGrayColor];
    }
    return _nameLab;
}




@end
