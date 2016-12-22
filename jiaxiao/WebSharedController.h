//
//  WebSharedController.h
//  FindDrivingSchool
//
//  Created by 杜 海峰 on 11-11-3.
//  Copyright (c) 2011年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebSharedController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *mWebView;
    NSInteger mType;
    
    NSString *mContentStr;
}
@property (nonatomic,copy) NSString* mContentStr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(NSInteger)type content:(NSString *)str;
@end
