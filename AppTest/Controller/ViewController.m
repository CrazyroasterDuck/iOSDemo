//
//  ViewController.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/21.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "ViewController.h"
#import "DelegateView.h"

@interface ViewController ()<ViewDelegate,UITextFieldDelegate>
{
    UIButton *btn;
    UILabel *label;
    DelegateView *dView;
    BOOL isShow;
}
- (void)setBtnStyle;
- (void)setLabelStyle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.brownColor;
    [self setBtnStyle];
    [self setLabelStyle];
    [self addTextFieldWithDifferentKeyboard];
    dView = [[DelegateView alloc] init];
    dView.delegate = self;
    [dView setFrame:CGRectMake(20, 20, 200, 100)];
    [self.view addSubview:dView];
    isShow = YES;
}

- (void)setBtnStyle{
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 120) / 2, ([UIScreen mainScreen].bounds.size.height - 90) / 2, 120, 90)];
    [btn setTitle:@"click me!" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor greenColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)setLabelStyle{
    label = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2, ([UIScreen mainScreen].bounds.size.height + 100) / 2, 200, 100)];
    label.numberOfLines = 0; //不限制label标签的行数
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"Show After you click button!";
    label.textAlignment = NSTextAlignmentCenter;
    label.hidden = YES;
    [self.view addSubview:label];
}

-(void) addTextFieldWithDifferentKeyboard{

   UITextField *textField1= [[UITextField alloc]initWithFrame:
   CGRectMake(20, 150, 280, 30)];
   textField1.delegate = self;
   textField1.borderStyle = UITextBorderStyleRoundedRect;
   textField1.placeholder = @"Default Keyboard";
   [self.view addSubview:textField1];

   UITextField *textField2 = [[UITextField alloc]initWithFrame:
   CGRectMake(20, 170, 280, 30)];
   textField2.delegate = self;
   textField2.borderStyle = UITextBorderStyleRoundedRect;
   textField2.keyboardType = UIKeyboardTypeASCIICapable;
   textField2.placeholder = @"ASCII keyboard";
   [self.view addSubview:textField2];

   UITextField *textField3 = [[UITextField alloc]initWithFrame:
   CGRectMake(20, 190, 280, 30)];
   textField3.delegate = self;
   textField3.borderStyle = UITextBorderStyleRoundedRect;
   textField3.keyboardType = UIKeyboardTypePhonePad;
   textField3.placeholder = @"Phone pad keyboard";
   [self.view addSubview:textField3];

   UITextField *textField4 = [[UITextField alloc]initWithFrame:
   CGRectMake(20, 210, 280, 30)];
   textField4.delegate = self;
   textField4.borderStyle = UITextBorderStyleRoundedRect;
   textField4.keyboardType = UIKeyboardTypeDecimalPad;
   textField4.placeholder = @"Decimal pad keyboard";
   [self.view addSubview:textField4];

   UITextField *textField5= [[UITextField alloc]initWithFrame:
   CGRectMake(20, 230, 280, 30)];
   textField5.delegate = self;
   textField5.borderStyle = UITextBorderStyleRoundedRect;
   textField5.keyboardType = UIKeyboardTypeEmailAddress;
   textField5.placeholder = @"Email keyboard";
   [self.view addSubview:textField5];

   UITextField *textField6= [[UITextField alloc]initWithFrame:
   CGRectMake(20, 250, 280, 30)];
   textField6.delegate = self;
   textField6.borderStyle = UITextBorderStyleRoundedRect;
   textField6.keyboardType = UIKeyboardTypeURL;
   textField6.placeholder = @"URL keyboard";
   [self.view addSubview:textField6];
}

- (void)btnClicked:(UIButton *)btn{
    label.hidden = !label.hidden;
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
