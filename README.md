# ZXRequestBlock
//拦截全局请求
[ZXRequestBlock handleRequest:^NSURLRequest *(NSURLRequest *request) {
        NSLog(@"拦截到请求-%@",request);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blockTv.text = [self.blockTv.text stringByAppendingString:[NSString stringWithFormat:@"拦截到请求--%@\n",request]];
        });
        return request;
 }];

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



