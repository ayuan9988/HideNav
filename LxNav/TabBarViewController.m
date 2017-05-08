//
//  TabBarViewController.m
//  LxNav
//
//  Created by 刘武文 on 2017/4/24.
//  Copyright © 2017年 刘武文. All rights reserved.
//

#import "TabBarViewController.h"
#import "ViewController.h"
#import "BaseNavViewController.h"
#define Storyboard(sbObj,vcObj) [[UIStoryboard storyboardWithName:sbObj bundle:nil] instantiateViewControllerWithIdentifier:vcObj];

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ViewController *homeVC = Storyboard(@"Main", @"ViewController");
    homeVC.title = @"首页";
    homeVC.view.backgroundColor = [UIColor whiteColor];
    homeVC.tabBarItem.image = [UIImage imageNamed:@"main_tabbar_xianhuo"];
    homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"main_tabbar_xianhuo_this"];
    BaseNavViewController *homeNav = [[BaseNavViewController alloc] initWithRootViewController:homeVC];
    
    self.viewControllers = @[homeNav];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
