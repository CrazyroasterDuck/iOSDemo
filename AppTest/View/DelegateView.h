//
//  DelegateView.h
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/21.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*协议定义 delegate通信方式示例*/
@protocol ViewDelegate <NSObject>
@required
- (void)showViewContent;
@end

@interface DelegateView : UIView
@property(nonatomic,weak) id<ViewDelegate> delegate;

- (instancetype)init;
- (void)showLabel:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
