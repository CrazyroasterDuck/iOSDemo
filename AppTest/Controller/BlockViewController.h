//
//  BlockViewController.h
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/9.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <UIKit/UIKit.h>
/*block的使用方式：
 1.作为变量
 2.作为属性
 3.作为方法参数
 4.回调
 */

NS_ASSUME_NONNULL_BEGIN
typedef void(^BlockTest)(NSString *text);

@interface BlockViewController : UIViewController
@property(nonatomic,copy)BlockTest block;
@property(strong,nonatomic)NSThread *thread;
@end

NS_ASSUME_NONNULL_END
