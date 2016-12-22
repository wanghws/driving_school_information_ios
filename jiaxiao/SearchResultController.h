//
//  SearchResultController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-17.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "NearPointViewController.h"
#import "MBProgressHUD.h"

@interface SearchResultController : UIViewController<BMKSearchDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BMKSearch *searchMap;
}

@property (retain, nonatomic) NSString *searchKey;
@property (retain, nonatomic) NSArray *resultArray;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) MBProgressHUD *progressHUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSearchObj:(NSString *)key;

@end
