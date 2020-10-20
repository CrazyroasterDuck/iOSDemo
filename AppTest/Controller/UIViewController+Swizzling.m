//
//  UIViewController+Swizzling.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/19.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)
+ (void)load
{
    SEL origSel = @selector(viewWillAppear:);
    SEL swizSel = @selector(swiz_viewDidAppear:);
    [self swizzleMethods:[self class] originalSelector:origSel swizzledSelector:swizSel];
}

+ (void)swizzleMethods:(Class)class
            originalSelector:(SEL)origSel
            swizzledSelector:(SEL)swizSel
{
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method swizMethod = class_getInstanceMethod(self, swizSel);
    //class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(self, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if(didAddMethod){
        class_replaceMethod(self, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else{
        method_exchangeImplementations(origMethod, swizMethod);
    }
}



- (void)swiz_viewDidAppear:(BOOL)animated
{
    NSLog(@"I'm in - [swiz_viewDidAppear:]");
    [self swiz_viewDidAppear:animated];//此时该方法实际执行的是viewWillAppear:
}
@end
