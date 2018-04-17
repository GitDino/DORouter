//
//  DOTarget_Custom.m
//  DORouter
//
//  Created by 魏欣宇 on 2018/4/18.
//  Copyright © 2018年 Dino. All rights reserved.
//

#import "DOTarget_Custom.h"

#import "DOTestVC.h"

@implementation DOTarget_Custom

- (id)action_push:(NSDictionary *) value
{
    
    DOTestVC *test_vc = [[DOTestVC alloc] init];
    test_vc.value_str = [value[@"value"] stringByRemovingPercentEncoding];
    return test_vc;
}

@end
