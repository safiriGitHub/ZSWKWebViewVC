//
//  ZSWKWebViewJSVC.h
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2018/7/27.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSWKWebViewVC.h"

@interface ZSWKWebViewJSVC : ZSWKWebViewVC

@property (nonatomic ,strong, nonnull) WKWebViewConfiguration *webViewConfig;

@property (nonatomic ,strong, nonnull) WKUserContentController *jsUserContentController;

/**
 添加js回调的方法名
 需要子类调用
 实际调用：
 [self.jsUserContentController addScriptMessageHandler:self name:@"jSCallOC"];

 @param name 方法名
 */
- (void)jsUserContentControllerAddScriptName:(nonnull NSString *)name;


/**
 接收到js调用信息
 需要子类重写
 WKScriptMessageHandler代理方法回调时调用
 
 @param message js调用message
 */
- (void)didReceiveScriptMessage:(nullable WKScriptMessage *)message;


/**
 调用JS
 每次JS方法调用iOS方法的时候，为这个JS方法绑定一个对应的callBack方法，
 iOS直接回调相应的callBack方法，并携带相关的参数，这样就可以完美的进行交互了
 
 @param javaScriptString js代码，一般为js方法调用
 @param completionHandler 调用js成功后回调
 */
- (void)evaluateJavaScript:(nonnull NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;


/**
 加载远程JS文件(单个)

 @param jsUrlString JS文件url地址
 @param completionHandler 加载结果回调
 */
-(void)evaluateJavaScriptRemoteURL:(NSString *_Nullable)jsUrlString completionHandler:(void (^_Nullable)(id _Nullable, NSError * _Nullable))completionHandler;


/**
 加载本地JS文件(单个)
 这个方法只提供一般情况下加载逻辑，可自定义加载本地js后调用 -(void)evaluateJavaScript:completionHandler: 方法来实现加载

 @param jsFileName JS文件名
 @param completionHandler 加载结果回调
 */
-(void)evaluateJavaScriptLocalName:(NSString *_Nullable)jsFileName completionHandler:(void (^_Nullable)(id _Nullable, NSError * _Nullable))completionHandler;
@end

/*
 ---1---
 JS交互实现流程:
 使用WKWebView，JS调iOS-> JS端必须使用window.webkit.messageHandlers.JS_Function_Name.postMessage(null)，
 其中JS_Function_Name是iOS端提供给JS交互的Name。
 
 JS：
 function iOSCallJsAlert() {
    alert('弹个窗，再调用iOS端的JS_Function_Name');
    window.webkit.messageHandlers.JS_Function_Name.postMessage({body: 'paramters'});
 }
 
 OC:注入JS交互Handler
 [self.jsUserContentController addScriptMessageHandler:self name:JS_Function_Name];
 [self.jsUserContentController removeScriptMessageHandlerForName:JS_Function_Name];
 
 WKScriptMessageHandler:
 // JS调用上面[WKUserContentController addScriptMessageHandlerHandler:name:]添加的name
 // 获取到之后我们可以根据iOS和JS之间定义好的协议，来做出相应的操作。
 - (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
     NSLog(@"JS调iOS  name : %@    body : %@",message.name, message.body);
 }

 ---2---
 iOS端调用JS中的函数：
 只需要知道在JS中的函数名称和函数需要传递的参数。通过原生的方法呼叫JS，
 iOSCallJsAlert()是JS端的函数名称，如果有参数iOS端写法iOSCallJsAlert('p1','p2')
 [self.wkWebView evaluateJavaScript:@"iOSCallJsAlert()" completionHandler:nil];
 */
