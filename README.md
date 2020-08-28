# ZXRequestBlock
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/smilezxlee/ZXRequestBlock/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/ZXRequestBlock.svg?style=flat)](http://cocoapods.org/?q=ZXRequestBlock)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/ZXRequestBlock.svg?style=flat)](http://cocoapods.org/?q=ZXRequestBlock)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%208.0%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
## 安装
### 通过CocoaPods安装
```ruby
pod 'ZXRequestBlock'
```
### 手动导入
* 将ZXRequestBlock拖入项目中。

### 导入头文件
```objective-c
#import "ZXRequestBlock.h"
```
***

## 注意

### 不支持WKWebView！！

***

## 使用方法

### 拦截全局请求
```objective-c
[ZXRequestBlock handleRequest:^NSURLRequest *(NSURLRequest *request) {
        //拦截回调在异步线程
        NSLog(@"拦截到请求-%@",request);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blockTv.text = [self.blockTv.text stringByAppendingString:[NSString stringWithFormat:@"拦截到请求--%@\n",request]];
        });
        //在这里可以将request赋值给可变的NSURLRequest，进行一些修改（例如根据request的url过滤单独对一些请求的请求体进行修改等）然后再return，达到修改request的目的。
        return request;
}];
```
*** 
### 防代理抓包
#### 禁止网络代理抓包(开启后将无法通过网络代理抓包，通过Thor，Charles，Burp等均无法抓取此App的包，且在代理网络下App内部请求不受任何影响)
```objective-c
[ZXRequestBlock disableHttpProxy];
```
#### 允许网络代理抓包【默认为允许】
```objective-c
[ZXRequestBlock enableHttpProxy];
```





#### 注意 
* 此功能仅可以防止代理抓包，虽然可以屏蔽绝大多数的抓包方式，但是无法避免如Wireshark这类直接通过网卡抓包的工具，因此若您的请求协议很重要，请务必对请求进行验签或加密，并尽量避免明文声明AES加密key，详情可参照[【iOS应用安全、安全攻防】hook及越狱的基本防护与检测(动态库注入检测、hook检测与防护、越狱检测、签名校验、IDA反编译分析加密协议示例)](https://github.com/SmileZXLee/ZXHookDetection)

*** 

### HTTPDNS
#### 启用HTTPDNS（将会直接从本地或http://119.29.29.29 进行DNS解析，是一种避免DNS劫持的措施）
```objective-c
[ZXRequestBlock enableHttpDns];
```
#### 关闭HTTPDNS【默认为关闭】
```objective-c
[ZXRequestBlock disableHttpDns];
```

*** 

### 禁止/恢复所有网络请求
#### 禁止所有网络请求
```objective-c
[ZXRequestBlock cancelAllRequest];
```
#### 恢复所有网络请求
```objective-c
[ZXRequestBlock resumeAllRequest];
```
*** 

### 防抓包Demo演示
<img src="http://www.zxlee.cn/ZXRequestBlockDemo1.gif"/>




