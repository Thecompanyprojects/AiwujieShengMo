//
//  bottomView.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/18.
//  Copyright © 2019 a. All rights reserved.
//

#import "bottomView.h"

@interface bottomView()
@property (nonatomic,strong) UIView *lineView0;
@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;
@end

@implementation bottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
}

#pragma mark - getters

-(UIView *)lineView0
{
    if(!_lineView0)
    {
        _lineView0 = [[UIView alloc] init];
        
    }
    return _lineView0;
}

-(UIView *)lineView1
{
    if(!_lineView1)
    {
        _lineView1 = [[UIView alloc] init];
        
    }
    return _lineView1;
}

-(UIView *)lineView2
{
    if(!_lineView2)
    {
        _lineView2 = [[UIView alloc] init];
        
    }
    return _lineView2;
}

-(UIButton *)zanBtn
{
    if(!_zanBtn)
    {
        _zanBtn = [[UIButton alloc] init];
        
    }
    return _zanBtn;
}

-(UIButton *)commentBtn
{
    if(!_commentBtn)
    {
        _commentBtn = [[UIButton alloc] init];
        
    }
    return _commentBtn;
}

-(UIButton *)replyBtn
{
    if(!_replyBtn)
    {
        _replyBtn = [[UIButton alloc] init];
        
    }
    return _replyBtn;
}

-(UIButton *)topBtn
{
    if(!_topBtn)
    {
        _topBtn = [[UIButton alloc] init];
        
    }
    return _topBtn;
}








@end
