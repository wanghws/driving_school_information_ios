//
//  NearPointViewController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-17.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MobClick.h"

@interface NearPointViewController : UIViewController<BMKMapViewDelegate>

@property (nonatomic, retain) BMKMapView *PMapView;
@property (nonatomic, retain) BMKPoiInfo *poiInfo;
@property (nonatomic, retain) NSMutableArray *showPointList;
@property (nonatomic, retain) NSMutableArray *annotationArray;
@property (nonatomic, retain) BMKPointAnnotation * annotation1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSearchObj:(BMKPoiInfo *)obj;

@end
