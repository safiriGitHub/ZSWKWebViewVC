//
//  ZSExtendWKWebVC.h
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2018/7/27.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSWKWebViewVC.h"


/**
 ZSWKWebViewVC扩展VC
 基于 WKNavigationDelegate、WKUIDelegate 实现各种配置
 */
@interface ZSExtendWKWebVC : ZSWKWebViewVC <WKNavigationDelegate>

/**
 是否关闭识别电话 默认NO
 */
@property (nonatomic ,assign) BOOL closeRecognizePhone;
@end
