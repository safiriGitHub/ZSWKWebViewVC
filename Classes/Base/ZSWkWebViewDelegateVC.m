//
//  ZSWkWebViewDelegateVC.m
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2019/1/17.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "ZSWkWebViewDelegateVC.h"

@interface ZSWkWebViewDelegateVC ()

@end

@implementation ZSWkWebViewDelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isOpenNavigationDelegate) {
        self.wkWebView.navigationDelegate = self;
    }
    if (self.isOpenUIDelegate) {
        self.wkWebView.UIDelegate = self;
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


// MARK: - delegate
// MARK: WKNavigationDelegate

// 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
// 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
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

// 决定是否接收响应
// 这个是决定是否接收response
// 要获取response，通过WKNavigationResponse对象获取
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 当main frame的导航开始请求时，会调用此方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 当main frame接收到服务重定向时，会回调此方法
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

// 当main frame的web内容开始到达时，会回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 当main frame导航完成时，会回调
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

// 这与用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

// 当web content处理完成时，会回调
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0) {
    
}

// MARK: WKUIDelegate

//在JS端调用alert函数时，会触发此代理方法。JS端调用alert时所传的数据可以通过message拿到。在原生得到结果后，需要回调JS，是通过completionHandler回调。
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.jsAlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    //NSLog(@"alert message:%@",message);
}

//JS端调用confirm函数时，会触发此方法，通过message可以拿到JS端所传的数据，在iOS端显示原生alert得到YES/NO后，通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.jsConfirmTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    //NSLog(@"confirm message:%@", message);
}

//JS端调用prompt函数时，会触发此方法,要求输入一段文本,在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.jsTextInputTitle message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
        textField.textColor = [UIColor blackColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

//MARK: getters
- (NSString *)jsAlertTitle {
    if (!_jsAlertTitle) {
        _jsAlertTitle = @"温馨提示";
    }
    return _jsAlertTitle;
}
- (NSString *)jsConfirmTitle {
    if (!_jsConfirmTitle) {
        _jsConfirmTitle = @"温馨提示";
    }
    return _jsConfirmTitle;
}
- (NSString *)jsTextInputTitle {
    if (!_jsTextInputTitle) {
        _jsTextInputTitle = @"温馨提示";
    }
    return _jsTextInputTitle;
}

@end
