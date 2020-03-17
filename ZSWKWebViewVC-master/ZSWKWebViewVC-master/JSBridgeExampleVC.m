//
//  JSBridgeExampleVC.m
//  ZSWKWebViewVC-master
//
//  Created by pengpai on 2020/3/17.
//  Copyright © 2020 safiri. All rights reserved.
//

#import "JSBridgeExampleVC.h"

@interface JSBridgeExampleVC ()

@end

@implementation JSBridgeExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"trans_agreement" ofType:@"html"];
    if (@available(iOS 9.0, *)) {
        [self.wkWebView loadFileURL:[NSURL fileURLWithPath:filePath] allowingReadAccessToURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    } else {
        // Fallback on earlier versions
    }
    [self.javascriptBridge registerHandler:@"inputPlateNum" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"truckNo");
    }];
    [self.javascriptBridge registerHandler:@"inputPhone" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"inputPhone");
    }];
    [self.javascriptBridge registerHandler:@"inputFirstParty" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"inputFirstParty");
    }];
    [self.javascriptBridge registerHandler:@"inputSecondParty" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"inputSecondParty");
    }];
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
