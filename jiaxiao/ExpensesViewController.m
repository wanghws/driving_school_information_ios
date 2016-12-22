//
//  ExpensesViewController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "ExpensesViewController.h"
#import "CJSONDeserializer.h"
#import "CONST.h"
#import "RXCustomTabBar.h"
#import "Commons.h"
#import "ASIFormDataRequest.h"
#import "MobClick.h"

@interface ExpensesViewController ()

@end

@implementation ExpensesViewController


@synthesize phoneLabel = _phoneLabel;
@synthesize myTableView = _myTableView;

#pragma mark lifecycle
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
    self.navigationItem.title = @"课程费用";
    schoolKey = [NSString stringWithFormat:@"school_%@",SCHOOL_ID];
    NSDictionary *school = [[NSUserDefaults standardUserDefaults]objectForKey:schoolKey];
    if (!school) {
        RXCustomTabBar *controller  = (RXCustomTabBar *)self.tabBarController;
        [controller selectTab:0];
        return;
    }
    // Do any additional setup after loading the view from its nib.
    UIImage *toothImage;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        toothImage = [[UIImage imageNamed:@"sawtooth.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 20, 0)];
    }else {
        toothImage = [[UIImage imageNamed:@"sawtooth.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:20];
    } 

    
    UIImageView *backTooth = [[UIImageView alloc] initWithImage:toothImage];
    backTooth.frame = CGRectMake(0, 0, 320, 50);
    [self.view insertSubview:backTooth atIndex:0];
    
    NSString *phone = [school objectForKey:@"phone"];
//    self.phoneLabel.text = self.phoneString;
    NSRange range;
    range.length = 3;
    range.location = 3;
    phoneString = [NSString stringWithFormat:@"%@-%@-%@",[phone substringToIndex:3],[phone  substringWithRange:range],[phone substringFromIndex:6]];

//     NSLog(@"self.phoneString :%@",self.phoneString);
    
   self.phoneLabel.text = phoneString;
    
    //
    items = [[NSDictionary alloc]init];
    groups = [[NSArray alloc]init];
    
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:progressHUD];
    
    progressHUD.labelText = @"正在更新...";
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick event:@"h2"];
    [super viewWillAppear:animated];
    [(RXCustomTabBar *)self.tabBarController showNewTabBar];
    if ([groups count]<=0) {
        [progressHUD showWhileExecuting:@selector(loadSchoolPriceList) onTarget:self withObject:nil animated:YES];
    }
}

-(void)buildSchoolPriceList:(NSArray *) arrayList
{
    NSArray *categoryList = [[NSArray alloc]initWithObjects:@"周末训练",@"速成班",@"周一到周五训练",@"周一到周日训练",@"其他",nil];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    for (NSString *category in categoryList){
        NSMutableArray *list = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in arrayList){
            if ([category isEqualToString:[dict objectForKey:@"category"]]) {
                [list addObject:dict];
            }
        }
        if (list && [list count]>0) {
            [dictionary setValue:list forKey:category];
            [keys addObject:category];
        }
        
    }
    items = dictionary;
    groups = keys;
    
    [self.myTableView reloadData];
}
-(void)loadSchoolPriceList
{
    NSURL *url = [NSURL URLWithString:SCHOOL_PRICE_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:SCHOOL_ID forKey:@"schoolId"];
    //[request addRequestHeader:@"k" value:[SharedDelegate requestKey]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        if (200==[request responseStatusCode]) {
            NSArray *arrayList = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:&error];
            [self buildSchoolPriceList:arrayList];
            return;
        }
    }
    [Commons alertWithTitle:@"提示" Message:@"网络连接失败,请稍后再试"];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark buttonPressed
- (IBAction)callButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"电话:%@",phoneString] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打电话" otherButtonTitles:nil];
    actionSheet.delegate = self;
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSDictionary *school = [[NSUserDefaults standardUserDefaults]objectForKey:schoolKey];
        NSString *num = [[NSString alloc] initWithFormat:@"tel:%@",[school objectForKey:@"phone"]];
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:num];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }
}



#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSString *key = [groups objectAtIndex:section];
    NSArray *nameSection = [items objectForKey:key];
    return [nameSection count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [groups objectAtIndex:section];
    return key;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [groups objectAtIndex:section];
    NSArray *nameSection = [items objectForKey:key];
    NSUInteger row = [indexPath row];
    NSDictionary *dict = [nameSection objectAtIndex:row];
    
    static NSString *CellIdentifier = @"courseCell";
    schoolCourseCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"schoolCourseCell" owner:self options:nil] lastObject];
    }
    cell.licenseTypeLabel.text = [dict objectForKey:@"licenseType"];
    cell.carTypeLabel.text = [NSString stringWithFormat:@"%@/%@",[dict objectForKey:@"trainingTime"],[dict objectForKey:@"carType"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dict objectForKey:@"price"]];
    if (![[dict objectForKey:@"preferentialPrice"] isEqualToString:@"null"]) {
        cell.preferentialPriceLabel.text = [NSString stringWithFormat:@"￥%@",[dict objectForKey:@"preferentialPrice"]];
    }else {
        cell.preferentialPriceLabel.hidden = YES;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [groups objectAtIndex:section];
    NSArray *nameSection = [items objectForKey:key];
    NSUInteger row = [indexPath row];
    NSDictionary *dict = [nameSection objectAtIndex:row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ApplyOnlineViewController *applyView = [[ApplyOnlineViewController alloc] initWithNibName:@"ApplyOnlineViewController" bundle:nil BUsinessMessageItem:dict];
    
    [self.navigationController pushViewController:applyView animated:YES];


}

@end
