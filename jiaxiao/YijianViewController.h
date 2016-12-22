//
//  YijianViewController.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-11.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"
#import "ASIFormDataRequest.h"
#import "Commons.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface YijianViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate>
{
    NSURLConnection * conn;
    NSMutableData * webData;
    BOOL backJianpan;
    
    UIToolbar * toolBar;
}
@property (retain, nonatomic) IBOutlet UILabel *zishuLable;
@property (retain, nonatomic) IBOutlet UITextView *textView1;
@property (retain, nonatomic) IBOutlet UITextField *youxianText;
@property (retain, nonatomic) MBProgressHUD *progressBar;

@end
