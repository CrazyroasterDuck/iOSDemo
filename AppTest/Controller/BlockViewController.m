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
    UIScrollView *scrollView;
}
@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    //定义一个计时器，每秒钟调用setTime方法
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0  target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    //将定时器添加到当前RunLoop的NSDefaultRunLoopMode
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    //要想定时器在NSDefaultRunLoopMode和UITrackingRunLoopMode两种模式下工作，可将上改成：
   // [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.thread start];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
