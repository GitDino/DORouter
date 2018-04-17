//
//  DORouter.m
//  DORouter
//
//  Created by 魏欣宇 on 2018/4/18.
//  Copyright © 2018年 Dino. All rights reserved.
//

#import "DORouter.h"

@implementation DORouter

+ (instancetype)sharedInstance
{
    static DORouter *routerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        routerInstance = [[self alloc] init];
    });
    return routerInstance;
}

- (id)openUrl:(NSString *) url_str
{
    NSURL *url = [NSURL URLWithString:[url_str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *urlString = [url query];
    
    for (NSString *param in [urlString componentsSeparatedByString:@"&"])
    {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        
        if ([elts count] > 2)  continue;
        
        id firstEle = [elts firstObject];
        id lastEle = [elts lastObject];
        
        if (firstEle && lastEle)
        {
            [params setObject:lastEle forKey:firstEle];
        }
    }
    
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([actionName hasPrefix:@"native"])
    {
        return @(NO);
    }
    id result = [self performTarget:url.host action:actionName param:params];
    
    return result;
}

- (id)performTarget:(NSString *) targetName action:(NSString *) actionName param:(NSDictionary *) para
{
    NSString *targetClassString = [NSString stringWithFormat:@"DOTarget_%@", targetName];
    NSString *actionMethodString = [NSString stringWithFormat:@"action_%@:", actionName];
    
    Class targetClass = NSClassFromString(targetClassString);
    NSObject *target = [[targetClass alloc] init];
    
    SEL action = NSSelectorFromString(actionMethodString);
    
    if ([target respondsToSelector:action])
    {
        return [self safePerformAction:action target:target param:para];
    }
    else
    {
        SEL notAction = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:notAction])
        {
            return [self safePerformAction:notAction target:target param:para];
        }
        else
        {
            return nil;
        }
    }
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target param:(NSDictionary *)para
{
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
    
    if (methodSignature == nil)
    {
        return nil;
    }
    
    const char *type = [methodSignature methodReturnType];
    
    if (strcmp(type, @encode(void)) == 0 || strcmp(type, @encode(BOOL)) == 0 || strcmp(type, @encode(NSInteger)) == 0 || strcmp(type, @encode(NSUInteger)) == 0)
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        
        [invocation setArgument:&para atIndex:2];
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation invoke];
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
//    if (strcmp(type, @encode(NSInteger)) == 0)
//    {
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
//
//        [invocation setArgument:&para atIndex:2];
//        [invocation setTarget:target];
//        [invocation setSelector:action];
//        [invocation invoke];
//
//        NSInteger result = 0;
//        [invocation getReturnValue:&result];
//        return @(result);
//    }
    
//    if (strcmp(type, @encode(NSUInteger)) == 0)
//    {
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
//
//        [invocation setArgument:&para atIndex:2];
//        [invocation setTarget:target];
//        [invocation setSelector:action];
//        [invocation invoke];
//
//        NSInteger result = 0;
//        [invocation getReturnValue:&result];
//        return @(result);
//    }
    
//    if (strcmp(type, @encode(BOOL)) == 0)
//    {
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
//
//        [invocation setArgument:&para atIndex:2];
//        [invocation setTarget:target];
//        [invocation setSelector:action];
//        [invocation invoke];
//
//        NSInteger result = 0;
//        [invocation getReturnValue:&result];
//        return @(result);
//    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:para];
#pragma clang diagnostic pop
}

@end
