//
//  ZXURLProtocol.m
//  ZXRequestBlock
//
//  Created by 李兆祥 on 2018/8/26.
//  Copyright © 2018年 李兆祥. All rights reserved.
//  https://github.com/SmileZXLee/ZXRequestBlock
//  V1.0.4

#import "ZXURLProtocol.h"
#define protocolKey @"SessionProtocolKey"
@interface ZXURLProtocol()<NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLResponse *currentResponse;
@end
@implementation ZXURLProtocol
+(instancetype)sharedInstance {
    static ZXURLProtocol *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance){
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

+(BOOL)canInitWithRequest:(NSURLRequest *)request{
    if ([NSURLProtocol propertyForKey:protocolKey inRequest:request]) {
        return NO;
    }
    NSString * url = request.URL.absoluteString;
    return [self isUrl:url] && [ZXURLProtocol sharedInstance].requestBlock;
}

+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return [[ZXURLProtocol sharedInstance] requestBlockForRequst:request];
}

-(void)startLoading{
    NSMutableURLRequest *request = [self.request mutableCopy];
    [NSURLProtocol setProperty:@(YES) forKey:protocolKey inRequest:request];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.session = [ZXURLProtocol sharedInstance].sessionBlock ? [ZXURLProtocol sharedInstance].sessionBlock(session) : session;
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}

-(void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

#pragma mark - NSURLSessionDataDelegate
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.currentResponse = response;
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSData *currentData = [ZXURLProtocol sharedInstance].responseBlock ? [ZXURLProtocol sharedInstance].responseBlock(self.currentResponse, data) : data;
    [self.client URLProtocol:self didLoadData:currentData];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler{
    completionHandler(proposedResponse);
}

#pragma mark private
+(BOOL)isUrl:(NSString *)url{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:url];
}

-(NSURLRequest *)requestBlockForRequst:(NSURLRequest *)request{
    NSURLRequest *currentRequest = self.requestBlock ? self.requestBlock(request) : request;
    return currentRequest;
}
@end
