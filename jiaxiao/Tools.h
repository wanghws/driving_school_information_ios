//
//  Tools.h
//  gaosuzhushou
//
//  Created by hash yang on 12-8-24.
//
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (UIBarButtonItem *)leftNavigationBarButtonWithTitle:(NSString *)title Image:(NSString *)imagename Method:(SEL)method Object:(id)object;

+ (UIColor *) getColor: (NSString *) hexColor;

@end
