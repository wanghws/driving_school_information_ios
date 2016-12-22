//
//  ApplyOnlineViewController.h
//  SimpleDrivingSchool
//
//  Created by wanghw on 12-7-14.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
@interface ApplyOnlineViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UILabel *applyInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *preferentialPriceLabel;
@property (retain, nonatomic) IBOutlet UITextField *nameFeild;
@property (retain, nonatomic) IBOutlet UITextField *phoneFeild;
@property (retain, nonatomic) IBOutlet UITextField *addressFeild;
@property (retain, nonatomic) IBOutlet UILabel *applyLebal;
@property (retain,nonatomic) NSDictionary *priceInfo;



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil BUsinessMessageItem:(NSDictionary *)priceInfo;

- (IBAction)applyButtonPressed:(id)sender;

@end
