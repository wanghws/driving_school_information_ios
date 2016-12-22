//
//  MoreViewController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebSharedController.h"
#import <MessageUI/MessageUI.h>
#import "MobClick.h"
#import "RecommendViewController.h"

@interface MoreViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *myTabelView;

@end
