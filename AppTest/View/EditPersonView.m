//
//  EditPersonView.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/28.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "EditPersonView.h"

@interface EditPersonView()
{
    UITextField *regnoField;
    UITextField *nameField;
    UITextField *depField;
    UITextField *yearField;
    UILabel *regnoLabel;
    UILabel *nameLabel;
    UILabel *depLabel;
    UILabel *yearLabel;
    UIButton *saveBtn;
    UIButton *delBtn;
}
@end

@implementation EditPersonView

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id)delegate{
    if(self = [super initWithFrame:frame]){
        _delegate = delegate;
        regnoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 50, (self.bounds.size.height - 30) / 2)];
        regnoLabel.text = @"Register";
        regnoLabel.backgroundColor = [UIColor grayColor];
        regnoLabel.textAlignment = NSTextAlignmentCenter;
        regnoLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10];
        regnoField = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, (self.bounds.size.width -225) / 2,
                        (self.bounds.size.height - 30) / 2)];
        regnoField.delegate = _delegate;
        regnoField.borderStyle = UITextBorderStyleRoundedRect;
        regnoField.keyboardType = UIKeyboardTypeNumberPad;
        regnoField.placeholder = @"输入注册日期";
        regnoField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65 + (self.bounds.size.width -225) / 2,
                        10, 50, (self.bounds.size.height - 30) / 2)];
        nameLabel.text = @"Name";
        nameLabel.backgroundColor = [UIColor grayColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10];
        nameField = [[UITextField alloc]initWithFrame:CGRectMake(120 + (self.bounds.size.width -225) / 2, 10,
                        (self.bounds.size.width -225) / 2, (self.bounds.size.height - 30) / 2)];
        nameField.delegate = _delegate;
        nameField.borderStyle = UITextBorderStyleRoundedRect;
        nameField.keyboardType = UIKeyboardTypeDefault;
        nameField.placeholder = @"输入用户姓名";
        nameField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        depLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 20 + (self.bounds.size.height - 30) / 2,
                        50, (self.bounds.size.height - 30) / 2)];
        depLabel.text = @"Department";
        depLabel.backgroundColor = [UIColor grayColor];
        depLabel.textAlignment = NSTextAlignmentCenter;
        depLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10];
        depField = [[UITextField alloc]initWithFrame:CGRectMake(60,20 + (self.bounds.size.height - 30) / 2 ,
                        (self.bounds.size.width -225) / 2, (self.bounds.size.height - 30) / 2)];
        depField.delegate = _delegate;
        depField.borderStyle = UITextBorderStyleRoundedRect;
        depField.keyboardType = UIKeyboardTypeDefault;
        depField.placeholder = @"输入部门";
        depField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(65 + (self.bounds.size.width -225) / 2,
                        20 + (self.bounds.size.height - 30) / 2, 50, (self.bounds.size.height - 30) / 2)];
        yearLabel.text = @"Year";
        yearLabel.backgroundColor = [UIColor grayColor];
        yearLabel.textAlignment = NSTextAlignmentCenter;
        yearLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10];
        yearField = [[UITextField alloc]initWithFrame:CGRectMake(120 + (self.bounds.size.width -225) / 2,
                        20 + (self.bounds.size.height - 30) / 2, (self.bounds.size.width -225) / 2, (self.bounds.size.height - 30) / 2)];
        yearField.delegate = _delegate;
        yearField.borderStyle = UITextBorderStyleRoundedRect;
        yearField.keyboardType = UIKeyboardTypeNumberPad;
        yearField.placeholder = @"输入年份";
        yearField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [saveBtn setFrame:CGRectMake(self.bounds.size.width - 80, 10, 60, 40)];
        [saveBtn setBackgroundColor:[UIColor whiteColor]];
        [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //设置边框颜色
        saveBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        //设置边框宽度
        saveBtn.layer.borderWidth = 1.0f;
        //给按钮设置角的弧度
        saveBtn.layer.cornerRadius = 4.0f;
        
        delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [delBtn setFrame:CGRectMake(self.bounds.size.width - 80, 55, 60, 40)];
        [delBtn setBackgroundColor:[UIColor whiteColor]];
        [delBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [delBtn setTitle:@"DELETE" forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //设置边框颜色
        delBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        //设置边框宽度
        delBtn.layer.borderWidth = 1.0f;
        //给按钮设置角的弧度
        delBtn.layer.cornerRadius = 4.0f;
        
        self.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:regnoLabel];
        [self addSubview:regnoField];
        [self addSubview:nameLabel];
        [self addSubview:nameField];
        [self addSubview:depLabel];
        [self addSubview:depField];
        [self addSubview:yearLabel];
        [self addSubview:yearField];
        [self addSubview:saveBtn];
        [self addSubview:delBtn];
    }
    return self;
}

- (void)setPersonInfo:(NSArray *)arr{
    regnoField.text = arr[0];
    nameField.text = arr[1];
    depField.text = arr[2];
    yearField.text = arr[3];
}

- (void)saveBtnClicked:(UIButton *)btn
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(savePersonInfo:)]){
        NSString *regno = regnoField.text;
        NSString *name = nameField.text;
        NSString *dep = depField.text;
        NSString *year = yearField.text;
        NSArray *arr = @[regno,name,dep,year];
        [self.delegate savePersonInfo:arr];
    }
}

- (void)delBtnClicked:(UIButton *)btn
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(delPersonInfo:)]){
        if(regnoField.text && nameField.text && depField.text && yearField.text){
            NSString *regno = regnoField.text;
            NSString *name = nameField.text;
            NSString *dep = depField.text;
            NSString *year = yearField.text;
            NSArray *arr = @[regno,name,dep,year];
            [self.delegate delPersonInfo:arr];
        }
        regnoField.text = nil;
        nameField.text = nil;
        depField.text = nil;
        yearField.text = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
