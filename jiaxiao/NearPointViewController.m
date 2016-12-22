//
//  NearPointViewController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-17.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "NearPointViewController.h"
#import "Commons.h"
#import "AppDelegate.h"


@interface NearPointViewController ()

@end

@implementation NearPointViewController
@synthesize PMapView;
@synthesize poiInfo;
@synthesize showPointList;
@synthesize annotationArray;
@synthesize annotation1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSearchObj:(BMKPoiInfo *)obj
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.poiInfo = obj;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"附近班车点";
    //[MobClick event:@"h34"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 1, 54, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = buttonItem;

    
    [(RXCustomTabBar *)self.tabBarController hideNewTabBar];
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    BMKMapView *aMap = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, mainScreenRect.size.height-56)];
    self.PMapView = aMap;
    [self.PMapView setShowsUserLocation:NO];
    PMapView.delegate = self;
    [self.view addSubview:PMapView];


    annotation1 = [[BMKPointAnnotation alloc]init];
	CLLocationCoordinate2D coor;
    coor = poiInfo.pt;
	annotation1.coordinate = coor;
	annotation1.title = self.poiInfo.name;
    [self.PMapView setCenterCoordinate:coor];
	[self.PMapView addAnnotation:annotation1];
    
    self.showPointList = [[NSMutableArray alloc] init];
    self.annotationArray = [[NSMutableArray alloc] init];
    
    [self findNearPoint];
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

- (void)leftBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark BKMapDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];   
        if (annotation != annotation1)newAnnotation.image = [UIImage imageNamed:@"marker_bus.png"];
        [newAnnotation setPinColor:BMKPinAnnotationColorRed];
        //newAnnotation.animatesDrop = YES;
        newAnnotation.canShowCallout = TRUE;
        //[newAnnotation setSelected:YES animated:YES];
		return newAnnotation;   
	}
	return nil;
}

- (void)showMap
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

- (void)findNearPoint
{
    double yMin = self.poiInfo.pt.latitude - 0.02;
    double yMax = self.poiInfo.pt.latitude + 0.02;
    
    double xMin = self.poiInfo.pt.longitude - 0.02;
    double xMax = self.poiInfo.pt.longitude + 0.02;
    
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
        //[self.navigationController popViewControllerAnimated:YES];
    }else {
        [self showMap];
    }
}

@end
