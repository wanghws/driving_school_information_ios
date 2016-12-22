//
//  WebSharedController.m
//  FindDrivingSchool
//
//  Created by 杜 海峰 on 11-11-3.
//  Copyright (c) 2011年 . All rights reserved.
//

#import "WebSharedController.h"
#import "RXCustomTabBar.h"
#import "MobClick.h"

@implementation WebSharedController

@synthesize mContentStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(NSInteger)type content:(NSString *)str
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        mType=type;
        self.mContentStr=str;
        self.title = @"微博分享";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"h53"];
    self.navigationController.navigationBarHidden=NO;
    [(RXCustomTabBar *)self.tabBarController hideNewTabBar];
}

-(void)leftBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (mType==0) {
        
        //@"学车请用找驾校iphone版"
        
        NSString *content=[NSString stringWithFormat:@"http://v.t.sina.com.cn/share/share.php?title=%@",mContentStr];
        NSString* escapedUrlString =[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:escapedUrlString]]];
    }
    else if(mType==3){
        NSString *content=[NSString stringWithFormat:@"http://itunes.apple.com/cn/app//id522043557?mt=8"];
        
        [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:content]]];
    }
    else
    {   
        NSString *content=[NSString stringWithFormat:@"http://v.t.qq.com/share/share.php?title=%@",mContentStr];
        NSString* escapedUrlString =[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:escapedUrlString]]];
    }
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 1, 54, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = buttonItem;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
