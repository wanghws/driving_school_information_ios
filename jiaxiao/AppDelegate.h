//
//  AppDelegate.h
//  jiaxiao
//
//  Created by wanghw on 12-7-9.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RXCustomTabBar.h"
#import "BMapKit.h"
#import "MobClick.h"
#import "CONST.h"
#import "HomePageController.h"

#define SharedDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (retain, nonatomic) IBOutlet UITabBarController *tabbarController;
@property (retain, nonatomic) IBOutlet HomePageController *homePageController;

@property (retain, nonatomic) BMKMapManager *mapManager;

@property (retain,nonatomic) NSArray *lines;

@end
