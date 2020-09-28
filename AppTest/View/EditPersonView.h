//
//  EditPersonView.h
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/28.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditPersonView : UIView
@property(nonatomic,weak) id<UITextFieldDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id)delegate;
@end

NS_ASSUME_NONNULL_END
