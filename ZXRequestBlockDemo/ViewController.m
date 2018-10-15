//
//  ViewController.m
//  ZXRequestBlockDemo
//
//  Created by 李兆祥 on 2018/8/25.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import "ViewController.h"
#import "ZXRequestBlock.h"
#import "ZXHttpIPGet.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *reqMethodSeg;
@property (weak, nonatomic) IBOutlet UITextField *reqUrlTf;
@property (weak, nonatomic) IBOutlet UITextView *reqListTv;
@property (weak, nonatomic) IBOutlet UITextField *webUrlTf;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *blockTv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyTvW;
@property (weak, nonatomic) IBOutlet UITextView *bodyTv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZXRequestBlock";
    self.reqListTv.editable = NO;
    self.blockTv.editable = NO;
    [ZXRequestBlock handleRequest:^NSURLRequest *(NSURLRequest *request) {
        NSLog(@"拦截到请求-%@",request);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blockTv.text = [self.blockTv.text stringByAppendingString:[NSString stringWithFormat:@"拦截到请求--%@\n",request]];
        });
        return request;
    }];
    
    
//    [ZXRequestBlock handleRequest:^NSURLRequest *(NSURLRequest *request) {
//        NSLog(@"拦截到请求-%@",request);
//        NSMutableURLRequest * mutableReq = [request mutableCopy];
//        NSMutableDictionary * headers = [mutableReq.allHTTPHeaderFields mutableCopy];
//        mutableReq.URL = [NSURL URLWithString:@"http://jwgl.fafu.edu.cn"];
//        return mutableReq;
//    }];
    //[ZXRequestBlock enableHttpDns];
    [self reqMethodAction:self.reqMethodSeg];
    self.reqListTv.text = [self.reqListTv.text stringByAppendingString:@"\n"];
//    NSString *ipstr = [ZXHttpIPGet getIPArrFromLocalDnsWithUrlStr:@"http://manage.unioncity.com.cn"];
//    NSString *dnsUrl = [NSString stringWithFormat:@"http://119.29.29.29/d?ttl=1&dn=%@",@"www.baidu.com"];
//    NSURL *url = [NSURL URLWithString:dnsUrl];
//    NSMutableURLRequest *mr = [NSMutableURLRequest requestWithURL:url];
//    mr.HTTPMethod = @"GET";
//    mr.timeoutInterval = 10;
//    [NSURLConnection sendAsynchronousRequest:mr queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        if (connectionError) {
//            NSLog(@"connectionError-%@",connectionError);
//            return;
//        }
//        NSString *responseStr = [[NSString alloc]initWithData:data encoding:kCFStringEncodingUTF8];
//        NSLog(@"请求成功--%@",responseStr);
//    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)enableHttpDnsAction:(id)sender {
    UIButton *curBtn = (UIButton *)sender;
    if([curBtn.currentTitle isEqualToString:@"启用HTTPDNS"]){
        [curBtn setTitle:@"禁用HTTPDNS" forState:UIControlStateNormal];
        curBtn.backgroundColor = [UIColor redColor];
       [ZXRequestBlock enableHttpDns];
    }else{
        [curBtn setTitle:@"启用HTTPDNS" forState:UIControlStateNormal];
        curBtn.backgroundColor = [UIColor colorWithRed:72/255.0 green:185/255.0 blue:34/255.0 alpha:1];
    }
    
}
- (IBAction)enableHttpProxy:(id)sender {
    UIButton *curBtn = (UIButton *)sender;
    if([curBtn.currentTitle isEqualToString:@"允许代理网络"]){
        [curBtn setTitle:@"禁用代理网络" forState:UIControlStateNormal];
        curBtn.backgroundColor = [UIColor redColor];
        [ZXRequestBlock disableHttpProxy];
    }else{
        [curBtn setTitle:@"允许代理网络" forState:UIControlStateNormal];
        curBtn.backgroundColor = [UIColor colorWithRed:72/255.0 green:185/255.0 blue:34/255.0 alpha:1];
    }
}
- (IBAction)sendReqAction:(id)sender {
    if(!self.reqUrlTf.text.length){
        [self showAlertWithStr:self.reqUrlTf.placeholder];
        return;
    }
    if(self.reqMethodSeg.selectedSegmentIndex == 0){
        //get请求
        [self reqWithMethod:0];
        
    }else{
        //post请求
        [self reqWithMethod:1];
    }
    
}
- (IBAction)reqMethodAction:(id)sender {
    if(self.reqMethodSeg.selectedSegmentIndex == 0){
        //get请求
        self.bodyTvW.constant = -[UIScreen mainScreen].bounds.size.width / 2 - 15;
        
    }else{
        //post请求
        self.bodyTvW.constant = -15;
    }
}
- (IBAction)webGoAction:(id)sender {
    if(!self.webUrlTf.text.length){
        [self showAlertWithStr:self.webUrlTf.placeholder];
        return;
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrlTf.text]]];
    
}
- (IBAction)cleanReqListAction:(id)sender {
    self.reqListTv.text = @"请求结果\n";
    
}
- (IBAction)cleanBlockTfAction:(id)sender {
    self.blockTv.text = nil;
}

-(void)showAlertWithStr:(NSString *)str{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)reqWithMethod:(NSUInteger *)method{
    NSURL *url = [NSURL URLWithString:self.reqUrlTf.text];
    NSMutableURLRequest *mr = [NSMutableURLRequest requestWithURL:url];
    if(method == 0){
        mr.HTTPMethod = @"GET";
    }else{
        mr.HTTPMethod = @"POST";
        mr.HTTPBody = [self.bodyTv.text dataUsingEncoding:NSUTF8StringEncoding];
    }
    mr.timeoutInterval = 10;
    [NSURLConnection sendAsynchronousRequest:mr queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            self.reqListTv.text = [self.reqListTv.text stringByAppendingString:[NSString stringWithFormat:@"请求失败--%@\n",connectionError]];
            NSLog(@"connectionError-%@",connectionError);
            return;
        }
        NSString *responseStr = [[NSString alloc]initWithData:data encoding:kCFStringEncodingUTF8];
        
        NSString *formatStr = responseStr.length > 20 ? [[responseStr substringToIndex:20] stringByAppendingString:@"..."] : responseStr;
        self.reqListTv.text = [self.reqListTv.text stringByAppendingString:[NSString stringWithFormat:@"请求成功--%@\n",formatStr]];
        NSLog(@"请求成功--%@",responseStr);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
