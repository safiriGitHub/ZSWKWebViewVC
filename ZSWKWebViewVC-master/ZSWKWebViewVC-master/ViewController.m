//
//  ViewController.m
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2018/7/26.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ViewController.h"
#import "ZSWKWebViewVC.h"


#import <SafariServices/SafariServices.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.translucent = YES;
}

- (IBAction)push:(id)sender {
    ZSWKWebViewVC *webViewVC = [[ZSWKWebViewVC alloc] init];
    //webViewVC.requestURL = @"https://www.baidu.com";
    //webViewVC.requestURL = @"http://pay.egintra.com:8080/tuiguang/start.html";
    //webViewVC.requestURL = @"https://siteapp.news18a.com/m/price/select_brands/brand/?ina_from=weizhangjiaofeiyi";
    //webViewVC.requestURL = @"https://mp.weixin.qq.com/s?__biz=MzU5MjMwMjQyMg==&mid=100000844&idx=1&sn=1de825be1a2c6e95713371d3259e2312&chksm=7e209c754957156320c161b95174980fb0e3afc27d4fc4321396e404ac32c7a5180469b78caf#rd";
    webViewVC.requestURL = @"http://222.218.31.20:8765/apui/xfyewu/92";
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
