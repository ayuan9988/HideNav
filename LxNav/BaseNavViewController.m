//
//  BaseNavViewController.m
//  LxNav
//
//  Created by 刘武文 on 2017/4/24.
//  Copyright © 2017年 刘武文. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        //        UIView *view = [[UIView alloc] init];
        //        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        //        [self.view insertSubview:view belowSubview:self.navigationBar];
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //        self.navigationBar.layer.masksToBounds = YES;// 去掉横线（没有这一行代码导航栏的最下面还会有一个横线）
        //        self.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [self.navigationBar setShadowImage:[UIImage new]];
    }
    return self;
}

@end
