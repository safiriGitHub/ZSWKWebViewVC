# ZSWKWebViewVC

#### 项目介绍
WKWebView 常用功能封装

0.0.8: 删除`ZSExtendWKWebVC`类, 改由 ZSWKWebViewVC 处理 `WKNavigationDelegate, WKUIDelegate` 代理方法

0.0.9: fix some bug

0.1.0: 添加 ZSWKWebViewVC 是否使用已经封装好的代理逻辑代码功能

0.1.1: 添加 ZSDefaultDelegateVC 类，封装默认的处理代理逻辑的代码

0.1.2/0.1.3: 修改 WKWebView h5页面显示不全问题

0.1.4: 修改dealloc中的bug `self.webView -> _webview`

0.1.5: - 删除无用代码；
	   - 添加页面Back消失时，pop或者dismiss形式，及是否弹框提示、弹框配置；
	   - 添加ZSWKWebViewPayVC类，添加支付宝、微信H5支付功能及相关适配

#### 安装教程

pod 'ZSWKWebViewVC'

pod 'ZSWKWebViewVC/Base'

pod 'ZSWKWebViewVC/WKWebViewJavaScript'

pod 'ZSWKWebViewVC/WKWebViewJavascriptBridge'

#### 参与贡献

1. Fork 本项目
2. 新建 Feat_xxx 分支
3. 提交代码
4. 新建 Pull Request