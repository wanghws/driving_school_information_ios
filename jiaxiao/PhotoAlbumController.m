//
//  PhotoAlbumController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "PhotoAlbumController.h"
#import <QuartzCore/QuartzCore.h>
#import "CONST.h"
#import "MobClick.h"
#import "Commons.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "RXCustomTabBar.h"

@interface PhotoAlbumController ()

@end

@implementation PhotoAlbumController

@synthesize myScrollView;
@synthesize progressHUD;
@synthesize photoList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    [super viewDidUnload];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"驾校图片";
    photoList = [[NSArray alloc]init];
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    progressHUD.labelText = @"正在更新...";
    [self.view addSubview:progressHUD];


}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"h4"];
    [(RXCustomTabBar *)self.tabBarController showNewTabBar];
    //NSLog(@"[photoList count]:%d",[self.photoList count]);
    if ([self.photoList count]<=0) {
        [progressHUD showWhileExecuting:@selector(loadSchoolPhotos) onTarget:self withObject:nil animated:YES];
    }
}

-(void)loadSchoolPhotos
{
    NSURL *url = [NSURL URLWithString:SCHOOL_PHOTOS_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:SCHOOL_ID forKey:@"pid"];
    [request setPostValue:@"99" forKey:@"limit"];
    //[request addRequestHeader:@"k" value:[SharedDelegate requestKey]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        if (200==[request responseStatusCode]) {
            NSArray *arrayList = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:&error];
            int i = 0;
            for (NSDictionary *photo in arrayList) {
                int j;

                UIImageView *imageView = [[UIImageView alloc]init];
                NSString *url = [NSString stringWithFormat:@"http://image./images/school/a_%@",[photo objectForKey:@"pic"]];
                NSURL *imgUrl = [NSURL URLWithString:url];
                [imageView setImageWithURL:imgUrl refreshCache:NO placeholderImage:[UIImage imageNamed:@"zhanwei.png"]];
                
                if (i%3 == 0)j = i/3;
                imageView.frame = CGRectMake(8 + (i%3)*103, 9 + j*80, 97, 73);
                
                self.myScrollView.contentSize = CGSizeMake(320, imageView.frame.origin.y + 80);
                CALayer * layer1 = [imageView layer];
                layer1.borderWidth = 3.0f;
                layer1.borderColor = [[UIColor whiteColor] CGColor];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = imageView.frame;
                [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                [self.myScrollView addSubview:button];

                [self.myScrollView addSubview:imageView];
                i++;
            }
            self.photoList = arrayList;
            arrayList  = nil;
            return;
        }
    }
    [Commons alertWithTitle:@"提示" Message:@"网络连接失败,请稍后再试"];
}

- (void)buttonPressed:(UIButton *)sender
{
    DetailPhotoController *detailPhotoView = [[DetailPhotoController alloc] init];
    detailPhotoView.photoList = self.photoList;
    detailPhotoView.index = sender.tag;
    [self.navigationController pushViewController:detailPhotoView animated:YES];

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
