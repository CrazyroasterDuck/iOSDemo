//
//  ViewController.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/21.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "FirstViewController.h"
#import "DelegateView.h"
#import "BlockViewController.h"
#import "CustomButton.h"
#import "NetViewController.h"
#import "AnimationViewController.h"
#import "ContainerView.h"
#import "Utility.h"

@interface FirstViewController ()<ViewDelegate,UITextFieldDelegate>
{
    UIButton *btn;
    UIButton *blockBtn;
    UIButton *netBtn;
    UIButton *animationBtn;
    UILabel *label;
    DelegateView *dView;
    UIScrollView *scrollView;
    ContainerView *cView;
    BOOL isShow;
    AVPlayerItem *vItem;
    AVPlayer *vPlayer;
    AVPlayerViewController *playerVC;
}
@end

@implementation FirstViewController

//self.view = nil的时候加载
-(void)loadView{
    [super loadView];
    NSLog(@"%s",__func__);
}
//self.view相关视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.brownColor;
    isShow = YES;
    [self initDelegateView];
    [self initNetBtn];
    [self addTextFieldWithDifferentKeyboard];
    [self setBtnStyle];
    [self setLabelStyle];
    [self initBlockView];
    [self initScrollView];
    [self initVideoPlayerView];
    
    animationBtn = [[CustomButton alloc] init];
    //[animationBtn setFrame:CGRectMake(320, 250, 75, 75)];
    [animationBtn setTitle:@"动画" forState:UIControlStateNormal];
    [animationBtn addTarget:self action:@selector(animationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:animationBtn];
    [animationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(dView);
        make.top.mas_equalTo(blockBtn).offset(10);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    
    //设置导航栏的标题属性
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 62, 20)];
    titleLabel.text = @"主页";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:26];
    self.navigationItem.titleView = titleLabel;
}

//视图将要被展示时使用，present和push等改变视图层次时使用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
}
//子控件大小未被设置好
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"%s",__func__);
}
//子控件的大小已被设置好
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"%s",__func__);
}

//视图渲染完成后调用，与viewDidAppear配套使用
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%s",__func__);
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning{
    //收到内存警告时调用
}

-(void)dealloc{
    NSLog(@"%s",__func__);
    [vItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [vItem removeObserver:self forKeyPath:@"status"];
}

- (void)initDelegateView{
    dView = [[DelegateView alloc] init];
    dView.delegate = self;
    [self.view addSubview:dView];
    [dView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(@120);
        make.size.mas_equalTo(CGSizeMake(200,50));
    }];
    [dView initLbl];
}

- (void)initNetBtn{
    netBtn = [[CustomButton alloc] init];
    //[netBtn setFrame:CGRectMake(250, 120, 150, 75)];
    [netBtn setTitle:@"进入网络模块" forState:UIControlStateNormal];
    [netBtn addTarget:self action:@selector(netBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:netBtn];
    [netBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(dView);
        make.size.mas_equalTo(CGSizeMake(150, 75));
    }];
}


- (void) addTextFieldWithDifferentKeyboard{
    
    UITextField *lastField , *textField;
    for(int i = 0;i < 6;i++){
        textField= [[UITextField alloc]init];
        textField.delegate = self;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:textField];
        switch (i) {
            case 0:
                textField.placeholder = @"Default keyboard";
                break;
            case 1:
                textField.keyboardType = UIKeyboardTypeASCIICapable;
                textField.placeholder = @"ASCII keyboard";
                break;
            case 2:
                textField.keyboardType = UIKeyboardTypePhonePad;
                textField.placeholder = @"Phone pad keyboard";
                break;
            case 3:
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                textField.placeholder = @"Decimal pad keyboard";
                break;
            case 4:
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                textField.placeholder = @"Email keyboard";
                break;
            case 5:
                textField.keyboardType = UIKeyboardTypeURL;
                textField.placeholder = @"URL keyboard";
                break;
            default:
                break;
        }
        if(lastField){
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastField.mas_left);
                make.top.mas_equalTo(lastField.mas_bottom).offset(5);
                make.size.equalTo(lastField);
            }];
        } else {
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(dView.mas_left);
                make.top.mas_equalTo(dView.mas_bottom).offset(20);
                make.size.equalTo(@(CGSizeMake(200, 30)));
            }];
        }
        lastField = textField;
    }
}

- (void)setBtnStyle{
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"click me!" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor greenColor]];
    //MV的target-action通信方式
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(netBtn.mas_left);
        make.top.mas_equalTo(netBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(150, 75));
    }];
}

