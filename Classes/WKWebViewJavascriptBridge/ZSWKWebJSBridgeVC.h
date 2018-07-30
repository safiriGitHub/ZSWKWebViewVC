//
//  ZSWKWebJSBridgeVC.h
//  CheFu365
//
//  Created by safiri on 2017/11/28.
//  Copyright © 2017年 safiri. All rights reserved.
//


#import "ZSWKWebViewVC.h"
#import "WKWebViewJavascriptBridge.h"

@interface ZSWKWebJSBridgeVC : ZSWKWebViewVC <WKUIDelegate>

@property (nonatomic ,strong) WKWebViewJavascriptBridge *javascriptBridge;

@end

//WKWebViewJavascriptBridge 的具体使用方法？？

/*
 
 [self.webViewBridge callHandler:@"htmlLoadFinished"];
 
 
 @weakify(self);
 [self.webViewBridge registerHandler:@"paySuccess" handler:^(id data, WVJBResponseCallback responseCallback) {
 //NSLog(@"支付成功！");
 @strongify(self);
 [self payIsSuccess:YES];
 }];
 [self.webViewBridge registerHandler:@"payFailure" handler:^(id data, WVJBResponseCallback responseCallback) {
 //NSLog(@"支付失败！");
 @strongify(self);
 [self payIsSuccess:NO];
 }];
 */
