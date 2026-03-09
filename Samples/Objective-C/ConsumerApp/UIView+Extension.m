//
//  View.m
//  ConsumerApp
//
//  Created by Sunku Sneha on 09/03/26.
//

#import "UIView+Extension.h"
#import <UIKit/UIKit.h>

@implementation UIView (Extension)

- (void)tp_roundCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    // Ensure layout updates adjust the mask; call again in layoutSubviews if needed
}

- (void)tp_setRadiusWithShadow {
    self.layer.cornerRadius = 12.0;
    self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.25].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 4.0;
    self.layer.shadowOpacity = 1.0;
    self.layer.masksToBounds = NO;
}


@end
