//
//  SDWebImageCompatibly.h.h
//  SDWebData
//
//  Created by stm on 11-7-13.
//  Copyright 2011 . All rights reserved.
//

#import <TargetConditionals.h>

#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#ifndef UIImage
#define UIImage NSImage
#endif
#ifndef UIImageView
#define UIImageView NSImageView
#endif
#else
#import <UIKit/UIKit.h>
#endif
