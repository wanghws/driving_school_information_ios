//
//  HomePageController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@class BDMapViewController;

@interface HomePageController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *items;
    NSArray *groups;
    MBProgressHUD *progressHUD;
    
    NSString *schoolKey;
}

@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;

@property (retain, nonatomic) BDMapViewController *bdMapView;
@property (retain, nonatomic) NSString *strDesc;

@property (retain, nonatomic) IBOutlet UITableView *itemsTableView;

- (IBAction)mapButtonPressed:(id)sender;

- (IBAction)callButtonPressed:(id)sender;

- (NSString *) stringByStrippingHTML:(NSString*)srcStr;

@end
