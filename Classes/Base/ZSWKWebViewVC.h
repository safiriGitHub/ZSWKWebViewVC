//
//  ZSWKWebViewVC.h
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2018/7/26.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


/**
 导航栏样式

 - StyleBackCloseTogether: < x
 - StyleBackCloseSeparate: <        x
 - StyleBack: <
 */
typedef NS_ENUM(NSUInteger, WebNavigationBarStyle) {
    StyleBackCloseSeparate,
    StyleBackCloseTogether,
    StyleBack
};

@interface ZSWKWebViewVC : UIViewController

// MARK: - UI
/**
 WKWebView浏览器
 */
@property (nonatomic ,strong) WKWebView *wkWebView;

/**
 加载进度条控件
 */
@property (nonatomic ,strong) UIProgressView *progressView;

/**
 居中显示加载失败时提示View - todo
 */
@property (nonatomic ,strong) UIView *loadFailedHintView;

// MARK: - config
/**
 网页加载标题
 */
@property (nonatomic ,copy) NSString *navigationTitle;

/**
 需要加载的URL地址
 */
@property (nonatomic ,copy) NSString *requestURL;

/**
 是否隐藏网页标题
 默认NO:加载完成后自动显示网页标题
 */
@property (nonatomic ,assign) BOOL hideWebpageTitle;

/**
 导航栏样式，默认StyleBackCloseTogether
 若自定义导航栏样式，设置为StyleBack，并在子类中自定义
 */
@property (nonatomic ,assign) WebNavigationBarStyle webNavigationBarStyle;


/**
 是否在dealloc时清除缓存和cookie,默认NO
 */
@property (nonatomic ,assign) BOOL allowCleanCacheAndCookie;


/**
 是否禁止滑动返回，默认NO可以左滑返回上一页
 */
@property (nonatomic ,assign) BOOL forbidPopGestureRecognizer;

@end

/*
 navigationDelegate协议可以监听加载网页的周期和结果。
 navigationDelegate协议方法介绍
 self.wkWebView.navigationDelegate = self;
 
 判断链接是否允许跳转
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction     decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
 
 拿到响应后决定是否允许跳转
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
 
 链接开始加载时调用
 - (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
 
 收到服务器重定向时调用
 - (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
 
 加载错误时调用
 - (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
 
 当内容开始到达主帧时被调用（即将完成）
 - (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
 
 加载完成
 - (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
 
 在提交的主帧中发生错误时调用
 - (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
 
 当webView需要响应身份验证时调用(如需验证服务器证书)
 - (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge    completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable   credential))completionHandler;
 
 当webView的web内容进程被终止时调用。(iOS 9.0之后)
 - (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0));
 
 */

/*
 WKWebView中的WKUIDelegate实现UI弹出框的一些处理（警告面板、确认面板、输入框）
 self.wkWebView.UIDelegate = self
 
 在JS端调用alert函数时，会触发此代理方法。JS端调用alert时所传的数据可以通过message拿到。在原生得到结果后，需要回调JS，是通过completionHandler回调。
 - (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"message = %@",message);
 }
 
 JS端调用confirm函数时，会触发此方法，通过message可以拿到JS端所传的数据，在iOS端显示原生alert得到YES/NO后，通过completionHandler回调给JS端
 - (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"message = %@",message);
 }
 
 JS端调用prompt函数时，会触发此方法,要求输入一段文本,在原生输入得到文本内容后，通过completionHandler回调给JS
 - (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
 {
 NSLog(@"%s", __FUNCTION__);
 NSLog(@"%@", prompt);
 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
 [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
 {
 textField.textColor = [UIColor redColor];
 }];
 [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
 {
 completionHandler([[alert.textFields lastObject] text]);
 }]];
 [self presentViewController:alert animated:YES completion:NULL];
 }
 */


