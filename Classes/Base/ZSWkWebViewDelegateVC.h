//
//  ZSWkWebViewDelegateVC.h
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2019/1/17.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "ZSWKWebViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSWkWebViewDelegateVC : ZSWKWebViewVC<WKNavigationDelegate, WKUIDelegate>

/**
 是否开启已经封装的NavigationDelegate处理逻辑，默认NO
 */
@property (nonatomic, assign) BOOL isOpenNavigationDelegate;

/**
 是否开启已经封装的UIDelegate处理逻辑，默认NO
 */
@property (nonatomic, assign) BOOL isOpenUIDelegate;

/**
 是否关闭识别电话 默认NO
 */
@property (nonatomic ,assign) BOOL closeRecognizePhone;

/**
 JS调用alert函数自定义标题,默认：温馨提示
 */
@property (nonatomic, strong) NSString *jsAlertTitle;

/**
 JS调用confirm函数自定义标题,默认：温馨提示
 */
@property (nonatomic, strong) NSString *jsConfirmTitle;

/**
 JS调用prompt函数自定义标题,默认：温馨提示
 */
@property (nonatomic, strong) NSString *jsTextInputTitle;

@end

NS_ASSUME_NONNULL_END

/*
 @protocol WKNavigationDelegate <NSObject>
 
 @optional
 
 // 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
 // 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
 // 这个是决定是否Request
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
 
 // 决定是否接收响应
 // 这个是决定是否接收response
 // 要获取response，通过WKNavigationResponse对象获取
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
 
 // 当main frame的导航开始请求时，会调用此方法
 - (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
 
 // 当main frame接收到服务重定向时，会回调此方法
 - (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
 
 // 当main frame开始加载数据失败时，会回调
 - (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
 
 // 当main frame的web内容开始到达时，会回调
 - (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
 
 // 当main frame导航完成时，会回调
 - (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
 
 // 当main frame最后下载数据失败时，会回调
 - (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
 
 // 这与用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
 - (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler;
 
 // 当web content处理完成时，会回调
 - (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0);
 
 @end
 
 @protocol WKUIDelegate <NSObject>
 
 @optional
 
 // 创建新的webview
 // 可以指定配置对象、导航动作对象、window特性
 - (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures;
 
 // webview关闭时回调
 - (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0);
 
 // 调用JS的alert()方法
 - (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
 
 // 调用JS的confirm()方法
 - (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;
 
 // 调用JS的prompt()方法
 - (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler;
 
 @end
 
 
 作者：JYSDeveloper
 链接：https://www.jianshu.com/p/7bb5f15f1daa
 來源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
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
