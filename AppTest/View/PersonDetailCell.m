//
//  PersonDetailCell.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/28.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "PersonDetailCell.h"

@implementation PersonDetailCell
@synthesize regnoLabel,nameLabel,depLabel,yearLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)cellFrame
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        regnoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, (cellFrame.size.width - 30) / 2, (cellFrame.size.height - 15) / 2)];
        regnoLabel.backgroundColor = [UIColor clearColor];
        regnoLabel.textAlignment = NSTextAlignmentLeft;
        regnoLabel.numberOfLines = 2;
        regnoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        regnoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [self.contentView addSubview:regnoLabel];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + (cellFrame.size.width - 30) / 2, 5, (cellFrame.size.width - 30) / 2, (cellFrame.size.height - 15) / 2)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.numberOfLines = 2;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [self.contentView addSubview:nameLabel];
        
        depLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + (cellFrame.size.height - 15) / 2, (cellFrame.size.width - 30) / 2, (cellFrame.size.height - 15) / 2)];
        depLabel.backgroundColor = [UIColor clearColor];
        depLabel.textAlignment = NSTextAlignmentLeft;
        depLabel.numberOfLines = 2;
        depLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        depLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [self.contentView addSubview:depLabel];
        
        yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + (cellFrame.size.width - 30) / 2, (cellFrame.size.height - 15) / 2 + 10, (cellFrame.size.width - 30) / 2, (cellFrame.size.height - 15) / 2)];
        yearLabel.backgroundColor = [UIColor clearColor];
        yearLabel.textAlignment = NSTextAlignmentLeft;
        yearLabel.numberOfLines = 2;
        yearLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        yearLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [self.contentView addSubview:yearLabel];
    }
    return self;
}

- (void)setPersonDetailInfo:(NSString *)regno name:(NSString *)name department:(NSString *)dep year:(NSString *)year{
    regnoLabel.text = regno;
    nameLabel.text = name;
    depLabel.text = dep;
    yearLabel.text = year;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
