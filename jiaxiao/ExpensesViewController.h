//
//  ExpensesViewController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "schoolCourseCell.h"
#import "ApplyOnlineViewController.h"
#import "MBProgressHUD.h"

@interface ExpensesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSDictionary *items;
    NSArray *groups;
    MBProgressHUD *progressHUD;
    NSString *schoolKey;
    NSString *phoneString;
}

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;
- (IBAction)callButtonPressed:(id)sender;



@end
