//
//  schoolCourseCell.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "schoolCourseCell.h"

@implementation schoolCourseCell

@synthesize carTypeLabel;
@synthesize licenseTypeLabel;
@synthesize priceLabel;
@synthesize preferentialPriceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
