//
//  ZSWKWebViewVC.m
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2018/7/26.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSWKWebViewVC.h"

@interface ZSWKWebViewVC ()<UIGestureRecognizerDelegate, WKNavigationDelegate, WKUIDelegate>

@end

@implementation ZSWKWebViewVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.configStatusBarStyle = UIStatusBarStyleLightContent;
        _navigationBarTranslucent = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self setWebNavigationBar];
    //开始加载
    [self starLoadRequestURL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)configUI {
    if (self.navigationTitle)
        self.title = self.navigationTitle;
    [self.view addSubview:self.wkWebView];
    [self.wkWebView addSubview:self.progressView];
    self.navigationController.navigationBar.translucent = self.navigationBarTranslucent;
    if (!self.forbidPopGestureRecognizer) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:ObserVerKeyPathEstimatedProgress context:nil];
    [self.wkWebView removeObserver:self forKeyPath:ObserVerKeyPathTitle context:nil];
    if (self.allowCleanCacheAndCookie) {
        [self cleanCacheAndCookie];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - public for override

- (void)starLoadRequestURL {
    if (self.requestURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestURL]];
        [self.wkWebView loadRequest:request];
    }
}

#pragma mark - getters and setters
NSString *const ObserVerKeyPathEstimatedProgress = @"estimatedProgress";
NSString *const ObserVerKeyPathTitle = @"title";
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        if (self.configurationForInit) {
            _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:self.configurationForInit];
        }else {
            _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        }
        
        [_wkWebView addObserver:self forKeyPath:ObserVerKeyPathEstimatedProgress options:NSKeyValueObservingOptionNew context:NULL];
        [_wkWebView addObserver:self forKeyPath:ObserVerKeyPathTitle options:NSKeyValueObservingOptionNew context:NULL];
        //开启手势触摸
        _wkWebView.allowsBackForwardNavigationGestures = YES;
    }
    return _wkWebView;
}
- (UIProgressView *)progressView {
    if (!_progressView) {
        CGFloat y = self.navigationBarTranslucent ? 64 : 0;
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 1.5)];
        _progressView.progressTintColor = [UIColor colorWithRed:50.f / 255.f green:250.f / 245.f blue:0.f / 255.f alpha:1.0]; // 微信绿;
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}
- (void)setWebNavigationBarStyle:(WebNavigationBarStyle)webNavigationBarStyle {
    _webNavigationBarStyle = webNavigationBarStyle;
    [self setWebNavigationBar];
}
- (void)setIsOpenNavigationDelegate:(BOOL)isOpenNavigationDelegate {
    _isOpenNavigationDelegate = isOpenNavigationDelegate;
    if (isOpenNavigationDelegate) {
        self.wkWebView.navigationDelegate = self;
    }else {
        self.wkWebView.navigationDelegate = nil;
    }
}
- (void)setIsOpenUIDelegate:(BOOL)isOpenUIDelegate {
    _isOpenUIDelegate = isOpenUIDelegate;
    if (isOpenUIDelegate) {
        self.wkWebView.UIDelegate = self;
    }else {
        self.wkWebView.UIDelegate = nil;
    }
}
+ (WKWebViewConfiguration *)commonWKWebViewConfiguration {
    //初始化一个WKWebViewConfiguration对象
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口. iOS默认为NO
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    return config;
}
#pragma mark - private
- (void)backNavigationButtonClick {
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeNavigationButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setWebNavigationBar {
    if (self.webNavigationBarStyle == StyleBackCloseTogether) {
        if (@available(iOS 11, *)) {
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedSpace.width = 15.0f;
            
            UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftBtn setImage:[self getDefaultBundleImage:@"webNav_backItem@2x"] forState:UIControlStateNormal];
            [leftBtn addTarget:self action:@selector(backNavigationButtonClick) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
            
            UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [popBtn setImage:[self getDefaultBundleImage:@"webNav_closeItem@2x"] forState:UIControlStateNormal];
            [popBtn addTarget:self action:@selector(closeNavigationButtonClick) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *popItem = [[UIBarButtonItem alloc] initWithCustomView:popBtn];
            
            self.navigationItem.leftBarButtonItems = @[leftItem,fixedSpace,popItem];
            
            
        } else {
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedSpace.width = -17.0f;
            UIBarButtonItem *fixedSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedSpace1.width = 4.0f;
            
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
            //解决出现的那条线
            toolBar.clipsToBounds = YES;
            //解决tools背景颜色的问题
            [toolBar setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
            [toolBar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
            //添加两个button
            UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[self getDefaultBundleImage:@"webNav_backItem@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(backNavigationButtonClick)];
            UIBarButtonItem *popItem = [[UIBarButtonItem alloc]initWithImage:[self getDefaultBundleImage:@"webNav_closeItem@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(closeNavigationButtonClick)];
            
            [toolBar setItems:@[fixedSpace,leftItem,fixedSpace1,popItem,fixedSpace]];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
        }
    }
    else if (self.webNavigationBarStyle == StyleBackCloseSeparate) {
        //返回按钮用系统的
        UIImage *image1 = [[self getDefaultBundleImage:@"webNav_backItem@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:image1 style:UIBarButtonItemStyleDone target:self action:@selector(backNavigationButtonClick)];
        self.navigationItem.leftBarButtonItem = backItem;
        //右侧关闭按钮：
        UIImage *image2 = [[self getDefaultBundleImage:@"webNav_closeItem@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:image2 style:UIBarButtonItemStyleDone target:self action:@selector(closeNavigationButtonClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}
- (UIImage *)getDefaultBundleImage:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[ZSWKWebViewVC class]] pathForResource:@"ZSWKWebView" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}
//MARK: CleanCacheAndCookie
- (void)cleanCacheAndCookie {
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    if (@available(iOS 9.0, *)) {
        WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
        [dataStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] completionHandler:^(NSArray<WKWebsiteDataRecord *> * _Nonnull records) {
            for (WKWebsiteDataRecord *record in records) {
                [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes forDataRecords:@[record] completionHandler:^{
                    NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                }];
            }
        }];
    }
}

//MARK: KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    // 首先，判断是哪个路径
    
    if ([keyPath isEqualToString:ObserVerKeyPathEstimatedProgress]) {
        //判断是哪个对象
        if (object == self.wkWebView) {
            //NSLog(@"进度信息：%lf",self.wkWebView.estimatedProgress);
            if (self.wkWebView.estimatedProgress == 1.0) {
                //隐藏
                self.progressView.hidden = YES;
            }else{
                self.progressView.hidden = NO;
                // 添加进度数值
                self.progressView.progress = self.wkWebView.estimatedProgress;
            }
        }
        else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else if ([keyPath isEqualToString:ObserVerKeyPathTitle]) {
        //判断是哪个对象
        if (object == self.wkWebView) {
            if (!self.hideWebpageTitle) {
                self.title = self.wkWebView.title;
            }
        }
        else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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

//MARK: StatusBarStyle
- (void)setConfigStatusBarStyle:(UIStatusBarStyle)configStatusBarStyle {
    _configStatusBarStyle = configStatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.configStatusBarStyle;//childViewControllerForStatusBarStyle 返回nil才起作用
}
- (UIViewController *)childViewControllerForStatusBarStyle {
    return nil;
}

@end
