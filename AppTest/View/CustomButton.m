//
//  CustomButton.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/10.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
- (instancetype)init{
    if((self = [super init])){
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置边框颜色
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        //设置边框宽度
        self.layer.borderWidth = 1.0f;
        //给按钮设置角的弧度
        self.layer.cornerRadius = 4.0f;
    }
    return self;
}
@end
