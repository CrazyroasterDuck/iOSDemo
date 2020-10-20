//
//  Person.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/10.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)printInfo{
    NSLog(@"My name is %@ , I'm %@ years old. My registerNumber is %@, from %@ department!",_name,_year,_registerNumber,_department);
}

- (void)sw_printInfo{
    NSLog(@"swizzling method test!");
}
@end
