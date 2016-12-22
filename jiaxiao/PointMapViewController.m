//
//  PointMapViewController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-17.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "PointMapViewController.h"
#import "RXCustomTabBar.h"
#import "MobClick.h"

@interface PointMapViewController ()

@end

@implementation PointMapViewController
@synthesize linePoints;
@synthesize PMapView;
@synthesize lineTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPointItem:(NSArray *)item title:(NSString*) title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.linePoints = [NSArray arrayWithArray:item];
        self.lineTitle = title;
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"h34"];
    [(RXCustomTabBar *)self.tabBarController hideNewTabBar];
//    [self addAnnatationForMap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.lineTitle;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 1, 54, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = buttonItem;
    

    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"list_button.png"] forState:UIControlStateNormal];
    [rightButton setTitle:@"    列表" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightButton addTarget:self action:@selector(rightBarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = buttonItem1;
    

    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    BMKMapView *aMap = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, mainScreenRect.size.height-56)];
    self.PMapView = aMap;
    [self.PMapView setShowsUserLocation:NO];
    PMapView.delegate = self;
    [self.view addSubview:PMapView];

    
    
    [NSThread detachNewThreadSelector:@selector(addAnnatationForMap) toTarget:self withObject:nil];
}

- (void)addAnnatationForMap
{
    NSDictionary *dict;
    for (int i = 0; i<[self.linePoints count]; i++) {
        dict = [self.linePoints objectAtIndex:i];
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[dict objectForKey:@"y"]floatValue];
        coor.longitude = [[dict objectForKey:@"x"]floatValue];
        annotation.title = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"time"],[dict objectForKey:@"name"]];
        annotation.coordinate = coor;
        if (i == 0){
            [self.PMapView setCenterCoordinate:coor];
  
        }
        [self.PMapView addAnnotation:annotation];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];   
        newAnnotation.image = [UIImage imageNamed:@"marker_bus.png"];
		//newAnnotation.animatesDrop = YES;
        
        newAnnotation.canShowCallout = TRUE;
		return newAnnotation;   
	}
	return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

//- (void)isReachability
//{
//    Reachability *reachability = [Reachability reachabilityWithHostName:@"www."];
//    if (reachability.currentReachabilityStatus == NotReachable) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启网络，以便我们更好的为您提供服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)leftBarButtonAction:(id)sender
{
    //NSLog(@"map view back");
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)rightBarButtonPressed
{
    
    CATransition *transition = [CATransition animation];
    transition.duration =0.7;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController popViewControllerAnimated:NO]; 
}

@end
