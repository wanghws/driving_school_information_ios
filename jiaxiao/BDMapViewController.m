//
//  BDMapViewController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "BDMapViewController.h"
#import "MobClick.h"
#import "RXCustomTabBar.h"

@interface BDMapViewController ()

@end

@implementation BDMapViewController
@synthesize school = _school;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDataBase:(NSDictionary *)school
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.school = school;
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"驾校地图";
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 1, 54, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = buttonItem;

    
    [(RXCustomTabBar *)self.tabBarController hideNewTabBar];
    
    mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 424)];
    mapView.delegate = self;
    self.view = mapView;
    //[self.view addSubview:mapView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"h11"];
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
	CLLocationCoordinate2D coor;
	coor.latitude = [[self.school objectForKey:@"y"]floatValue];
	coor.longitude = [[self.school objectForKey:@"x"]floatValue];
	annotation.coordinate = coor;
	annotation.title = [self.school objectForKey:@"name"];
    [mapView setCenterCoordinate:coor];
	[mapView addAnnotation:annotation];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];   
		newAnnotation.pinColor = BMKPinAnnotationColorRed;   
		newAnnotation.animatesDrop = YES;
        [newAnnotation setSelected:YES animated:YES];
		return newAnnotation;   

	}
	return nil;
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark - buttonPressed
- (void)leftBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)nav
//{
//    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) { // ios6以下，调用google map
//        NSString *latlong = [NSString stringWithFormat:@"http://ditu.google.cn/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d",self.userX,self.userY,linePoint.xPoi,linePoint.yPoi];
//        latlong =  [latlong stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//        NSURL *url = [NSURL URLWithString:latlong];
//        [[UIApplication sharedApplication] openURL:url];
//    } else { // 直接调用ios自己带的apple map
//        CLLocationCoordinate2D to;
//        
//        
//        to.latitude = stationLat;
//        to.longitude = stationLon;
//        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil] autorelease]];
//        
//        
//        toLocation.name = @"Destination";
//        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
//                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
//                                      
//                                      
//                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
//        [toLocation release];
//    }
//}

@end
