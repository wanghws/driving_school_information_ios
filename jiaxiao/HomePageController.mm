//
//  HomePageController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "HomePageController.h"
#import "BDMapViewController.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "CONST.h"
#import "Commons.h"
#import "RXCustomTabBar.h"
#import "MobClick.h"

@interface HomePageController ()

@end

@implementation HomePageController
@synthesize bdMapView = _bdMapView;
@synthesize strDesc = _strDesc;
@synthesize addressLabel = _addressLabel;
@synthesize phoneLabel = _phoneLabel;
@synthesize itemsTableView = _itemsTableView;

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

    [super viewDidLoad];
    
    self.navigationItem.title = SCHOOL_NAME;
    
    schoolKey = [NSString stringWithFormat:@"school_%@",SCHOOL_ID];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:schoolKey];
    
    
    
    items = [[NSDictionary alloc]init];
    groups = [[NSArray alloc]init];

    
//    NSLog(@"view did :%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"updataResult"]);
    UIImage *toothImage;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        toothImage = [[UIImage imageNamed:@"sawtooth.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 20, 0)];
    }else {
        toothImage = [[UIImage imageNamed:@"sawtooth.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:20];
    } 

    UIImageView *backTooth = [[UIImageView alloc] initWithImage:toothImage];
    backTooth.frame = CGRectMake(0, 0, 320, 85);
    [self.view insertSubview:backTooth atIndex:0];
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"mapbutton.png"] forState:UIControlStateNormal];
    [rightButton setTitle:@"官网" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightButton addTarget:self action:@selector(webSite) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = buttonItem1;
    
    //self.myImageView.layer.cornerRadius = 8;
    //self.myImageView.layer.masksToBounds = YES;
    
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataMethod:) name:@"updataResult" object:nil];
    progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    progressHUD.labelText = @"正在更新...";
    [self.view addSubview:progressHUD];

    
    
    
    [self showSchoolInfo];
}


- (void)showSchoolInfo
{
    NSDictionary *school = [[NSUserDefaults standardUserDefaults]objectForKey:schoolKey];
    if (school) {
        NSRange range;
        range.length = 3;
        range.location = 3;
        NSString *phoneStr = [NSString stringWithFormat:@"报名电话: %@-%@-%@",[[school objectForKey:@"phone"] substringToIndex:3],[[school objectForKey:@"phone"]  substringWithRange:range],[[school objectForKey:@"phone"] substringFromIndex:6]];
        
        self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",[school objectForKey:@"address"] ];
        self.phoneLabel.text = phoneStr;
    }else{
        [progressHUD showWhileExecuting:@selector(loadSchoolInfo) onTarget:self withObject:nil animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick event:@"h1"];
    [(RXCustomTabBar *)self.tabBarController showNewTabBar];
    if ([groups count]<=0) {
        [progressHUD showWhileExecuting:@selector(loadSchoolFacility) onTarget:self withObject:nil animated:YES];
    }
}

-(void)webSite
{
    NSDictionary *school = [[NSUserDefaults standardUserDefaults]objectForKey:schoolKey];
    if (!school) return;
    NSString *web = [NSString stringWithFormat:@"http://www./%@",[school objectForKey:@"path"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:web]];
}

-(void)loadSchoolInfo
{
    NSURL *url = [NSURL URLWithString:SCHOOL_INFO_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:SCHOOL_ID forKey:@"schoolId"];
    //[request addRequestHeader:@"k" value:[SharedDelegate requestKey]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        if (200==[request responseStatusCode]) {
            NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:&error];
            //NSLog(@"dict:%@",[request responseString]);
            if (dict) {
                NSMutableDictionary *school = [[NSMutableDictionary alloc]init];
                NSString *name = [dict objectForKey:@"name"];
                NSString *phone = [dict objectForKey:@"phone"];
                NSString *address = [dict objectForKey:@"address"];
                NSString *city = [dict objectForKey:@"city"];
                NSString *path = [dict objectForKey:@"path"];
                NSString *x = [dict objectForKey:@"x"];
                NSString *y = [dict objectForKey:@"y"];
                
                [school setValue:name forKey:@"name"];
                [school setValue:phone forKey:@"phone"];
                [school setValue:address forKey:@"address"];
                [school setValue:city forKey:@"city"];
                [school setValue:path forKey:@"path"];
                [school setValue:x forKey:@"x"];
                [school setValue:y forKey:@"y"];
                
                
                
                [[NSUserDefaults standardUserDefaults] setValue:school forKey:schoolKey];
                [self showSchoolInfo];
            }
            return;
        }
    }
    [Commons alertWithTitle:@"提示" Message:@"网络连接失败,请稍后再试"];
}