- (void)setLabelStyle{
    label = [[UILabel alloc] init];
    label.numberOfLines = 0; //不限制label标签的行数
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"Show After you click button!";
    label.textAlignment = NSTextAlignmentCenter;
    label.hidden = YES;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btn.mas_left);
        make.top.mas_equalTo(btn.mas_bottom).offset(5);
        make.right.mas_equalTo(btn.mas_right);
        make.height.mas_equalTo(75);
    }];
}

- (void)initBlockView{
    blockBtn = [[CustomButton alloc] init];
    [blockBtn setTitle:@"block button" forState:UIControlStateNormal];
    [blockBtn addTarget:self action:@selector(blockBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blockBtn];
    [blockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btn.mas_left);
        make.top.mas_equalTo(label.mas_bottom).offset(20);
        make.size.mas_equalTo(netBtn);
    }];
}

- (void)initScrollView{
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockBtn.mas_bottom).offset(20);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    cView = [[ContainerView alloc]init];
    cView.backgroundColor = [UIColor blackColor];
    [scrollView addSubview:cView];
    [cView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.mas_equalTo(scrollView);
    }];
    [cView initImagView];
    [cView initPlayerView];
}

- (void)initVideoPlayerView{
    NSString *vStr = @""; //@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    NSURL *vUrl = [NSURL URLWithString:[Utility EncodeString:vStr]];
    vItem = [AVPlayerItem playerItemWithURL:vUrl];
    vPlayer = [AVPlayer playerWithPlayerItem:vItem];
    //使用layer设置视图约束不太方便该用AVPlayerViewController
//    playLayer = [AVPlayerLayer playerLayerWithPlayer:vPlayer];
//    playLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    playLayer.backgroundColor = [UIColor greenColor].CGColor;
//    [scrollView.layer addSublayer:playLayer];
//    playLayer.frame = CGRectMake(0, 0, 200, 400);
    playerVC = [[AVPlayerViewController alloc]init];
    playerVC.player = vPlayer;
    playerVC.view.backgroundColor = [UIColor whiteColor];
    [cView.playerView addSubview:playerVC.view];
    [playerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(300);
    }];

    [vItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [vItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    __block __typeof(self) weakself = self;
    [vPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                          queue:dispatch_get_main_queue()
                                     usingBlock:^(CMTime time) {
        NSTimeInterval current = CMTimeGetSeconds(time); //当前播放时间
        NSTimeInterval total = CMTimeGetSeconds(weakself->vPlayer.currentItem.duration);
        NSLog(@"now %f,total %f",current,total);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                      change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if([keyPath isEqualToString:@"loadedTimeRanges"]){
        
    } else if([keyPath isEqualToString:@"status"]){
        if(playerItem.status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"player Item is ready to play");
            [vPlayer play];
        } else if(playerItem.status == AVPlayerStatusUnknown){
            NSLog(@"playerItem unknown错误");
        } else if(playerItem.status == AVPlayerStatusFailed){
            NSLog(@"playerItem 失败");
        }
    }
    //销毁监听
    [vItem removeObserver:self forKeyPath:@"status"];
    [vItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    NSTimeInterval startSec = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSec = CMTimeGetSeconds(timeRange.duration);
    return startSec + durationSec;
}

# pragma mark -Action

- (void)btnClicked:(UIButton *)btn{
    label.hidden = !label.hidden;
}

- (void)netBtnClicked:(UIButton *)btn{
    NetViewController *nVC = [[NetViewController alloc] init];
    [self presentViewController:nVC animated:YES completion:^{}];
}

- (void)blockBtnClicked:(UIButton *)blockBtn{
    BlockViewController *blockVC = [[BlockViewController alloc] init];
    [self presentViewController:blockVC animated:YES completion:^{}];
    __weak typeof(self) weakSelf = self;
    [blockVC setBlock:^(NSString * _Nonnull text) {
        //通过以下方式换成强引用,或者将上面的__weak换成__block
        __typeof__(self) strongSelf = weakSelf;
        strongSelf->label.text = text;
    }];
}

- (void)animationBtnClicked:(UIButton *)btn{
    AnimationViewController *animationVC = [[AnimationViewController alloc] init];
    [self presentViewController:animationVC animated:YES completion:^{
    }];
}

#pragma mark -ViewDelegate
- (void)showViewContent{
    isShow = !isShow;
    [dView showLabel:isShow];
}

// pragma mark is used for easy access of code in Xcode
#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   NSLog(@"Text field did begin editing");
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
   NSLog(@"Text field ended editing");
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
