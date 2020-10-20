//
//  Student.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/19.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "Student.h"
#import "Person+Category.h"
#import <objc/runtime.h>

@implementation Student
- (void)swizzlingTest{
    Method origMethod = class_getInstanceMethod([self superclass], @selector(printInfo));
    if(!origMethod) {
        NSLog(@"original method %@ not found for class %@",NSStringFromSelector(@selector(printInfo)),[self superclass]);
        return;
    }
    
    Method altMethod = class_getInstanceMethod([self superclass], @selector(sw_printInfo));
    if(!altMethod) {
        NSLog(@"original method %@ not found for class %@",NSStringFromSelector(@selector(sw_printInfo)),[self superclass]);
        return;
    }
    method_exchangeImplementations(origMethod, altMethod);
    [self printInfo];
    [self sw_printInfo];
}
@end
