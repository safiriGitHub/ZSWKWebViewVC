//
//  ZSWKWebViewPayVC.h
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2019/2/15.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "ZSWKWebViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSWKWebViewPayVC : ZSWKWebViewVC

/**
 配置支付宝回调Scheme
 此值应在 Info 下的 URL Types 中配置，否则支付宝不能回调回本APP
 若不配置目前来看给的默认值：alipays，可能会与其他APP冲突
 */
@property (nonatomic, copy) NSString *aliPayScheme;

/**
 配置微信回调Scheme
 此值应为微信后台填写的支付账户域名，且应在 Info 下的 URL Types 中进行相关配置，否则微信不能回调回本APP
 例如：填写的是 https://xxx.com ,则为 xxx.com:// “URL Types”：xxx.com
      若解决自己多款APPy都用此域名，则可为每个APP配置不同的前缀：如，
        a.xxx.com:// -- “URL Types”：a.xxx.com,
        b.xxx.com:// -- “URL Types”：b.xxx.com ...
 */
@property (nonatomic, copy) NSString *wxPayScheme;

@end

NS_ASSUME_NONNULL_END
