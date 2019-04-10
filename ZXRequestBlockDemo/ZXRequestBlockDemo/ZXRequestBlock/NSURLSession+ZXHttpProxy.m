//
//  NSURLSession+ZXHttpProxy.m
//  ZXRequestBlockDemo
//
//  Created by 李兆祥 on 2019/4/10.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "NSURLSession+ZXHttpProxy.h"
#import <objc/runtime.h>
@implementation NSURLSession (ZXHttpProxy)
+(void)disableHttpProxy{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [NSURLSession class];
        [self swizzingMethodWithClass:class orgSel:NSSelectorFromString(@"sessionWithConfiguration:") swiSel:NSSelectorFromString(@"zx_sessionWithConfiguration:")];
        [self swizzingMethodWithClass:class orgSel:NSSelectorFromString(@"sessionWithConfiguration:delegate:delegateQueue:") swiSel:NSSelectorFromString(@"zx_sessionWithConfiguration:delegate:delegateQueue:")];
    });
}
+(NSURLSession *)zx_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration
                                    delegate:(nullable id<NSURLSessionDelegate>)delegate
                               delegateQueue:(nullable NSOperationQueue *)queue{
    if (!configuration){
        configuration = [[NSURLSessionConfiguration alloc] init];
    }
    configuration.connectionProxyDictionary = @{};
    return [self zx_sessionWithConfiguration:configuration delegate:delegate delegateQueue:queue];
}

+(NSURLSession *)zx_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration{
    if (configuration){
        configuration.connectionProxyDictionary = @{};
    }
    return [self zx_sessionWithConfiguration:configuration];
}

+(void)swizzingMethodWithClass:(Class)cls orgSel:(SEL) orgSel swiSel:(SEL) swiSel{
    Method orgMethod = class_getClassMethod(cls, orgSel);
    Method swiMethod = class_getClassMethod(cls, swiSel);
    method_exchangeImplementations(orgMethod, swiMethod);
}

@end

