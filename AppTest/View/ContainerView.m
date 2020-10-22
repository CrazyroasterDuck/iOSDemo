//
//  ContainerView.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/21.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "ContainerView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "Utility.h"

@interface ContainerView()
{
    UIImageView *imageView;
}
@end

@implementation ContainerView

- (void)initImagView{
    imageView = [[UIImageView alloc] init];
    NSString *urlStr = @"https://s3.cn-north-1.amazonaws.com.cn/discovery/activity/degree_pre_banner.png";
    [self addSubview:imageView];
    __block CGSize size;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[Utility EncodeString:urlStr]]
                 placeholderImage:[UIImage imageNamed: @"launch image"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(error){
            [self->imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self);
            }];
        } else {
            size = image.size;
            [self->imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.height.mas_equalTo(self.bounds.size.width * size.height / size.width);
            }];
        }
    }];
    
}

- (void)initPlayerView{
    _playerView = [[UIView alloc] init];
    _playerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_playerView];
    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(5);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(600);
        //添加与父视图bottom相关的约束，已撑起来父视图
        make.bottom.equalTo(self.mas_bottom).offset(-30);
    }];
}

@end
