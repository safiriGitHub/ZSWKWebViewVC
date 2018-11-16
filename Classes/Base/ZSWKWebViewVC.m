//
//  ZSWKWebViewVC.m
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2018/7/26.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSWKWebViewVC.h"

@interface ZSWKWebViewVC ()<UIGestureRecognizerDelegate>

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
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        
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
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"ZSWKWebView" ofType:@"bundle"]];
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
