//
//  schoolCourseCell.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface schoolCourseCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *licenseTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *preferentialPriceLabel;

@end
