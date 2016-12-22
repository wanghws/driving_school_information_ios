//
//  PhotoAlbumController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailPhotoController.h"
#import "MBProgressHUD.h"
#import "SDImageView+SDWebCache.h"

@interface PhotoAlbumController : UIViewController
@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain,nonatomic) NSArray *photoList;

@end
