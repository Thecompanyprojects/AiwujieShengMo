//
//  AlertTool.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/11/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import "AlertTool.h"

static NSString *_stampNum;

@implementation AlertTool

/**
 * 一般的正面弹框提示
 */
+(void)alertWithViewController:(UIViewController *)controller andTitle:(NSString *)title andMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil];
    
    [alert addAction:action];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

/**
 * 兑换会员的弹框提示
 */
+(void)alertWithViewController:(UIViewController *)controller type:(NSString *)type num:(NSString *)numStr andAlertDidSelectItem:(void(^)(int index, NSString *viptype))selectBlock;{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    //礼物魔豆兑换充值魔豆
    UIAlertAction *ChangeAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换充值魔豆"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (selectBlock) {
            selectBlock(1, @"CHANGEMODOU");
        }
    }];
    
    UIAlertAction *SVIPAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换SVIP"] style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *SVIPArray = @[@"1个月/1920魔豆", @"3个月/5220魔豆", @"8个月/13470魔豆", @"12个月/19470魔豆"];
        NSMutableArray *arrs = [NSMutableArray new];
        [arrs addObject:[NSString stringWithFormat:@"%@%@%@",@"(剩余",numStr,@"魔豆)"]];
        [arrs addObjectsFromArray:SVIPArray];
        
        UIAlertController *SVIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < arrs.count; i++) {
            UIAlertAction *month = [UIAlertAction actionWithTitle:arrs[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (selectBlock) {
                    selectBlock(i, @"SVIP");
                }
            }];
            
            [SVIPAlert addAction:month];
            if (PHONEVERSION.doubleValue >= 8.3&&i!=0) {
                [month setValue:MainColor forKey:@"_titleTextColor"];
            }
            if (PHONEVERSION.doubleValue >= 8.3&&i==0) {
                [month setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            }
        }
        [self cancelActionWithAlert:SVIPAlert];
        [controller presentViewController:SVIPAlert animated:YES completion:nil];
    }];
    
    UIAlertAction * VIPAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换VIP"] style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
     
        NSArray *VIPArray = @[[NSString stringWithFormat:@"%@%@%@",@"(剩余",numStr,@"魔豆)"],@"1个月/450魔豆", @"3个月/1320魔豆", @"6个月/2520魔豆", @"12个月/4470魔豆"];
        
        UIAlertController *VIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < VIPArray.count; i++) {
            
            UIAlertAction *month = [UIAlertAction actionWithTitle:VIPArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (selectBlock) {
                    
                    selectBlock(i, @"VIP");
                }
                
            }];
            
            [VIPAlert addAction:month];
            
            if (PHONEVERSION.doubleValue >= 8.3&&i!=0) {
                [month setValue:MainColor forKey:@"_titleTextColor"];
            }
            if (PHONEVERSION.doubleValue >= 8.3&&i==0) {
                [month setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            }
        }
        
        [self cancelActionWithAlert:VIPAlert];
        
        [controller presentViewController:VIPAlert animated:YES completion:nil];
    }];
    
    UIAlertAction *topcareAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换推顶卡"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *TopcardArray = @[[NSString stringWithFormat:@"%@%@%@",@"(剩余",numStr,@"魔豆)"],@"3张/450魔豆", @"10张/1500魔豆", @"30张/4500魔豆", @"50张/7500魔豆", @"100张/15000魔豆", @"308张/45000魔豆"];
        
        UIAlertController *VIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < TopcardArray.count; i++) {
            UIAlertAction *month = [UIAlertAction actionWithTitle:TopcardArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (selectBlock) {
                    selectBlock(i, @"TOPCARD");
                }
            }];
            [VIPAlert addAction:month];
            
            if (PHONEVERSION.doubleValue >= 8.3&&i!=0) {
                [month setValue:MainColor forKey:@"_titleTextColor"];
            }
            if (PHONEVERSION.doubleValue >= 8.3&&i==0) {
                [month setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            }

        }
        [self cancelActionWithAlert:VIPAlert];
        [controller presentViewController:VIPAlert animated:YES completion:nil];
    }];
    

    UIAlertAction *chargeAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换邮票"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *TopcardArray = @[[NSString stringWithFormat:@"%@%@%@",@"(剩余",numStr,@"魔豆)"],@"3张/90魔豆", @"10张/300魔豆", @"30张/900魔豆", @"50张/1500魔豆", @"100张/3000魔豆", @"308张/9000魔豆"];
        
        UIAlertController *VIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < TopcardArray.count; i++) {
            UIAlertAction *month = [UIAlertAction actionWithTitle:TopcardArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (selectBlock) {
                    selectBlock(i, @"YOUPIAO");
                }
            }];
            [VIPAlert addAction:month];
            
            if (PHONEVERSION.doubleValue >= 8.3&&i!=0) {
                [month setValue:MainColor forKey:@"_titleTextColor"];
            }
            if (PHONEVERSION.doubleValue >= 8.3&&i==0) {
                [month setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            }
        }
        
        [self cancelActionWithAlert:VIPAlert];
        [controller presentViewController:VIPAlert animated:YES completion:nil];
    }];
    