-(void)loadSchoolFacility
{
    NSURL *url = [NSURL URLWithString:SCHOOL_FACILITY_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:SCHOOL_ID forKey:@"pid"];
    //[request addRequestHeader:@"k" value:[SharedDelegate requestKey]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        if (200==[request responseStatusCode]) {
            NSArray *arrayList = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:&error];
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
            NSMutableArray *keys = [[NSMutableArray alloc]init];
            NSString *title;
            NSArray *list;
            for (NSDictionary *category in arrayList){
                title = [category objectForKey:@"name"];
                list = [category objectForKey:@"categorys"];
                [keys addObject:title];
                [dictionary setValue:list forKey:title];
            }
            items = dictionary;
            groups = keys;
            
            [self.itemsTableView reloadData];
            return;
        }
    }
    [Commons alertWithTitle:@"提示" Message:@"网络连接失败,请稍后再试"];
}

#pragma mark - textViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;//textView 禁止操作
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)stringWithoutHTMLTag:(NSString *)htmlStr
{
    //NSLog(@"htmlStr:%@",htmlStr);
    NSMutableString *busStr = [[NSMutableString alloc] initWithString:htmlStr];
    
    [busStr replaceOccurrencesOfString:@"&mdash;" withString:@"" options:0 range:NSMakeRange(0, busStr.length)];
    [busStr replaceOccurrencesOfString:@"&nbsp;" withString:@"" options:0 range:NSMakeRange(0, busStr.length)];
    [busStr replaceOccurrencesOfString:@"<strong>" withString:@"" options:0 range:NSMakeRange(0, busStr.length)];
    [busStr replaceOccurrencesOfString:@"</strong>" withString:@"" options:0 range:NSMakeRange(0, busStr.length)];
    [busStr replaceOccurrencesOfString:@"<p>" withString:@"" options:0 range:NSMakeRange(0, busStr.length)];
    [busStr replaceOccurrencesOfString:@"</p>" withString:@"\n" options:0 range:NSMakeRange(0, busStr.length)];
    [busStr replaceOccurrencesOfString:@"&gt;" withString:@"" options:0 range:NSMakeRange(0, busStr.length)];
    [busStr replaceOccurrencesOfString:@"&lt;" withString:@"" options:0 range:NSMakeRange(0, busStr.length)];
    [busStr replaceOccurrencesOfString:@"&rarr;" withString:@"" options:0 range:NSMakeRange(0, busStr.length)];
    [busStr replaceOccurrencesOfString:@"&ldquo;" withString:@"\"" options:0 range:NSMakeRange(0, busStr.length)];
    
    NSString *str=[self stringByStrippingHTML:busStr];
    
    // NSLog(@"转换后：%@",str);

    return str;
    //return [busStr autorelease];
}

- (NSString *) stringByStrippingHTML:(NSString*)srcStr {
    NSRange r;
    NSString *s = [srcStr copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s; 
}



#pragma mark - buttonPressed

- (IBAction)mapButtonPressed:(id)sender {
    NSDictionary *school = [[NSUserDefaults standardUserDefaults]objectForKey:schoolKey];
    if (!school) {
        return;
    }
    BDMapViewController *mapView = [[BDMapViewController alloc] initWithNibName:@"BDMapViewController" bundle:nil withDataBase:school];
    self.bdMapView = mapView;

    
    [self.navigationController pushViewController:self.bdMapView animated:YES];
}

- (IBAction)callButtonPressed:(id)sender {
    NSDictionary *school = [[NSUserDefaults standardUserDefaults]objectForKey:schoolKey];
    if (!school) {
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"电话:%@",[school objectForKey:@"phone"]] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打电话" otherButtonTitles:nil];
    actionSheet.delegate = self;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *school = [[NSUserDefaults standardUserDefaults]objectForKey:schoolKey];
    if (!school) {
        return;
    }
    if (buttonIndex == 0) {
        NSString *num = [[NSString alloc] initWithFormat:@"tel:%@",[school objectForKey:@"phone"]];
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:num];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [groups objectAtIndex:section];
    return key;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *key = [groups objectAtIndex:section];
    NSArray *nameSection = [items objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [groups objectAtIndex:section];
    NSArray *nameSection = [items objectForKey:key];
    NSUInteger row = [indexPath row];
    
    static NSString *cellIdentifier = @"SchoolFacilityCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        //cell.backgroundColor = [UIColor whiteColor];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SchoolFacilityCell" owner:self options:nil] lastObject];
        
    }
    
    UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:2012];
    UILabel *contentLabel = (UILabel*)[cell.contentView viewWithTag:2013];
    NSDictionary *dict = [nameSection objectAtIndex:row];
    //NSLog(@"dict:%@",dict);
    titleLabel.text = [dict objectForKey:@"title"];
    contentLabel.text = [dict objectForKey:@"content"];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
