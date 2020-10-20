//
//  main.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/21.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Person.h"
#import "Person+Category.h"
#import "Student.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
//        Person *p = [[Person alloc] init];
//        p.nameWithSetterGetter = @"test";
//        [p printInfo];
//        Student *st  = [[Student alloc]init];
//        [st swizzlingTest];
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
