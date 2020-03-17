//
//  ZSWKWebViewJSBridgeVC.h
//  ZSWKWebViewVC-master
//
//  Created by pengpai on 2020/3/17.
//  Copyright © 2020 safiri. All rights reserved.
//

#import "ZSWKWebViewVC.h"
#import "WKWebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSWKWebViewJSBridgeVC : ZSWKWebViewVC

// MARK: - WKWebViewJavascriptBridge js交互
@property (nonatomic ,strong) WKWebViewJavascriptBridge *javascriptBridge;

/**
 是否关闭bridge代理，默认开启，关闭后使用javascriptBridge后子类无法拦截到代理方法
 */
@property (nonatomic, assign) BOOL closeBridgeDelegate;

@end

NS_ASSUME_NONNULL_END
// MARK:WKWebViewJavascriptBridge 的具体使用方法？？

/*
 
 [self.javascriptBridge callHandler:@"htmlLoadFinished"];
 
 
 @weakify(self);
 [self.javascriptBridge registerHandler:@"paySuccess" handler:^(id data, WVJBResponseCallback responseCallback) {
    //NSLog(@"支付成功！");
    @strongify(self);
    [self payIsSuccess:YES];
 }];
 [self.javascriptBridge registerHandler:@"payFailure" handler:^(id data, WVJBResponseCallback responseCallback) {
    //NSLog(@"支付失败！");
    @strongify(self);
    [self payIsSuccess:NO];
 }];
 
 */
