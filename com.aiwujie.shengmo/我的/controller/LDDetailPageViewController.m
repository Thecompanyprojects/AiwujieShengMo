//
//  LDDetailPageViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/6/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDDetailPageViewController.h"
#import "LDBillViewController.h"

@interface LDDetailPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDBillViewController *billViewController;

@end

@implementation LDDetailPageViewController

#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDBillViewController *v1 = [[LDBillViewController alloc] init];
        LDBillViewController *v2 = [[LDBillViewController alloc] init];
        LDBillViewController *v3 = [[LDBillViewController alloc] init];
            
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        [arrayM addObject:v3];
        
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_index == 1) {
        
        self.navigationItem.title = @"礼物明细";
        NSArray *array = @[@"收到的礼物",@"系统赠送",@"兑换记录"];
        
        for (int i = 100; i < 103; i++) {
            
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            [button setTitle:array[i - 100] forState:UIControlStateNormal];
        }
        
        //创建兑换的按钮
        [self createButton];
            
    }else{
    
        self.navigationItem.title = @"邮票明细";
        NSArray *array = @[@"购买记录",@"系统赠送",@"使用记录"];
        
        for (int i = 100; i < 103; i++) {
            
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            [button setTitle:array[i - 100] forState:UIControlStateNormal];
        }
    }
    
    //生成翻页控制器
    [self createPageViewController];
}

-(void)createButton{
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed: @"其他"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)backButtonOnClick{
    
    if (_index == 1) {
        
        //兑换VIP和SVIP
        [AlertTool alertWithViewController:self type:@"礼物魔豆" andAlertDidSelectItem:^(int index, NSString *viptype) {
            
           __block NSString *urlString;
           __block NSDictionary *parameters;
            
            if ([viptype isEqualToString:@"VIP"]) {
                
                urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Ping/vip_beans"];
                
                parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"viptype":[NSString stringWithFormat:@"%d",index + 1], @"beanstype":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                
                [self startExchangeWithUrl:urlString parameters:parameters];
                
            }else if ([viptype isEqualToString:@"SVIP"]){
                
                urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Ping/svip_beans"];
                
                parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"subject":[NSString stringWithFormat:@"%d",index + 1], @"channel":@"2",@"vuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                
                [self startExchangeWithUrl:urlString parameters:parameters];
                
            }else{
                
                //兑换邮票
                [AlertTool alertWithViewController:self type:@"礼物魔豆" andAlertInputStampsNumber:^(NSString *stampNumbers, NSString *channel) {
                    
                    urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Ping/stamp_baans"];
                    
                   parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"num":stampNumbers, @"channel":channel};
                    
                    [self startExchangeWithUrl:urlString parameters:parameters];
                    
                }];
            }
        }];
    }
}

- (void)startExchangeWithUrl:(NSString *)url parameters:(NSDictionary *)parameters{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [LDAFManager postDataWithDictionary:parameters andUrlString:url success:^(NSString *msg) {
        
        hud.labelText = msg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
    } fail:^(NSString *errorMsg){
        
        hud.labelText = errorMsg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
    }];
}

//生成翻页控制器
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    LDBillViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 52, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDBillViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDBillViewController *)viewController];
    
    if (index == NSNotFound) {
        
        return nil;
    }
    
    index++;
    
    if (index == [self.pageContentArray count]) {
        
        return nil;
    }
    
    
    return [self viewControllerAtIndex:index];
    
}

//翻页视图控制器将要翻页时执行的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
    _billViewController = (LDBillViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_billViewController];
            
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            [self changeNavButtonColor:index];
        }
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDBillViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDBillViewController *contentVC = self.pageContentArray[index];
    
    contentVC.content = [NSString stringWithFormat:@"%lu",(unsigned long)index];
    
    contentVC.index = [NSString stringWithFormat:@"%lu",(unsigned long)_index];
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDBillViewController *)viewController {
    
    return [viewController.content integerValue];
    
}

- (IBAction)billButtonClick:(UIButton *)sender {
    
    LDBillViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 100];// 得到对应页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    [self changeNavButtonColor:sender.tag - 100];
}


//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *button = (UIButton *)[self.view viewWithTag:index + 100];
    
    for (int i = 100; i < 103; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        
        UIView *view = (UIView *)[self.view viewWithTag:i + 100];
        
        if (button.tag == btn.tag) {
            
            [button setTitleColor:MainColor forState:UIControlStateNormal];
            
            view.hidden = NO;
            
        }else{
            
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            view.hidden = YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
