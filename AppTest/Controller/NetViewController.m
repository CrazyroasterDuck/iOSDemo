//
//  NetViewController.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/10.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "NetViewController.h"
#import "CustomButton.h"
#define MainWidth [UIScreen mainScreen].bounds.size.width
#define MainHeight [UIScreen mainScreen].bounds.size.height
@interface NetViewController ()<UISearchBarDelegate,WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>
{
    CustomButton *backButton;
    UILabel *resLabel;
    WKUserContentController *userContent;
}
@property (nonatomic, strong) UISearchBar *searchBar;
/// 网页控制导航栏
@property (weak, nonatomic) UIView *bottomView;

@property (nonatomic, strong) WKWebView *wkWebView;

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *forwardBtn;
@property (strong, nonatomic) UIButton *reloadBtn;
@property (strong, nonatomic) UIButton *browserBtn;

@property (strong, nonatomic) NSString *baseURLString;

//为视图添加进度条
@property(nonatomic,strong) UIProgressView *progressView;

@end

@implementation NetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    //[self SessionTest];
    //[self downloadTaskTest];
    //[self NSURLSessionBinaryUploadTaskTest];
    //[self simpleExampleTest];
    [self addSubViews];
    [self.wkWebView addSubview:self.progressView];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    
    UIButton *tempBtn = [[CustomButton alloc] init];
    [tempBtn setFrame:CGRectMake(10, MainHeight - 44, MainWidth,44)];
    [tempBtn setTitle:@"返回主页" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempBtn];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    backButton = [[CustomButton alloc] init];
    [backButton setFrame:CGRectMake(10, 10, 120, 75)];
    [backButton setTitle:@"返回主页" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 10, 200, 75)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:imageView];
    /*
     iOS 9出于安全方面的考虑，不允许使用非安全的HTTP协议联网，如果要用需要修改项目的Info.plist文件，
     添加“App Transport Security Settings”键，其类型是Dictionary；
     在“App Transport Security Settings”下添加一个子元素，
     键是“Allow Arbitrary Loads”，类型是Boolean，将其值设置为YES.
     */
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/img/bd_logo1.png"];
    //备用图片地址：https://tse3-mm.cn.bing.net/th/id/OIP.TtuOBhyQpZsSSxRHDiBqfAAAAA?pid=Api&rs=1
    NSData *data = [NSData dataWithContentsOfURL:url];
    imageView.image = [UIImage imageWithData:data];
    
}

- (void)backBtnClicked:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)SessionTest{
    resLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 200, 200)];
    resLabel.numberOfLines = 0;
    [self.view addSubview:resLabel];
    /*NSSession使用示例*/
    //建立url
    NSURL *urlT = [NSURL URLWithString:@"http://localhost:8080/wechat/hello/crazyduck?userId=321"];
    //根据url建立请求参数二三是缓存策略和超时时间
    NSURLRequest *request = [NSURLRequest requestWithURL:urlT cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    //还可以设置请求头和请求体等信息，前提是可变类型NSMutableURLRequest
    //使用全局session单例
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    //系统但会一个datatask任务
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result;
        NSString *currentThread = [NSThread currentThread];
        __typeof__(self) strongSelf = weakSelf;
        if(data && (error == nil)){
            result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //刷新UI需要放入主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf->resLabel.text = result;
            });
        } else{
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf->resLabel.text = error;
            });
        }
    }];
    //每个任务默认是挂起的，需要调用resume方法启动
    [dataTask resume];
}

- (void)downloadTaskTest{
    NSString *urlString = [NSString stringWithFormat:@"http://m8.music.126.net/20201013142417/2b8c048c7136222546c36b2a9ee87cba/ymusic/5152/5552/030c/f860fa842eb8201274264f2d9eda6139.mp3"];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    //创建下载任务
    NSURLSessionDownloadTask *downLoadTask = [sharedSession downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil){
            //location是临时存储下载文件的地址
            NSString *temp = location.path;
            //拷贝需要写到文件名
            NSString *store = @"/Users/crazyduck/Downloads/f860fa842eb8201274264f2d9eda6139.mp3";
            NSError *fileError;
            [[NSFileManager defaultManager] copyItemAtPath:temp toPath:store error:&fileError];
            if(fileError == nil){
                NSLog(@"file save sucess");
            }else{
                NSLog(@"file save error:%@",fileError);
            }
        }else{
            NSLog(@"download error:%@",error);
        }
    }];
    [downLoadTask resume];
}

/// 以流的方式上传，大小理论上不受限制，但应注意时间
- (void) NSURLSessionBinaryUploadTaskTest {
    // 1.创建url  采用Apache本地服务器
    NSString *urlString = @"https://postimages.org/json/rr";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 文件上传使用post
    request.HTTPMethod = @"POST";
    
    // 3.开始上传   request的body data将被忽略，而由fromData提供
    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:[NSData dataWithContentsOfFile:@"/Users/crazyduck/Downloads/Schrecksee_ZH-CN8548752524_1920x1080.jpg"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"upload success：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"upload error:%@",error);
        }
    }] resume];
}

