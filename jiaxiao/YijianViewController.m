//
//  YijianViewController.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-11.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "YijianViewController.h"
#import "URLEncode.h"
#import "CJSONDeserializer.h"
#import "CONST.h"

@implementation YijianViewController
@synthesize zishuLable;
@synthesize textView1;
@synthesize youxianText;
@synthesize progressBar;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 30)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"but_fit.png"] forState:UIControlStateNormal];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightButton addTarget:self action:@selector(tijiaoButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    

    
    self.navigationItem.rightBarButtonItem = buttonItem1;
    self.navigationItem.leftBarButtonItem = [Tools leftNavigationBarButtonWithTitle:@"返回" Image:@"back.png" Method:@selector(leftBarButtonPressed) Object:self];
    self.navigationItem.title= @"意见反馈";

    textView1.backgroundColor = [UIColor clearColor];
    self.youxianText.returnKeyType = UIReturnKeyDone;
    self.zishuLable.text = @"还可以输入200字";
    
    [self.textView1 becomeFirstResponder];
    
//    NSURL *url = [NSURL URLWithString:URL_PUSH_TIME];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:[NSNumber numberWithInt:1] forKey:@"type"];
//    [request setPostValue:SharedDelegate.userToken forKey:@"u"];
//    [request addRequestHeader:@"k" value:[SharedDelegate requestKey]];
//    [request startSynchronous];
//    
//    NSError *error = [request error];
//    if (!error) {
//        NSString *str = [request responseString];
//        NSLog(@"success %@",str);
//    }else {
//        NSLog(@"error:%@",error);
//    }
    
    self.progressBar = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    
    self.progressBar.delegate = self;
    self.progressBar.labelText = @"正在发送";
    self.progressBar.yOffset = -50.f;
    [self.navigationController.navigationBar addSubview:self.progressBar];



}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick event:@"h52"];
    [(RXCustomTabBar *)self.tabBarController hideNewTabBar];
}

- (void)leftBarButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{

    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [self tijiaoButton:nil];
    
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    int a = 200 - self.textView1.text.length;
    NSNumber * aNum = [[NSNumber alloc] initWithInt:a];
    self.zishuLable.text = [NSString stringWithFormat:@"还可以输入%@字",aNum];
    if (a <= 0) {
        [Commons alertWithTitle:@"提示" Message:@"已经超过字数限制"];
    }
}

- (void)viewDidUnload
{
    [self setZishuLable:nil];
    [self setTextView1:nil];
    [self setYouxianText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}


- (IBAction)tijiaoButton:(id)sender {
    


    if ([self.textView1.text isEqualToString:@""]) {
        [Commons alertWithTitle:@"提示" Message:@"意见内容为空，请输入内容"];
        [self.progressBar hide:YES];
        return;
    }
    
    if ([self.youxianText.text isEqualToString:@""]) {
        [Commons alertWithTitle:@"提示" Message:@"请输入您的邮箱"];
        [self.progressBar hide:YES];
        return;
    }
    
    if (![self isValidateEmail:self.youxianText.text]) {
        [Commons alertWithTitle:@"提示" Message:@"您输入的不是正确邮箱，请重新输入！"];
        [self.progressBar hide:YES];
        return;
    }
    
    int a = 200 - self.textView1.text.length;
    NSNumber * aNum = [[NSNumber alloc] initWithInt:a];
    self.zishuLable.text = [NSString stringWithFormat:@"还可以输入%@字",aNum];
    if (a <= 0) {
        [Commons alertWithTitle:@"提示" Message:@"已经超过字数限制"];
        
        return;
    }
    
    [self.progressBar show:YES];
    
    NSURL *url = [NSURL URLWithString:ADVICE_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setPostValue:self.textView1.text forKey:@"content"];
    [request setPostValue:self.youxianText.text forKey:@"contact"];
    [request setPostValue:APPSTORE_ID forKey:@"source"];
    [request setPostValue:@"4" forKey:@"type"];
    [request setDelegate:self];
    
    [request setDidFailSelector:@selector(requestDidFailed:)];
    
    [request setDidFinishSelector:@selector(requestDidSuccess:)];
    [request startAsynchronous];

}
- (void)requestDidSuccess:(ASIFormDataRequest *)request
{
    //NSLog(@"responseString:%@",[request responseString]);
    NSString *result = [request responseString];
    if ([result rangeOfString:@"true" options:NSCaseInsensitiveSearch].location!=NSNotFound) {
        [Commons alertWithTitle:@"提示" Message:@"感谢您的反馈，我们会尽快处理！"];
        [self.textView1 resignFirstResponder];
        [self.youxianText resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        [Commons alertWithTitle:@"提示" Message:@"网络连接失败,请稍后再试"];
    }
    [self.progressBar hide:YES];
}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    //NSLog(@"responseString:%@",[request responseString]);
    [Commons alertWithTitle:@"提示" Message:@"网络连接失败,请稍后再试"];
    [self.progressBar hide:YES];
}

@end
