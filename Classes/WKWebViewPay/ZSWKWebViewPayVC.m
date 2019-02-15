//
//  ZSWKWebViewPayVC.m
//  ZSWKWebViewVC-master
//
//  Created by safiri on 2019/2/15.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "ZSWKWebViewPayVC.h"

@interface ZSWKWebViewPayVC ()<WKNavigationDelegate>

@end

@implementation ZSWKWebViewPayVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.wkWebView.navigationDelegate = self;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    //NSLog(@"urlStr=%@",urlStr);

    // NOTE: ------  支付宝h5支付 -------
    if ([urlStr hasPrefix:@"alipay://alipayclient/"]) {
        NSURL *finalUrl = navigationAction.request.URL;
        // 更换scheme
        if (self.aliPayScheme) {
            NSString *decodePar = navigationAction.request.URL.query;
            if (decodePar == nil) decodePar = @"";
            decodePar = [self URLDecode:decodePar];
            NSMutableDictionary *dic = [[NSJSONSerialization JSONObjectWithData:[decodePar dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil] mutableCopy];
            [dic setValue:self.aliPayScheme forKey:@"fromAppUrlScheme"];
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:nil];
            NSString *param = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            param = [self URLEncode:param];
            if (param == nil) param = @"";
            finalUrl = [NSURL URLWithString:[@"alipay://alipayclient/?" stringByAppendingString:param]];
        }
        
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:finalUrl options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO}  completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:finalUrl];
        }
    }
    
    
    // NOTE: ------  微信h5支付，并解决APP内h5微信支付无法返回应用，跳转到Safari浏览器问题 -------
    /*
     https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?prepay_id=wx27141845681070d5d9c219683061113623&package=2942769839&redirect_url=http%3A%2F%2Fpay.egintra.com%3A8080%2FegintraPay-apptest%2Findex.jsp
     */
    NSString *wxpayScheme = self.wxPayScheme;
    // 去除原有的URL回调地址，换成自己的配置
    if ([urlStr hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"]) {
        if (wxpayScheme == nil) {
            WKBackForwardList *backForwardList = webView.backForwardList;
            WKBackForwardListItem *item = backForwardList.backList.firstObject;
            wxpayScheme = [[item.initialURL.absoluteString componentsSeparatedByString:@"?"] firstObject];
            if (wxpayScheme == nil) return;
        }
        NSURLComponents *comps = [[NSURLComponents alloc] initWithString:urlStr];
        BOOL needChange = NO;
        NSMutableArray *queryItems = [NSMutableArray arrayWithArray:comps.queryItems];
        for (NSInteger i = 0; i < queryItems.count; i++) {
            NSURLQueryItem *item = queryItems[i];
            if ([item.name isEqualToString:@"redirect_url"] && ![item.value isEqualToString:wxpayScheme]) {
                [[NSUserDefaults standardUserDefaults] setObject:item.value forKey:wxpayScheme];
                needChange = true;
                [queryItems removeObjectAtIndex:i];
                break;
            }
        }
        
        if (needChange) {
            NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:@"redirect_url" value:wxpayScheme];
            [queryItems addObject:item];
            comps.queryItems = [queryItems copy];
            if (comps.URL) {
                //NSLog(@"%@",comps.URL.absoluteString);
                NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:comps.URL];
                [mRequest setValue:wxpayScheme forHTTPHeaderField:@"Referer"];
                decisionHandler(WKNavigationActionPolicyCancel);
                [self.wkWebView loadRequest:mRequest];
                return;
            }
        }
    }
    if ([urlStr hasPrefix:@"weixin://"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        //  跳转支付宝App
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO}  completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        }
        return;
    }
    
    if (wxpayScheme && [urlStr hasPrefix:wxpayScheme]) {
        
        //访问原有的重定向地址
        NSString *redirectUrl = [[NSUserDefaults standardUserDefaults] objectForKey:wxpayScheme];
        if (redirectUrl) {
            decisionHandler(WKNavigationActionPolicyCancel);
            [webView goBack];
            NSURLRequest *redirectRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:redirectUrl]];
            [webView loadRequest:redirectRequest];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:wxpayScheme];
            return;
        }else {
            // 进入空白页，强制后退
            decisionHandler(WKNavigationActionPolicyCancel);
            [webView goBack];
        }
        return;
    }
    // NOTE: ------  微信h5支付 -------
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - url

- (NSString *)URLEncode:(NSString *)string {
    if ([string respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
         - parameter string: The string to be percent-escaped.
         - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < string.length) {
            NSUInteger length = MIN(string.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [string rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [string substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)string,
                                                NULL,
                                                CFSTR("!$&'()*+,-./:;=?@_~%#[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)URLDecode:(NSString *)string {
    if ([string respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [string stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [string stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

@end
