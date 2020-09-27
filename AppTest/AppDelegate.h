//
//  AppDelegate.h
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/21.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ViewController; //提前声明使用

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong,nonatomic) UIWindow *window;

@property (strong,nonatomic) ViewController *viewControler;

- (void)saveContext;


@end

