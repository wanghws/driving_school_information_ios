//
//  BDMapViewController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

//#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface BDMapViewController : UIViewController<BMKMapViewDelegate>


@property (retain, nonatomic) NSDictionary *school;
@property (retain,nonatomic) BMKMapView *mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDataBase:(NSDictionary *)item;
@end
