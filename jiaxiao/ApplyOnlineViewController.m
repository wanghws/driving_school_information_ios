//
//  ApplyOnlineViewController.m
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-14.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "ApplyOnlineViewController.h"
#import "MobClick.h"
#import "Commons.h"
#import "CONST.h"
#import "ASIFormDataRequest.h"
#import "RXCustomTabBar.h"

@interface ApplyOnlineViewController ()

@end

@implementation ApplyOnlineViewController
@synthesize applyInfoLabel;
@synthesize priceLabel;
@synthesize preferentialPriceLabel;
@synthesize nameFeild;
@synthesize phoneFeild;
@synthesize addressFeild;
@synthesize applyLebal;
@synthesize priceInfo = _priceInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil BUsinessMessageItem:(NSDictionary *)priceInfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.hidesBottomBarWhenPushed = YES;
        self.priceInfo = priceInfo;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"马上报名";
    [(RXCustomTabBar *)self.tabBarController hideNewTabBar];
    [MobClick event:@"h21"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *toothImage;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        toothImage = [[UIImage imageNamed:@"sawtooth.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 20, 0)];
    }else {
        toothImage = [[UIImage imageNamed:@"sawtooth.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:20];
    } 
    
    UIImageView *backTooth = [[UIImageView alloc] initWithImage:toothImage];
    backTooth.frame = CGRectMake(0, 0, 320, 80);
    [self.view insertSubview:backTooth atIndex:0];
    // Do any additional setup after loading the view from its nib.
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 1, 54, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = buttonItem;
    

    
//    Reachability *reachability = [Reachability reachabilityWithHostName:@"www."];
//    if (reachability.currentReachabilityStatus == NotReachable) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您现在未联网，不能完成在线报名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
    [self showPriceInfo];
}

- (void)viewDidUnload
{
    [self setApplyInfoLabel:nil];
    [self setPriceLabel:nil];
    [self setPreferentialPriceLabel:nil];
    [self setNameFeild:nil];
    [self setPhoneFeild:nil];
    [self setAddressFeild:nil];
    [self setApplyLebal:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)showPriceInfo
{
    
    self.applyInfoLabel.text = [NSString stringWithFormat:@"%@    %@    %@",[self.priceInfo objectForKey:@"licenseType"],[self.priceInfo objectForKey:@"trainingTime"],[self.priceInfo objectForKey:@"carType"]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[self.priceInfo objectForKey:@"price"]];
    
    if (![[self.priceInfo objectForKey:@"preferentialPrice"] isEqualToString:@"null"]) {
        self.preferentialPriceLabel.text = [NSString stringWithFormat:@"￥%@",[self.priceInfo objectForKey:@"preferentialPrice"]];
        
    }else {
        self.preferentialPriceLabel.hidden = YES;
        self.applyLebal.hidden = YES;
    }
}


#pragma mark UITextFeildDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0,-120,width,height);//上移80个单位，按实际情况设置
    self.view.frame=rect;
    [UIView commitAnimations];
    
    return YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0,0,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

#pragma mark ButtonPressed
- (void)leftBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)applyButtonPressed:(id)sender {
    
    NSString *name = self.nameFeild.text;
    NSString *phone = self.phoneFeild.text;
    NSString *address = self.addressFeild.text;
    
    if(name.length == 0 || phone.length == 0) {
        [Commons alertWithTitle:@"提示" Message:@"报名内容填写不完整"];
        return;
    }


    NSURL *url = [NSURL URLWithString:SCHOOL_ORDER_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:CRM_CHANNEL_ID forKey:@"source"];
    [request setPostValue:[self.priceInfo objectForKey:@"id"] forKey:@"messageId"];
    [request setPostValue:name forKey:@"customerName"];
    [request setPostValue:phone forKey:@"phoneNum"];
    [request setPostValue:address forKey:@"address"];
    
    //[request addRequestHeader:@"k" value:[SharedDelegate requestKey]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        if (200==[request responseStatusCode]) {
            
            NSDictionary *josnData = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:&error];
            if ([[josnData objectForKey:@"result"] isEqualToString:@"true"]) {
                [Commons alertWithTitle:@"报名成功" Message:@"报名工作人员将在24小时内与您联系"];
                self.phoneFeild.text = @"";
                self.nameFeild.text = @"";
                self.addressFeild.text = @"";
                return;
            }
        }
    }
    [Commons alertWithTitle:@"报名失败" Message:@"网络连接失败,请稍后再试"];
    
}
@end
