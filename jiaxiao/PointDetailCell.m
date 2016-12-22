//
//  PointDetailCell.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-14.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "PointDetailCell.h"

@implementation PointDetailCell
@synthesize pointLabel;
@synthesize nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
