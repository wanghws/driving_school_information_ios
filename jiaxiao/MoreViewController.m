//
//  MoreViewController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "MoreViewController.h"
#import "CONST.h"
#import "YijianViewController.h"



@interface MoreViewController ()

@end

@implementation MoreViewController
@synthesize myTabelView;


#pragma mark - buttonPressed

- (void)leftButtonPressed
{

    
}

#pragma mark - lifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick event:@"h5"];
    [(RXCustomTabBar *)self.tabBarController showNewTabBar];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"更多";
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }  
    
    UILabel *titleLabel = [[UILabel alloc]  initWithFrame:CGRectMake(13, 13, 80, 18)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleLabel];

    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 16, 200, 15)];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:contentLabel];

    
    if (indexPath.row == 0) {
        titleLabel.text = @"评价";
        contentLabel.text = @"给本应用打分";
    }else if (indexPath.row == 1){
        titleLabel.text = @"反馈";
        contentLabel.text = @"您的反馈能使软件更加好用";
    }else if(indexPath.row == 2){
        titleLabel.text = @"分享";
        contentLabel.text = @"通过微博或短信分享好友";
    }else if(indexPath.row == 3){
        titleLabel.text = @"推荐";
        contentLabel.text = @"热门应用推荐";

    }

    return cell;
}

#pragma Mark actionsheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *content = [NSString stringWithFormat:APP_SHARE_CONTENT,SCHOOL_NAME,APPSTORE_ID];
    if (buttonIndex==0) {
        WebSharedController *nextController=[[WebSharedController alloc] initWithNibName:@"WebSharedController" bundle:nil withType:0 content:content];
        [self.navigationController pushViewController:nextController animated:YES];

    }else if(buttonIndex==1){
        WebSharedController *nextController=[[WebSharedController alloc] initWithNibName:@"WebSharedController" bundle:nil withType:1 content:content];    
        [self.navigationController pushViewController:nextController animated:YES];

    }
    else if(buttonIndex==2){
        [self showSMSPicker:nil];
    }
}

#pragma mark - sendSMS

-(void)showSMSPicker:(id)sender {
    
	BOOL canSendSMS = [MFMessageComposeViewController canSendText];
	if (canSendSMS) {
        
		MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
		picker.messageComposeDelegate = self;
		picker.navigationBar.tintColor = [UIColor blackColor];
		picker.body = [NSString stringWithFormat:APP_SHARE_CONTENT,SCHOOL_NAME,APPSTORE_ID];
		[self presentModalViewController:picker animated:YES];
	
	}	
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
	// Notifies users about errors associated with the interface
//	switch (result) {
//		case MessageComposeResultCancelled:
//			if (DEBUG) NSLog(@"Result: canceled");
//			break;
//		case MessageComposeResultSent:
//			if (DEBUG) NSLog(@"Result: Sent");
//			break;
//		case MessageComposeResultFailed:
//			if (DEBUG) NSLog(@"Result: Failed");
//			break;
//		default:
//			break;
//	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [MobClick event:@"h51"];
        NSString *url = [NSString stringWithFormat:APPSTORE_COMMENT_URL,APPSTORE_ID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else if(indexPath.row == 1){
        YijianViewController *fankui = [[YijianViewController alloc] init];
        fankui.title = @"意见反馈";
        [self.navigationController pushViewController:fankui animated:YES];
    }else if(indexPath.row == 2){
        
        UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博",@"分享到腾讯微博",@"用短信分享",nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }else if(indexPath.row == 3){
        RecommendViewController *appViewController = [[RecommendViewController alloc] init];
        [self.navigationController pushViewController:appViewController animated:YES];

        
    }
}

@end
