//
//  Commons.m
//  jiaxiao
//
//  Created by wanghw on 12-12-11.
//  Copyright (c) 2012年 zhaojiaxiao. All rights reserved.
//

#import "Commons.h"

@implementation Commons

+(void)alertWithTitle:(NSString *) title Message:(NSString *)message
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

@end
