//
//  Person.h
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/10.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property(nonatomic,strong) NSString *registerNumber; //注册号
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *department;
@property(nonatomic,strong) NSString *year;
- (void)printInfo;
- (void)sw_printInfo;
@end

NS_ASSUME_NONNULL_END
