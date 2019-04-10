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
+(void)handleRequest:(requestBlock)block;
+(void)enableHttpDns;
+(id)disableHttpProxy;
@end
