//
//  SchoolBusController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import "LineDetailViewController.h"
#import "SearchResultController.h"
#import "MyLocationViewController.h"
#import "MBProgressHUD.h"

@interface SchoolBusController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (retain,nonatomic) NSArray *lines;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (retain, nonatomic) UIToolbar *toolBar;


@end
