//
//  NSString.m
//  ConsumerApp
//
//  Created by Sunku Sneha on 09/03/26.
//

#import "NSString+TPSize.h"
#import <UIKit/UIKit.h>

@implementation NSString (TPSize)

- (CGSize)tp_sizeForViewWithFont:(UIFont *)font width:(CGFloat)width height:(CGFloat)height {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = font;
    label.text = self; // In a category, 'self' refers to the string instance
    
    [label sizeToFit];
    return label.frame.size;
}

@end
