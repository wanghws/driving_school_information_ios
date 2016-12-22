//
//  RecommendViewController.m
//  FindDrivingSchool
//
//  Created by wanghw on 12-6-5.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "RecommendViewController.h"
#import "Commons.h"
#import "AppDelegate.h"
#import "CONST.h"
#import "ASIFormDataRequest.h"

@implementation RecommendViewController

@synthesize progressHUD;
@synthesize appArrarList;
@synthesize appTabelView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title= @"应用推荐";
    
    NSArray *list = [[NSArray alloc]init];
    self.appArrarList = list;

    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    self.appTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, mainScreenRect.size.height)];
    self.appTabelView.delegate = self;
    self.appTabelView.dataSource = self;
    [self.view addSubview:self.appTabelView];

    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    progressHUD.labelText = @"正在更新...";
    [self.view addSubview:progressHUD];

    
    self.navigationItem.leftBarButtonItem = [Tools leftNavigationBarButtonWithTitle:@"返回" Image:@"back.png" Method:@selector(leftButtonPressed) Object:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [MobClick event:@"h54"];
    if ([self.appArrarList count]<=0) {
        [progressHUD showWhileExecuting:@selector(requestAppDataSource) onTarget:self withObject:nil animated:YES];
    }
}

- (void)leftButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.appArrarList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }  
    
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_background.png"]];
    cell.backgroundView = bgImage;
    
    
    UIImageView *selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_background2.png"]];
    cell.selectedBackgroundView = selectedImage;
    
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.numberOfLines = 2;

    NSURL *imgUrl = [NSURL URLWithString:[[self.appArrarList objectAtIndex:indexPath.row] objectForKey:@"logo"]];
    [cell.imageView setImageWithURL:imgUrl refreshCache:NO placeholderImage:[UIImage imageNamed:@"zhanwei.png"]];
    
    //[cell.imageView setImage:[UIImage imageNamed:@"zhanwei.png"]];
    NSDictionary *dict = [self.appArrarList objectAtIndex:[indexPath row]];
    NSString *desc = [dict objectForKey:@"description"];
    NSString *title = [dict objectForKey:@"title"];
    [cell.textLabel setText:title];
    [cell.detailTextLabel setText:desc];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[self.appArrarList objectAtIndex:indexPath.row] objectForKey:@"url"]]];
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:NO];
}



- (void)requestAppDataSource
{
    NSURL *url = [NSURL URLWithString:APP_RECOMMENT_URL];
    ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        if (200==[request responseStatusCode]) {
            //NSLog(@"response:%@",[request responseString]);
            NSArray *arrayList = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:&error];
            self.appArrarList = arrayList;
            [self.appTabelView reloadData];
            UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 120.0f)];
            self.appTabelView.tableFooterView = tableFooterView;
            return;
        }
    }
    [Commons alertWithTitle:@"提示" Message:@"网络连接失败,请稍后再试"];
}

@end
