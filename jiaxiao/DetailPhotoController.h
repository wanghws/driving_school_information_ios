//
//  DetailPhotoController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDImageView+SDWebCache.h"

@interface DetailPhotoController : UIViewController<UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain,nonatomic) NSArray *photoList;
@property (assign,nonatomic) NSInteger index;

@end
