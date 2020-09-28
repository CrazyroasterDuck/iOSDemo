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
    UIButton *addBtn;
}
@end

@implementation EditPersonView

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id)delegate{
    if(self = [super initWithFrame:frame]){
        _delegate = delegate;
        regnoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 50, (self.bounds.size.height - 30) / 2)];
        regnoLabel.text = @"RegisterNumber";
        regnoLabel.backgroundColor = [UIColor grayColor];
        regnoLabel.textAlignment = NSTextAlignmentCenter;
        regnoField = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, (self.bounds.size.width -225) / 2, (self.bounds.size.height - 30) / 2)];
        regnoField.delegate = _delegate;
        regnoField.borderStyle = UITextBorderStyleRoundedRect;
        regnoField.keyboardType = UIKeyboardTypeNumberPad;
        regnoField.placeholder = @"请输入注册日期";
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65 + (self.bounds.size.width -225) / 2, 10, 50, (self.bounds.size.height - 30) / 2)];
        nameLabel.text = @"Name";
        nameLabel.backgroundColor = [UIColor grayColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameField = [[UITextField alloc]initWithFrame:CGRectMake(120 + (self.bounds.size.width -225) / 2, 10, (self.bounds.size.width -225) / 2, (self.bounds.size.height - 30) / 2)];
        nameField.delegate = _delegate;
        nameField.borderStyle = UITextBorderStyleRoundedRect;
        nameField.keyboardType = UIKeyboardTypeDefault;
        nameField.placeholder = @"请输入用户姓名";
        
        depLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 20 + (self.bounds.size.height - 30) / 2, 50, (self.bounds.size.height - 30) / 2)];
        depLabel.text = @"Department";
        depLabel.backgroundColor = [UIColor grayColor];
        depLabel.textAlignment = NSTextAlignmentCenter;
        depField = [[UITextField alloc]initWithFrame:CGRectMake(60,20 + (self.bounds.size.height - 30) / 2 , (self.bounds.size.width -225) / 2, (self.bounds.size.height - 30) / 2)];
        depField.delegate = _delegate;
        depField.borderStyle = UITextBorderStyleRoundedRect;
        depField.keyboardType = UIKeyboardTypeNumberPad;
        depField.placeholder = @"请输入部门";
        
        yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(65 + (self.bounds.size.width -225) / 2, 20 + (self.bounds.size.height - 30) / 2, 50, (self.bounds.size.height - 30) / 2)];
        yearLabel.text = @"Year";
        yearLabel.backgroundColor = [UIColor grayColor];
        yearLabel.textAlignment = NSTextAlignmentCenter;
        yearField = [[UITextField alloc]initWithFrame:CGRectMake(120 + (self.bounds.size.width -225) / 2, 20 + (self.bounds.size.height - 30) / 2, (self.bounds.size.width -225) / 2, (self.bounds.size.height - 30) / 2)];
        yearField.delegate = _delegate;
        yearField.borderStyle = UITextBorderStyleRoundedRect;
        yearField.keyboardType = UIKeyboardTypeNumberPad;
        yearField.placeholder = @"请输入年份";
        
        saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [saveBtn setFrame:CGRectMake(self.bounds.size.width - 80, 10, 60, 40)];
        [saveBtn setBackgroundColor:[UIColor whiteColor]];
        [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
        //设置边框颜色
        saveBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        //设置边框宽度
        saveBtn.layer.borderWidth = 1.0f;
        //给按钮设置角的弧度
        saveBtn.layer.cornerRadius = 4.0f;
        
        addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [addBtn setFrame:CGRectMake(self.bounds.size.width - 80, 55, 60, 40)];
        [addBtn setBackgroundColor:[UIColor whiteColor]];
        [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addBtn setTitle:@"ADD" forState:UIControlStateNormal];
        //设置边框颜色
        addBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        //设置边框宽度
        addBtn.layer.borderWidth = 1.0f;
        //给按钮设置角的弧度
        addBtn.layer.cornerRadius = 4.0f;
        
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
        [self addSubview:addBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
