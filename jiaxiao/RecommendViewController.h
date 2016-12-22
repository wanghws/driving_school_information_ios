//
//  RecommendViewController.h
//  FindDrivingSchool
//
//  Created by wanghw on 12-6-5.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SDImageView+SDWebCache.h"
#import "CJSONDeserializer.h"
#import "Tools.h"

@interface RecommendViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain,nonatomic) NSArray *appArrarList;
@property (retain,nonatomic) UITableView *appTabelView;
@end
