//
//  SearchResultController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-17.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "SearchResultController.h"
#import "MobClick.h"
#import "RXCustomTabBar.h"
#import "Commons.h"

@interface SearchResultController ()

@end

@implementation SearchResultController

@synthesize searchKey;
@synthesize resultArray;
@synthesize myTableView;
@synthesize progressHUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSearchObj:(NSString *)key
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.searchKey = key;
    }
    return self;
}





- (void)viewDidLoad
{
    //NSLog(@"SearchResultController viewDidLoad");
    [super viewDidLoad];
    self.navigationItem.title = @"搜索结果";
    // Do any additional setup after loading the view from its nib.
    
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    progressHUD.labelText = @"正在更新...";
    [self.view addSubview:progressHUD];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 1, 54, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    
    searchMap = [[BMKSearch alloc] init];
    [searchMap setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"SearchResultController viewWillAppear");
    [super viewWillAppear:animated];
    [MobClick event:@"h32"];
    [(RXCustomTabBar *)self.tabBarController hideNewTabBar];
    [progressHUD showWhileExecuting:@selector(search) onTarget:self withObject:nil animated:YES];
    
}

-(void)search
{
    [searchMap poiSearchInCity:@"北京" withKey:searchKey pageIndex:0];
}

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    if (error == BMKErrorOk) {
        if (poiResultList && poiResultList.count > 0) {
            BMKPoiResult *result = [poiResultList objectAtIndex:0];
            NSArray *list = [NSArray arrayWithArray:result.poiInfoList];
            if(list.count > 0){
                self.resultArray = list;
                [self.myTableView reloadData];
                return;
            }
        }
    }
    [Commons alertWithTitle:@"提示" Message:@"没有搜索到该地址"];
    
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#define mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultArray count];
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

    BMKPoiInfo *poiInfo = (BMKPoiInfo *)[self.resultArray objectAtIndex:indexPath.row];

    cell.textLabel.text = poiInfo.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = poiInfo.address;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearPointViewController *nearPointView = [[NearPointViewController alloc] initWithNibName:@"NearPointViewController" bundle:nil andSearchObj:[self.resultArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:nearPointView animated:YES];

}

- (void)leftBarButtonAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
