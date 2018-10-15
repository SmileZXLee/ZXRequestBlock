//
//  ZXRequestBlock.m
//  ZXRequestBlockDemo
//
//  Created by 李兆祥 on 2018/8/25.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import "ZXRequestBlock.h"
#import "ZXURLProtocol.h"
#import "ZXHttpIPGet.h"
static BOOL isCancelAllReq;
@interface ZXRequestBlock()
@end
@implementation ZXRequestBlock
+(void)load{
    [super load];
    [self addRequestBlock];
}
+(void)addRequestBlock{
    [NSURLProtocol registerClass:[ZXURLProtocol class]];
}
+(void)removeRequestBlock{
    [NSURLProtocol unregisterClass:[ZXURLProtocol class]];
}
+(void)handleRequest:(requestBlock)block{
    [ZXURLProtocol sharedInstance].requestBlock = ^NSURLRequest *(NSURLRequest *request) {
        return block(request);
    };
}
+(void)disableRequestWithUrlStr:(NSString *)urlStr{
    [self handleRequest:^NSURLRequest *(NSURLRequest *request) {
        NSString *handleUrlStr = request.URL.absoluteString;
        if([handleUrlStr.uppercaseString containsString:urlStr.uppercaseString]){
            return nil;
        }else{
            return request;
        }
    }];
}
+(void)cancelAllRequest{
    isCancelAllReq = YES;
    [self blockRequest];
}
+(void)resumeAllRequest{
    isCancelAllReq = NO;
    [self blockRequest];
}
+(void)blockRequest{
    [self handleRequest:^NSURLRequest *(NSURLRequest *request) {
         return isCancelAllReq ? nil : request;
    }];
}
+(id)disableHttpProxy{
    id httpProxy = [self fetchHttpProxy];
    if(httpProxy){
        [self cancelAllRequest];
    }
    return httpProxy;
}
+(void)enableHttpDns{
    [self handleRequest:^NSURLRequest *(NSURLRequest *request) {
        NSString *handleUrlStr = request.URL.absoluteString;
        if([self isValidIP:handleUrlStr]){
            return request;
        }
        NSString *ipStr = [ZXHttpIPGet getIPArrFromLocalDnsWithUrlStr:request.URL.absoluteString];
        NSMutableURLRequest * mutableReq = [request mutableCopy];
        //NSMutableDictionary * headers = [mutableReq.allHTTPHeaderFields mutableCopy];
        [mutableReq setValue:ipStr forHTTPHeaderField:@"HOST"];
        return mutableReq;
    }];
    
    
}
+(id)fetchHttpProxy {
    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
    const CFStringRef proxyCFstr = (const CFStringRef)CFDictionaryGetValue(dicRef,
                                                                           (const void*)kCFNetworkProxiesHTTPProxy);
    NSString* proxy = (__bridge NSString *)proxyCFstr;
    return  proxy;
}
+ (BOOL)isValidIP:(NSString *)ipStr {
    if (nil == ipStr) {
        return NO;
    }
    NSArray *ipArray = [ipStr componentsSeparatedByString:@"."];
    if (ipArray.count == 4) {
        for (NSString *ipnumberStr in ipArray) {
            int ipnumber = [ipnumberStr intValue];
            if (!(ipnumber>=0 && ipnumber<=255)) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}
@end
