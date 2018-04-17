//
//  DORootVC.m
//  DORouter
//
//  Created by 魏欣宇 on 2018/4/18.
//  Copyright © 2018年 Dino. All rights reserved.
//

#import "DORootVC.h"
#import "DORouter.h"

@interface DORootVC ()

@end

@implementation DORootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"自定义路由学习";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickAction:(UIButton *) btn
{
    DORouter *router = [DORouter sharedInstance];
    UIViewController *test_vc = [router openUrl:@"http://Custom/push?value=这是一个奇迹"];
    [self.navigationController pushViewController:test_vc animated:YES];
}

@end
