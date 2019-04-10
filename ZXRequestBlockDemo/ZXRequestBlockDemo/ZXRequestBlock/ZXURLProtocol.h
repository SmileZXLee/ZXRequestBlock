//
//  ZXURLProtocol.h
//  ZXRequestBlockDemo
//
//  Created by 李兆祥 on 2018/8/26.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZXURLProtocol : NSURLProtocol
@property (nonatomic, copy) NSURLRequest *(^requestBlock)(NSURLRequest *request);
+(instancetype)sharedInstance;
@end
