//
//  PersonDetailCell.h
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/28.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonDetailCell : UITableViewCell
@property (nonatomic,strong)UILabel *regnoLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *depLabel;
@property (nonatomic,strong)UILabel *yearLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)cellFrame;
- (void)setPersonDetailInfo:(NSString *)regno name:(NSString *)name
                 department:(NSString *)dep year:(NSString *)year;
@end

NS_ASSUME_NONNULL_END
