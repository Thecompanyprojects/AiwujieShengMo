//
//  NTImageBrowser.m
//  NTImageBrowser
//
//  Created by Nineteen on 10/5/16.
//  Copyright © 2016 Nineteen. All rights reserved.
//

#import "NTImageBrowser.h"
#import "UIButton+countDown.h"

#define NTDeviceSize [UIScreen mainScreen].bounds.size
#define NTCurrentWindow [[UIApplication sharedApplication].windows lastObject]

@interface NTImageBrowser()
{
    
    //倒计时时间
    __block NSInteger timeOut;
    
    dispatch_queue_t queue;
    __block dispatch_source_t _timer ;
    
}
@property (nonatomic, assign) BOOL timerStop;
@property (nonatomic, strong) UIButton *doneBtn;
@end


@implementation NTImageBrowser

+ (instancetype)sharedShow{
    static NTImageBrowser *_show = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _show = [[NTImageBrowser alloc]init];
    });
    return _show;
}


static CGRect originFrame; // 用于记录imageView本来的frame

-(void)showImageBrowserWithImageView :(NSString *)imageUrl {
    
    originFrame = CGRectMake(100, 100, WIDTH/2-50, 200); // 这个方法用于将imageView原来在父控件中的位置对应到NTCurrentWindow中来
    
    // 1、创建新的UIImageView，原因有两点：第一点是原来的imageView已经被添加了手势,第二点是原来的frame不对新的父控件生效
    UIImageView *newImageView = [[UIImageView alloc]initWithFrame:originFrame];
    [newImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    newImageView.tag = 19; // 这个标记用于在hide方法中获取到backgroundView（如果不想采用这个方法也可以将backgroundView变成全局变量）
    
    // 2、创建黑色的背景视图
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, NTDeviceSize.width, NTDeviceSize.height)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImageBrowser :)];
    [backgroundView addGestureRecognizer: tap];
    
    [backgroundView addSubview:newImageView];
    [NTCurrentWindow addSubview:backgroundView];
    
   
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneBtn.frame = CGRectMake(WIDTH-60, 10, 40, 40);
    self.doneBtn.tag = 201;
    self.doneBtn.backgroundColor = [UIColor whiteColor];
    [NTCurrentWindow addSubview:self.doneBtn];
    
    
    timeOut = 5;
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (self.timerStop) {
            dispatch_source_cancel(_timer);
            _timer = nil;
            self.timerStop = NO;
        }
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            _timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.doneBtn.backgroundColor = [UIColor blackColor];
                [self.doneBtn setTitle:@"" forState:UIControlStateNormal];
                self.doneBtn.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)5 + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.doneBtn.backgroundColor = [UIColor blackColor];
                [self.doneBtn setTitle:timeStr forState:normal];
                [self.doneBtn setTitleColor:[UIColor whiteColor] forState:normal];
                self.doneBtn.userInteractionEnabled = NO;
                
                if (timeOut==0) {
                    [UIView animateWithDuration:0.3f animations:^{
                        // frame的动画
                        newImageView.frame = originFrame;
                        // 透明度的动画
                        backgroundView.alpha = 0;
                    } completion:^(BOOL finished) {
                        [backgroundView removeFromSuperview];
                        [self.doneBtn removeFromSuperview];
                    }];
                }
                
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
    
    
    // 3、执行动画效果
    [UIView animateWithDuration:0.3f animations:^{
        // frame的动画
        CGFloat width = NTDeviceSize.width;
        CGFloat height = NTDeviceSize.width/originFrame.size.width * originFrame.size.height;
        CGFloat x = 0;
        CGFloat y = NTDeviceSize.height/2 - height/2;
        newImageView.frame = CGRectMake(x, y, width, height);
        
        // 透明度的动画
        backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideImageBrowser :(UIGestureRecognizer *)sender {
    UIView *backgroundView = sender.view;
    UIView *imageView = (UIView *)[backgroundView viewWithTag:19];
    //self.timerStop = YES;
    [self.doneBtn removeFromSuperview];
    
    [UIView animateWithDuration:0.3f animations:^{
        // frame的动画
        imageView.frame = originFrame;
        // 透明度的动画
        backgroundView.alpha = 0;
       
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
       
    }];
}

@end
