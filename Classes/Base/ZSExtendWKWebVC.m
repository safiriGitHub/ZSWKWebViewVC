//
//  ZSExtendWKWebVC.m
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2018/7/27.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSExtendWKWebVC.h"

@interface ZSExtendWKWebVC ()

@end

@implementation ZSExtendWKWebVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wkWebView.navigationDelegate = self;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    /// <a href="tel:123456789">拨号</a>
    if ([navigationAction.request.URL.scheme isEqualToString:@"tel"] && self.closeRecognizePhone == NO) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSString *telString = [NSString stringWithFormat:@"telprompt://%@",navigationAction.request.URL.resourceSpecifier];
        NSURL *telURL = [NSURL URLWithString:telString];
        if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:telURL options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:telURL];
            }
        }
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
