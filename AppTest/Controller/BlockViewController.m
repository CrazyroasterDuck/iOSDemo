//
//  BlockViewController.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/9.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "BlockViewController.h"

@interface BlockViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UITextField *textField;
    UIButton *backBtn;
    UILabel *timeLabel;
    UILabel *blockLabel;
    UIScrollView *scrollView;
}
@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self listenInput];
    
    //定义一个计时器，每秒钟调用setTime方法
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0  target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    //将定时器添加到当前RunLoop的NSDefaultRunLoopMode
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    //要想定时器在NSDefaultRunLoopMode和UITrackingRunLoopMode两种模式下工作，可将上改成：
   // [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.thread start];
}

- (void)listenInput{
    /*
     KVO通信方式示例
     监听textField的text属性，当其值发生改变时，
     vc获取到其值，并显示到blockLabel中
     */
    [textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"text"] && [object isKindOfClass:[UITextField class]]){
        textField = object;
        blockLabel.text = textField.text;
    }
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    textField= [[UITextField alloc]initWithFrame:
    CGRectMake(20, 50, 300, 40)];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"请输入内容";
    [self.view addSubview:textField];
//    [textField addTarget:self action:@selector(text) forControlEvents:UIControlEventEditingChanged];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backBtn setFrame:CGRectMake(80, 100, 100, 75)];
    [backBtn setBackgroundColor:[UIColor whiteColor]];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //设置边框颜色
    backBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    //设置边框宽度
    backBtn.layer.borderWidth = 1.0f;
    //给按钮设置角的弧度
    backBtn.layer.cornerRadius = 4.0f;
    [self.view addSubview:backBtn];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 220, 250, 100)];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.contentSize = CGSizeMake(250, 400);
    [self.view addSubview:scrollView];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 250, 50)];
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:timeLabel];
    
    blockLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 350, 200, 100)];
    blockLabel.backgroundColor = [UIColor lightTextColor];
    blockLabel.textAlignment = NSTextAlignmentCenter;
    blockLabel.text = @"KVO测试";
    blockLabel.numberOfLines = 0;
    [self.view addSubview:blockLabel];
}

- (void)run{
    [self freshTimeInTextField];
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

- (void)freshTimeInTextField{
    //刷新UI的代码需要放置到主线程中去
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        self->textField.text = [self getCurrentTimes];
    });
}

- (void)setTime{
    timeLabel.text = [self getCurrentTimes];
}

//监听触摸事件，将freshTimeInTextField放入到常驻方法中去
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self performSelector:@selector(freshTimeInTextField) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (NSString*)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateNow = [NSDate date];
    //把NSDate按formatter格式转成NSString
    NSString *currentTime = [formatter stringFromDate:dateNow];
    return currentTime;
}



- (void)backBtnClicked:(UIButton *)backBtn{
    [self dismissViewControllerAnimated:YES completion:^{}];
    self.block(textField.text);
}

#pragma mark - TextField Delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//- (void)textFieldDidChangeSelection:(UITextField *)textField{
//    if(textField.markedTextRange == nil){
//        blockLabel.text = textField.text;
//    }
//}

- (void)dealloc{
    [textField removeObserver:self forKeyPath:@"text"];
}

@end
