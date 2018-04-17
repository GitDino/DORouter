//
//  DORouter.h
//  DORouter
//
//  Created by 魏欣宇 on 2018/4/18.
//  Copyright © 2018年 Dino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DORouter : NSObject

+ (instancetype)sharedInstance;

- (id)openUrl:(NSString *) url_str;

@end
