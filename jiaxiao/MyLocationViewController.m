//
//  MyLocationViewController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-17.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "MyLocationViewController.h"
#import "MobClick.h"
#import "Commons.h"

@interface MyLocationViewController ()

@end

@implementation MyLocationViewController
@synthesize PMapView;
@synthesize showPointList;
@synthesize annotationArray;


#pragma mark lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"h31"];
    
    [(RXCustomTabBar *)self.tabBarController hideNewTabBar];
    //[self.PMapView setShowsUserLocation:YES];
    //[MobClick event:@"h31"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"附近班车";
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 1, 54, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = buttonItem;

    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    BMKMapView *aMap = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, mainScreenRect.size.height-56)];
    self.PMapView = aMap;
    PMapView.delegate = self;
    [aMap setShowsUserLocation:YES];
    [self.view addSubview:PMapView];

    
    
    self.showPointList = [[NSMutableArray alloc] init];
    self.annotationArray = [[NSMutableArray alloc] init];
    
}


- (void)leftBarButtonAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addAnnatationForMap
{
    for (NSDictionary *point in self.showPointList) {
        float x = [[point objectForKey:@"x" ]floatValue];
        float y = [[point objectForKey:@"y" ]floatValue];
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = y;
        coor.longitude = x;
        annotation.subtitle = [point objectForKey:@"lineName" ];
        annotation.title = [NSString stringWithFormat:@"%@ %@",[point objectForKey:@"time" ],[point objectForKey:@"name" ]];
        annotation.coordinate = coor;
        [self.PMapView setCenterCoordinate:coor];
        [self.annotationArray addObject:annotation];

    }
    
    [self.PMapView removeAnnotations:self.annotationArray];
    [self.PMapView addAnnotations:self.annotationArray];
}

#pragma mark BKMapDelegate
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
        double yMin = self.PMapView.userLocation.location.coordinate.latitude - 0.02;
        double yMax = self.PMapView.userLocation.location.coordinate.latitude + 0.02;
        
        double xMin = self.PMapView.userLocation.location.coordinate.longitude - 0.02;
        double xMax = self.PMapView.userLocation.location.coordinate.longitude + 0.02;
        
        if ([SharedDelegate.lines count] > 0)
            [self.showPointList removeAllObjects];
        else
            return;
        
        //NSLog(@"SharedDelegate.lines %d",[SharedDelegate.lines count]);
        for (NSDictionary *line in SharedDelegate.lines) {
            NSArray *list = [line objectForKey:@"list"];
            for (NSDictionary *local in list){
                float x = [[local objectForKey:@"x" ]floatValue];
                float y = [[local objectForKey:@"y" ]floatValue];
                if (x > xMin && x < xMax && y > yMin && y < yMax) {
                    NSMutableDictionary *point = [[NSMutableDictionary alloc]initWithDictionary:local];
                    [point setValue:[line objectForKey:@"lineName"] forKey:@"lineName"];
                    [self.showPointList addObject:point];
                }
            }
            
            
        }
        
        if ([self.showPointList count] <= 0) {
            [Commons alertWithTitle:@"提示" Message:@"附近2公里范围内没有班车点"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }else {
            [self addAnnatationForMap];
        }

	}
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
	[Commons alertWithTitle:@"提示" Message:@"定位失败"];
	
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	
}

- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{

    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];   
        newAnnotation.image = [UIImage imageNamed:@"marker_bus.png"];
		newAnnotation.animatesDrop = NO;
        newAnnotation.canShowCallout = TRUE;
		return newAnnotation;
	}
	return nil;
}

@end
