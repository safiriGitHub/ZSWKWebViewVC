//
//  ViewController.m
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2018/7/26.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ViewController.h"
#import "ZSWKWebViewVC.h"
#import "ZSWKWebViewPayVC.h"
#import <SafariServices/SafariServices.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)push:(id)sender {
    ZSWKWebViewVC *webViewVC = [[ZSWKWebViewVC alloc] init];
    //webViewVC.requestURL = @"https://www.baidu.com";
    //webViewVC.requestURL = @"https://product.haibaobaoxian.com/index?pcode=weizjfy-h5-all&version=testb";
    webViewVC.requestURL = @"https://siteapp.news18a.com/init.php?m=price&c=index&a=select_brands_daohang&type=brand&ina_from=weizhangjiaofeiyi";
    
    //webViewVC.requestURL = @"http://o2o.hks360.com/?channelCode=wzjfy";
    webViewVC.isOpenNavigationDelegate = YES;
    webViewVC.isOpenUIDelegate = YES;
    webViewVC.navigationBarTranslucent = NO;
    webViewVC.webNavigationBarStyle = StyleBackCloseSeparate;
    [self.navigationController pushViewController:webViewVC animated:YES];

    
    
//    if (@available(iOS 9.0, *)) {
//        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://222.218.31.20:8765/apui/xfyewu/92"]];
//        [self presentViewController:safariVC animated:YES completion:nil];
//    } else {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://222.218.31.20:8765/apui/xfyewu/92"]];
//    }
}
- (IBAction)test2Click:(id)sender {
    ZSWKWebViewVC *webViewVC = [[ZSWKWebViewVC alloc] init];
    webViewVC.requestURL = @"http://222.218.31.20:6701/mobile/main/Login/ssjc.jsp?sysUserId=1000123";
    webViewVC.isOpenNavigationDelegate = YES;
    webViewVC.navigationBarTranslucent = YES;
    webViewVC.webNavigationBarStyle = StyleBackCloseSeparate;
    [self.navigationController pushViewController:webViewVC animated:YES];
}
- (IBAction)payTestClick:(id)sender {
    ZSWKWebViewPayVC *webViewVC = [[ZSWKWebViewPayVC alloc] init];
    webViewVC.requestURL = @"http://o2o.hks360.com/?channelCode=wzjfy";
    //账户 18676836071 密码 hks123
    webViewVC.navigationBarTranslucent = YES;
    webViewVC.webNavigationBarStyle = StyleBackCloseSeparate;
    webViewVC.aliPayScheme = @"aliPayhks360";
    webViewVC.wxPayScheme = @"demo.o2o.hks360.com://";
    [self.navigationController pushViewController:webViewVC animated:YES];
    
}

- (IBAction)jsbridgeClick:(id)sender {
//    ZSWKWebViewVC *webViewVC = [[ZSWKWebViewVC alloc] init];
//    webViewVC.requestURL = @"http://123.232.237.119:8089/cf-app/test2.jsp";
//
//    [self.navigationController pushViewController:webViewVC animated:YES];
    
    

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
