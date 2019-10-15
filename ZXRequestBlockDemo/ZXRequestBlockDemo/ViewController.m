//
//  ViewController.m
//  ZXRequestBlockDemo
//
//  Created by 李兆祥 on 2018/8/25.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "ZXRequestBlock.h"
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
    [self setupUI];
    [self requestBlock];
}
#pragma mark 拦截全局请求
- (void)requestBlock{
    [ZXRequestBlock handleRequest:^NSURLRequest *(NSURLRequest *request) {
        NSLog(@"拦截到请求-%@",request);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blockTv.text = [self.blockTv.text stringByAppendingString:[NSString stringWithFormat:@"拦截到请求--%@\n",request]];
        });
        return request;
    }];
}
#pragma mark - Actions
#pragma mark 启用/禁用httpDNS
- (IBAction)enableHttpDnsAction:(id)sender {
    UIButton *curBtn = (UIButton *)sender;
    if([curBtn.currentTitle isEqualToString:@"启用HTTPDNS"]){
        [curBtn setTitle:@"禁用HTTPDNS" forState:UIControlStateNormal];
        curBtn.backgroundColor = [UIColor redColor];
       [ZXRequestBlock enableHttpDns];
    }else{
        [curBtn setTitle:@"启用HTTPDNS" forState:UIControlStateNormal];
        curBtn.backgroundColor = [UIColor colorWithRed:72/255.0 green:185/255.0 blue:34/255.0 alpha:1];
        [ZXRequestBlock disableHttpDns];
    }
    
}

#pragma mark 启用/禁止网络代理(防抓包)
- (IBAction)enableHttpProxy:(id)sender {
    UIButton *curBtn = (UIButton *)sender;
    if([curBtn.currentTitle isEqualToString:@"禁止代理网络"]){
        [curBtn setTitle:@"已禁止代理网络" forState:UIControlStateNormal];
        curBtn.backgroundColor = [UIColor redColor];
        [ZXRequestBlock disableHttpProxy];
    }else{
        [curBtn setTitle:@"禁止代理网络" forState:UIControlStateNormal];
        curBtn.backgroundColor = [UIColor colorWithRed:72/255.0 green:185/255.0 blue:34/255.0 alpha:1];
        [ZXRequestBlock enableHttpProxy];
    }
}

#pragma mark 发送请求
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

#pragma mark 切换请求方式
- (IBAction)reqMethodAction:(id)sender {
    if(self.reqMethodSeg.selectedSegmentIndex == 0){
        //get请求
        self.bodyTvW.constant = -[UIScreen mainScreen].bounds.size.width / 2 - 15;
    }else{
        //post请求
        self.bodyTvW.constant = -15;
    }
}

#pragma mark 开始加载网页
- (IBAction)webGoAction:(id)sender {
    if(!self.webUrlTf.text.length){
        [self showAlertWithStr:self.webUrlTf.placeholder];
        return;
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrlTf.text]]];
    
}

#pragma mark 清除请求结果
- (IBAction)cleanReqListAction:(id)sender {
    self.reqListTv.text = @"请求结果\n";
}

#pragma mark 清除拦截到的请求
- (IBAction)cleanBlockTfAction:(id)sender {
    self.blockTv.text = nil;
}

#pragma mark - Private
#pragma mark 显示弹窗
-(void)showAlertWithStr:(NSString *)str{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark 网络请求
-(void)reqWithMethod:(int)method{
    NSURL *url = [NSURL URLWithString:self.reqUrlTf.text];
    NSMutableURLRequest *mr = [NSMutableURLRequest requestWithURL:url];
    if(method == 0){
        mr.HTTPMethod = @"GET";
    }else{
        mr.HTTPMethod = @"POST";
        mr.HTTPBody = [self.bodyTv.text dataUsingEncoding:NSUTF8StringEncoding];
    }
    mr.timeoutInterval = 10;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSURLConnection sendAsynchronousRequest:mr queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (connectionError) {
            self.reqListTv.text = [self.reqListTv.text stringByAppendingString:[NSString stringWithFormat:@"请求失败--%@\n",connectionError]];
            NSLog(@"请求失败--%@",connectionError);
            return;
        }
        NSString *responseStr = [[NSString alloc]initWithData:data encoding:kCFStringEncodingUTF8];
        self.reqListTv.text = [self.reqListTv.text stringByAppendingString:[NSString stringWithFormat:@"请求成功--%@\n",responseStr]];
        NSLog(@"请求成功--%@",responseStr);
    }];
}

#pragma mark 初始化设置
- (void)setupUI{
    self.title = @"ZXRequestBlock";
    self.reqListTv.editable = NO;
    self.blockTv.editable = NO;
    [self reqMethodAction:self.reqMethodSeg];
    self.reqListTv.text = [self.reqListTv.text stringByAppendingString:@"\n"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
