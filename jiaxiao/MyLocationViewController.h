//
//  MyLocationViewController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-17.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "AppDelegate.h"

@interface MyLocationViewController : UIViewController<BMKMapViewDelegate>

@property (nonatomic, retain) BMKMapView *PMapView;
@property (nonatomic, retain) NSMutableArray *showPointList;
@property (nonatomic, retain) NSMutableArray *annotationArray;

@end
