//
//  SchoolBusController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "SchoolBusController.h"
#import "CONST.h"
#import "ASIFormDataRequest.h"
#import "Commons.h"
#import "RXCustomTabBar.h"
#import "AppDelegate.h"

@interface SchoolBusController ()

@end

@implementation SchoolBusController
@synthesize toolBar;
@synthesize myTableView;
@synthesize mySearchBar;
@synthesize lines;
@synthesize progressHUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    //NSLog(@"bus viewDidLoad");
    [super viewDidLoad];
    self.navigationItem.title = @"班车路线";
    NSArray *list = [[NSArray alloc]init];
    self.lines = list;

    NSString *schoolKey = [NSString stringWithFormat:@"school_%@",SCHOOL_ID];
    NSDictionary *school = [[NSUserDefaults standardUserDefaults]objectForKey:schoolKey];
    if (!school) {
        RXCustomTabBar *controller  = (RXCustomTabBar *)self.tabBarController;
        [controller selectTab:0];
        return;
    }
    school = nil;
    schoolKey = nil;
    //[schoolKey release];
    
    //[[self.mySearchBar.subviews objectAtIndex:0]removeFromSuperview];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"positionbutton.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = buttonItem1;

    
    UIImage *image = [UIImage imageNamed:@"navbg.png"];
    [self.mySearchBar setBackgroundImage:image];

    
    //放置隐藏键盘的按钮
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,mainScreenRect.size.height,320,44)];
    self.toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem * hiddenButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jianpan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(HiddenKeyBoard)];
    UIBarButtonItem * spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolBar.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil];
    [self.view addSubview:self.toolBar];

    
    //监控键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //监控键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    progressHUD.labelText = @"正在更新...";
    [self.view addSubview:progressHUD];

    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"h3"];
    self.mySearchBar.text = @"";
    [(RXCustomTabBar *)self.tabBarController showNewTabBar];
    if ([self.lines count]<=0) {
        [self.progressHUD showWhileExecuting:@selector(loadSchoolBusLines) onTarget:self withObject:nil animated:YES];
    }
    
}

-(void)loadSchoolBusLines
{
    //NSLog(@"loadSchoolBusLines");

    NSURL *url = [NSURL URLWithString:SCHOOL_BUS_LINE_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:SCHOOL_ID forKey:@"schoolId"];
    //[request setPostValue:SharedDelegate.userToken forKey:@"u"];
    [request startSynchronous];
    NSError *error = [request error];
   // NSLog(@"error:%@",error);
    if (!error) {
        if (200==[request responseStatusCode]) {
           /// NSLog(@"responseString:%@",[request responseString]);
            NSArray *arrayList = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:&error];
            NSMutableArray *linesList = [[NSMutableArray alloc]init];
            NSMutableDictionary *line;
            for (NSDictionary *dict in arrayList){
                line = [[NSMutableDictionary alloc]init];
                NSString *lineName = [dict objectForKey:@"lineName"];
                NSString *busLineId = [dict objectForKey:@"busLineId"];
                NSArray *list = [dict objectForKey:@"pointList"];
                [line setValue:lineName forKey:@"lineName"];
                [line setValue:busLineId forKey:@"busLineId"];
                [line setValue:list forKey:@"list"];
                [linesList addObject:line];
            }
            self.lines = linesList;
            SharedDelegate.lines = linesList;
            [self.myTableView reloadData];

            return;
        }
    }
    [Commons alertWithTitle:@"提示" Message:@"网络连接失败,请稍后再试"];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"shouldAutorotateToInterfaceOrientation");

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)rightBarButtonPressed
{
    //NSLog(@"rightBarButtonPressed");

    MyLocationViewController *aView= [[MyLocationViewController alloc] init];
    [self.navigationController pushViewController:aView animated:YES];

}

#pragma mark keyBoardMethod
//隐藏键盘的按钮的方法
-(void) HiddenKeyBoard
{
    //NSLog(@"HiddenKeyBoard");

    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    [self.mySearchBar resignFirstResponder];
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    self.toolBar.frame = CGRectMake(0, mainScreenRect.size.height, 320, 44);
    [UIView commitAnimations];
}
//监控键盘的方法
-(void)keyboardWillShow:(NSNotification*)notification{
    //NSLog(@"keyboardWillShow");

    NSDictionary *info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    self.toolBar.frame = CGRectMake(0, mainScreenRect.size.height-kbSize.height-104, 320, 44);
    [UIView commitAnimations];
}
//监控键盘的方法
-(void)keyboardWillHide:(NSNotification*)notification{
    //NSLog(@"keyboardWillHide");

    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.toolBar.frame = CGRectMake(0, mainScreenRect.size.height, 320, 44);
    [UIView commitAnimations];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"searchBarSearchButtonClicked");

    [searchBar resignFirstResponder];
    SearchResultController *resultView = [[SearchResultController alloc] initWithNibName:@"SearchResultController" bundle:nil andSearchObj:searchBar.text];
    [self.navigationController pushViewController:resultView animated:YES];

}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection");
    return [self.lines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath");
    static NSString *cellIdentifier = @"SchoolBusLinesCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }

    NSDictionary *dict = [self.lines objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = [dict objectForKey:@"lineName"];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath");
    
    NSDictionary *dict = [self.lines objectAtIndex:indexPath.row];
    NSArray *points = [dict objectForKey:@"list"];
    LineDetailViewController *lineDetailView = [[LineDetailViewController alloc] initWithNibName:@"LineDetailViewController" bundle:nil withPointItem:points];
    lineDetailView.lineTitle = [dict objectForKey:@"lineName"];
    [self.navigationController pushViewController:lineDetailView animated:YES];
    //[lineDetailView release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