- (void)simpleExampleTest{
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 210, MainWidth - 10, MainHeight - 210)];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    [webView loadRequest:request];
    NSURL *localURL = [NSURL fileURLWithPath:@"/Users/crazyduck/Downloads/Schrecksee_ZH-CN8548752524_1920x1080.jpg"];
    [webView loadFileURL:localURL allowingReadAccessToURL:localURL];
    /*
     - (WKNavigation *)loadRequest:(NSURLRequest *)request;
     - (WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
     - (WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType
        characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL;
     */
    [self.view addSubview:webView];
}

- (void)addSubViews {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.wkWebView];
}



#pragma mark - WKWebView WKUIDelegate 相关
- (void)webView:(WKWebView *)webView
    runJavaScriptAlertPanelWithMessage:(NSString *)message
    initiatedByFrame:(WKFrameInfo *)frame
    completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

// 显示两个按钮，通过completionHandler回调判断用户点击的确定还是取消按钮
- (void)webView:(WKWebView *)webView
    runJavaScriptConfirmPanelWithMessage:(NSString *)message
    initiatedByFrame:(WKFrameInfo *)frame
    completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 显示一个带有输入框和一个确定按钮的，通过completionHandler回调用户输入的内容
- (void)webView:(WKWebView *)webView
    runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
    defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame
    completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields.lastObject.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - WKWebView WKNavigationDelegate 相关
/// 是否允许加载网页 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    urlString = [urlString stringByRemovingPercentEncoding];
    //    NSLog(@"urlString=%@",urlString);
    // 用://截取字符串
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if ([urlComps count]) {
        // 获取协议头
        NSString *protocolHead = [urlComps objectAtIndex:0];
        NSLog(@"protocolHead=%@",protocolHead);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    //native调用js方法(js中调用alert的方法需要实现WKUIDelegate中的Alertpanel相关方法否则无法弹框)
    [_wkWebView evaluateJavaScript:@"iOSCallJsAlert()" completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"%@",error);
        }
    }];
    //加载远程JS文件
//    [webView evaluateJavaScript:@"var script = document.createElement('script');"
//         "script.type = 'text/javascript';"
//         "script.src = 'https://cn.bing.com/rs/6w/5/cj,nj/liatFQ1U8ZUHMNx-XEOJJE4W_qw.js';"
//         "document.getElementsByTagName('head')[0].appendChild(script);"
//                       completionHandler:^(id _Nullable object, NSError * _Nullable error)
//         {
//
//
//        NSLog(@"------error = %@ object = %@",error,object);
//         }];
}


#pragma mark - searchBar代理方法
/// 点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 创建url
    NSURL *url = nil;
    NSString *urlStr = searchBar.text;
    
    // 如果file://则为打开bundle本地文件，http则为网站，否则只是一般搜索关键字
    if([urlStr hasPrefix:@"File://"]){
        NSRange range = [urlStr rangeOfString:@"File://"];
        NSString *fileName = [urlStr substringFromIndex:range.length];
        url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        // 如果是模拟器加载电脑上的文件，则用下面的代码
        url = [NSURL fileURLWithPath:fileName];
    }else if(urlStr.length>0){
        if ([urlStr hasPrefix:@"http://"]) {
            url=[NSURL URLWithString:urlStr];
        } else {
            urlStr=[NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",urlStr];
        }
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url=[NSURL URLWithString:urlStr];
        
    }
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    // 加载请求页面
    [self.wkWebView loadRequest:request];
}
#pragma mark - 懒加载
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainHeight - 45, MainWidth, 44)];
        _bottomView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}
- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 90, MainWidth, 44)];
        searchBar.delegate = self;
        searchBar.text = @"http://www.baidu.com";
        _searchBar = searchBar;
        
    }
    return _searchBar;
}

- (WKWebView *)wkWebView {
    if (_wkWebView == nil) {
        //创建配置
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //创建UserContentController，提供js向webview发送消息的方法
        userContent = [[WKUserContentController alloc] init];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        [userContent addScriptMessageHandler:self name:@"JS_Function_Name"];
        config.userContentController = userContent;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 135, MainWidth, MainHeight - 180) configuration:config];
        webView.backgroundColor = [UIColor lightGrayColor];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        
        // 允许左右划手势导航，默认允许
        webView.allowsBackForwardNavigationGestures = YES;
        _wkWebView = webView;
    }

    return _wkWebView;
}

- (UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, MainHeight / 2 , MainWidth, 1)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(nonnull WKUserContentController *)userContentController
      didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSString *mes;
    mes = message.name;
    mes = message.body;
    NSLog(@"JS 调用 iOS name :%@ body : %@",message.name,message.body);
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    if([keyPath isEqualToString:@"estimatedProgress"]){
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             * 添加一个简单的动画，将 progressView 的 Height 变为1.5倍
             * 动画时长0.25s，延时0.3s后开始动画
             * 动画结束后将 progressView 隐藏
             */
            __weak __typeof(self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [userContent removeScriptMessageHandlerForName:@"JS_Function_Name"];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
