//
//  Person+Category.h
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/16.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (Category)
@property(nonatomic,copy) NSString *nameWithSetterGetter;           //设置setter/getter方法的属性

@property(nonatomic,copy) NSString *nameWithoutSetterGetter;        //不设置setter/getter方法的属性，注意编译的警告部分

- (void) programCategoryMethod;
- (void)printInfo;
@end

NS_ASSUME_NONNULL_END