//    if ([type isEqualToString:@"礼物魔豆"]) {
//        [alert addAction:ChangeAction];
//    }
    
    [alert addAction:VIPAction];
    [alert addAction:SVIPAction];
    [alert addAction:chargeAction];
    [alert addAction:topcareAction];
    [self cancelActionWithAlert:alert];
    if (PHONEVERSION.doubleValue >= 8.3) {
        [ChangeAction setValue:MainColor forKey:@"_titleTextColor"];
        [SVIPAction setValue:MainColor forKey:@"_titleTextColor"];
        [VIPAction setValue:MainColor forKey:@"_titleTextColor"];
        [chargeAction setValue:MainColor forKey:@"_titleTextColor"];
        [topcareAction setValue:MainColor forKey:@"_titleTextColor"];
    }
    [controller presentViewController:alert animated:YES completion:nil];
}

/**
 * 兑换邮票的弹框提示
 */
+ (void)alertWithViewController:(UIViewController *)controller type:(NSString *)type andAlertInputStampsNumber:(void (^)(NSString *stampNumbers, NSString *channel))stampNumBlock{
   
    UIAlertController *numberAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换邮票"] message:@"(请输入兑换张数)"  preferredStyle:UIAlertControllerStyleAlert];
    
    [numberAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"兑换" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        NSScanner *scan = [NSScanner scannerWithString:_stampNum];
        int val;
        if (_stampNum.length > 0 && [_stampNum intValue] > 0 && ![_stampNum hasPrefix:@"0"] && ([scan scanInt:&val] && [scan isAtEnd])) {
            
            if (stampNumBlock) {
                
                if ([type isEqualToString:@"充值魔豆"]) {
                    
                    stampNumBlock(_stampNum, @"0");
                    
                }else{
                    
                    stampNumBlock(_stampNum, @"1");
                }
            }
            
        }else{
            
            [self alertWithViewController:controller andTitle:@"提示" andMessage:@"输入兑换数量有误,请重新输入~"];
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    }];
    
    [numberAlert addAction:sureAction];
    [self cancelActionWithAlert:numberAlert];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [sureAction setValue:MainColor forKey:@"_titleTextColor"];
        
    }
    
    [controller presentViewController:numberAlert animated:YES completion:nil];
}

+ (void)handleTextFieldTextDidChangeNotification:(NSNotification *)noti{
    
    UITextField *textield = noti.object;
    
    _stampNum = textield.text;
}

//创建取消的按钮
+ (void)cancelActionWithAlert:(UIAlertController *)alert{
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
    
    [alert addAction:cancelAction];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
    }
}


@end

