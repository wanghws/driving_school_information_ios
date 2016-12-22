//
//  DetailPhotoController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "DetailPhotoController.h"
#import "CONST.h"
#import "MobClick.h"
#import "RXCustomTabBar.h"

@interface DetailPhotoController ()

@end

@implementation DetailPhotoController
@synthesize myScrollView;
@synthesize photoList;
@synthesize index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}



- (void)viewDidLoad
{
    //NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    
    self.navigationItem.title = [[photoList objectAtIndex:self.index]objectForKey:@"title"];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 1, 54, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    
    [self setImageViewForScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    [MobClick event:@"h41"];
    [(RXCustomTabBar *)self.tabBarController hideNewTabBar];
}

- (void)setImageViewForScrollView
{
    
    self.myScrollView.contentSize = CGSizeMake(320*[self.photoList count], 240);
    
    int i = 0;
    for(NSDictionary *photo in self.photoList) {

        UIImageView *imageView = [[UIImageView alloc]init];
        NSString *url = [NSString stringWithFormat:@"http://image./images/school/f_%@",[photo objectForKey:@"pic"]];
        NSURL *imgUrl = [NSURL URLWithString:url];
        [imageView setImageWithURL:imgUrl refreshCache:NO placeholderImage:[UIImage imageNamed:@"zhanwei.png"]];
        imageView.frame = CGRectMake(0+320*i, 90, 320, 240);
        [self.myScrollView addSubview:imageView];

        i++;
    }
    self.myScrollView.contentOffset = CGPointMake(0+self.index*320, 0);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ((int)(scrollView.contentOffset.x)%320 == 0) {
        int i = (int)(scrollView.contentOffset.x)/320;
        self.navigationItem.title = [[photoList objectAtIndex:i]objectForKey:@"title"];
    }
}

#pragma mark ButtonPressed
- (void)leftBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
