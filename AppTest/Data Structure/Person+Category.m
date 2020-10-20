//
//  Person+Category.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/16.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "Person+Category.h"
#import <objc/runtime.h>
static NSString *nameWithSetterGetterKey = @"nameWithSetterGetterKey";

@implementation Person (Category)
/*
 属性nameWithoutSetterGetter没有getter和setter方法实现
 */
- (void)setNameWithSetterGetter:(NSString *)nameWithSetterGetter {
        objc_setAssociatedObject(self, &nameWithSetterGetterKey, nameWithSetterGetter, OBJC_ASSOCIATION_COPY);
}
- (NSString *)nameWithSetterGetter {
    return objc_getAssociatedObject(self, &nameWithSetterGetterKey);

}
- (void)programCategoryMethod {
    NSLog(@"实现分类方法");
}

- (void)printInfo{
    NSLog(@"分类覆盖原有的打印方法！");
}
@end
