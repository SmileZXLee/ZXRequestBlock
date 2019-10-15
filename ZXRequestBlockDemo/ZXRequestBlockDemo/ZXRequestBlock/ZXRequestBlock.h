//
//  ZXRequestBlock.h
//  ZXRequestBlockDemo
//
//  Created by 李兆祥 on 2018/8/25.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NSURLRequest *(^requestBlock) (NSURLRequest *request);
@interface ZXRequestBlock : NSObject
@property (nonatomic, copy) NSURLRequest *(^requestBlock)(NSURLRequest *request);

/**
 启用ZXRequestBlock(一般情况下无需手动调用)
 */
+(void)addRequestBlock;

/**
 禁用ZXRequestBlock(一般情况下无需手动调用)
 */
+(void)removeRequestBlock;

/**
 拦截全局请求

 @param block 请求回调，block返回修改后的请求
 */
+(void)handleRequest:(requestBlock)block;

/**
 启用HttpDns
 */
+(void)enableHttpDns;

/**
 关闭HttpDns
 */
+(void)disableHttpDns;

/**
 禁止网络代理抓包（开启后使用代理方式抓包的程序无法抓到此App中的请求，且计时处于代理网络下也不会影响App本身的请求）

 @return 若不为nil，则代表检测到了网络代理，可进行额外操作
 */
+(id)disableHttpProxy;

/**
 允许网络代理抓包
 */
+(void)enableHttpProxy;

/**
 禁止所有网络请求
 */
+(void)cancelAllRequest;

/**
 恢复所有网络请求
 */
+(void)resumeAllRequest;
@end
