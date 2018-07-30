//
//  ViewController.m
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2018/7/26.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ViewController.h"
#import "ZSWKWebViewVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
}

- (IBAction)push:(id)sender {
    ZSWKWebViewVC *webViewVC = [[ZSWKWebViewVC alloc] init];
    webViewVC.requestURL = @"https://www.baidu.com";
    webViewVC.webNavigationBarStyle = StyleBackCloseTogether;
    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
