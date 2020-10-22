//
//  DelegateView.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/21.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "DelegateView.h"
#import <Masonry/Masonry.h>
@interface DelegateView()
{
    UILabel *label;
}
@end

@implementation DelegateView

@synthesize delegate = _delegate;
- (instancetype)init
{
    if(self = [super init]){
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initLbl{
    label = [[UILabel alloc] init];
    label.text = @"show after click view!";
    label.textColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.hidden = YES;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    if(self.delegate && [self.delegate respondsToSelector:@selector(showViewContent)]){
        [self.delegate showViewContent];
        NSLog(@"调用委托方法！");
    }
}

- (void)showLabel:(BOOL)show{
    label.hidden = show;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
