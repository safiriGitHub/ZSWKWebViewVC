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
    StyleBackCloseTogether,
    StyleBackCloseSeparate,
    StyleBack
};

@interface ZSWKWebViewVC : UIViewController
// MARK: - Init

/**
 初始化 wkWebView 的WKWebViewConfiguration，在push前设置
 */
@property (nonatomic, strong) WKWebViewConfiguration *configurationForInit;

/**
 返回常用配置：最小字体10，支持JavaScript。
 更多配置根据实际需要配置，并赋值给 configurationForInit
 @return WKWebViewConfiguration实例
 */
+ (WKWebViewConfiguration *)commonWKWebViewConfiguration;

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

/**
 导航栏是否透明 默认YES
 */
@property (nonatomic, assign) BOOL navigationBarTranslucent;

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

/**
 控制状态栏颜色，默认UIStatusBarStyleLightContent
 前提：View controller-based status bar appearance - YES
 */
@property (nonatomic ,assign) UIStatusBarStyle configStatusBarStyle;

// MARK: - pop Or dismiss / alert config

/**
 值为：pop还是dismiss
 */
@property (nonatomic, copy) NSString *popOrDismiss;

/**
 当pop或dismiss时是否提示，默认NO不提示
 */
@property (nonatomic, assign) BOOL isHintBack;

/**
 alert标题，isHintBack为YES时需要配置
 */
@property (nonatomic, copy) NSString *alertTitle;

/**
 alert内容，isHintBack为YES时需要配置
 */
@property (nonatomic, copy) NSString *alertMessage;

@end



