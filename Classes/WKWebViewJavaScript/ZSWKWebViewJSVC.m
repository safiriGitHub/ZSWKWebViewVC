//
//  ZSWKWebViewJSVC.m
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2018/7/27.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSWKWebViewJSVC.h"

@interface ZSWKWebViewJSVC ()<WKScriptMessageHandler>

@end

@implementation ZSWKWebViewJSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //打开或者关闭javaScript
    //self.wkWebView.configuration.preferences.javaScriptEnabled
    //控制javaScript是否自动打开windows
    //self.wkWebView.configuration.preferences.javaScriptCanOpenWindowsAutomatically
    
    //创建一个webview的配置项
    WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
    self.webViewConfig = webViewConfig;
    
    //WKPreferences:
    //webViewConfig.preferences = [[WKPreferences alloc]init];
    //webViewConfig.preferences.minimumFontSize = 10;
    //webViewConfig.preferences.javaScriptEnabled = YES;
    //默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    //webViewConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    //WKUserContentController:
    /*例子：
     1.
    [self.jsUserContentController addScriptMessageHandler:self name:@"jSCallOC"];//添加
    [self.jsUserContentController removeScriptMessageHandlerForName:JS_Function_Name];//移除
     js:
     window.webkit.messageHandlers.jSCallOC.postMessage({body: 'jS Call OC'});
     之后代理方法会被调用
     
     2.
    NSString *jsString = @"function showAlert() { alert('在载入webview时通过WKUserContentController注入的JS方法'); }";
    WKUserScript *script = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    //WKUserScriptInjectionTimeAtDocumentStart:在载入时就添加JS YES:只添加到mainFrame中
    [self.jsUserContentController addUserScript:script];
     */
    //js与webview交互配置
    self.jsUserContentController = [[WKUserContentController alloc] init];
    webViewConfig.userContentController = self.jsUserContentController;
    
    
    //添加一个名称，就可以在JS通过这个名称发送消息：
    //window.webkit.messageHandlers.AppModel.postMessage({body: 'xxx'})
    //[webViewConfig.userContentController addScriptMessageHandler:self name:@"AppModel"];
}

// JS调用上面[WKUserContentController addScriptMessageHandlerHandler:name:]添加的handler和name
// 获取到之后我们可以根据iOS和JS之间定义好的协议，来做出相应的操作。
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self didReceiveScriptMessage:message];
}

#pragma mark - public
- (void)jsUserContentControllerAddScriptName:(NSString *)name {
    [self.jsUserContentController addScriptMessageHandler:self name:@"jSCallOC"];
}

- (void)didReceiveScriptMessage:(WKScriptMessage *)message {
    //NSLog(@"JS调iOS  name : %@    body : %@",message.name, message.body);
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {
    [self.wkWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

-(void)evaluateJavaScriptRemoteURL:(NSString *)jsUrlString completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {
    NSString *jsFormatString = @"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.src = '%@';"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    NSString *jsString = [NSString stringWithFormat:jsFormatString, jsUrlString];
    [self.wkWebView evaluateJavaScript:jsString completionHandler:completionHandler];
}

-(void)evaluateJavaScriptLocalName:(NSString *)jsFileName completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:jsFileName ofType:@"js"];
    NSString *data = [NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:nil];
    NSString *jsString = [NSString stringWithFormat:@"javascript:%@",data];
    [self.wkWebView evaluateJavaScript:jsString completionHandler:completionHandler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
