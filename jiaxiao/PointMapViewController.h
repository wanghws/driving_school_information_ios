//
//  PointMapViewController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-17.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <QuartzCore/CoreAnimation.h>
#import "BMapKit.h"

@interface PointMapViewController : UIViewController<BMKMapViewDelegate>
@property (nonatomic, retain) NSArray *linePoints;
@property (nonatomic, retain) BMKMapView *PMapView;
@property (nonatomic,retain) NSString *lineTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPointItem:(NSArray *)item title:(NSString*) title;

@end
