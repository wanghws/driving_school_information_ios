//
//  Tools.m
//  gaosuzhushou
//
//  Created by hash yang on 12-8-24.
//
//

#import "Tools.h"
#import <QuartzCore/QuartzCore.h>

@implementation Tools


+(NSNumber *)HexStringToNSNumber:(NSString *)hexStr{
	NSNumber *number;
	NSScanner *scanner;
	unsigned tempInt;
	
	scanner = [NSScanner scannerWithString:hexStr];
	[scanner scanHexInt:&tempInt];
	number = [NSNumber numberWithInt:tempInt];
	
	return number;
}

+(UIColor *)hexColor:(NSString *)colorStr
{
	NSArray *components = [colorStr componentsSeparatedByString:@":"];
	if ([components count]==3) {
		NSString *rStr=[NSString stringWithFormat:@"0x%@",[components objectAtIndex:0]];
		NSString *gStr=[NSString stringWithFormat:@"0x%@",[components objectAtIndex:1] ];
		NSString *bStr=[NSString stringWithFormat:@"0x%@",[components objectAtIndex:2] ];
		
		CGFloat r=[[self HexStringToNSNumber:rStr] doubleValue]/255;
		CGFloat g=[[self HexStringToNSNumber:gStr] doubleValue]/255;
		CGFloat b=[[self HexStringToNSNumber:bStr] doubleValue]/255;
		return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
	}
	return [UIColor blackColor];
}

+(UIColor *) getColor: (NSString *) hexColor
{
	unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
	
	range.location = 0;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
	range.location = 2;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
	range.location = 4;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
	
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

+ (UIBarButtonItem *)leftNavigationBarButtonWithTitle:(NSString *)title Image:(NSString *)imagename Method:(SEL)method Object:(id)object
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 30)];
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [leftButton setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:object action:method forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return buttonItem;
}

@end
