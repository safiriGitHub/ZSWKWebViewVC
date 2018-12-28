//
//  ZSXfywWebViewVC.m
//  SmartFire
//
//  Created by safiri on 2018/12/28.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSXfywWebViewVC.h"

@interface ZSXfywWebViewVC ()

@end

@implementation ZSXfywWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if ([message isEqualToString:@"提交成功"]) {
        [webView goBack];
        completionHandler();
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.jsAlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler();
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
        
    
    //NSLog(@"alert message:%@",message);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
