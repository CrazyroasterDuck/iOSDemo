//
//  ContainerView.h
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/21.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContainerView : UIView
@property(strong,nonatomic) UIView *playerView;

- (void)initImagView;
- (void)initPlayerView;
@end

NS_ASSUME_NONNULL_END
