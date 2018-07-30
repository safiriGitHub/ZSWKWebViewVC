//
//  ZSWKWebJSBridgeVC.m
//  CheFu365
//
//  Created by safiri on 2017/11/28.
//  Copyright © 2017年 safiri. All rights reserved.
//

#import "ZSWKWebJSBridgeVC.h"

@implementation ZSWKWebJSBridgeVC

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.javascriptBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
}

//- (void)testJSFunction {
//    [self.webViewBridge callHandler:@"testJSFunction" data:@"一个字符串" responseCallback:^(id responseData) {
//        NSLog(@"调用完JS后的回调：%@",responseData);
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
