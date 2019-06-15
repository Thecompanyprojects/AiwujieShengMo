//
//  SSCopyLabel.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/14.
//  Copyright © 2019 a. All rights reserved.
//

#import "SSCopyLabel.h"

@implementation SSCopyLabel

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touch];
    
}

-(void)handleTap:(UIGestureRecognizer*) recognizer {
    
    [self becomeFirstResponder];
    // 1.获得菜单 menu
    UIMenuController *menu = [UIMenuController sharedMenuController];
//    // 2.设置菜单最终显示的位置
    [menu setTargetRect:self.frame inView:self.superview];
    
    // 当label有内容的时候，再添加一个UIMenuItem
   // if (self.text.length > 0) {
        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyAction)];
        menu.menuItems = [NSArray arrayWithObjects: menuItem1, nil];
//    }
    [menu setMenuVisible:YES animated:!menu.isMenuVisible];
   
}

- (void)copyAction{
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    pBoard.string = self.text;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

@end
