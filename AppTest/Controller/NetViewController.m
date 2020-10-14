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
@interface NetViewController ()<UISearchBarDelegate,WKNavigationDelegate>
{
    CustomButton *backButton;
    UILabel *resLabel;
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
    [self refreshBottomButtonState];
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
    [self addBottomViewButtons];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.wkWebView];
}

- (void)addBottomViewButtons {
    // 记录按钮个数
    int count = 0;
    // 添加按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setTitle:@"后退" forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor colorWithRed:249 / 255.0 green:102 / 255.0 blue:129 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_backBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_backBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    _backBtn.tag = ++count;    // 标记按钮
    [_backBtn addTarget:self action:@selector(onBottomButtonsClicled:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_backBtn];
    
    
    _forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forwardBtn setTitle:@"前进" forState:UIControlStateNormal];
    [_forwardBtn setTitleColor:[UIColor colorWithRed:249 / 255.0 green:102 / 255.0 blue:129 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_forwardBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_forwardBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_forwardBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    _forwardBtn.tag = ++count;
    [_forwardBtn addTarget:self action:@selector(onBottomButtonsClicled:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_forwardBtn];
    
    _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [_reloadBtn setTitleColor:[UIColor colorWithRed:249 / 255.0 green:102 / 255.0 blue:129 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_reloadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_reloadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_reloadBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    _reloadBtn.tag = ++count;
    [_reloadBtn addTarget:self action:@selector(onBottomButtonsClicled:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_reloadBtn];
    
    _browserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_browserBtn setTitle:@"Safari" forState:UIControlStateNormal];
    [_browserBtn setTitleColor:[UIColor colorWithRed:249 / 255.0 green:102 / 255.0 blue:129 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_browserBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_browserBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_browserBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    _browserBtn.tag = ++count;
    [_browserBtn addTarget:self action:@selector(onBottomButtonsClicled:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_browserBtn];
    // 统一设置frame
    [self setupBottomViewLayout];
}
- (void)setupBottomViewLayout
{
    int count = 4;
    CGFloat btnW = 80;
    CGFloat btnH = 30;
    
    CGFloat btnY = (self.bottomView.bounds.size.height - btnH) / 2;
    // 按钮间间隙
    CGFloat margin = (self.bottomView.bounds.size.width - btnW * count) / count;
    
    CGFloat btnX = margin * 0.5;
    self.backBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    btnX = self.backBtn.frame.origin.x + btnW + margin;
    self.forwardBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    btnX = self.forwardBtn.frame.origin.x + btnW + margin;
    self.reloadBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    btnX = self.reloadBtn.frame.origin.x + btnW + margin;
    self.browserBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
}
/// 刷新按钮是否允许点击
- (void)refreshBottomButtonState {
    if ([self.wkWebView canGoBack]) {
        self.backBtn.enabled = YES;
    } else {
        self.backBtn.enabled = NO;
    }
    
    if ([self.wkWebView canGoForward]) {
        self.forwardBtn.enabled = YES;
    } else {
        self.forwardBtn.enabled = NO;
    }
}
/// 按钮点击事件
- (void)onBottomButtonsClicled:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [self.wkWebView goBack];
            [self refreshBottomButtonState];
        }
            break;
        case 2:
        {
            [self.wkWebView goForward];
            [self refreshBottomButtonState];
        }
            break;
        case 3:
            [self.wkWebView reload];
            break;
        case 4:
            [[UIApplication sharedApplication] openURL:self.wkWebView.URL];
            break;
        default:
            break;
    }
}

#pragma mark - WKWebView WKNavigationDelegate 相关
/// 是否允许加载网页 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
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
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, (MainHeight / 2 + 135), MainWidth, 44)];
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
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 135, MainWidth, MainHeight / 2)];
        webView.backgroundColor = [UIColor lightGrayColor];
        webView.navigationDelegate = self;
//                webView.scrollView.scrollEnabled = NO;
        
        //        webView.backgroundColor = [UIColor colorWithPatternImage:self.image];
        // 允许左右划手势导航，默认允许
        webView.allowsBackForwardNavigationGestures = YES;
        _wkWebView = webView;
    }

    return _wkWebView;
}
@end
