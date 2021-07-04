//
//  CommentCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

-(void)setModel:(commentModel *)model{

    _model = model;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.nameLabel.text = model.nickname;
    self.timeLabel.text = model.sendtime;
    if ([_model.is_volunteer intValue] == 1) {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
    }else if ([_model.is_admin intValue] == 1) {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
    }else{
        if ([_model.svipannual intValue] == 1) {
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"年svip标识"];
        }else if ([_model.svip intValue] == 1){
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"svip标识"];
        }else if ([_model.vipannual intValue] == 1) {
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"年费会员"];
        }else{
            if ([_model.vip intValue] == 1) {
                self.vipView.hidden = NO;
                self.vipView.image = [UIImage imageNamed:@"高级紫"];
            }else{
                self.vipView.hidden = YES;
            }
        }
    }
    if ([model.is_hand intValue] == 1) {
        self.handleView.hidden = NO;
    }else{
        self.handleView.hidden = YES;
    }
    if ([model.otheruid intValue] == 0) {
         self.contentLabel.text = model.content;
        NSMutableAttributedString *attributedString = [self.contentLabel.attributedText mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.content length])];
        self.contentLabel.attributedText = attributedString;
        
    }else{
    
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复 %@: %@",model.othernickname,model.content]];
        [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(3,[model.othernickname length])];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        self.contentLabel.attributedText = str;
    }
    self.contentLabel.isCopyable = YES;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(WIDTH - 84, 0)];
    self.contentH.constant = size.height;
    self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 65 + self.contentH.constant);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headView.layer.cornerRadius = 29;
    self.headView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)headButton:(id)sender {
    
}
@end
