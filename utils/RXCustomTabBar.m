//
//  RumexCustomTabBar.m
//  
//
//  Created by Oliver Farago on 19/06/2010.
//  Copyright 2010 Rumex IT All rights reserved.
//

#import "RXCustomTabBar.h"

@implementation RXCustomTabBar

@synthesize btn1, btn2, btn3, btn4, btn5,sliderImage;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
	[self hideTabBar];
	[self addCustomElements];
    
    [self.tabBar setFrame:CGRectMake(0, mainScreenRect.size.height-44, 320, 44)];
    [[[self.view subviews] objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, mainScreenRect.size.height-44)];
}

- (void)hideTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

- (void)hideNewTabBar 
{
    tabbarView.hidden = YES;
    tabbarView.alpha = 0.0f;
}

- (void)showNewTabBar 
{
    [self hideTabBar];
    [UIView beginAnimations:nil context:nil];  
	[UIView setAnimationDuration:1];  
	[UIView setAnimationDelegate:self];
    tabbarView.hidden = 0;
    tabbarView.alpha = 1.0f;
	[UIView commitAnimations];
}

-(void)addCustomElements
{
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, mainScreenRect.size.height-44, 320, 44)];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    bgImageView.frame = CGRectMake(0, 0, 320, 44);
    [tabbarView addSubview:bgImageView];
    [bgImageView release];
    
    sliderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_hoverbg.png"]];
    
	UIImage *btnImage = [UIImage imageNamed:@"tab1.png"];
	UIImage *btnImageSelected = [UIImage imageNamed:@"tab1_hover.png"];
	
	self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
	btn1.frame = CGRectMake(5, 0, 59, 44); // Set the frame (size and position) of the button)
	[btn1 setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
    self.btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	[btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
	[btn1 setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
     self.btn1.contentVerticalAlignment  = UIControlContentVerticalAlignmentBottom;
    [self.btn1 setTitle:@"首页" forState:UIControlStateNormal];
    
    sliderImage.frame = self.btn1.frame;
// Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
	
	// Now we repeat the process for the other buttons
	btnImage = [UIImage imageNamed:@"tab2.png"];
	btnImageSelected = [UIImage imageNamed:@"tab2_hover.png"];
	self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
     self.btn2.contentVerticalAlignment  = UIControlContentVerticalAlignmentBottom;
    self.btn2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	btn2.frame = CGRectMake(68, 0, 59, 44);
	[btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.btn2 setTitle:@"课程费用" forState:UIControlStateNormal];
	[btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[btn2 setTag:1];
	
	btnImage = [UIImage imageNamed:@"tab3.png"];
	btnImageSelected = [UIImage imageNamed:@"tab3_hover.png"];
	self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
     self.btn3.contentVerticalAlignment  = UIControlContentVerticalAlignmentBottom;
    self.btn3.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	btn3.frame = CGRectMake(131, 0, 59, 44);
	[btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [self.btn3 setTitle:@"班车路线" forState:UIControlStateNormal];
	[btn3 setTag:2];
	
	btnImage = [UIImage imageNamed:@"tab4.png"];
	btnImageSelected = [UIImage imageNamed:@"tab4_hover.png"];
	self.btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
     self.btn4.contentVerticalAlignment  = UIControlContentVerticalAlignmentBottom;
    self.btn4.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	btn4.frame = CGRectMake(194, 0, 59, 44);
	[btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.btn4 setTitle:@"驾校图片" forState:UIControlStateNormal];
	[btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[btn4 setTag:3];
    
	btnImage = [UIImage imageNamed:@"tab5.png"];
	btnImageSelected = [UIImage imageNamed:@"tab5_hover.png"];
	self.btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
     self.btn5.contentVerticalAlignment  = UIControlContentVerticalAlignmentBottom;
    self.btn5.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	btn5.frame = CGRectMake(257, 0, 59, 44);
	[btn5 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.btn5 setTitle:@"更多" forState:UIControlStateNormal];
	[btn5 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[btn5 setTag:4];
    [tabbarView addSubview:sliderImage];
    [tabbarView addSubview:btn1];
    [tabbarView addSubview:btn2];
    [tabbarView addSubview:btn3];
    [tabbarView addSubview:btn4];
    [tabbarView addSubview:btn5];
    
	[btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 addTarget:self action:@selector(buttonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tabbarView];
    [tabbarView release];
    [self buttonClicked:self.btn1];
}

- (void)buttonClicked:(id)sender
{
	int tagNum = [sender tag];
	[self selectTab:tagNum];
    
    [self performSelector:@selector(slideTabBg:) withObject:sender];
}

- (void)slideTabBg:(UIButton *)btn{
    
	[UIView beginAnimations:nil context:nil];  
	[UIView setAnimationDuration:0.20];  
	[UIView setAnimationDelegate:self];
	sliderImage.frame = btn.frame;
	[UIView commitAnimations];
}

- (void)selectTab:(int)tabID
{
	switch(tabID)
	{
		case 0:
			[btn1 setSelected:true];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
            [btn5 setSelected:false];
			break;
		case 1:
			[btn1 setSelected:false];
			[btn2 setSelected:true];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
            [btn5 setSelected:false];
			break;
		case 2:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:true];
			[btn4 setSelected:false];
            [btn5 setSelected:false];
			break;
		case 3:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:true];
            [btn5 setSelected:false];
			break;
        case 4:
            [btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
            [btn5 setSelected:true];
            break;
	}	
	
	self.selectedIndex = tabID;
}

- (void)dealloc {
	[btn1 release];
	[btn2 release];
	[btn3 release];
	[btn4 release];
    [btn5 release];
    
    [sliderImage release];

    [super dealloc];
}

@end
