//
//  LineDetailViewController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-14.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointDetailCell.h"
#import "PointMapViewController.h"
#import "MobClick.h"

@interface LineDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSArray *linePoints;
@property (nonatomic,retain) NSString *lineTitle;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) PointMapViewController *mapView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPointItem:(NSArray *)item;

@end
