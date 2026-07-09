//
//  EasySSplashDetailViewController.m
//  EasySpreadSDK
//
//  Created by renpin-ios on 2026/5/18.
//  Copyright © 2026 易推SDK. All rights reserved.
//

#import "EasySSplashDetailViewController.h"
#import "EasySCustomNavigationBarView.h"
#import <WebKit/WebKit.h>
#import "UIDevice+EasyS.h"
#import "EasySSDKStartConfiguration.h"
#import "YTSDKAPIConfiguration.h"

@interface EasySSplashDetailViewController ()
<WKUIDelegate,
 WKNavigationDelegate,
 EasySCustomNavigationBarViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *splashWebView;
@property (nonatomic, strong) EasySCustomNavigationBarView *customNav;
@property (nonatomic, assign) EasySSplashAdCloseType closeType;
@property (nonatomic, assign) BOOL isObservingProgress; // 标记KVO状态
@property (nonatomic, strong) NSString *titleKey;
@end

@implementation EasySSplashDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.closeType = EasySSplashAdCloseType_DetailClose;
    self.isObservingProgress = NO;
    self.titleKey = @"title";
    [self setUpSubViews];
    [self loadWebContent];
}

- (void)setUpSubViews {
    CGFloat statusBarH = [UIDevice getStatusBarHeight];
    CGFloat navBarH = 44.0;
    
    // 自定义导航栏
    self.customNav = [[EasySCustomNavigationBarView alloc]
                      initWithFrame:CGRectMake(0, statusBarH, self.view.bounds.size.width, navBarH)];
    self.customNav.backgroundColor = [UIColor whiteColor];
    self.customNav.title = self.splashTitle ?: @"";
    self.customNav.delegate = self;
    [self.view addSubview:self.customNav];
    
    // 进度条：紧贴导航栏下方
    CGFloat progressY = statusBarH + navBarH;
    self.progressView = [[UIProgressView alloc]
                         initWithFrame:CGRectMake(0, progressY, self.view.bounds.size.width, 2)];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = MySDKColor();
    self.progressView.hidden = YES;
    [self.view addSubview:self.progressView];
    
    // WebView
    CGFloat webY = CGRectGetMaxY(self.progressView.frame);
    CGFloat webH = self.view.bounds.size.height - webY;
    self.splashWebView.frame = CGRectMake(0, webY, self.view.bounds.size.width, webH);
    [self.view addSubview:self.splashWebView];
    
    // 滚动区域适配
    if (@available(iOS 11.0, *)) {
        self.splashWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)loadWebContent {
    if (!self.splashUrl || self.splashUrl.length == 0) {
        return;
    }
    NSURL *url = [NSURL URLWithString:self.splashUrl];
    if (!url) {
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = YTSDKAPIConfiguration.shared.timeoutInterval;
    [self.splashWebView loadRequest:request];
    
    // 开启KVO监听加载进度
    if (!self.isObservingProgress) {
        [self.splashWebView addObserver:self
                             forKeyPath:@"estimatedProgress"
                                options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                               context:nil];
        self.isObservingProgress = YES;
    }
    [self.splashWebView addObserver:self
                         forKeyPath:self.titleKey
                            options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                           context:nil];

}

#pragma mark - KVO 进度监听
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.splashWebView) {
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        self.progressView.progress = progress;
        self.progressView.hidden = (progress >= 1.0);
        
    }else if ([keyPath isEqualToString:self.titleKey] && object == self.splashWebView) {
        self.customNav.title = change[NSKeyValueChangeNewKey];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = url.scheme.lowercaseString;
    
    // 拦截微信、支付宝等第三方跳转
    if ([scheme isEqualToString:@"weixin"] || [scheme isEqualToString:@"alipay"]) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    
    // -999 直接忽略，不做弹窗/日志报错
        if (error.code == NSURLErrorCancelled) {
            return;
        }
    [self navigationBarClose]; //加载失败退出
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
}

#pragma mark - WKUIDelegate 支持JS弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 自定义导航栏代理
- (void)navigationBarBack {
    // Web 内部回退
    if (self.splashWebView.canGoBack) {
        // 加载新URL前先取消
        [self.splashWebView stopLoading];
        [self.splashWebView goBack];
        return;
    }
    
    // 无法回退则关闭页面
    if (self.currentTime <= 0) {
        self.closeType = EasySSplashAdCloseType_DetailBack;
        [self navigationBarClose];
    } else {
        if ([self.delegate respondsToSelector:@selector(splashDetailBackTime:)]) {
            [self.delegate splashDetailBackTime:self.currentTime];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)navigationBarClose {
    if ([self.delegate respondsToSelector:@selector(splashDetailAdDidCloseType:)]) {
        [self.delegate splashDetailAdDidCloseType:self.closeType];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 生命周期
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 页面消失 立即停止加载 + 移除KVO（防崩溃核心）
    [self.splashWebView stopLoading];
    if (self.isObservingProgress) {
        [self.splashWebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.splashWebView removeObserver:self forKeyPath:self.titleKey];
        self.isObservingProgress = NO;
    }
}

- (void)dealloc {
    
    // 二次兜底
    if (self.isObservingProgress) {
        [self.splashWebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.splashWebView removeObserver:self forKeyPath:self.titleKey];
    }
    // 清空代理，打破引用
    _splashWebView.navigationDelegate = nil;
    _splashWebView.UIDelegate = nil;
    _customNav.delegate = nil;
}

#pragma mark - Lazy Load
- (WKWebView *)splashWebView {
    if (!_splashWebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 开启JS交互
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        _splashWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _splashWebView.navigationDelegate = self;
        _splashWebView.UIDelegate = self;
        _splashWebView.allowsBackForwardNavigationGestures = YES;
        _splashWebView.scrollView.showsVerticalScrollIndicator = YES;
        _splashWebView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _splashWebView;
}

@end
