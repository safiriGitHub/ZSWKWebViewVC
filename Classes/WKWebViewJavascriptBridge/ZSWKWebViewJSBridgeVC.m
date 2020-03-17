//
//  ZSWKWebViewJSBridgeVC.m
//  ZSWKWebViewVC-master
//
//  Created by pengpai on 2020/3/17.
//  Copyright © 2020 safiri. All rights reserved.
//

#import "ZSWKWebViewJSBridgeVC.h"

@interface ZSWKWebViewJSBridgeVC ()

@end

@implementation ZSWKWebViewJSBridgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// MARK: - WKWebViewJavascriptBridge js交互
- (WKWebViewJavascriptBridge *)javascriptBridge {
    if (!_javascriptBridge) {
        _javascriptBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
        if (!self.closeBridgeDelegate) {
            [_javascriptBridge setWebViewDelegate:self];
        }
    }
    return _javascriptBridge;
}

@end
