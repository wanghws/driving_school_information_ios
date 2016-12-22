//
//  LineDetailViewController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-14.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "LineDetailViewController.h"
#import  <QuartzCore/CoreAnimation.h>
#import "RXCustomTabBar.h"

@interface LineDetailViewController ()

@end

@implementation LineDetailViewController
@synthesize linePoints;
@synthesize myTableView;
@synthesize mapView;
@synthesize lineTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPointItem:(NSArray *)item
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.linePoints = [NSArray arrayWithArray:item];
        
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"h33"];
    [(RXCustomTabBar *)self.tabBarController hideNewTabBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.lineTitle;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 1, 54, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = buttonItem;
    

    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"mapbutton.png"] forState:UIControlStateNormal];
    [rightButton setTitle:@"地图" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightButton addTarget:self action:@selector(rightBarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = buttonItem1;
    

    
    PointMapViewController *aView = [[PointMapViewController alloc] initWithNibName:@"PointMapViewController" bundle:nil withPointItem:self.linePoints title:self.lineTitle];
    self.mapView = aView;
    

}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.linePoints count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 32;
    }else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }  
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        cell.textLabel.text = self.lineTitle;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *CellIdentifier = @"pointCell";
    PointDetailCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PointDetailCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = [self.linePoints objectAtIndex:indexPath.row-1];

    cell.pointLabel.text = [dict objectForKey:@"time"];
    cell.nameLabel.text = [dict objectForKey:@"name"];
    
    return cell;
}

- (void)leftBarButtonAction:(id)sender
{
    //NSLog(@"list view back");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightBarButtonPressed
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController pushViewController:self.mapView animated:NO];
}

@end
